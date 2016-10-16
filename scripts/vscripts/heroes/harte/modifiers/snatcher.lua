if snatcher == nil then
	snatcher = class({})
end

function snatcher:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster.snatch_range == nil then
			caster.snatch_range = 0
		end
	end
end

function snatcher:DeclareFunctions()
	local funcs =
	{ 
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
	return funcs
end

function snatcher:GetModifierPhysicalArmorBonus( params )
	--if IsServer() then
		local caster = self:GetCaster()
		return caster.snatched_armor * -1
	--end
end
function snatcher:GetModifierAttackSpeedBonus_Constant( params )
	--if IsServer() then
		local caster = self:GetCaster()
		return caster.snatched_attack * -1
	--end
end


function snatcher:GetModifierAttackRangeBonus( params )
	--if IsServer() then
		local caster = self:GetCaster()
		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		return caster.snatch_range
	--end
end

function snatcher:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end
end