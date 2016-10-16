if modifier_borus_greater_magnet_positive_aura_offensive == nil then
	modifier_borus_greater_magnet_positive_aura_offensive = class({})
end

function modifier_borus_greater_magnet_positive_aura_offensive:IsAura()
	return true
end

function modifier_borus_greater_magnet_positive_aura_offensive:GetModifierAura()
	return "modifier_borus_positive_effect_enemies"
end

function modifier_borus_greater_magnet_positive_aura_offensive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end


function modifier_borus_greater_magnet_positive_aura_offensive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end



function modifier_borus_greater_magnet_positive_aura_offensive:GetAuraRadius()
	return self.radiusvisual
end

--------------------------------------------------------------------------------

function modifier_borus_greater_magnet_positive_aura_offensive:OnCreated( kv )
	self.radiusvisual = self:GetAbility():GetSpecialValueFor( "radiusvisual" )
	if IsServer() and self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink( 0.5 )
		self:SetDuration(0.1, false)
	end
end

--------------------------------------------------------------------------------

function modifier_borus_greater_magnet_positive_aura_offensive:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end