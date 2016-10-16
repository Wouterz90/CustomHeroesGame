function AddBackTrackModifier(keys)
	local caster = keys.caster
	local ability = keys.ability

	if caster:HasModifier("modifier_backtrack_chance") then
		caster:SetModifierStackCount("modifier_backtrack_chance",caster,caster:GetModifierStackCount("modifier_backtrack_chance",caster)+1)
	else
		caster:SetModifierStackCount("modifier_backtrack_chance",caster,1)
	end

end

function CritTwiceLua(caster)

	local caster = mikhail
	local ability = caster:FindAbilityByName("Mikhail_Offense_is_the_best_Defense")

	if ability and ability:IsCooldownReady() then
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
		caster:SetModifierStackCount("modifier_Offense_is_the_best_defense_debuff_decrease",caster,1)
		Timers:CreateTimer(ability:GetLevelSpecialValueFor("duration",ability:GetLevel()-1),
  			function()
    			caster:SetModifierStackCount("modifier_Offense_is_the_best_defense_debuff_decrease",caster,0)
  			end
  		)
	end
end

function CritTwiceKV(keys)

	local caster = mikhail
	local ability = caster:FindAbilityByName("Mikhail_Offense_is_the_best_Defense")

	if ability and ability:IsCooldownReady() then
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
		caster:SetModifierStackCount("modifier_Offense_is_the_best_defense_debuff_decrease",caster,1)
		Timers:CreateTimer(ability:GetLevelSpecialValueFor("duration",ability:GetLevel()-1),
  			function()
    			caster:SetModifierStackCount("modifier_Offense_is_the_best_defense_debuff_decrease",caster,0)
  			end
  		)
	end
end
