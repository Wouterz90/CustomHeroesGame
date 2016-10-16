function AttackWhileMoving
local caster = keys.caster
local ability = keys.ability
local range = caster:GetAttackRange()

	if caster:AttackReady() and not IsAttacking() then
		local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, range,
				DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP +DOTA_UNIT_TARGET_HERO, 0, 0, false )
		PrintTable(#units)
		local random = RandomInt(1,#units)
		print(random)

		caster:PerformAttack(units[random],true,true,true,true,false)
	end
end