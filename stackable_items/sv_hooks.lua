local PLUGIN = PLUGIN

function PLUGIN:InventoryItemAdded(currentInv, inventory, newItem)
    if not newItem.stackMax then return end

    local newStackSize = newItem:GetData("stackSize", 1)

    if not newStackSize or newStackSize < 1 then return end

    for _, currentItem in pairs(inventory:GetItems()) do
        if newItem.id == currentItem.id then
            continue
        end

        if newItem.uniqueID == currentItem.uniqueID then
            local currentStackSize = currentItem:GetData("stackSize", 1)
            local currentStackMax = currentItem.stackMax
            local total = newStackSize + currentStackSize

            if total > currentStackMax then
                newStackSize = total - currentStackSize
                currentItem:SetData("stackSize", currentStackMax)
                newItem:SetData("stackSize", newStackSize)

                continue
            else
                currentItem:SetData("stackSize", total)
                newItem:Remove()

                break
            end
        end
    end
end
