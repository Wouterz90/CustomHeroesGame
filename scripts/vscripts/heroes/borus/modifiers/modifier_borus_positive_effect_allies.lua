if modifier_borus_positive_effect_allies == nil then
	modifier_borus_positive_effect_allies = class({})
end


function modifier_borus_positive_effect_allies:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_borus_positive_effect_allies:GetModifierPercentageCasttime(params)
	if IsServer() then
		return self:GetCaster().greater_magnet_cast_point_increase
	end
end

function modifier_borus_positive_effect_allies:GetModifierMoveSpeedBonus_Percentage (params)
	if IsServer() then
		return self:GetCaster().greater_magnet_ms_increase
	end
end