function CreateBird (keys)
	local caster = keys.caster
	feather_barrage_caster = keys.caster
	feather_barrage_point = keys.target_points[1]
	local ability = keys.ability
	feather_ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")

	feather_barrage_bird = CreateUnitByName("npc_dota_beastmaster_hawk_2", caster:GetAbsOrigin(),false, keys.caster, keys.caster, keys.caster:GetTeamNumber())
	feather_ability:ApplyDataDrivenModifier(caster, feather_barrage_bird, "modifier_feather_barrage_dummy", {duration = duration})

	feather_barrage_projectile_number = nil
	feather_barrage_projectile_hit_number = nil
	feather_barrage_casterloc = {}
end

function FollowHero (keys)
	local caster = keys.caster

	feather_barrage_bird:SetAbsOrigin(caster:GetAbsOrigin())
end

function ShootFeathers (keys)
	local caster = keys.caster
	local ability = keys.ability
	
	if feather_barrage_projectile_number == nil then
		feather_barrage_projectile_number = 1
	end
	
	feather_barrage_casterloc[feather_barrage_projectile_number] = feather_barrage_caster:GetAbsOrigin()
	local feather_barrage_casterlocation = feather_barrage_caster:GetAbsOrigin()
	feather_barrage_projectile_number = feather_barrage_projectile_number + 1
	feather_barrage_distance = (feather_barrage_casterlocation	 - feather_barrage_point):Length2D()
	feather_barrage_projectileradius = ability:GetLevelSpecialValueFor("projectile_aoe", ability:GetLevel() -1)
	feather_barrage_projectilespeed = ability:GetLevelSpecialValueFor("projectile_speed", ability:GetLevel() -1)
	local feather_barrage_direction = (feather_barrage_point - feather_barrage_casterlocation):Normalized()
	local feathers = keys.feather
	local feather = 
	{
		Ability = ability,
        EffectName = feathers,
        vSpawnOrigin = feather_barrage_casterlocation,
        fDistance = feather_barrage_distance,
        fStartRadius = feather_barrage_projectileradius,
        fEndRadius = feather_barrage_projectileradius,
        Source = feather_barrage_caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = feather_barrage_direction * feather_barrage_projectilespeed,
		bProvidesVision = true,
		iVisionRadius = feather_barrage_projectileradius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(feather)
end

function ProjectileHit (keys)
	local ability = keys.ability
	local target = keys.target

	if feather_barrage_projectile_hit_number == nil then
		feather_barrage_projectile_hit_number = 1
	end

	local feather_barrage_projectiledamagelossdistance = ability:GetLevelSpecialValueFor("projectile_loss_dist", ability:GetLevel() -1)
	local feather_barrage_projectiledamageloss = ability:GetLevelSpecialValueFor("projectile_loss_dmg", ability:GetLevel() -1) / 100
	local feather_barrage_projectiledamage = ability:GetLevelSpecialValueFor("projectiledamage", ability:GetLevel() -1)
	local feather_barrage_casterlocation = feather_barrage_casterloc[feather_barrage_projectile_hit_number]
	local feather_barrage_distance = (feather_barrage_casterlocation - target:GetAbsOrigin()):Length2D()
	feather_barrage_projectile_hit_number = feather_barrage_projectile_hit_number +1

	while (feather_barrage_distance > feather_barrage_projectiledamagelossdistance) do
		feather_barrage_distance = feather_barrage_distance - feather_barrage_projectiledamagelossdistance
		
		feather_barrage_projectiledamage = feather_barrage_projectiledamage * (1 - feather_barrage_projectiledamageloss)
	end

	local damageTable = 
	{
	victim = target,
	attacker = feather_barrage_caster,
	damage = feather_barrage_projectiledamage,
	damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
end


function KillBird ()
	feather_barrage_bird:RemoveSelf()
end


