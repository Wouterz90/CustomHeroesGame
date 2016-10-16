--[[Author: Amused/D3luxe
	Used by: Pizzalol
	Date: 19.12.2014.
	Blinks the target to the target point, if the point is beyond max blink range then blink the maximum range]]
function Blink(keys)
	--PrintTable(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("footskill_range", (ability:GetLevel() - 1))
	
	ProjectileManager:ProjectileDodge(caster)


	FindClearSpaceForUnit(caster, point, false)	

end