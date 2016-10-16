modifier_corkscrew_slow = class ({})

function modifier_corkscrew_slow:DeclareFunctions()
	local funcs =
	{ 
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE	
	}
	return funcs
end

function modifier_corkscrew_slow:GetModifierMoveSpeed_AbsoluteMin (params)
	return 0.1
end

--[[function modifier_corkscrew_slow:GetModifierMoveSpeedBonus_Percentage(params)
	if IsServer() then
		local time_to_stop = self:GetAbility():GetLevelSpecialValueFor("time_to_stop",self:GetAbility():GetLevel()-1)
		local time = GameRules:GetGameTime()
		local slowpercentage = (time - self:GetAbility().StartTime)/time_to_stop
		if self.speed == nil then
			self.speed = self:GetParent():GetIdealSpeed()
		end
		return  self.speed * slowpercentage * -1
	end
end ]]