const { TMBus } = require('./tmproxy')
const { KVApp } = require("./kvapp")

const bus = new TMBus("myapp", KVApp)
bus.run()


