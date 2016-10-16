function SacrificeBlink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]

	local range = ability:GetLevelSpecialValueFor("range",ability:GetLevel() -1)
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel() -1)	
	local casterloc = caster:GetAbsOrigin()
	local difference = (casterloc - target_point):Length2D()
	local direction = (target_point - casterloc):Normalized() 	
	if difference > range then
		target_point = casterloc + (direction * range)
	end
	local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf",PATTACH_WORLDORIGIN,caster)
	ParticleManager:SetParticleControl(particle1,0,casterloc)

	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP +DOTA_UNIT_TARGET_HERO, 0, 0, false )
	for _,unit in pairs( units ) do
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_sacrifice_dummy",{duration = 0.25})
		ability:ApplyDataDrivenModifier(caster,unit,"modifier_sacrifice_slow",{duration = duration})
		local DamageTable = 
		{
			attacker = caster,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage = caster:GetAverageTrueAttackDamage(),
			victim = unit
		}
		ApplyDamage(DamageTable)
	end

	local casterhealth = caster:GetHealth()

	local SacrificeDamage = 
	{
		victim = caster,
		attacker = caster,
		damage = casterhealth*0.1,
		damage_type = DAMAGE_TYPE_PURE
	}	
	ApplyDamage(SacrificeDamage)
	FindClearSpaceForUnit(caster,target_point,false)

	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf",PATTACH_WORLDORIGIN,caster)
	ParticleManager:SetParticleControl(particle2,0,target_point)
	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP +DOTA_UNIT_TARGET_HERO, 0, 0, false )
	for _,unit in pairs( units ) do
		if not unit:HasModifier("modifier_sacrifice_dummy") then
			local DamageTable = 
			{
				attacker = caster,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage = caster:GetAverageTrueAttackDamage(),
				victim = unit
			}
			ApplyDamage(DamageTable)
		end
	end
end
