# tm2rmb

Write apps for [Tendermint](https://github.com/tendermint/tendermint) in Javascript and V based on [RMB](https://github.com/threefoldtech/rmb).

It's simply a proxy app for Tendermint that read request replies from message bus. Examples are included for [Javascript](/js) and [V](/v).

Based on Tendermint `0.34.11`.

### Running the node

Assuming you have already installed Tendermint with the target version, you need to compile the Go proxy app.

```
go build
```

Create initial config files:

```
TMHOME=/path/to/config tendermint init
```

Then you can run node with our app and give it a twin id for RMB and an app name:

Twin with this ID should have an IP of `localhost`, this twin should be create on tfgrid (substrate).

```
./tm2rmb -config /path/to/config/config.toml -twin 20 -app myapp
```

Running [message bus](https://github.com/threefoldtech/rmb/tree/master/msgbusd) with the same twin ID:

```
msgbusd --twin 20
```

### Running examples

After running Tendermint and node, it's the time to run our app, you can run an example key-value store app that uses redis in Javascript or V.

#### Javascript

Tested on node version `v14.17.0`:

```
cd js
npm install
node tm_app.js
```

#### V

```
cd v
v tm.v
./tm
```


#### Testing example app

Do a query first:

```
curl -s 'localhost:26657/abci_query?data="key1"
```

Write a value to the same key

```
curl -s 'curl -s 'localhost:26657/broadcast_tx_commit?tx="key1=somevalue"'
```

Query again:

```
curl -s 'localhost:26657/abci_query?data="key1"
```
