if arbalest_attack_dummy == nil then
	arbalest_attack_dummy = class({})
end

function arbalest_attack_dummy:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		--attackspeed = caster:GetIncreasedAttackSpeed() * 50
		self:StartIntervalThink(0.1)
	end
end



function arbalest_attack_dummy:IsHidden()
	return true
end

function arbalest_attack_dummy:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
 
	return funcs
end

function arbalest_attack_dummy:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		attackspeed = caster:GetIncreasedAttackSpeed() * 50
		caster:CalculateStatBonus()
	end
end

function arbalest_attack_dummy:GetModifierBaseAttack_BonusDamage(params)
	--if IsServer() then
		return attackspeed
	--end
end