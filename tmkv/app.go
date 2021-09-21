package main

import (
	"context"
	"fmt"

	"github.com/abom/tm2rmb/rmb"
	abcitypes "github.com/tendermint/tendermint/abci/types"
)

type Request struct {
}

type BusProxyApp struct {
	bus  rmb.Client
	twin uint32
	name string
}

func NewBusProxyApp(name string, twin uint32, bus rmb.Client) *BusProxyApp {
	return &BusProxyApp{
		bus:  bus,
		name: name,
		twin: twin,
	}
}

func (app *BusProxyApp) call(funcName string, req interface{}, resp interface{}) error {
	ctx := context.TODO()
	name := fmt.Sprintf("%s.%s", app.name, funcName)
	err := app.bus.Call(ctx, app.twin, name, req, &resp)
	if err != nil {
		fmt.Println(err)
	}
	return err
}

func (app *BusProxyApp) Info(req abcitypes.RequestInfo) abcitypes.ResponseInfo {
	resp := abcitypes.ResponseInfo{}
	app.call("info", req, &resp)
	return resp
}

func (app *BusProxyApp) InitChain(req abcitypes.RequestInitChain) abcitypes.ResponseInitChain {
	resp := abcitypes.ResponseInitChain{}
	app.call("initchain", req, &resp)
	return resp
}

func (app *BusProxyApp) EndBlock(req abcitypes.RequestEndBlock) abcitypes.ResponseEndBlock {
	resp := abcitypes.ResponseEndBlock{}
	app.call("endblock", req, &resp)
	return resp
}

func (app *BusProxyApp) ListSnapshots(req abcitypes.RequestListSnapshots) abcitypes.ResponseListSnapshots {
	resp := abcitypes.ResponseListSnapshots{}
	app.call("listsnapshots", req, &resp)
	return resp
}

func (app *BusProxyApp) OfferSnapshot(req abcitypes.RequestOfferSnapshot) abcitypes.ResponseOfferSnapshot {
	resp := abcitypes.ResponseOfferSnapshot{}
	app.call("offersnameshot", req, &resp)
	return resp
}

func (app *BusProxyApp) LoadSnapshotChunk(req abcitypes.RequestLoadSnapshotChunk) abcitypes.ResponseLoadSnapshotChunk {
	resp := abcitypes.ResponseLoadSnapshotChunk{}
	app.call("loadsnapshotchunk", req, &resp)
	return resp
}

func (app *BusProxyApp) ApplySnapshotChunk(req abcitypes.RequestApplySnapshotChunk) abcitypes.ResponseApplySnapshotChunk {
	resp := abcitypes.ResponseApplySnapshotChunk{}
	app.call("applysnapshotchunk", req, &resp)
	return resp
}

func (app *BusProxyApp) SetOption(req abcitypes.RequestSetOption) abcitypes.ResponseSetOption {
	resp := abcitypes.ResponseSetOption{}
	app.call("setoption", req, &resp)
	return resp
}

func (app *BusProxyApp) CheckTx(req abcitypes.RequestCheckTx) abcitypes.ResponseCheckTx {
	resp := abcitypes.ResponseCheckTx{Code: 0, GasWanted: 1}
	app.call("checktx", req, &resp)
	return resp
}

func (app *BusProxyApp) DeliverTx(req abcitypes.RequestDeliverTx) abcitypes.ResponseDeliverTx {
	resp := abcitypes.ResponseDeliverTx{Code: 0}
	app.call("delivertx", req, &resp)
	return resp
}

func (app *BusProxyApp) Commit() abcitypes.ResponseCommit {
	req := Request{}
	resp := abcitypes.ResponseCommit{Data: []byte{}}
	app.call("commit", req, &resp)
	return resp
}

func (app *BusProxyApp) Query(req abcitypes.RequestQuery) (resp abcitypes.ResponseQuery) {
	app.call("query", req, &resp)
	return
}

func (app *BusProxyApp) BeginBlock(req abcitypes.RequestBeginBlock) abcitypes.ResponseBeginBlock {
	resp := abcitypes.ResponseBeginBlock{}
	app.call("beginblock", req, &resp)
	return resp
}
