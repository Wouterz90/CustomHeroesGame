function Maelstrom (keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local ability = keys.ability
	local dur = ability:GetDuration()

	ability:ApplyDataDrivenThinker(caster, point, "maelstrom_slow_aura", {duration = dur})
	ability:ApplyDataDrivenThinker(caster, point, "maelstrom_speed_aura", {duration = dur})

end
