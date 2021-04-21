local PLUGIN = PLUGIN

PLUGIN.name = "ATM"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.description = "Spawns an ATM entity to handle money."

ix.char.RegisterVar("BankMoney", {
    field = "bank_money",
    fieldType = ix.type.number,
    default = 0,
    isLocal = true,
    bNoDisplay = true
})
