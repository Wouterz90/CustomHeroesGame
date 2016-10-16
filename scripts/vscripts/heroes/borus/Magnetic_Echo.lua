function Echo (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetDuration()

	if target:HasModifier("Positive_Charge_Magnetic") or target:HasModifier("Negative_Charge_Magnetic") then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_Magnetic_Echo",{duration = duration })
	end
end