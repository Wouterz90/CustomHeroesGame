if modifier_break_speed_limit == nil
	then modifier_break_speed_limit = class({})
end

function modifier_break_speed_limit:DeclareFunctions()
	local funcs =
	{ 
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	}
	return funcs
end

function modifier_break_speed_limit:GetAttributes() 
    return 
    {
    MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE,
    MODIFIER_ATTRIBUTE_PERMANENT
	}
end

function modifier_break_speed_limit:IsHidden()
    return true
end

function modifier_break_speed_limit:GetModifierMoveSpeed_Limit( params )
	return 700
end

function modifier_break_speed_limit:GetModifierMoveSpeed_Max( params )
    return 700
end