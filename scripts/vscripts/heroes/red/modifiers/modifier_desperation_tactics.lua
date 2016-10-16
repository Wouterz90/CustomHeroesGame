modifier_desperation_tactics = class({})


function modifier_desperation_tactics:DeclareFunctions()	
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_desperation_tactics:IsPassive()
	return true
end
function modifier_desperation_tactics:IsHidden()
	return false
end
function modifier_desperation_tactics:GetModifierModelScale()
	if IsServer() then
		--print((0 + (25-self:GetCaster():GetHealthPercent()/2)))
		return  (0 + (25-self:GetCaster():GetHealthPercent()/2))
	end
end


function modifier_desperation_tactics:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		local evadechance = ability:GetLevelSpecialValueFor("evasion_chance",ability:GetLevel()-1)
		local base_chance = ability:GetLevelSpecialValueFor("base_chance",ability:GetLevel()-1)
		local casterhealthpercent = (100 - caster:GetHealthPercent())/100
		self.evasion = base_chance + (evadechance * casterhealthpercent)
		self:ForceRefresh()
		
	end
end
function modifier_desperation_tactics:OnCreated(kv)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	self:StartIntervalThink(0.1)
	if IsServer() then
		local evadechance = ability:GetLevelSpecialValueFor("evasion_chance",ability:GetLevel()-1)
		local base_chance = ability:GetLevelSpecialValueFor("base_chance",ability:GetLevel()-1)
		local casterhealthpercent = (100 - caster:GetHealthPercent())/100
		self.evasion = base_chance + (evadechance * casterhealthpercent)
	end
end
function modifier_desperation_tactics:OnAttackStart(kv)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	
	if IsServer() then
		local random = RandomInt(0,100)
		local critchance = ability:GetLevelSpecialValueFor("crit_chance",ability:GetLevel()-1)
		local base_chance = ability:GetLevelSpecialValueFor("base_chance",ability:GetLevel()-1)
		local casterhealthpercent = (100 - caster:GetHealthPercent())/100 
		if random < base_chance +(critchance*casterhealthpercent) then
			--caster:AddNewModifier(caster,ability,"modifier_desperation_tactics_crit",nil)
			self:GetCaster():FindAbilityByName("Mikhail_Sacrifice"):ApplyDataDrivenModifier(self:GetCaster(),self:GetCaster(),"modifier_sacrifice_crit",nil)
		end
	end
		
end
function modifier_desperation_tactics:OnAttackFail(kv)
	self:GetCaster():RemoveModifierByName("modifier_desperation_tactics_crit")
end


function modifier_desperation_tactics:GetModifierEvasion_Constant(params)
	return self.evasion
end