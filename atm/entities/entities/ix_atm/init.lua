util.AddNetworkString("ixAtmDeposit")
util.AddNetworkString("ixAtmWithdraw")

include("shared.lua")
AddCSLuaFile("cl_init.lua")

net.Receive("ixAtmDeposit", function(_, client)
    local requested = net.ReadUInt(32)
    local character = client:GetCharacter()

    local wallet = character:GetMoney()
    local bank = character:GetBankMoney()

    if requested > wallet then
        return client:Notify("You do not have enough money in your wallet!")
    end

    character:TakeMoney(requested)
    character:SetBankMoney(bank + requested)
    client:Notify("You have deposited " .. ix.currency.Get(requested) .. "!")
end)

net.Receive("ixAtmWithdraw", function(_, client)
    local requested = net.ReadUInt(32)
    local character = client:GetCharacter()

    local bank = character:GetBankMoney()

    if requested > bank then
        return client:Notify("You do not have enough money in your bank!")
    end

    character:GiveMoney(requested)
    character:SetBankMoney(bank - requested)
    client:Notify("You have withdrawn " .. ix.currency.Get(requested) .. "!")
end)