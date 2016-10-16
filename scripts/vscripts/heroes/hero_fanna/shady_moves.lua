function RemoveSight(keys)
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	
	ability:ApplyDataDrivenThinker(caster,target_point,"modifier_shady_moves_dummy",{duration = ability:GetDuration()})
end

