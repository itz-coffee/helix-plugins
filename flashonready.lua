PLUGIN.name = "Flash on Ready"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.description = "Flashes the taskbar icon once the game has fully loaded."

function PLUGIN:InitPostEntity()
    if CLIENT and system.IsWindows() and not system.HasFocus() then
		system.FlashWindow()
	end
end