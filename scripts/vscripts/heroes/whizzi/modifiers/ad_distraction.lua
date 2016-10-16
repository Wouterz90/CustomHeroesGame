if ad_distraction == nil then 
	ad_distraction = class({}) 
end
function ad_distraction:OnCreated()
	if IsServer() then
		caster = self:GetCaster()
		ability = self:GetAbility()
		target = self:GetParent()
		casttime = ability:GetLevelSpecialValueFor("cast_point_increase", ability:GetLevel() - 1)
	end
end

function ad_distraction:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	}
 
	return funcs
end

function ad_distraction:GetModifierPercentageCasttime(params)
	if IsServer() then
		return casttime
	end
end
