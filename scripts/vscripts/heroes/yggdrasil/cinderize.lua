LinkLuaModifier("modifier_cinderized_buff","heroes/yggdrasil/modifiers/modifier_cinderized_buff.lua",LUA_MODIFIER_MOTION_NONE)

function ApplyDebuff (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetDuration()

	target:AddNewModifier(caster,ability,"modifier_cinderized_buff",{duration = duration})
	
end