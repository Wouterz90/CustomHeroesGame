if snatched == nil then
	snatched = class({})
end

function snatched:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		print(caster.snatched_armor)
		print(caster.snatched_attack)
	end
end


function snatched:DeclareFunctions()
	local funcs =
	{ 
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	}
	return funcs
end

function snatched:GetModifierPhysicalArmorBonus( params )
	--if IsServer() then
		local caster = self:GetCaster()
		return caster.snatched_armor
	--end
end

function snatched:GetModifierAttackSpeedBonus_Constant( params )
	--if IsServer() then
		local caster = self:GetCaster()
		return caster.snatched_attack
	--end
end