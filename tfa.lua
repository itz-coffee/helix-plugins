PLUGIN.name = "TFA Support"
PLUGIN.author = "wildflowericecoffee"
PLUGIN.description = "Adds support for TFA weapons."

if CLIENT then
    hook.Remove("ContextMenuOpen", "TFAContextBlock")
    hook.Remove("Think", "TFAInspectionMenu")
    hook.Add("TFA_DrawCrosshair", "TFARemoveCrosshair", function() return true end)
end
