if modifier_borus_greater_magnet_negative_aura_defensive == nil then
	modifier_borus_greater_magnet_negative_aura_defensive = class({})
end

function modifier_borus_greater_magnet_negative_aura_defensive:IsAura()
	return true
end

function modifier_borus_greater_magnet_negative_aura_defensive:GetModifierAura()
	return "modifier_borus_negative_effect_allies"
end

function modifier_borus_greater_magnet_negative_aura_defensive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end


function modifier_borus_greater_magnet_negative_aura_defensive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end



function modifier_borus_greater_magnet_negative_aura_defensive:GetAuraRadius()
	return self.radiusvisual
end

--------------------------------------------------------------------------------

function modifier_borus_greater_magnet_negative_aura_defensive:OnCreated( kv )
	self.radiusvisual = self:GetAbility():GetSpecialValueFor( "radiusvisual" )
	if IsServer() and self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink( 0.5 )
		self:SetDuration(0.1, false)
	end
end

--------------------------------------------------------------------------------

function modifier_borus_greater_magnet_negative_aura_defensive:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end