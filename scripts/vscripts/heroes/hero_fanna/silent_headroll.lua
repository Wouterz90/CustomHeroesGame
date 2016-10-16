function Hide(keys)
	local caster = keys.caster
	caster:AddNoDraw()
end

function Roll(keys)
	local caster = keys.caster
	local target_point = keys.target_points[1]
	FindClearSpaceForUnit(caster,target_point,true)
	caster:AddNewModifier(caster,nil,"modifier_phase",{duration = 0.2})
	caster:RemoveNoDraw()
	caster:RemoveModifierByName("modifier_silent_headroll_channeling")
end

function DragtoPoint(keys)
	local target = keys.target
	local caster = keys.caster
	local target_point = keys.target_points[1]
	--print(target:GetUnitName())
	if target:HasModifier("modifier_dagger_throw_dummy") then
		caster:FindAbilityByName("fanna_dagger_throw"):EndCooldown()
		target:RemoveSelf()
		
		
	elseif target:IsHero() and not (target:IsInvulnerable() or target:IsMagicImmune()) then

		local casterloc = caster:GetAbsOrigin()
		local targetloc = target:GetAbsOrigin()
		local targetdirection = target:GetForwardVector()

		local direction = (targetloc - casterloc):Normalized()
		local vision_cone = 90
		local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(targetdirection)).y)
		--print(angle)

		if angle > vision_cone then
			
			target:AddNewModifier(caster,nil,"modifier_phase",{duration = 0.1})
			FindClearSpaceForUnit(target,casterloc+(caster:GetForwardVector() *75),true)
			
		end
	end

end