modifier_super_strength_lua = class({})

function modifier_super_strength_lua: DeclareFunctions()
	local funcs_array = 
	{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}

	return funcs_array
end

function modifier_super_strength_lua: GetModifierBonusStats_Strength(params)
	return 100;
end

