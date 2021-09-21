const util = require("util")

class KVApp {
    constructor(bus) {
        this.bus = bus
        this.get = util.promisify(bus.client.get.bind(bus.client))
        this.set = util.promisify(bus.client.set.bind(bus.client))
    }

    info(req) {
        return {}
    }

    initChain(req) {
        return {}
    }

    beginBlock(req) {
        return {}
    }

    endBlock(req) {
        return {}
    }

    setOption(req) {
        return {}
    }

    commit(req) {
        return {
            data: ""
        }
    }

    encode(value) {
        if (!value) {
            return value
        }

        return Buffer.from(value).toString("base64")
    }

    decode(value) {
        if (!value) {
            return value
        }

        return Buffer.from(value, "base64").toString()
    }

    async isValid(tx) {
        // but need to check if it actually a key=value
        if (!tx) {
            return 2
        }

        let parts = tx.split("=")
        if (parts.length != 2) {
            return 1
        }

        let [key, _] = parts

        const value = await this.get(key)
        if (!value) {
            return 0
        } else {
            return 2
        }

    }

    async checkTx(req) {
        const code = await this.isValid(this.decode(req.tx))
        return {
            code: code,
            gas_wanted: 1
        }
    }


    async deliverTx(req) {
        const tx = this.decode(req.tx)
        const code = await this.isValid(tx)
        if (code != 0) {
            return {
                code: code
            }
        }

        let [key, value] = tx.split("=")
        await this.set(key, value)
        return {
            code: 0
        }
    }

    async query(req) {
        let resp = {}
        resp.key = req.data

        console.log("query of: ", req, "data: ", resp.key)
        const value = await this.get(this.decode(resp.key))
        if (value) {
            resp.log = "key exists"
            resp.value = value
        } else {
            resp.log = "key does not exist"
        }

        if (resp.log) {
            resp.log = this.encode(resp.log)
        }
        if (resp.value) {
            resp.value = this.encode(resp.value)
        }
        return resp
    }

}

module.exports = {
    KVApp
}
