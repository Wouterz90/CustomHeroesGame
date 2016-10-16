function PrimaryStat (keys)
	local caster = keys.caster

	local caster_str = caster:GetStrength()
	local caster_agi = caster:GetAgility()
	local caster_int = caster:GetIntellect()

	if (caster_agi > caster_str) and (caster_agi > caster_int) and not caster:GetPrimaryAttribute() == 1 then
		caster:SetPrimaryAttribute(1)
	elseif (caster_str > caster_agi) and (caster_str > caster_int) and not caster:GetPrimaryAttribute() == 0 then
		caster:SetPrimaryAttribute(0)
	elseif (caster_int > caster_agi) and (caster_int > caster_str) and not caster:GetPrimaryAttribute() == 2 then
		caster:SetPrimaryAttribute(2)
	end
end

function ChargeCollection (keys)
	local caster = keys.caster
	local chargetime = ability:GetLevelSpecialValueFor("chargetime",ability:GetLevel() -1)
	local charge_modifier = FindModifierByName("Charges")

	Timers:CreateTimer
	(
	{
		endTime = chargetime
		function()
			if caster:HasModifier("Charges") then
				charge_modifier:SetStackCount(charge_modifier:GetStackCount() + 1)
			else
				ApplyDataDrivenModifier(caster,caster,charge_modifier, {duration = -1})
				charge_modifier:SetStackCount(1)
			end
		end
	}
	)
end

function SpawnRegularUnit (keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel() -1
	
	local caster_str = caster:GetStrength()
	local caster_agi = caster:GetAgility()
	local caster_int = caster:GetIntellect()

	local BaseHealth = ability:GetLevelSpecialValueFor("BaseHealth",abilityLevel)
	local BaseMana = ability:GetLevelSpecialValueFor("BaseMana",abilityLevel)
	local str_factor = ability:GetLevelSpecialValueFor("str_factor",abilityLevel)
	local agi_factor = ability:GetLevelSpecialValueFor("agi_factor",abilityLevel)
	local int_factor_resis = ability:GetLevelSpecialValueFor("int_factor_resis",abilityLevel)
	local int_factor_mana = ability:GetLevelSpecialValueFor("int_factor_mana",abilityLevel)

	local Regular_Sliver = CreateUnitByName("npc_unit_sliver",caster:GetAbsOrigin(),true, caster,caster, caster:GetTeamNumber())

	Regular_Sliver:SetMaxHealth(BaseHealth + (caster_str * str_factor))
	Regular_Sliver:SetPhysicalArmorBaseValue(caster_agi * agi_factor)
	Regular_Sliver:SetBaseMagicalResistanceValue(caster_int * int_factor_resis)
	Regular_Sliver:SetMana(BaseMana + (caster_int * int_factor_mana))
	if ability:GetAbilityName() == "" then
		Regular_Sliver:AddAbility("")
	end
end