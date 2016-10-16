if momentum_break_limit == nil
	then momentum_break_limit = class({})
end


function momentum_break_limit:DeclareFunctions()
	local funcs =
	{ 
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,	
	}
	return funcs
end

function momentum_break_limit:GetAttributes() 
    return 
    {
    MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE,
    MODIFIER_ATTRIBUTE_PERMANENT
	}
end

function momentum_break_limit:IsHidden()
    return true
end

function momentum_break_limit:IsPurgable()
    return false
end



function momentum_break_limit:GetModifierMoveSpeed_Limit( params )
	return 650
end

function momentum_break_limit:GetModifierMoveSpeed_Max( params )
    return 650
end

function momentum_break_limit:MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE( params )
	if IsServer() then 
		if momentum_bonusdamage == nil then
			momentum_bonusdamage = 0
		end
	end
    return momentum_bonusdamage
end