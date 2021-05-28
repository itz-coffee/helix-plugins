local PLUGIN = PLUGIN

function PLUGIN:OnCharacterCreated(client, character)
    local bank = ix.item.CreateInv(10, 10, os.time())
    bank:SetOwner(character:GetID())
    bank:Sync(client)

    character:SetData("bankID", bank:GetID())
end

function PLUGIN:PlayerLoadedCharacter(client, character, currentCharacter)
    local ID = character:GetData("bankID")
    local bank

    if ID then
        bank = ix.item.inventories[ID]

        if not bank then
            ix.item.RestoreInv(ID, 10, 10, function(inventory)
                inventory:SetOwner(character:GetID())
                bank = inventory
            end)
        end
    else
        bank = ix.item.CreateInv(10, 10, os.time())
        bank:SetOwner(character:GetID())
        bank:Sync(character)

        character:SetData("bankID", bank:GetID())
    end
end