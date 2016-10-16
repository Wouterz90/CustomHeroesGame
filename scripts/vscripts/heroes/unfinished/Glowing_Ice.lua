function glowing_ice (keys)

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dur = ability:GetLevelSpecialValueFor("restarttime", ability:GetLevel() - 1 )

	if target:HasModifier("Swirling_Embrace_dummy") or target:HasModifier("maelstrom_speed") then
		ability:ApplyDataDrivenModifier(caster, target, "glowing_ice_heal", {duration = dur})
	end

end
