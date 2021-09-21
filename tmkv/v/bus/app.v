module bus

pub interface App {
	name string

mut:
	bus BusServer

	info(RequestInfo) ?ResponseInfo
	init_chain(RequestInitChain) ?ResponseInitChain
	begin_block(RequestBeginBlock) ?ResponseBeginBlock
	end_block(RequestEndBlock) ?ResponseEndBlock
	set_option(RequestSetOption) ?ResponseSetOption
	commit(RequestCommit) ?ResponseCommit
	check_tx(RequestCheckTx) ?ResponseCheckTx
	deliver_tx(RequestDeliverTx) ?ResponseDeliverTx
	query(RequestQuery) ?ResponseQuery
}
