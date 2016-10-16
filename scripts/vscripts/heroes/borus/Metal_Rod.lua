function Metal_Rod (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]
	local duration = ability:GetDuration()
	local modifierName = "metal_rod_stack_counter"
	local maximum_charges = ability:GetLevelSpecialValueFor( "Rod_Charges", ( ability:GetLevel() - 1 ) )
	local metal_rod_charge_replenish_time = ability:GetLevelSpecialValueFor( "metal_rod_charge_replenish_time", ( ability:GetLevel() - 1 ) )

	if caster.metal_rod_charges > 0 then  -- Checking if there are charges

		local next_charge = caster.metal_rod_charges - 1  -- Removing a charge
		
		if caster.metal_rod_charges == maximum_charges then 
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { duration = metal_rod_charge_replenish_time } )
			metal_rod_start_cooldown( caster, metal_rod_charge_replenish_time ) -- starts another fucntion, the one that controls the recharging
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )  -- Controls the visible amount
		caster.metal_rod_charges = next_charge						--Controls the invisible amount, its the same	
		-- Check if stack is 0, display ability cooldown
		if caster.metal_rod_charges == 0 then
			-- Start Cooldown from caster.live_transfusion_cooldown
			ability:StartCooldown( caster.metal_rod_cooldown )
		else
			ability:EndCooldown()
		end


		local metal_rod_unit = CreateUnitByName("npc_magnet_unit", target_point, false, nil, nil, caster:GetTeam())
			 
			--We give the ice wall dummy unit its own instance of Ice Wall both to more easily make it apply the correct intensity of slow (based on Quas' level)
			--and because if Invoker uninvokes Ice Wall and the spell is removed from his toolbar, existing modifiers originating from that ability can start to error out.
		metal_rod_unit:AddAbility("Metal_Rod")
		local metal_rod_unit_ability = metal_rod_unit:FindAbilityByName("Metal_Rod")
		if metal_rod_unit_ability ~= nil then
			metal_rod_unit_ability:ApplyDataDrivenModifier(metal_rod_unit, metal_rod_unit, "metal_rod_modifier_dummy", {duration = -1})
		end
		metal_rod_unit.parent_caster = keys.caster  --Store the reference to the Invoker that spawned this Ice Wall unit.
			
			--Remove the Ice Wall auras after the duration ends, and the dummy units themselves after their aura slow modifiers will have all expired.
		Timers:CreateTimer({
			endTime = duration,
			callback = function()
				metal_rod_unit:RemoveModifierByName("metal_rod_modifier_dummy")
				metal_rod_unit:RemoveSelf()
				
			end
		})
		
	else
		ability:RefundManaCost()
	end

end

function metal_rod_start_charge( keys )  -- Copied from shrapnel. Credit goes to kritth from the spelllibrary
	-- Only start charging at level 1
	if keys.ability:GetLevel() ~= 1 then return end

	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "metal_rod_stack_counter"
	local maximum_charges = ability:GetLevelSpecialValueFor( "Rod_Charges", ( ability:GetLevel() - 1 ) )
	local metal_rod_charge_replenish_time = ability:GetLevelSpecialValueFor( "metal_rod_charge_replenish_time", ( ability:GetLevel() - 1 ) )
	
	-- Initialize stack
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.metal_rod_charges = maximum_charges
	caster.metal_rod_start_charge = false
	caster.metal_rod_cooldown = metal_rod_charge_replenish_time
	
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, 0 )
	
	-- create timer to restore stack
	Timers:CreateTimer( function()
			-- Restore charge
			if caster.metal_rod_start_charge and caster.metal_rod_charges < maximum_charges then
				-- Calculate stacks
				local next_charge = caster.metal_rod_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= maximum_charges then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { duration = metal_rod_charge_replenish_time } )
					metal_rod_start_cooldown( caster, metal_rod_charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.metal_rod_start_charge = false
				end
				caster:SetModifierStackCount( modifierName, caster, next_charge )
				
				-- Update stack
				caster.metal_rod_charges = next_charge
			end
			
			-- Check if max is reached then check every 0.5 seconds if the charge is used
			if caster.metal_rod_charges ~= maximum_charges then
				caster.metal_rod_start_charge = true
				return metal_rod_charge_replenish_time
			else
				return 0.5
			end
		end
	)
end



function metal_rod_start_cooldown( caster, metal_rod_charge_replenish_time )
	caster.metal_rod_cooldown = metal_rod_charge_replenish_time
	Timers:CreateTimer( function()
			local current_cooldown = caster.metal_rod_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.metal_rod_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end
	)
end