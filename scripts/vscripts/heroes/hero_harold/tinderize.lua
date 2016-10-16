harold_tinderize = class({})

function harold_tinderize:OnSpellStart()
	self.isVectorTarget = true
	--print(self.isVectorTarget)
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local direction = self:GetTargetVector()
	local distance = self:GetLevelSpecialValueFor("distance",self:GetLevel()-1)
	local width = self:GetLevelSpecialValueFor("width",self:GetLevel()-1)
	local projectile = 
	{
		Ability = self,
	    EffectName = "particles/harold/harold_tinderize_swipe.vpcf",
	    vSpawnOrigin = point,
	    fDistance = distance,
	    fStartRadius = width,
	    fEndRadius = width,
	    Source = caster,
	    bHasFrontalCone = false,
	    bReplaceExisting = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    fExpireTime = GameRules:GetGameTime() + 1,
		bDeleteOnHit = false,
		vVelocity = Vector (direction.x, direction.y, 0) * distance,
		bProvidesVision = true,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(projectile)
end

function harold_tinderize:OnProjectileHit(hTarget,vLocation)
	if hTarget == nil then return end
	local caster = self:GetCaster()

	if hTarget:GetTeamNumber() == caster:GetTeamNumber() then
		hTarget:Heal(self:GetLevelSpecialValueFor("damage_or_heal",self:GetLevel()-1),caster)
	else
		local damageTable =
		{
			victim = hTarget,
			attacker = caster,
			damage = self:GetLevelSpecialValueFor("damage_or_heal",self:GetLevel()-1),
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damageTable)
		print("hurt")
	end
end