include("shared.lua")

ENT.PopulateEntityInfo = true

function ENT:OnPopulateEntityInfo(tooltip)
    local title = tooltip:AddRow("name")
    title:SetImportant()
    title:SetText("Bank ATM")
    title:SetBackgroundColor(ix.config.Get("color"))
    title:SizeToContents()

    local description = tooltip:AddRow("description")
    description:SetText("Lets you withdraw and deposit your money.")
    description:SizeToContents()
end

net.Receive("ixATMMenu", function()
    local character = LocalPlayer():GetCharacter()

    local bank = ix.currency.Get(character:GetBankMoney())
    local wallet = ix.currency.Get(character:GetMoney())

    Derma_Query("Wallet: " .. wallet .. "\nBank: " .. bank, "Bank ATM",
        "Withdraw", function()
            Derma_StringRequest("Bank ATM", "Enter the amount to withdraw", "0", function(amount)
                net.Start("ixATMWithdraw")
                    net.WriteUInt(math.abs(tonumber(amount)), 32)
                net.SendToServer()
            end)
        end,
        "Deposit", function()
            Derma_StringRequest("Bank ATM", "Enter the amount to deposit", "0", function(amount)
                net.Start("ixATMDeposit")
                    net.WriteUInt(math.abs(tonumber(amount)), 32)
                net.SendToServer()
            end)
        end
    )
end)
