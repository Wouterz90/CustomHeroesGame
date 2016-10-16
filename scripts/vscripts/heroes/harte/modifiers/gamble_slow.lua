if gamble_slow == nil then
	gamble_slow = class({})
end

function gamble_slow:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end


function gamble_slow:GetModifierMoveSpeedBonus_Percentage (params)
	return harte_gamble_slow
end