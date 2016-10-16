if ads_everywhere == nil then 
	ads_everywhere = class({}) 
end

--LinkLuaModifier( "ad_distraction", "heroes/whizzi/modifiers/ad_distraction.lua" ,LUA_MODIFIER_MOTION_NONE )	
--[[function start (event)
	local target = event.target
	local ability = event.ability
	if ability:GetLevel() == 1 then
		local target = event.target
	
		local targets = event.target_entities
		for _,hero in pairs(targets) do
			target.OldMana = target:GetMana()
		end
	end
end

function Check_Mana (event)
	local target = event.target
	local targets = event.target_entities

	for _,hero in pairs(targets) do
		hero.OldMana = hero:GetMana()
	end
end


function Extra_Mana (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local multiplier = ability:GetLevelSpecialValueFor("mana_factor", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("aura_effect", ability:GetLevel() - 1 )
	local mana_spent
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local distance_percentage = (range - (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()) / range
	if target.OldMana then
		mana_spent = target.OldMana - target:GetMana()
	end
	target:AddNewModifier(caster, ability , "ad_distraction", { duration = duration})
	if mana_spent and mana_spent > 0 then
		mana_spent = mana_spent * multiplier * distance_percentage
		caster:Heal(mana_spent, caster)
	end
end 

function Start_Effect (keys) --Taken from kritth's ember spirit flame guard

	-- Inherited variables
	local targetUnit = keys.target
	local ability = keys.ability
	
	-- Table for look up
	targetUnit.take_next = {}
	
	-- Check if listener is already running
	if targetUnit.listener ~= nil then
		targetUnit.listener = true
		return
	end
	
	--[[
		Anything below this point should be called only ONCE per game session
		unless someone know how to properly stop listener
	
	
	-- Set flags
	targetUnit.listener = true
	
	-- Targeting variables
	local targetEntIndex = targetUnit:entindex()
	local abilityBlockType = DAMAGE_TYPE_MAGICAL
	
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
					if ability:GetAbilityDamageType() == abilityBlockType then
						targetUnit.take_next[ attacker ] = false	-- use attacker entindex as ref point
					end
				end
			end
		end, nil
	)
end

function Ad_On_Take_Damage( keys )
	-- Inherited variables
	local targetUnit = keys.unit
	local attackerEnt = keys.attacker:entindex()
	local target = keys.attacker
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local modifier = "ad_distraction"


	
	-- Check if flag has been turned from listener
	if targetUnit.take_next[ attackerEnt ] ~= nil and targetUnit.take_next[ attackerEnt ] == false then
		target:AddNewModifier(targetUnit, ability , "ad_distraction", { duration = duration})
	end
end		]]

function SetStack (keys)
	local target = keys.target
	local modifier = "modifier_ads_everywhere"

	target.modifier_ads = target:FindModifierByName(modifier)
	target.modifier_ads:SetStackCount(1)


end
