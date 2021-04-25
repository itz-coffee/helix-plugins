include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

local ATM_SCREEN_VECTOR = Vector(7, -12.5, 55)
local ATM_SCREEN_ANGLE = Angle(0, 90, 75)

local ATM_KEYPAD_VECTOR = Vector(9.5, -11, 46.5)
local ATM_KEYPAD_ANGLE = Angle(0, 90, 30)

function ENT:DrawTranslucent()
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 100 * 100 then
        if IsValid(ix.gui.atmScreen) then
            ix.gui.atmScreen:Remove()
        end

        if IsValid(ix.gui.atmKeypad) then
            ix.gui.atmKeypad:Remove()
        end

        return
    end

    if not IsValid(ix.gui.atmScreen) then
        ix.gui.atmScreen = vgui.Create("ixAtmScreen")
    end

    if not IsValid(ix.gui.atmKeypad) then
        ix.gui.atmKeypad = vgui.Create("ixAtmKeypad")
    end

    vgui.MaxRange3D2D(50)

    vgui.Start3D2D(self:LocalToWorld(ATM_SCREEN_VECTOR), self:LocalToWorldAngles(ATM_SCREEN_ANGLE), 0.01)
        ix.gui.atmScreen:Paint3D2D()
        ix.gui.atmScreen:Show()
    vgui.End3D2D()

    vgui.Start3D2D(self:LocalToWorld(ATM_KEYPAD_VECTOR), self:LocalToWorldAngles(ATM_KEYPAD_ANGLE), 0.01)
        ix.gui.atmKeypad:Paint3D2D()
        ix.gui.atmKeypad:Show()
    vgui.End3D2D()
end