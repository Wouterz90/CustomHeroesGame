--Taken from the spelllibrary, credits go to valve

modifier_flesh_heap_int = class({})



--------------------------------------------------------------------------------

function modifier_flesh_heap_int:OnCreated( kv )
	self.flesh_heap_intelligence_buff_amount = self:GetAbility():GetSpecialValueFor( "flesh_heap_intelligence_buff_amount" )
	if IsServer() then
		self:SetStackCount( self:GetAbility():GetFleshHeapKills() )
		self:GetParent():CalculateStatBonus()
	end
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_int:OnRefresh( kv )
	self.flesh_heap_intelligence_buff_amount = self:GetAbility():GetSpecialValueFor( "flesh_heap_intelligence_buff_amount" )
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

--------------------------------------------------------------------------------

function modifier_flesh_heap_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

--------------------------------------------------------------------------------


function modifier_flesh_heap_int:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() * self.flesh_heap_intelligence_buff_amount
end
