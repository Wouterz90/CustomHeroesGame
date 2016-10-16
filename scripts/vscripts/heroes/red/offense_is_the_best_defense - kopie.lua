function MikhailForceAttack(keys)
	local caster = keys.caster
	local target = keys.target

	target:SetForceAttackTarget(nil)
	local order = 
	{
		UnitIndex = target:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = caster:entindex()
	}
	ExecuteOrderFromTable(order)
end

function ForceModifiers(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local radius = ability:GetLevelSpecialValueFor("aoe",ability:GetLevel() -1 )
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel() -1 )
	print(radius)

	local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	
	for _,unit in pairs( units ) do
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_Offense_is_the_best_defense_debuff",{duration = duration})
	end

	target:RemoveModifierByName("modifier_Offense_is_the_best_defense_debuff")
end