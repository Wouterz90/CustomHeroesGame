modifier_desperation_tactics_crit = class({})

function modifier_desperation_tactics_crit:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_desperation_tactics_crit:IsHidden()
	return false
end

function modifier_desperation_tactics_crit:OnIntervalThink(kv)
	self:GetCaster():RemoveModifierByName(self:GetName())
end

function modifier_desperation_tactics_crit:GetModifierPreAttack_CriticalStrike(params)
	if IsServer() then

		return 200 --self:GetAbility():GetLevelSpecialValueFor("crit_multiplier",self:GetAbility():GetLevel()-1) *100
	end
end

function modifier_desperation_tactics_crit:OnAttackLanded(kv)
	local caster = self:GetCaster()
	self:StartIntervalThink(0.1)
	CritTwiceLua(caster)

end