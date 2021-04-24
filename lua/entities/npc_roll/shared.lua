ENT.Base = "base_ai" -- Magic Spin System
ENT.Type = "anim"
ENT.PrintName   = "NPC Roll Magie" -- Rename Here the Name of your NPC
ENT.Category    = "Outils NANO" -- Rename Here the name of the category in the spawnmenu (entities)
ENT.Instruction = ""
ENT.Spawnable   = true

function ENT:Initialize()
    self:SetModel("models/gman.mdl") -- Modify Here the NPC model
    self:SetSolid(SOLID_BBOX)
    if SERVER then self:SetUseType(SIMPLE_USE) end
end