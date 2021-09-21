module bus

import json

pub struct InfoHandler {
mut:
	app App
}

pub fn (mut h InfoHandler) handle(payload string) ?string {
	req := json.decode(RequestInfo, payload)?
	resp := h.app.info(req) or {
		return error("info failed: $err, req: $req")
	}

	return json.encode(resp as ResponseInfo)
}

pub struct InitChainHandler {
mut:
	app App
}

pub fn (mut h InitChainHandler) handle(payload string) ?string {
	req := json.decode(RequestInitChain, payload)?
	resp := h.app.init_chain(req) or {
		return error("init_chain failed: $err, req: $req")
	}

	return json.encode(resp as ResponseInitChain)
}

pub struct BeginBlockHandler {
mut:
	app App
}

pub fn (mut h BeginBlockHandler) handle(payload string) ?string {
	req := json.decode(RequestBeginBlock, payload)?
	resp := h.app.begin_block(req) or {
		return error("begin_block failed: $err, req: $req")
	}

	return json.encode(resp as ResponseBeginBlock)
}

pub struct EndBlockHandler {
mut:
	app App
}

pub fn (mut h EndBlockHandler) handle(payload string) ?string {
	req := json.decode(RequestEndBlock, payload)?
	resp := h.app.end_block(req) or {
		return error("end_block failed: $err, req: $req")
	}

	return json.encode(resp as ResponseEndBlock)
}

pub struct SetOptionHandler {
mut:
	app App
}

pub fn (mut h SetOptionHandler) handle(payload string) ?string {
	req := json.decode(RequestSetOption, payload)?
	resp := h.app.set_option(req) or {
		return error("set_option failed: $err, req: $req")
	}

	return json.encode(resp as ResponseSetOption)
}

pub struct CommitHandler {
mut:
	app App
}

pub fn (mut h CommitHandler) handle(payload string) ?string {
	req := json.decode(RequestCommit, payload)?
	resp := h.app.commit(req) or {
		return error("commit failed: $err, req: $req")
	}

	return json.encode(resp as ResponseCommit)
}

pub struct CheckTxHandler {
mut:
	app App
}

pub fn (mut h CheckTxHandler) handle(payload string) ?string {
	req := json.decode(RequestCheckTx, payload)?
	resp := h.app.check_tx(req) or {
		return error("checkTx failed: $err, req: $req")
	}

	return json.encode(resp as ResponseCheckTx)
}

pub struct DeliverTxHandler {
mut:
	app App
}

pub fn (mut h DeliverTxHandler) handle(payload string) ?string {
	req := json.decode(RequestDeliverTx, payload)?
	resp := h.app.deliver_tx(req) or {
		return error("deliver_tx failed: $err, req: $req")
	}

	return json.encode(resp as ResponseDeliverTx)
}

pub struct QueryHandler {
mut:
	app App
}

pub fn (mut h QueryHandler) handle(payload string) ?string {
	req := json.decode(RequestQuery, payload)?
	resp := h.app.query(req) or {
		return error("query failed: $err, req: $req")
	}

	return json.encode(resp as ResponseQuery)
}

// pub fn setup_handlers(mut app App)  {

// }
