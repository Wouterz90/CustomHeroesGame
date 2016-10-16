if modifier_borus_positive_effect_enemies == nil then
	modifier_borus_positive_effect_enemies = class({})
end

function modifier_borus_positive_effect_enemies:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_borus_positive_effect_enemies:GetModifierPercentageCasttime(params)
	if IsServer() then
		return self:GetCaster().greater_magnet_cast_point_increase * -1
	end

end

function modifier_borus_positive_effect_enemies:GetModifierMoveSpeedBonus_Percentage (params)
	if IsServer() then
		return self:GetCaster().greater_magnet_ms_increase * -1
	end
end