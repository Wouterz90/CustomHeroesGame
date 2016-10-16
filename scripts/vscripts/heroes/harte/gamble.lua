if gamble == nil then
	gamble = class({})
end

LinkLuaModifier("gamble_slow","heroes/harte/modifiers/gamble_slow.lua",LUA_MODIFIER_MOTION_NONE)

function gamble:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	
	local block_chance = self:GetLevelSpecialValueFor("block_chance", self:GetLevel() -1)
	local one_x_attack_chance = self:GetLevelSpecialValueFor("1_x_attack_chance", self:GetLevel() -1)
	local two_x_attack_chance = self:GetLevelSpecialValueFor("2_x_attack_chance", self:GetLevel() -1)
	local three_x_attack_chance = self:GetLevelSpecialValueFor("3_x_attack_chance", self:GetLevel() -1)
	local four_x_attack_chance = self:GetLevelSpecialValueFor("4_x_attack_chance", self:GetLevel() -1)
	local max_slow_rate = self:GetLevelSpecialValueFor("max_slow_rate", self:GetLevel() -1) * -1
	local second_slow_rate = self:GetLevelSpecialValueFor("2nd_slow_rate", self:GetLevel() -1) * -1
	local third_slow_rate = self:GetLevelSpecialValueFor("3rd_slow_rate", self:GetLevel() -1) * -1
	local min_slow_rate = self:GetLevelSpecialValueFor("min_slow_rate", self:GetLevel() -1) * -1
	local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() -1)
	local distance = self:GetLevelSpecialValueFor("distance", self:GetLevel() -1)
	local projectile_speed = self:GetLevelSpecialValueFor("projectile_speed", self:GetLevel() -1)
	local projectile_aoe = self:GetLevelSpecialValueFor("projectile_aoe", self:GetLevel() -1)
	local missile = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
	local direction = (target - caster:GetAbsOrigin()):Normalized()

	local gamble_missile = 
	{
		Ability = self,
        EffectName = missile,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = distance,
        fStartRadius = projectile_aoe,
        fEndRadius = projectile_aoe,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + (distance / projectile_speed),
		bDeleteOnHit = true,
		vVelocity = direction * projectile_speed,
		bProvidesVision = true,
		iVisionRadius = projectile_aoe * 4,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile(gamble_missile)
end



function gamble:OnProjectileHit(hTarget)

	local caster = self:GetCaster()
	
	local block_chance = self:GetLevelSpecialValueFor("block_chance", self:GetLevel() -1) / 100
	local one_x_attack_chance = self:GetLevelSpecialValueFor("1_x_attack_chance", self:GetLevel() -1) / 100
	local two_x_attack_chance = self:GetLevelSpecialValueFor("2_x_attack_chance", self:GetLevel() -1) / 100
	local three_x_attack_chance = self:GetLevelSpecialValueFor("3_x_attack_chance", self:GetLevel() -1) / 100
	local four_x_attack_chance = self:GetLevelSpecialValueFor("4_x_attack_chance", self:GetLevel() -1) / 100
	local max_slow_rate = self:GetLevelSpecialValueFor("max_slow_rate", self:GetLevel() -1) * -1
	local second_slow_rate = self:GetLevelSpecialValueFor("2nd_slow_rate", self:GetLevel() -1) * -1
	local third_slow_rate = self:GetLevelSpecialValueFor("3rd_slow_rate", self:GetLevel() -1) * -1
	local min_slow_rate = self:GetLevelSpecialValueFor("min_slow_rate", self:GetLevel() -1) * -1
	local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() -1)
	local distance = self:GetLevelSpecialValueFor("distance", self:GetLevel() -1)
	local projectile_speed = self:GetLevelSpecialValueFor("projectile_speed", self:GetLevel() -1)
	local projectile_aoe = self:GetLevelSpecialValueFor("projectile_aoe", self:GetLevel() -1)
	local missile = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
	
	
	if hTarget ~= nil then
		local random = RandomFloat(0,1)
		print(random)
		local direction = (hTarget:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()		print(self:GetLevel())
		if self:GetLevel() == 1 then
			if random <= block_chance then
				harte_gamble_slow = max_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
			else
				harte_gamble_slow = min_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage(),
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			end
		elseif self:GetLevel() == 2 then
			if random <= block_chance then
				harte_gamble_slow = max_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
			elseif random <= block_chance + one_x_attack_chance then
				harte_gamble_slow = second_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage(),
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			else
				harte_gamble_slow = third_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage() * 2,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			end
		elseif self:GetLevel() == 3 then
			if random <= block_chance then
				harte_gamble_slow = max_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
			elseif random <= block_chance + one_x_attack_chance then
				harte_gamble_slow = second_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage(),
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			elseif random <= block_chance + two_x_attack_chance then
				harte_gamble_slow = third_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage() * 2,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			else
				harte_gamble_slow = min_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage() * 3,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			end
		elseif self:GetLevel() == 4 then
			if random <= block_chance then
				harte_gamble_slow = 0
				hTarget:AddNewModifier(caster, self,"modifier_stunned", {duration = duration})
			elseif random <= block_chance + one_x_attack_chance then
				harte_gamble_slow = max_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage(),
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			elseif random <= block_chance + two_x_attack_chance then
				harte_gamble_slow = second_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage() * 2,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			elseif random <= block_chance + three_x_attack_chance then
				harte_gamble_slow = third_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage() * 3,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			else
				harte_gamble_slow = min_slow_rate
				hTarget:AddNewModifier(caster, self,"gamble_slow", {duration = duration})
				local DamageTable =   -- Done in the modifier now.
				{
					victim = hTarget,
					attacker = caster,
					damage = caster:GetAttackDamage() * 4,
					damage_type = DAMAGE_TYPE_PHYSICAL,
				}
				ApplyDamage(DamageTable)
			end
		end
	end
end

