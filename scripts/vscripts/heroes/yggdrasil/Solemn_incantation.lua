function DealingDamage (keys)
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability

	local max_instances = ability:GetLevelSpecialValueFor("max_instances",ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("instance_refresh_rate",ability:GetLevel() -1)
	local hp_heal = ability:GetLevelSpecialValueFor("hp_gain_per_instance",ability:GetLevel() -1)
	local mp_heal = ability:GetLevelSpecialValueFor("mp_gain_per_instance",ability:GetLevel() -1)

	if not target:HasModifier("modifier_solemn_incantation_counter") then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_solemn_incantation_counter",{duration = -1})
	end
	local counting_modifier = target:FindModifierByName("modifier_solemn_incantation_counter")
	local instances_healed = counting_modifier:GetStackCount()
	print(instances_healed)

	if instances_healed <= max_instances then
		
		if instances_healed == nil or instances_healed == 0 then
			counting_modifier:SetStackCount(1)
		else
			counting_modifier:SetStackCount(counting_modifier:GetStackCount()+1)
		end
		Timers:CreateTimer({
			endTime = duration,
			callback = function()
				counting_modifier:SetStackCount(counting_modifier:GetStackCount()-1)
			end
		})
		if counting_modifier:GetStackCount() == 0 then
			target:RemoveModifierByName("modifier_solemn_incantation_counter")
		end
		target:Heal(hp_heal,caster)
		target:GiveMana(mp_heal)
	end
end




