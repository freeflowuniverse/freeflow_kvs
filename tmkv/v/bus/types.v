// from tendermint/abci/types/types.pb.go
// better to be generated from protobuf spec
module bus

import time

struct EventAttribute {
pub mut:
	key   string
	value string
	index bool
}

struct Event {
pub mut:
	type_       string   [json: "type"]
	attributes []EventAttribute
}

pub struct RequestInfo {
pub mut:
	version      string
	block_version i64
	p2p_version   i64
}

pub struct ResponseInfo {
pub mut:
	data             string
	version          string
	app_version       i64
	last_block_height  i64
	last_block_app_hash string
}

pub struct RequestInitChain {
pub mut:
	time            time.Time
	chain_id         string
	// TODO: a bit complex type (too many nested types, mostly not used)
	// should be generated from protobuf spec
	// consensus_params *ConsensusParams
	// Validators      []ValidatorUpdate
	app_state_bytes  string
	initial_height   i64
}

pub struct ResponseInitChain {
pub mut:
	// TODO: a bit complex type (too many nested types, mostly not used)
	// should be generated from protobuf spec
	// ConsensusParams *ConsensusParams
	// Validators      []ValidatorUpdate
	app_hash         string
}

pub struct RequestBeginBlock {
pub mut:
	hash                string
	// TODO: a bit complex type (too many nested types, mostly not used)
	// should be generated from protobuf spec
	// header              types1.Header
	// last_commit_info      LastCommitInfo
	// byzantine_validators []Evidence
}

pub struct ResponseBeginBlock {
pub mut:
	events []Event
}

pub struct RequestEndBlock {
pub mut:
	height i64
}

pub struct ResponseEndBlock {
pub mut:
	// ValidatorUpdates      []ValidatorUpdate
	// ConsensusParamUpdates *ConsensusParams
	events	[]Event
}

pub struct RequestSetOption {
pub mut:
	key string
	value string
}

pub struct ResponseSetOption {
pub mut:
	code int
	log string
	info string
}

pub struct RequestCommit {
	// just adding this because empty struct fails here
	empty string
}

pub struct ResponseCommit {
pub mut:
	data string
	retain_height i64
}


pub struct RequestCheckTx {
pub mut:
	tx   string
	type_ int [json: "type"]
}

pub struct ResponseCheckTx  {
pub mut:
	code      int
	data      string
	log       string
	info      string
	gas_wanted i64
	gas_used   i64
	events    []Event
	codespace string
}

pub struct RequestDeliverTx {
pub mut:
	tx   string
	type_ int [json: "type"]
}

pub struct ResponseDeliverTx  {
pub mut:
	code      int
	data      string
	log       string
	info      string
	gas_wanted i64
	gas_used   i64
	events    []Event
	codespace string
}


pub struct RequestQuery {
pub mut:
	data   string
	path   string
	height i64
	prove  bool
}

pub struct ProofOp {
pub mut:
	type_ string [json: "type"]
	key string
	data string
}

pub struct ProofOps {
pub mut:
	ops	[]ProofOps
}

pub struct ResponseQuery {
pub mut:
	code int
	// bytes data = 2; // use "value" instead.
	log       string
	info      string
	index     i64
	key       string
	value     string
	proof_ops  ProofOps
	height    i64
	codespace string
}

pub type Request =
	RequestInfo |
	RequestInitChain |
	RequestBeginBlock |
	RequestEndBlock |
	RequestSetOption |
	RequestCommit |
	RequestCheckTx |
	RequestDeliverTx |
	RequestQuery

pub type Response =
	ResponseInfo |
	ResponseInitChain |
	ResponseBeginBlock |
	ResponseEndBlock |
	ResponseSetOption |
	ResponseCommit |
	ResponseCheckTx  |
	ResponseDeliverTx  |
	ResponseQuery
