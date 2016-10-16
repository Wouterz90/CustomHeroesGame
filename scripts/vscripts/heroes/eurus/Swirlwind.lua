-- Thx to Ragnar Homsar from the spelllibrary, created with help off the bristleback spell

function Swirlwind (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local layersize = ability:GetLevelSpecialValueFor("layers", ability:GetLevel() -1)
	local aoe = ability:GetLevelSpecialValueFor("swirlwind_aoe", ability:GetLevel() -1)

	local casterloc = caster:GetAbsOrigin()
	local targetloc = target:GetAbsOrigin()
	local targetdirection = target:GetForwardVector()

	local distance_2d = (targetloc - casterloc):Length2D()
	local distance = targetloc - casterloc
	local direction = (targetloc - casterloc):Normalized()
	local vision_cone = 180
	local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(targetdirection)).y)
	print("angle = "..angle)
	if not (angle <= vision_cone/2) then		


		print("Facing Front")
		if distance_2d <= layersize then
			target:SetAbsOrigin(targetloc + direction * (layersize * 4))
		elseif distance_2d <= layersize *2 then 
			target:SetAbsOrigin(targetloc + direction * (layersize * 3))
		elseif distance_2d <= layersize *3 then
			target:SetAbsOrigin(targetloc + direction * (layersize * 2))
		elseif distance_2d <= layersize *4 then
			target:SetAbsOrigin(targetloc + direction * (layersize * 1))
		end
	else
		print("Facing Back")
		if distance_2d <= layersize then
			--target:SetAbsOrigin(targetloc + direction * (layersize * 0))
		elseif distance_2d <= layersize *2 then
			target:SetAbsOrigin(targetloc - direction * (layersize * 1))
		elseif distance_2d <= layersize *3 then
			target:SetAbsOrigin(targetloc - direction * (layersize * 2))
		elseif distance_2d <= layersize *4 then
			target:SetAbsOrigin(targetloc - direction * (layersize * 3))
		end
	end
	ability:ApplyDataDrivenModifier(caster,target,"no_collision",{duration = 0.2})
end




