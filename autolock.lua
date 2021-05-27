local PLUGIN = PLUGIN

PLUGIN.name = "Door Autolock"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.description = "Autolocks doors when the map loads"

PLUGIN.doors = PLUGIN.doors or {}

function PLUGIN:LoadData()
    self.doors = self:GetData() or {}

    for _, entity in ipairs(ents.GetAll()) do
        if self.doors[entity:MapCreationID()] then
            entity:Fire("lock")
        end
    end
end

function PLUGIN:SaveData()
    self:SetData(self.doors)
end

ix.command.Add("DoorAddAutolock", {
    privilege = "Manage Doors",
    OnRun = function(self, client)
        local target = client:GetEyeTrace().Entity

        if IsValid(target) and target:IsDoor() then
            if PLUGIN.doors[target:MapCreationID()] then
                return "Door is already autolocked"
            end

            PLUGIN.doors[target:MapCreationID()] = true
            PLUGIN:SaveData()

            return "Door added to autolock"
        else
            return "Not looking at a door"
        end
    end
})

ix.command.Add("DoorRemoveAutolock", {
    privilege = "Manage Doors",
    OnRun = function(self, client)
        local target = client:GetEyeTrace().Entity

        if IsValid(target) and target:IsDoor() then
            if not PLUGIN.doors[target:MapCreationID()] then
                return "Door is not autolocked"
            end

            PLUGIN.doors[target:MapCreationID()] = nil
            PLUGIN:SaveData()

            return "Door removed from autolock"
        else
            return "Not looking at a door"
        end
    end
})
