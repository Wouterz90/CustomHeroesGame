function SpentMana(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stack_duration = ability:GetLevelSpecialValueFor("stack_duration",ability:GetLevel()-1)

	caster:SetModifierStackCount("modifier_spread_wisdom_passive",caster,caster:GetModifierStackCount("modifier_spread_wisdom_passive",caster)+1)
	Timers:CreateTimer(stack_duration,
	function()
		if caster:IsAlive() then
			caster:SetModifierStackCount("modifier_spread_wisdom_passive",caster,caster:GetModifierStackCount("modifier_spread_wisdom_passive",caster)-1)
		end
	end)
end

--Functions are required in gamemode 

function SpreadWisdomDamageBoost(hAttacker,hVictim,fDamage) -- Gets data from DamageFilter
	local stacks = hAttacker:GetModifierStackCount("modifier_spread_wisdom_passive",hAttacker:FindModifierByName("modifier_spread_wisdom_passive"):GetAbility())
	local instanceboost = hAttacker:FindModifierByName("modifier_spread_wisdom_passive"):GetAbility():GetLevelSpecialValueFor("boosted_spellvalue",hAttacker:FindModifierByName("modifier_spread_wisdom_passive"):GetAbility():GetLevel() -1)
	if stacks then
		if fDamage > instanceboost then
        	fDamage = fDamage + (stacks * instanceboost)
    	end
    	return fDamage
    end
end

function SpreadWisdomHealBoost(hCaster,hTarget,fHeal) -- Gets data from OnUnitHealed
	local stacks = hCaster:GetModifierStackCount("modifier_spread_wisdom_passive",hCaster:FindModifierByName("modifier_spread_wisdom_passive"):GetAbility())
    local instanceboost = hCaster:FindModifierByName("modifier_spread_wisdom_passive"):GetAbility():GetLevelSpecialValueFor("boosted_spellvalue",hCaster:FindModifierByName("modifier_spread_wisdom_passive"):GetAbility():GetLevel() -1)
    if fHeal > instanceboost then
    	hTarget:Heal(stacks * instanceboost,hCaster)
        fHeal = fHeal + (stacks * instanceboost)
    end
end
