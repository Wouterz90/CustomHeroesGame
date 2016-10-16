modifier_cinderized_buff = class({})

function modifier_cinderized_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_cinderized_buff:GetModifierAttackSpeedBonus_Constant(params)
	if IsServer() then
		return self:GetAbility():GetLevelSpecialValueFor("as_increase",self:GetAbility():GetLevel() -1)
	end
end

function modifier_cinderized_buff:GetModifierPercentageCasttime(params)
	if IsServer() then
		return self:GetAbility():GetLevelSpecialValueFor("cast_point_haste",self:GetAbility():GetLevel() -1)
	end
end

function modifier_cinderized_buff:GetModifierTotalDamageOutgoing_Percentage(params)
	if IsServer() then
		return self:GetAbility():GetLevelSpecialValueFor("damage_reduction",self:GetAbility():GetLevel() -1)
	end
end

function modifier_cinderized_buff:IsBuff()
	return true
end	