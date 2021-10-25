local PLUGIN = PLUGIN

PLUGIN.name = "Whitelist"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.description = "Adds a server whitelist"

PLUGIN.allowed = PLUGIN.allowed or {}

ix.config.Add("whitelistEnabled", false, "Enables the server whitelist.", nil, {
    category = "Whitelist"
})

if SERVER then
    function PLUGIN:LoadData()
        self.allowed = self:GetData() or {}
    end

    function PLUGIN:SaveData()
        self:SetData(self.allowed)
    end

    function PLUGIN:CheckPassword(steamID64)
        if ix.config.Get("whitelistEnabled") and not self.allowed[steamID64] then
            return false, "Sorry, you are not whitelisted for " .. GetHostName()
        end
    end

    function PLUGIN:PlayerAuthed(client, steamID, uniqueID)
        local steamID64 = util.SteamIDTo64(steamID)

        if ix.config.Get("whitelistEnabled") and not self.allowed[steamID64] then
            game.KickID(uniqueID, "Sorry, you are not whitelisted for " .. GetHostName())
        end
    end
end

ix.command.Add("WhitelistAdd", {
    description = "Adds a SteamID to the whitelist",
    privilege = "Manage Server Whitelist",
    superAdminOnly = true,
    arguments = ix.type.string,
    OnRun = function(self, client, steamID)
        if not steamID:match("STEAM_(%d+):(%d+):(%d+)") then
            return "Invalid SteamID!"
        end

        local steamID64 = util.SteamIDTo64(steamID)

        if PLUGIN.allowed[steamID64] then
            return "This SteamID is already whitelisted"
        else
            PLUGIN.allowed[steamID64] = true

            return "Added SteamID to the whitelist"
        end
    end
})

ix.command.Add("WhitelistRemove", {
    description = "Removes a SteamID from the whitelist",
    privilege = "Manage Server Whitelist",
    superAdminOnly = true,
    arguments = ix.type.string,
    OnRun = function(self, client, steamID)
        if not steamID:match("STEAM_(%d+):(%d+):(%d+)") then
            return "Invalid SteamID!"
        end

        local steamID64 = util.SteamIDTo64(steamID)

        if not PLUGIN.allowed[steamID64] then
            return "This SteamID is not whitelisted"
        else
            PLUGIN.allowed[steamID64] = nil

            return "Removed SteamID from the whitelist"
        end
    end
})

ix.command.Add("WhitelistClear", {
    description = "Clears the whitelist",
    privilege = "Manage Server Whitelist",
    superAdminOnly = true,
    OnRun = function(self)
        table.Empty(PLUGIN.allowed)

        return "Cleared the whitelist"
    end
})

ix.command.Add("WhitelistAddAll", {
    description = "Whitelists all current players",
    privilege = "Manage Server Whitelist",
    superAdminOnly = true,
    OnRun = function(self)
        for _, client in ipairs(player.GetHumans()) do
            if IsValid(client) then
                PLUGIN.allowed[client:SteamID64()] = true
            end
        end

        return "Added all current players to the whitelist"
    end
})
