function tidal_wave (keys)
	local target = keys.target_points[1]
	local caster = keys.caster
	local ability = keys.ability

	startradius = ability:GetLevelSpecialValueFor("startradius", ability:GetLevel() - 1)
	radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	halfrange = ability:GetSpecialValueFor("cast_range")
	casterloc = caster:GetAbsOrigin()
	casterdirection = caster:GetForwardVector()

	startpoint = casterloc + (casterdirection * halfrange )

	local projectileTable =
	{
		EffectName = "particles/bellatrix/bellatrix_live_transfusion.vpcf",
		Ability = ability,
		vSpawnOrigin = startpoint,
		vVelocity = 522 * casterdirection,
		fDistance = halfrange,
		fStartRadius = startradius,
		fEndRadius = radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = true,
		bProvidesVision = true,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()
		}
	local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
end