module app

import encoding.base64

import bus

pub struct KVApp {
pub:
	name string

pub mut:
	bus  bus.BusServer
}

pub fn(mut a KVApp) info(req bus.RequestInfo) ?bus.ResponseInfo {
	return bus.ResponseInfo{}
}

pub fn(mut a KVApp) init_chain(req bus.RequestInitChain) ?bus.ResponseInitChain {
	return bus.ResponseInitChain{}
}

pub fn(mut a KVApp) begin_block(req bus.RequestBeginBlock) ?bus.ResponseBeginBlock {
	return bus.ResponseBeginBlock{}
}

pub fn(mut a KVApp) end_block(req bus.RequestEndBlock) ?bus.ResponseEndBlock {
	return bus.ResponseEndBlock{}
}

pub fn(mut a KVApp) set_option(req bus.RequestSetOption) ?bus.ResponseSetOption {
	return bus.ResponseSetOption{}
}

pub fn(mut a KVApp) commit(req bus.RequestCommit) ?bus.ResponseCommit {
	return bus.ResponseCommit{
		data: ""
	}
}

pub fn(mut a KVApp) is_valid(tx string) int {
	if tx == "" {
		return 2
	}

	parts := tx.split("=")
	if parts.len != 2 {
		return 1
	}

	key := parts.first()

	a.bus.redis.get(key) or {
		return 0
	}

	return 2
}

pub fn(mut a KVApp) check_tx(req bus.RequestCheckTx) ?bus.ResponseCheckTx {
	tx := base64.decode_str(req.tx)
	code := a.is_valid(tx)
	return bus.ResponseCheckTx{
		code: code,
		gas_wanted: 1
	}
}

pub fn(mut a KVApp) deliver_tx(req bus.RequestDeliverTx) ?bus.ResponseDeliverTx {
	tx := base64.decode_str(req.tx)
	code := a.is_valid(tx)

	if code != 0 {
		return bus.ResponseDeliverTx {
			code: code
		}
	}

	tx_parts := tx.split("=")
	key := tx_parts.first()
	value := tx_parts.last()

	a.bus.redis.set(key, value) or {
		return bus.ResponseDeliverTx {
			log: "cannot set key of $key",
			code: 2
		}
	}

	return bus.ResponseDeliverTx{
		code: 0
	}
}

pub fn(mut a KVApp) query(req bus.RequestQuery) ?bus.ResponseQuery {
	mut resp := bus.ResponseQuery{}

	// FIXME: encoding should be handled in types (like custom marshal/unmarshal in go?)
	resp.key = req.data
	query_key := base64.decode_str(resp.key)
	value := a.bus.redis.get(query_key) or {
		resp.log = base64.encode_str("key does not exist")
		return resp
	}

	resp.value = base64.encode_str(value)
	resp.log = base64.encode_str("key exists")
	return resp
}
