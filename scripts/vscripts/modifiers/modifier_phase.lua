modifier_phase = class({})

function modifier_phase:CheckState()
	local funcs = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return funcs
end

function modifier_phase:IsHidden()
	return true
end

