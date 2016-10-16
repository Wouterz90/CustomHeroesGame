if heist_item_display == nil then
	heist_item_display = ({})
end
function heist_item_display:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABILITY_LAYOUT,
	}
	return funcs
end

function heist_item_display:GetModifierAbilityLayout( params )
	return 6
end