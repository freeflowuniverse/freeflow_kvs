module bus

import encoding.base64
import json
import time

import despiegk.crystallib.redisclient
import despiegk.crystallib.resp2

import threefoldtech.rmb.server


const blpop_timeout = "0"

// a handler function which takes payload request
// as a string, and returns a response string
// encoding/decoding should be done with structs in the app itself
// or in a helper proxy app
pub interface Handler {
mut:
	app App

	handle(string) ?string
}

pub struct BusServer {
	addr	string

pub mut:
	redis   redisclient.Redis
	handlers map[string]Handler

}

pub fn new_bus(addr string) &BusServer {
	mut redis := redisclient.connect(addr) or { panic(err) }

	return &BusServer{
		addr: addr,
		redis: redis,
		handlers: map[string]Handler{},
	}
}

pub fn (mut b BusServer) handle(topic string, mut handler Handler) {
	// this doesn't work for some reason
	b.handlers["msgbus.$topic"] = handler
}

pub fn (mut b BusServer) run()? {
	mut keys := []string{}

	for key, _ in b.handlers {
		println("watching $key")
		keys << key
	}

	value := b.redis.blpop(keys, blpop_timeout)?
	channel := resp2.get_redis_value(value.first())
	raw_message := resp2.get_redis_value(value.last())
	mut message := json.decode(server.Message, raw_message)?

	if channel in b.handlers {
		mut handler := b.handlers[channel]
		payload := base64.decode_str(message.data)
		println("handling: $channel, payload: $payload")
		resp := handler.handle(payload) or {
			b.reply(mut message, err.msg)
			return
		}
		b.reply(mut message, resp)
	}

	b.run()?
}

pub fn (mut b BusServer) reply(mut message server.Message, data string) {
    source := message.twin_src

    message.data = base64.encode_str(data)
    message.twin_src = message.twin_dst[0]
    message.twin_dst = [source]
    message.epoch = time.now().unix_time()

	message_str := json.encode(message)
    b.redis.lpush(message.retqueue, message_str) or { panic(err) }
}
