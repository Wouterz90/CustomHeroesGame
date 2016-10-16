modifier_inflate_size = class({})
--if IsServer() then

	function modifier_inflate_size:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_MODEL_SCALE,
		}
		return funcs
	end

	function modifier_inflate_size:GetModifierModelScale()
		if IsServer() then
			
			return 50
		end
	end

	