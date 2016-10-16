fanna_dagger_throw = class({})
LinkLuaModifier("modifier_dagger_throw_slow_turnrate","heroes/hero_fanna/dagger_throw.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dagger_throw_bonus_speed","heroes/hero_fanna/dagger_throw.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dagger_throw_dummy","heroes/hero_fanna/dagger_throw.lua",LUA_MODIFIER_MOTION_NONE)

function fanna_dagger_throw:OnSpellStart()
	local caster = self:GetCaster()
	self.startlocation = caster:GetAbsOrigin()
	self.direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	local dagger_width = self:GetLevelSpecialValueFor("projectile_width",self:GetLevel()-1)
	local throw_speed = self:GetLevelSpecialValueFor("projectile_speed",self:GetLevel()-1)
	local min_throw_range = self:GetLevelSpecialValueFor("min_throw_range",self:GetLevel()-1)
	local max_throw_range = self:GetLevelSpecialValueFor("max_throw_range",self:GetLevel()-1)
	self.dagger =
	{
		Ability = self,
	    EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
	    vSpawnOrigin = caster:GetAbsOrigin(),
	    fDistance = max_throw_range,
	    StartRadius = dagger_width,
	    fEndRadius = dagger_width,
	    Source = caster,
	    bHasFrontalCone = false,
	    bReplaceExisting = false,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO,
	    fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = self.direction * throw_speed,
		bProvidesVision = true,
		iVisionRadius = dagger_width,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	self.DaggerProjectile = ProjectileManager:CreateLinearProjectile(self.dagger)
	
	

end

--[[
function fanna_dagger_throw:OnProjectileThink(vLocation)
	local caster = self:GetCaster()
	local min_throw_range = self:GetLevelSpecialValueFor("min_throw_range",self:GetLevel()-1)
	local dagger_width = self:GetLevelSpecialValueFor("dagger_width",self:GetLevel()-1)
	local throw_speed = self:GetLevelSpecialValueFor("throw_speed",self:GetLevel()-1)
	local max_throw_range = self:GetLevelSpecialValueFor("max_throw_range",self:GetLevel()-1)
	--print((vLocation - self.startlocation):Length2D())
	if (vLocation - self.startlocation):Length2D() > min_throw_range and self.projectieTrigger == false then
		
		self.dagger =
		{
			Ability = self,
		    EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		    vSpawnOrigin = vLocation,
		    fDistance = min_throw_range,
		    StartRadius = dagger_width,
		    fEndRadius = dagger_width,
		    Source = caster,
		    bHasFrontalCone = false,
		    bReplaceExisting = false,
		    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		    iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		    fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = self.direction * throw_speed,
			bProvidesVision = true,
			iVisionRadius = dagger_width,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		self.doDamageTarget = true
		self.projectieTrigger = true
		DaggerProjectile2 = ProjectileManager:CreateLinearProjectile(self.dagger)

	end
end
]]

function fanna_dagger_throw:OnProjectileHit(hTarget,vLocation)
	local caster = self:GetCaster()
	local duration = self:GetLevelSpecialValueFor("duration",self:GetLevel() -1)
	local min_throw_range = self:GetLevelSpecialValueFor("min_throw_range",self:GetLevel()-1)
	local max_throw_range = self:GetLevelSpecialValueFor("max_throw_range",self:GetLevel()-1)
	local initial_pos = caster:GetAbsOrigin()
	if hTarget then
		--caster:SetAbsOrigin(vLocation)
		--caster:PerformAttack(hTarget,true,true,true,true,false)
		--caster:SetAbsOrigin(initial_pos)
		local damageTable = 
		{
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self:GetLevelSpecialValueFor("damage",self:GetLevel()-1),
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
		}
		ApplyDamage(damageTable)
		hTarget:AddNewModifier(caster,self,"modifier_dagger_throw_slow_turnrate",{duration = duration})
		ProjectileManager:DestroyLinearProjectile(self.DaggerProjectile)
	end
	if (vLocation - self.startlocation):Length2D() > min_throw_range then
		self.DaggerUnit = CreateUnitByName("npc_dota_dagger_unit",vLocation,true,caster,caster,caster:GetTeamNumber())
		self.DaggerUnit:AddNewModifier(caster,self,"modifier_dagger_throw_dummy",{})
		self.DaggerUnit:SetModelScale(3)
		if caster:HasScepter() and caster:HasModifier("modifier_chain_buddies_chained") then
			local remainingduration = caster:FindModifierByName("modifier_chain_buddies_chained"):GetDuration()

			caster:RemoveModifierByName("modifier_chain_buddies_chained")
			ParticleManager:DestroyParticle(caster.chain,true)

			if caster:HasAbility("fanna_chain_buddies_2nd") then
				local ability2 = caster:FindAbilityByName("fanna_chain_buddies_2nd")
				local abilitylevel = ability2:GetLevel()
				caster:AddAbility("fanna_chain_buddies")
				caster:SwapAbilities("fanna_chain_buddies","fanna_chain_buddies_2nd",true,false)
				local chain_buddies = caster:FindAbilityByName("fanna_chain_buddies")
				chain_buddies:SetLevel(abilitylevel)
				caster:RemoveAbility("fanna_chain_buddies_2nd")
			end

			local chain_buddies = caster:FindAbilityByName("fanna_chain_buddies")
			caster.chain = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)
        	ParticleManager:SetParticleControlEnt(caster.chain, 0, caster.target, PATTACH_POINT, "attach_hitloc", caster.target:GetAbsOrigin(), true)
        	ParticleManager:SetParticleControlEnt(caster.chain, 1, self.DaggerUnit, PATTACH_POINT, "attach_hitloc", self.DaggerUnit:GetAbsOrigin(), true)
        	ParticleManager:SetParticleControl(caster.chain, 2, Vector(duration,0,0))
			chain_buddies:ApplyDataDrivenModifier(caster,self.DaggerUnit,"modifier_chain_buddies_chained",{duration = remainingduration})

			if caster.chainlength > caster.target2:GetRangeToUnit(caster.target) then 
				caster.chainlength = caster.target2:GetRangeToUnit(caster.target)
			end
			caster.target2 = self.DaggerUnit
			local direction = (caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Normalized()
			caster.target:SetAbsOrigin(caster.target2:GetAbsOrigin() + (direction * caster.chainlength))
			

		end
	end
end

modifier_dagger_throw_slow_turnrate = class({})

function modifier_dagger_throw_slow_turnrate:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

function modifier_dagger_throw_slow_turnrate:GetModifierTurnRate_Percentage()
	if IsServer() then
		return self:GetAbility():GetLevelSpecialValueFor("turn_rate_slow",self:GetAbility():GetLevel()-1)
	end
end



modifier_dagger_throw_dummy = class({})
function modifier_dagger_throw_dummy:CheckState()
	if not self:GetParent():IsHero() then
	 	return 
	 	{ 
	 	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 	[MODIFIER_STATE_INVULNERABLE] = true,
	 	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	 	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	 	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	 	[MODIFIER_STATE_UNSELECTABLE] = true,
	 	} 
 	else
 		return
 		{}
 	end
end
function modifier_dagger_throw_dummy:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_dagger_throw_dummy:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local unit = self:GetParent()
		local ability = self:GetAbility()
		
		if (caster:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() < ability:GetLevelSpecialValueFor("lost_dagger_search_range",ability:GetLevel()-1) then
			ability:EndCooldown()
			unit:RemoveSelf()
		end

		if ability:IsCooldownReady() and not unit:IsNull() then
			unit:RemoveSelf()
		end	
	end
end