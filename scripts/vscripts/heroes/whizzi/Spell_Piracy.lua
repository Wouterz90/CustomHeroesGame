function GetSpellCaster (keys)
	local caster = keys.caster
	local target = keys.target

	--print(target:GetName())

	if target.DidCast == true then
		PiratedAbility = target.lastability:GetAbilityName()
		target.lastability:StartCooldown(999)
		--print(PiratedAbility)
		PiratedAbilityLevel = target.lastability:GetLevel()
		
		caster:AddAbility(PiratedAbility)
		caster:FindAbilityByName(PiratedAbility):SetLevel(PiratedAbilityLevel)
	else
	PiratedAbility = nil	
	end
end

function LoseSpellCaster (keys)
	local caster = keys.caster
	local target = keys.target
	if PiratedAbility then
		target:AddAbility(PiratedAbility)
		caster:RemoveAbility(PiratedAbility)
		target:FindAbilityByName(PiratedAbility):EndCooldown()
	end
end