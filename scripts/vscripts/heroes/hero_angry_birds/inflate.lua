LinkLuaModifier("modifier_inflate_size","heroes/hero_angry_birds/modifiers/modifier_inflate_size.lua",LUA_MODIFIER_MOTION_NONE)
function AirVision(keys)
	local caster = keys.caster
	local ability = keys.ability
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius",ability:GetLevel()-1)
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel()-1)
	caster:AddNewModifier(caster,ability,"modifier_inflate_size",{duration = duration})
	AddFOWViewer(caster:GetTeam(),caster:GetAbsOrigin(),vision_radius,duration,false)
end

