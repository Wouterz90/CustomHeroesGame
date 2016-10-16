--[[
	Author: kritth (This is copied)
	Date: 1.1.2015
	Teleport Zidane to destination
]]
function Zidane_Footskill_teleport( keys )
	Print("HALLO")
	local point = keys.target_points[1]
	local caster = keys.caster
	FindClearSpaceForUnit( caster, point, false )
end