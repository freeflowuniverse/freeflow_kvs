const { MessageBusServer } = require('./msgbus')

class TMProxy {
    // Object proxy can be used?
    constructor(app) {
        this.app = app

        this.info = this.wrapFunction(this.app.info)
        this.initChain = this.wrapFunction(this.app.initChain)
        this.beginBlock = this.wrapFunction(this.app.beginBlock)
        this.endBlock = this.wrapFunction(this.app.endBlock)
        this.setOption = this.wrapFunction(this.app.setOption)
        this.commit = this.wrapFunction(this.app.commit)
        this.checkTx = this.wrapFunction(this.app.checkTx)
        this.deliverTx = this.wrapFunction(this.app.deliverTx)
        this.query = this.wrapFunction(this.app.query)
    }

    wrapFunction(fn) {
        return async (_, payload) => {
            console.log("fn:", fn, " input: ", payload, " type: ", typeof (payload))
            const ret = await fn.bind(this.app)(JSON.parse(payload))
            console.log("fn:", fn, " result: ", ret)
            return ret
        }
    }
}

class TMBus {
    constructor(name, appType, redisPort) {
        if (!redisPort) {
            redisPort = 6379
        }

        this.bus = new MessageBusServer(redisPort)
        this.app = new appType(this.bus)
        this.proxy = new TMProxy(this.app)

        this.bus.withHandler(`${name}.info`, this.proxy.info)
        this.bus.withHandler(`${name}.initchain`, this.proxy.initChain)
        this.bus.withHandler(`${name}.beginblock`, this.proxy.beginBlock)
        this.bus.withHandler(`${name}.endblock`, this.proxy.endBlock)
        this.bus.withHandler(`${name}.setoption`, this.proxy.setOption)
        this.bus.withHandler(`${name}.commit`, this.proxy.commit)

        this.bus.withHandler(`${name}.checktx`, this.proxy.checkTx)
        this.bus.withHandler(`${name}.delivertx`, this.proxy.deliverTx)
        this.bus.withHandler(`${name}.query`, this.proxy.query)

    }

    run() {
        this.bus.run()
    }

}

module.exports = {
    TMBus,
}
