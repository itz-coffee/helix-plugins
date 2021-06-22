local PLUGIN = PLUGIN
PLUGIN.name = "SQL Logging"
PLUGIN.author = "wildflowericecoffee"

if CLIENT then return end

local HANDLER = {}

function HANDLER.Load()
    local query = mysql:Create("ix_logs")
    query:Create("id", "INT(132) UNSIGNED NOT NULL AUTO_INCREMENT")
    query:Create("type", "VARCHAR(20) NULL")
    query:Create("string", "TEXT DEFAULT NULL")
    query:Create("time", "INT(32) UNSIGNED NOT NULL")
    query:Create("steamid", "VARCHAR(20) NULL")
    query:Create("itemid", "INT(11) NULL")
    query:Create("charid", "INT(11) NULL")
    query:PrimaryKey("id")
    query:Execute()
end

function HANDLER.Write(client, message, logFlag, logType, args)
    local character
    local item

    if args then
        for _, v in pairs(args) do
            if type(v) == "table" then
                if v.uniqueID ~= nil then
                    item = v
                    continue
                end

                if isfunction(v.GetFaction) then
                    character = v
                end
            end
        end
    end

    if not character and IsValid(client) then
        character = isfunction(client.GetCharacter) and client:GetCharacter() or nil
    end

    local query = mysql:Insert("ix_logs")
    query:Insert("type", logType)
    query:Insert("string", message)
    query:Insert("time", os.time())

    if IsValid(client) then
        query:Insert("steamid", client:SteamID64())
    end

    if character then
        query:Insert("charid", character:GetID())
    end

    if item then
        query:Insert("itemid", item:GetID())
    end

    query:Execute()
end

ix.log.RegisterHandler("SQL_Logging", HANDLER)