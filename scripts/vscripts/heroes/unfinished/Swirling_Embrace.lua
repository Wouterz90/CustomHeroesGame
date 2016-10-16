function swirling_embrace (keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local totaldur = ability:GetDuration()
	local dur = ability:GetSpecialValueFor("interval")

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		target:Purge(false, true, true ,true, false)
		ability:ApplyDataDrivenModifier(caster, target, "Swirling_Embrace_Start_Slow", {duration = dur})
		ability:ApplyDataDrivenModifier(caster, target, "Swirling_Embrace_dummy", {duration = totaldur})
	else
		target:Purge(true, false, true, false, false)
		ability:ApplyDataDrivenModifier(caster, target, "Swirling_Embrace_Start_Slow", {duration = dur})
		ability:ApplyDataDrivenModifier(caster, target, "Swirling_Embrace_dummy", {duration = totaldur})
	end
end
