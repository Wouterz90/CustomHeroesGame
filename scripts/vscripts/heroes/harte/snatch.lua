if snatch == nil then
	snatch = class({})
end

LinkLuaModifier("snatched","heroes/harte/modifiers/snatched.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("snatcher","heroes/harte/modifiers/snatcher.lua",LUA_MODIFIER_MOTION_NONE)



function snatch:OnSpellStart()

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetDuration()

	local base = self:GetLevelSpecialValueFor("base_reduction", self:GetLevel() -1) / 100
	local other = self:GetLevelSpecialValueFor("other_reduction", self:GetLevel() -1) / 100
		
	local base_armor_snatch = target:GetPhysicalArmorBaseValue() * base * -1
	local other_armor_snatch = (target:GetPhysicalArmorValue() - target:GetPhysicalArmorBaseValue()) * other * -1
	caster.snatched_armor = base_armor_snatch + other_armor_snatch

	local base_attack_snatch = target:GetAttackDamage() * base * -1
	local other_attack_snatch = target:GetAverageTrueAttackDamage() * other * -1
	caster.snatched_attack = base_attack_snatch + other_attack_snatch

	if target:IsRangedAttacker() then
		caster.snatch_range = 322
	end

	target:AddNewModifier(caster, self, "snatched", {duration = duration})
	caster:AddNewModifier(caster, self, "snatcher", {duration = duration})
end

