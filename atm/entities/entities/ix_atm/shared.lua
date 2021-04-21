AddCSLuaFile()

ENT.Type = "ai"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PrintName = "Bank ATM"
ENT.Author = "wildflowericecoffee"
ENT.Purpose = "Lets you withdraw and deposit your money"

function ENT:Initialize()
    self:SetModel("models/props_unique/atm01.mdl")
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end
end