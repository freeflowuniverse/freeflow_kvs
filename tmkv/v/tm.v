module main

import bus as busmod
import app as appmod

fn main() {
	addr := "localhost:6379"

	mut bus := busmod.new_bus(addr)
	mut app := appmod.KVApp{
		name: "myapp",
		bus: bus
	}

	// setup handlers, using bus.handle does not work for some reason (bus.handlers would be empty)
	bus.handlers["msgbus.${app.name}.info"] = &busmod.InfoHandler{app: app}
	bus.handlers["msgbus.${app.name}.initchain"] = &busmod.InitChainHandler{app: app}
	bus.handlers["msgbus.${app.name}.beginblock"] = &busmod.BeginBlockHandler{app: app}
	bus.handlers["msgbus.${app.name}.endblock"] = &busmod.EndBlockHandler{app: app}
	bus.handlers["msgbus.${app.name}.setoption"] = &busmod.SetOptionHandler{app: app}
	bus.handlers["msgbus.${app.name}.commit"] = &busmod.CommitHandler{app: app}
	bus.handlers["msgbus.${app.name}.checktx"] = &busmod.CheckTxHandler{app: app}
	bus.handlers["msgbus.${app.name}.delivertx"] = &busmod.DeliverTxHandler{app: app}
	bus.handlers["msgbus.${app.name}.query"] = &busmod.QueryHandler{app: app}

	bus.run() or { panic(err) }
}

