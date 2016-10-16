function StartSpell (keys)

	local caster = keys.caster
	local ability = keys.ability
		  target = keys.target
	 	  sub_ability_name = keys.sub_ability_name
	      main_ability_name = ability:GetAbilityName()
		  hpfactor = ability:GetLevelSpecialValueFor("hp_factor", ability:GetLevel() - 1)
	local hpgift = caster:GetHealth()*hpfactor
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	      starttime = GameRules:GetGameTime()
	caster:AddAbility(sub_ability_name)
	local level = ability:GetLevel()
	local scam = caster:FindAbilityByName("Nigerian_Scam_CASH")
	if scam ~= nil and scam:GetLevel() ~= level then
		scam:SetLevel(level)
	end

	caster:SetHealth(caster:GetHealth()- hpgift)
	target:Heal(hpgift, caster)
	caster:SwapAbilities(main_ability_name,sub_ability_name, false, true)


	Timers:CreateTimer({
		endTime = duration+0.01,
		callback = function()
			if caster:HasModifier("Scamming") then
				caster:SwapAbilities(main_ability_name,sub_ability_name, true, false)
				caster:RemoveModifierByName("Scamming")
			end		
		end
	})
end

function RangeCheck (keys)
	local caster = keys.caster
	local ability = keys.ability
	local break_range = ability:GetLevelSpecialValueFor("break_range", ability:GetLevel() - 1)
	--print((caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D())
	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > break_range then
		caster:SwapAbilities(main_ability_name,sub_ability_name, true, false)
		caster:RemoveAbility(sub_ability_name)
		caster:RemoveModifierByName("Scamming")
	end
end



function StopSpell (keys)
	local caster = keys.caster
	local ability = keys.ability


	scamtime = GameRules:GetGameTime() - starttime
	hpsteal = caster:GetMaxHealth() * hpfactor * scamtime

	local damage_table = {}

		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.damage_type = DAMAGE_TYPE_MAGICAL
		damage_table.ability = ability
		damage_table.damage = hpsteal

	ApplyDamage(damage_table)

	caster:Heal(hpsteal, caster)
	caster:SwapAbilities(main_ability_name,sub_ability_name, true, false)
	caster:RemoveAbility(sub_ability_name)
end






