function Start_Effect (keys) --Taken from kritth's ember spirit flame guard

	-- Inherited variables
	local targetUnit = keys.target
	local ability = keys.ability

	
	-- Table for look up
	targetUnit.take_next_surge = {}
	
	-- Check if listener is already running
	if targetUnit.listener ~= nil then
		targetUnit.listener = true
		return
	end
	
	--[[
		Anything below this point should be called only ONCE per game session
		unless someone know how to properly stop listener
	]]
	
	-- Set flags
	targetUnit.listener = true
	
	-- Targeting variables
	local targetEntIndex = targetUnit:entindex()
	
	-- Listening to entity hurt
	ListenToGameEvent( "entity_hurt", function( event )
			-- check if should keep listening
			if targetUnit.listener == true then
				local inflictor = event.entindex_inflictor
				local attacker = event.entindex_attacker
				local compareTarget = event.entindex_killed
				-- Check if it's correct unit
				if compareTarget == targetEntIndex and inflictor ~= nil then
					local ability = EntIndexToHScript( inflictor )
					-- Check whether it is the correct type to block
					if ability:GetAbilityDamageType() == DAMAGE_TYPE_MAGICAL then
						targetUnit.take_next_surge[ attacker ] = 1	-- use attacker entindex as ref point
					elseif
						ability:GetAbilityDamageType() == DAMAGE_TYPE_PHYSICAL then
						targetUnit.take_next_surge[ attacker ] = 2	-- use attacker entindex as ref point
					end
				end
			end
		end, nil
	)
end

function PushBack( keys )
	-- Inherited variables
	local targetUnit = keys.unit
	local attackerEnt = keys.attacker:entindex()
	local target = keys.attacker
	local ability = keys.ability
	local wrong_type_x = ability:GetSpecialValueFor("wrong_type_x")
	local right_type_x = ability:GetSpecialValueFor("right_type_x")
	local duration = ability:GetLevelSpecialValueFor("push_duration", ability:GetLevel() - 1)
	local length = ability:GetLevelSpecialValueFor("push_distance", ability:GetLevel() - 1)
	if power_surge_ready == nil then
		power_surge_ready = 1
	end
	-- Check if flag has been turned from listener
	if targetUnit.take_next_surge[ attackerEnt ] == 1 and power_surge_ready == 1 and target:IsHero() then  -- Magic damage received
		if targetUnit:HasModifier("Positive_Charge_Magnetic") then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length * right_type_x,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable )
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})


		elseif targetUnit:HasModifier("Negative_Charge_Magnetic") then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length * wrong_type_x,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable )

		else
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable ) 
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})
		end
	elseif targetUnit.take_next_surge[ attackerEnt ] == 2 and power_surge_ready == 1 and target:IsHero() then -- Physical damage received
		if targetUnit:HasModifier("Positive_Charge_Magnetic") then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length * wrong_type_x,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable )
		elseif targetUnit:HasModifier("Negative_Charge_Magnetic") then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length * right_type_x,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable )
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})
		else 
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable ) 
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})
		end
	elseif power_surge_ready == 1 and target:IsHero() then
		local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable ) 
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})
	end
end		

function PushBack_Attack( keys )
	local targetUnit = keys.caster
	local attackerEnt = keys.attacker:entindex()
	local target = keys.attacker
	local attacker = keys.attacker
	local ability = keys.ability
	local wrong_type_x = ability:GetSpecialValueFor("wrong_type_x")
	local right_type_x = ability:GetSpecialValueFor("right_type_x")
	local duration = ability:GetLevelSpecialValueFor("push_duration", ability:GetLevel() - 1)
	local length = ability:GetLevelSpecialValueFor("push_distance", ability:GetLevel() - 1)

	if power_surge_ready == 1 then
		if targetUnit:HasModifier("Positive_Charge_Magnetic") and attacker:IsHero() then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length * wrong_type_x,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable )
		elseif targetUnit:HasModifier("Negative_Charge_Magnetic") and attacker:IsHero() then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length * right_type_x,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable )
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})
		elseif attacker:IsHero() then
			local knockbackModifierTable =
			{
				should_stun = 0,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = length,
				knockback_height = 0,
				center_x = targetUnit:GetAbsOrigin().x,
				center_y = targetUnit:GetAbsOrigin().y,
				center_z = targetUnit:GetAbsOrigin().z
			}
			target:AddNewModifier( targetUnit, nil, "modifier_knockback", knockbackModifierTable ) 
			power_surge_ready = 0
			Timers:CreateTimer({
				endTime = ability:GetLevelSpecialValueFor("internal_cooldown", ability:GetLevel()-1),
				callback = function()
					power_surge_ready = 1
				end
			})
		end
	end
end

function Power_Surge_Stop_Target_listen( keys )
	keys.target.take_next_surge = nil
	keys.target.listener = false
end