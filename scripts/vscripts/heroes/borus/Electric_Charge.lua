function Positive_Charge (keys)  -- The name of  your function. This can be anything. (keys) is used to get values ou of your abilities_custom file.
	local target = keys.target  -- Like over here, I let the script know what the target is.
	local caster = keys.caster  -- local values are only used in this function. Not writing local in front of them makes them global, that means only in this document.
	local ability = keys.ability
	local dur = ability:GetSpecialValueFor("duration") -- In Here I get the AbilitySpecial value "duration". 
	local maximum_charges = ability:GetSpecialValueFor( "maximum_charges")		 -- The GetLevelSpecialValue can change on different levels
	local charge_replenish_time = ability:GetSpecialValueFor( "charge_replenish_time" )
	local modifierName = "electric_charge_stack_counter" 
	local Theotherability = caster:FindAbilityByName("Negative_Charge")
	local positive_damage = ability:GetAbilityDamage() 
	borus_caster = keys.caster
	
	if caster.electric_charge_charges > 0 then  -- Checking if there are charges

		local next_charge = caster.electric_charge_charges - 1  -- Removing a charge
		
		if caster.electric_charge_charges == maximum_charges then 
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { duration = charge_replenish_time } )
			electric_charge_start_cooldown( caster, charge_replenish_time ) -- starts another fucntion, the one that controls the recharging
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )  -- Controls the visible amount
		caster.electric_charge_charges = next_charge						--Controls the invisible amount, its the same	
		-- Check if stack is 0, display ability cooldown
		if caster.electric_charge_charges == 0 then
			-- Start Cooldown from caster.live_transfusion_cooldown
			ability:StartCooldown( caster.electric_charge_cooldown )
			Theotherability:StartCooldown( charge_replenish_time )
		else
			ability:EndCooldown()
			Theotherability:EndCooldown()
		end

		ability:ApplyDataDrivenModifier(caster, target, "Positive_Charge_Magnetic", {duration = dur})

		target:RemoveModifierByName("Negative_Charge_Magnetic")

	else
		ability:RefundManaCost()
	end
end

function Negative_Charge (keys)  -- The name of  your function. This can be anything. (keys) is used to get values ou of your abilities_custom file.
	local target = keys.target  -- Like over here, I let the script know what the target is.
	local caster = keys.caster  -- local values are only used in this function. Not writing local in front of them makes them global, that means only in this document.
	local ability = keys.ability
	local dur = ability:GetSpecialValueFor("duration") -- In Here I get the AbilitySpecial value "duration". 
	local maximum_charges = ability:GetSpecialValueFor( "maximum_charges")		
	local charge_replenish_time = ability:GetSpecialValueFor( "charge_replenish_time")
	local modifierName = "electric_charge_stack_counter"
	local Otherability = caster:FindAbilityByName("Positive_Charge")
	local negative_damage = ability:GetAbilityDamage() -- Standard functions don't require a level.
	borus_caster = keys.caster
	
	if caster.electric_charge_charges > 0 then  -- Checking if there are charges

		local next_charge = caster.electric_charge_charges - 1  -- Removing a charge
		
		if caster.electric_charge_charges == maximum_charges then 
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { duration = charge_replenish_time } )
			electric_charge_start_cooldown( caster, charge_replenish_time ) -- starts another fucntion, the one that controls the recharging
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )  -- Controls the visible amount
		caster.electric_charge_charges = next_charge						--Controls the invisible amount, its the same	
		-- Check if stack is 0, display ability cooldown
		if caster.electric_charge_charges == 0 then

			ability:StartCooldown( caster.electric_charge_cooldown )
			Otherability:StartCooldown( charge_replenish_time )
		else
			ability:EndCooldown()
			Otherability:EndCooldown()
		end

		ability:ApplyDataDrivenModifier(caster, target, "Negative_Charge_Magnetic", {duration = dur})

		target:RemoveModifierByName("Positive_Charge_Magnetic")

	else
		ability:RefundManaCost()
	end
end

function Magnetic_Positive (keys) -- This function gets called every .01 second whenever there is a unit around the modified unit.
	local target = keys.target
	local ability = keys.ability
	local magnetic_aoe = ability:GetSpecialValueFor("magnetic_aoe") -- Getting special values again. I don't use GetLevelSpecialValue because they don't change.
	local supermagnetic_aoe = ability:GetSpecialValueFor("magnetic_aoe")
	local pull_speed = ability:GetSpecialValueFor("pull_speed") * 0.01 -- Because the Interval = 0.01 I have to adjust the speed accordingly.
	local min_range = ability:GetSpecialValueFor("min_range")

	local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_NEUTRALS + DOTA_TEAM_GOODGUYS, target:GetAbsOrigin(), nil, magnetic_aoe, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
																		-- This is a loop, checking all units. You would generally use ActOnTargets via datadriven though.
	for _,unit in pairs(targets) do 
		if unit == target then
		else

			if unit:HasModifier("Negative_Charge_Magnetic") then  -- Checking if there is an opposite charge
				local targetloc = target:GetAbsOrigin()				-- GetAbsOrigin() stores the location
				local unitloc = unit:GetAbsOrigin()
				local vector_distance = targetloc - unitloc			-- I have no idea about vector logic, I took this from dark seers vacuum.
				local distance = (vector_distance):Length2D()		-- Lenght2d() Gets the distance between the 2 units in dota's metric value "units"
				local direction = (vector_distance):Normalized()		-- I'm pretty this has something to do with the direction.

				if distance < min_range then 					-- Here I am checking if the units are getting too close to each other.
					ability:ApplyDataDrivenModifier(target, target, "no_collision", {duration = 2})
					target:RemoveModifierByName("Positive_Charge_Magnetic")  -- SetAbsOrigin obviously sets the new location. I don't know why it works like this but it does work like this.
					unit:RemoveModifierByName("Negative_Charge_Magnetic")
					FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
					FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
				else															-- You have your location and you multiply your direction by the amount of units you want to move.
				 														-- This only moved the unit with a positive charge. Since we know the negative charge is on the other unit we can do the same for that one.
					if distance < magnetic_aoe then 								-- Because the modifier should get removed after a certain point we check that here.
						target:SetAbsOrigin(targetloc - direction * pull_speed) -- In here we remove the modifier.
					end
				end
			end 

			if unit:HasModifier("Positive_Charge_Magnetic") then
				local targetloc = target:GetAbsOrigin()				-- GetAbsOrigin() stores the location
				local unitloc = unit:GetAbsOrigin()
				local vector_distance = targetloc - unitloc		-- I have no idea about vector logic, I took this from dark seers vacuum.
				local distance = (vector_distance):Length2D()		-- Lenght2d() Gets the distance between the 2 units in dota's metric value "units"
				local direction = vector_distance:Normalized()		-- I'm pretty this has something to do with the direction.

				if distance < (magnetic_aoe / 2) then
					target:SetAbsOrigin(targetloc + direction * pull_speed) -- This pushes them back
				end
			end
		end
	end
end

function Magnetic_Negative (keys)
	local target = keys.target
	local ability = keys.ability
	local magnetic_aoe = ability:GetSpecialValueFor("magnetic_aoe")
	local supermagnetic_aoe = ability:GetSpecialValueFor("magnetic_aoe")
	local pull_speed = ability:GetSpecialValueFor("pull_speed") * 0.01 -- Interval = 0.01
	local min_range = ability:GetSpecialValueFor("min_range")
	local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_NEUTRALS + DOTA_TEAM_GOODGUYS, target:GetAbsOrigin(), nil, magnetic_aoe, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,unit in pairs(targets) do
		if unit == target then
		else 
			if unit:HasModifier("Positive_Charge_Magnetic") then
				local unitloc = unit:GetAbsOrigin()
				local targetloc = target:GetAbsOrigin()
				local vector_distance = targetloc - unitloc
				local distance = (vector_distance):Length2D()
				local direction = vector_distance:Normalized()	

				if distance < min_range then
					ability:ApplyDataDrivenModifier(target, target, "no_collision", {duration = 2})
					target:RemoveModifierByName("Negative_Charge_Magnetic")
					unit:RemoveModifierByName("Positive_Charge_Magnetic")
					FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
					FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
				else
					if distance < magnetic_aoe then
						target:SetAbsOrigin(targetloc - direction * pull_speed)
					end
				end
			end

			if unit:HasModifier("Negative_Charge_Magnetic") then
				local unitloc = unit:GetAbsOrigin()				-- GetAbsOrigin() stores the location
				local targetloc = target:GetAbsOrigin()
				local vector_distance = targetloc - unitloc			-- I have no idea about vector logic, I took this from dark seers vacuum.
				local distance = (vector_distance):Length2D()		-- Lenght2d() Gets the distance between the 2 units in dota's metric value "units"
				local direction = vector_distance:Normalized()		-- I'm pretty this has something to do with the direction.

				if distance < (magnetic_aoe / 2) then
					target:SetAbsOrigin(targetloc + direction * pull_speed)
				end
			end
		end
	end
end

function metal_rod( keys )
	
	local target = keys.target
	local caster = borus_caster
	local ability = caster:FindAbilityByName("Positive_Charge")
	local rod = keys.ability
	local pull_speed = ability:GetSpecialValueFor("pull_speed") * 0.01 -- Interval = 0.01
	local metal_rod_aoe = ability:GetSpecialValueFor("magnetic_aoe")
	local metal_rod_ability = caster:FindAbilityByName("Metal_Rod")
	local metal_rod_leash_duration = ability:GetLevelSpecialValueFor("metal_rod_leash_duration",  ( metal_rod_ability:GetLevel() - 1 ))
	local silence_duration = metal_rod_ability:GetLevelSpecialValueFor("Silence_duration",  ( metal_rod_ability:GetLevel() - 1 ))

	local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_NEUTRALS + DOTA_TEAM_GOODGUYS, target:GetAbsOrigin(), nil, metal_rod_aoe, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do
		if unit:GetUnitName() == target:GetUnitName() then
		else
			if target:GetTeamNumber() == caster:GetTeamNumber() then
			else
				if unit:GetUnitName() == "npc_magnet_unit" then
					local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_NEUTRALS + DOTA_TEAM_GOODGUYS, target:GetAbsOrigin(), nil, metal_rod_aoe, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
					for _,unit in pairs(targets) do
						local unitlocation = unit:GetAbsOrigin()
						local targetlocation = target:GetAbsOrigin()
						local vector_distance = targetlocation - unitlocation

							local distance = (vector_distance):Length2D()
							local direction = (vector_distance):Normalized()

						
						if (distance < 30) and (distance ~= 0) then
							if target:HasModifier("Negative_Charge_Magnetic") then 
								target:RemoveModifierByName("Negative_Charge_Magnetic")
								metal_rod_ability:ApplyDataDrivenModifier(caster,target,"rod_disarm", {duration = silence_duration })
							end
							if target:HasModifier("Positive_Charge_Magnetic") then 
								target:RemoveModifierByName("Positive_Charge_Magnetic")
								metal_rod_ability:ApplyDataDrivenModifier(caster,target,"rod_silence", {duration = silence_duration })
							end
							ability:ApplyDataDrivenModifier(caster, target, "no_collision", {duration = 0.2})
							ability:ApplyDataDrivenModifier(unit,target,"metal_rod_leash", {duration = metal_rod_leash_duration})
							leash_magnet_unit = unit

						end
						if distance < metal_rod_aoe then
							target:SetAbsOrigin(targetlocation - direction * pull_speed)
						end
					end
				end
			end
		end
	end
end




function electric_charge_start_charge( keys )  -- Copied from shrapnel. Credit goes to kritth from the spelllibrary
	-- Only start charging at level 1
	if keys.ability:GetLevel() ~= 1 then return end

	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "electric_charge_stack_counter"
	local maximum_charges = ability:GetLevelSpecialValueFor( "max_charges", ( ability:GetLevel() - 1 ) )
	local charge_replenish_time = ability:GetLevelSpecialValueFor( "charge_replenish_time", ( ability:GetLevel() - 1 ) )
	
	-- Initialize stack
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.electric_charge_charges = maximum_charges
	caster.start_charge = false
	caster.electric_charge_cooldown = charge_replenish_time
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, 0 )
	
	-- create timer to restore stack
	Timers:CreateTimer( function()
			-- Restore charge
			if caster.start_charge and caster.electric_charge_charges < maximum_charges then
				-- Calculate stacks
				local next_charge = caster.electric_charge_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { duration = charge_replenish_time } )
					electric_charge_start_cooldown( caster, charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, caster, next_charge )
				
				-- Update stack
				caster.electric_charge_charges = next_charge
			end
			
			-- Check if max is reached then check every 0.5 seconds if the charge is used
			if caster.electric_charge_charges ~= maximum_charges then
				caster.start_charge = true
				return charge_replenish_time
			else
				return 0.5
			end
		end
	)
end

--[[
	Author: kritth
	Date: 6.1.2015.
	Helper: Create timer to track cooldown
]]
function electric_charge_start_cooldown( caster, charge_replenish_time )
	caster.electric_charge_cooldown = charge_replenish_time
	Timers:CreateTimer( function()
			local current_cooldown = caster.electric_charge_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.electric_charge_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end
	)
end

function metal_rod_leash( keys )

	local target = keys.target
	local currTime = GameRules:GetGameTime()
	local caster = borus_caster
	local ability = caster:FindAbilityByName("Positive_Charge")
	local leash_range = ability:GetSpecialValueFor("leash_range")
	
	if target.positions[(math.floor((currTime -0.04) * 25)/25)] ~= nil then
		target.OldPosition = target.positions[(math.floor((currTime -0.04) * 25)/25)]
	end
	if magnetposition == nil then
		magnetposition = leash_magnet_unit:GetAbsOrigin()
	end
	if (magnetposition - target:GetAbsOrigin()):Length2D() > (leash_range * 1.5) then
		target:RemoveModifierByName("metal_rod_leash")
	elseif (magnetposition - target:GetAbsOrigin()):Length2D() > leash_range then
		target:SetAbsOrigin(target.OldPosition)
	end
	

	if leash_magnet_unit:IsNull() then
		target:RemoveModifierByName("metal_rod_leash")
	end
end
 function metal_rod_leash_reset_values (keys)
 	local target = keys.target
 	magnetposition = nil 
 	

end 
 