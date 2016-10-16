modifier_bird_clone = class({})
--if IsServer() then

	function modifier_bird_clone:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
			MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
			MODIFIER_EVENT_ON_TAKEDAMAGE,
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_EVENT_ON_DEATH,

		}
		return funcs
	end

	function modifier_bird_clone:GetModifierModelScale()
		if IsServer() then
			
			return -50
		end
	end

	function modifier_bird_clone:IsHidden()
		return true
	end
	function modifier_bird_clone:OnDeath()
		if IsServer() then
			local caster = self:GetCaster()
		
			if not self:GetParent():HasModifier("modifier_tag_exploded") then
				
			else
			
			end
		end
	end

	function modifier_bird_clone:GetModifierPhysicalArmorBonus()
		if IsServer() then
			local strength_factor = self:GetAbility():GetLevelSpecialValueFor("strength_factor",self:GetAbility():GetLevel() -1)
			return self:GetCaster():GetAgility() * 0.14 * strength_factor
		end
	end

	function modifier_bird_clone:GetModifierExtraManaBonus()
		if IsServer() then
			local strength_factor = self:GetAbility():GetLevelSpecialValueFor("strength_factor",self:GetAbility():GetLevel() -1)
			return self:GetCaster():GetIntellect() * 13 * strength_factor
		end
	end

	function modifier_bird_clone:GetModifierExtraHealthBonus()
		if IsServer() then
			local strength_factor = self:GetAbility():GetLevelSpecialValueFor("strength_factor",self:GetAbility():GetLevel() -1)
			return self:GetCaster():GetStrength()*19 * strength_factor
		end
	end
--end
