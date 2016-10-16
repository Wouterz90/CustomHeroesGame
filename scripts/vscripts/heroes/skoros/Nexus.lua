LinkLuaModifier( "nexus_super_illusion", "heroes/skoros/modifiers/nexus_super_illusion.lua" ,LUA_MODIFIER_MOTION_NONE )

function CreateSuperIllusion (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	target.nexusdouble = CreateUnitByName( caster:GetUnitName(), target:GetAbsOrigin(), false, caster, caster:GetOwner(), caster:GetTeamNumber())
	--target.nexusdouble:MakeClone
	
	target.nexusdouble:AddNewModifier(caster, ability, "nexus_super_illusion", {duration = -1})
	ability:ApplyDataDrivenModifier(caster, target.nexusdouble, "Nexus_ManaSpent", {duration = -1})
	--ability:ApplyDataDrivenModifier(caster, target, "Nexus_Sync_Casts", {duration = -1})
	target.nexusdouble:SetControllableByPlayer(caster:GetPlayerID(), false)
	target.nexusdouble:AddNoDraw()
	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		target.nexusdouble:HeroLevelUp(false)
	end
	for ability_id = 0, 15 do
		local ability = target.nexusdouble:GetAbilityByIndex(ability_id)
		if ability then
			if ability:GetAbilityName() == "Arbalest" or ability:GetAbilityName() == "Arbalest_Attack" then
			--Do not learn them
			elseif ability:GetAbilityName() == "Third_Eye_Blind" then 
				target.nexusdouble:RemoveAbility("Third_Eye_Blind")
			else
				ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())

			end
		end
	end
	for item_id = 0, 5 do
		local item_in_caster = caster:GetItemInSlot(item_id)
		if item_in_caster ~= nil then
			local item_name = item_in_caster:GetName()
			if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry" or item_name == "item_bottle" or item_name == "item_blink") then
				local item_created = CreateItem( item_in_caster:GetName(), target.nexusdouble, target.nexusdouble)
				target.nexusdouble:AddItem(item_created)
				item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges()) 
				item_created:StartCooldown(item_in_caster:GetCooldownTimeRemaining())
			end
		end
	end
	target.nexusdouble:SetAbilityPoints(0)
	target.nexusdouble:SetHasInventory(false)
	Timers:CreateTimer(0.01, function()  
		if not target.nexusdouble:IsNull() then
			target.nexusdouble:SetAbsOrigin(target:GetAbsOrigin())
			
		--else 
			--return -1
		end
	return 0.01
	end) 
end

function KILLSELF (keys)
	local target = keys.target
	target.nexusdouble:RemoveSelf()
end

function SyncSpells (keys)
	local caster = keys.caster
	local ability = keys.ability
	local interval = ability:GetSpecialValueFor("interval") + 0.01
	local sight_aoe = ability:GetSpecialValueFor("sight_aoe")


	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)	
	for _,unit in pairs(units) do


		if unit:GetUnitName() == caster:GetUnitName() and unit:GetPlayerID() == caster:GetPlayerID() and unit:IsInvulnerable() then

			AddFOWViewer(caster:GetTeamNumber(),unit:GetAbsOrigin(), sight_aoe, interval , false)

			for ability_id = 0, 15 do
				local ability = unit:GetAbilityByIndex(ability_id)
				local originalability = caster:GetAbilityByIndex(ability_id)
				if ability and originalability then
					if not ability:IsCooldownReady() and ability:GetCooldownTimeRemaining() > 0 then
						originalability:StartCooldown(ability:GetCooldownTimeRemaining())
					end
					if not originalability:IsCooldownReady() and originalability:GetCooldownTimeRemaining() > 0 then
						ability:StartCooldown(originalability:GetCooldownTimeRemaining())
					end
					if not ability:IsCooldownReady() and ability:GetCooldownTimeRemaining() > 0 then
						originalability:StartCooldown(ability:GetCooldownTimeRemaining())
					end
				end
			end
			for item_id = 0, 5 do
				local item_in_unit = unit:GetItemInSlot(item_id)
				local item_in_caster = caster:GetItemInSlot(item_id)
				if item_in_caster and item_in_unit then
					if not item_in_unit:IsCooldownReady() and item_in_unit:GetCooldownTimeRemaining() > 0 then
						item_in_caster:StartCooldown(item_in_unit:GetCooldownTimeRemaining())
					end
					if not item_in_caster:IsCooldownReady() and item_in_caster:GetCooldownTimeRemaining() > 0 then
						item_in_unit:StartCooldown(item_in_caster:GetCooldownTimeRemaining())
					end
					if not item_in_unit:IsCooldownReady() and item_in_unit:GetCooldownTimeRemaining() > 0 then
						item_in_caster:StartCooldown(item_in_unit:GetCooldownTimeRemaining())
					end

				end
			end
			unit:SetMana(caster:GetMana())
		end
	end
end

function start (event)
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


function Remove_Caster_Mana (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit
	local multiplier = ability:GetLevelSpecialValueFor("mana_factor", ability:GetLevel() - 1)
	local mana_spent

	if target:GetUnitName() == caster:GetUnitName() and target:GetPlayerID() == caster:GetPlayerID() then
		--print(caster:GetAbsOrigin())
		--print(target:GetAbsOrigin())
		if target.OldMana then
			mana_spent = target.OldMana - target:GetMana()
		end
		caster:ReduceMana(mana_spent)
	end
end 

function MoveToTarget (keys)
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	if target:HasModifier("Nexus_on_ally") then
		FindClearSpaceForUnit(caster,target:GetAbsOrigin(),true)
		target:RemoveModifierByName("Nexus_on_ally")
	else
		ability:EndCooldown()
		ability:RefundManaCost()
		FireGameEvent('custom_error_show',{ player_ID = pID, _error = "Must target an ally with Nexus." })
	end
end

