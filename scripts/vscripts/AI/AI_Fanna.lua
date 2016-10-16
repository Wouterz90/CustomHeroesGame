--[[Fanna AI

Starting items: Blight Stone + Ward + Courier + Tango, Branch

Core items: Windlace, boots, wards,  MoC, Drums, Treads

Luxuary: Dagger, Desolator , Scepter,

Skills: 
Stealth 1,4,5,7
ChainBuddies 2,8,9,10
Silent HeadRoll 3,12,13,14
Dagger Throw: 6,11,16
Stats 15,17,18,19,20,21,22,23,24,25

Game starts:

Buy items, use courier, skill stealth plant a ward on top of the hill midlane and join the team at the rune.
Wait around the rune spot till the enemy hero is visible, walk via highground, exchange hits with him. Do not get in tower range or lower than 50% hp.
If your health is lower than 50% eat a tango and start hiding to regain charges and exchange hits with the midlaner again.
]]

function AI_fanna_Think()
	Timers:CreateTimer(0.5,function()
		if fanna:HasAbility("fanna_stealth") and not fanna.stealth then
			fanna.stealth = fanna:FindAbilityByName("fanna_stealth")
		end
		if fanna:HasAbility("fanna_chain_buddies") and not fanna.chain_buddies then
			fanna.chain_buddies = fanna:FindAbilityByName("fanna_chain_buddies")
		end
		 if fanna:HasAbility("fanna_silent_headroll") and not fanna.silent_headroll then
			fanna.silent_headroll = fanna:FindAbilityByName("fanna_silent_headroll")
		end
		 if fanna:HasAbility("fanna_dagger_throw") and not fanna.dagger_throw then
			fanna.dagger_throw = fanna:FindAbilityByName("fanna_dagger_throw")
		end

	AI_fanna_GetItems()
	AI_fanna_LearnSkills()
	AI_fanna_DecideState()
	if AI_fanna_ward == nil then
			AI_fanna_Init()
			AI_fanna_ward = 0
	end
	return 5
	end)
end




function AI_fanna_GetItems()	
	fanna.items = {
		"item_courier",
		"item_blight_stone",
		--"item_tango",
		"item_ward_observer",
		"item_wind_lace",
		"item_boots",
		"item_sobi_mask",
		"item_chainmail",
		"item_circlet",
		"item_gauntlets",
		"item_recipe_bracer",
		"item_ring_of_regen",
		"item_recipe_ancient_janggo",
		"item_belt_of_strength",
		"item_gloves",
		"item_dagger",
		"item_blight_stone",
		"item_mithril_hammer",
		"item_mithril_hammer",
		"item_point_booster",
		"item_ogre_axe",
		"item_staff_of_wizardry",
		"item_blade_of_alacrity",
		"item_point_booster",
		"item_ultimate_orb",
		"item_ultimate_orb",
		"item_orb_of_venom",
	}

	if itemno == nil then 
		itemno = 1 
	end
	--if fanna:GetGold() > GetItemCost("item_ward") then

	while fanna.items[itemno] and fanna:GetGold() > GetItemCost(fanna.items[itemno]) do
		GameRules:SetUseUniversalShopMode(true)
		if fanna.items[itemno] then
			fanna:AddItemByName(fanna.items[itemno])
			fanna:SpendGold(GetItemCost(fanna.items[itemno]),DOTA_ModifyGold_PurchaseItem)
			GameRules:SetUseUniversalShopMode(false)
			if fanna.items[itemno] == "item_courier" then
				 fanna:CastAbilityNoTarget(GetItemByName(fanna,"item_courier"),fanna:GetPlayerOwnerID())
			end
			itemno = itemno +1
		end
	end
end

function GetItemByName(caster, item_name)
	for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
		local item = caster:GetItemInSlot(i)
		if item and item:GetAbilityName() == item_name then
			return item
		end
	end
end

function AI_fanna_LearnSkills()
	fanna.skills = {
		"fanna_stealth",
		"fanna_chain_buddies",
		"fanna_silent_headroll",
		"fanna_stealth",
		"fanna_stealth",
		"fanna_dagger_throw",
		"fanna_stealth",
		"fanna_chain_buddies",
		"fanna_chain_buddies",
		"fanna_chain_buddies",
		"fanna_dagger_throw",
		"fanna_silent_headroll",
		"fanna_silent_headroll",
		"fanna_silent_headroll",
		"attribute_bonus",
		"fanna_dagger_throw",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
		"attribute_bonus",
	}

	while fanna:GetAbilityPoints() ~= 0 do
		fanna:UpgradeAbility(fanna:FindAbilityByName(fanna.skills[fanna:GetLevel()+(1-fanna:GetAbilityPoints())]))
	end

	fanna.dagger_throw = fanna:FindAbilityByName("fanna_dagger_throw")
	fanna.silent_headroll = fanna:FindAbilityByName("fanna_silent_headroll")
	fanna.stealth = fanna:FindAbilityByName("fanna_stealth")
	fanna.chain_buddies = fanna:FindAbilityByName("fanna_chain_buddies")
end

function AI_fanna_Init()

	if fanna:GetTeam() == DOTA_TEAM_GOODGUYS then
		fanna.Fountain = Vector(-7000,-6600,520)
		fanna.enemyFountain = Vector(6741,6200,520)
		fanna.firstRune = Vector(-2215,1665,128)
		fanna.otherRune = Vector(-2215,1665,128)
		fanna.firstMidWard = Vector(-236,5,256)
	elseif fanna:GetTeam() == DOTA_TEAM_BADGUYS then
		fanna.Fountain = Vector(6741,6200,520)
		fanna.enemyFountain = Vector(-7000,-6600,520) 
		fanna.firstRune = Vector(-2215,1665,128)
		fanna.firstMidWard = Vector(-1031,-555,256)
	end
	Timers:CreateTimer(10,function()
		if fanna:HasItemInInventory("item_ward_observer") then
			fanna:CastAbilityOnPosition(fanna.firstMidWard,GetItemByName(fanna,"item_ward_observer"),fanna:GetPlayerOwnerID())
			local order = 
			{
				UnitIndex = fanna:entindex(), 
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				TargetIndex = nil,
				AbilityIndex = nil, 
				Position = firstRune, --Top rune location
				Queue = 1
			}
			ExecuteOrderFromTable(order)
		end
		AI_fanna_DecideState()
	end)
end


function AI_fanna_DecideState()
	if fanna:GetHealthPercent() < 36 and fanna:IsAlive() then
		AI_fanna_StateRetreat()
	elseif fanna:GetHealthPercent() > 35 then
		AI_fanna_StateOffensive()
	end
end

function AI_fanna_StateRetreat()
	--Say(fanna,"I have "..fanna:GetHealthPercent().."%, I am retreating",true)
	Timers:CreateTimer(1,function()
		if fanna:GetHealthPercent() > 5 and fanna:IsAlive() then
			if fanna:GetGold() > GetItemCost("item_tpscroll") then
				fanna:AddItemByName("item_tpscroll")
			end
		elseif fanna:GetHealthPercent() < 90 and fanna:IsAlive() then
			MoveToPosition(fanna.Fountain) -- FOUNTAIN
			return 1
		else
			AI_fanna_DecideState()
		end
	end)
end

function AI_fanna_StateOffensive()
	--if AI_fanna_FindTargetToGank(fanna) then
		local gankTarget = AI_fanna_FindTargetToGank(fanna)
		AI_fanna_GankTarget(gankTarget)
 -- end



	--Gank the target that has low hp, fewer visible allies, is far from his tower

end

function AI_fanna_FindTargetToGank(hHero)
	local heroHeroes = FindUnitsInRadius(fanna:GetTeamNumber(), fanna:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _,unit in pairs(heroHeroes) do -- Rate how hard it would be to kill them, everything should have a value between 0 and 1
		if hHero:GetTeamNumber() ~= unit:GetTeamNumber() and unit:CanEntityBeSeenByMyTeam(hHero) then
			local TargetAttractionValue = 0
			--Get distance to nearest tower. Ranking system where low values become high; 900/length? if > 1 then=1
			--[[if (unit:GetRangeToUnit(unit:FindNearestTowerToUnit())) == nil then
				local divideby = 0.05
			else
				local divideby = (unit:GetRangeToUnit(unit:FindNearestTowerToUnit()))
			end
			local this = 900/divideby
			TargetAttractionValue = TargetAttractionValue + this
			--Get # of allied heroes around(2000 units? hero* 0.25
			--  TargetAttractionValue = TargetAttractionValue + this
			--Get # of enemy heroes around (1000 units?) 1 - hero *0.25
			-- TargetAttractionValue = TargetAttractionValue + this
			-- Get % of health unit:GetHealthPercent()
			--  TargetAttractionValue = TargetAttractionValue + this
			unit.TargetAttractionValue = TargetAttractionValue]]
			gankTarget = unit
			break
		end
	end
	highestAttractionValue = 0
	
	
	--Target to gank is gankTarget
	if gankTarget then
		return gankTarget
	else
		--Say(hHero,"I can't find enemies to gank",true)
		print("I can't find enemies to gank")
		return nil
	end
end

function AI_fanna_UseMedallion(hTarget)
	if fanna:HasItemInInventory("item_medallion_of_courage") and GetItemByName(fanna,"item_medallion_of_courage"):IsCooldownReady() then
		local order = --Chaining target to me
			{
				UnitIndex = fanna:entindex(), 
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hTarget:entindex(),
				AbilityIndex = GetItemByName(fanna,"item_medallion_of_courage"):entindex(), 
				Position =nil, 
				Queue = 1
			}
			ExecuteOrderFromTable(order)
	end
	if fanna:HasItemInInventory("item_solar_crest") and GetItemByName(fanna,"item_solar_crest"):IsCooldownReady() then
		local order = --Chaining target to me
			{
				UnitIndex = fanna:entindex(), 
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hTarget:entindex(),
				AbilityIndex = GetItemByName(fanna,"item_solar_crest"):entindex(), 
				Position =nil, 
				Queue = 1
			}
			ExecuteOrderFromTable(order)
	end
end

function AI_fanna_DaggerThrow(hTarget)
	if fanna:HasAbility("fanna_dagger_throw") and fanna.dagger_throw and fanna.dagger_throw:GetLevel() > 0 then
		if fanna.dagger_throw:IsCooldownReady() and fanna.dagger_throw:PredictPositionForLinearProjectiles(hTarget) then
			--Timers:CreateTimer(0.5,function()
				--if fanna.dagger_throw:PredictPositionForLinearProjectiles(hTarget) == nil then -- If there is no position in where we reach the target we move closer
					--fanna:MoveToPosition(hTarget:GetAbsOrigin())																	-- Do this in the main function??!
					--return 0.5
				--else -- Else we throw the dagger
					local vTargetLocation = fanna.dagger_throw:PredictPositionForLinearProjectiles(hTarget)
					local order = --Throwing the dagger where fanna thinks the target will be
					{
						UnitIndex = fanna:entindex(), 
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						TargetIndex = nil,
						AbilityIndex = fanna.dagger_throw:entindex(), 
						Position =vTargetLocation, 
						Queue = 1
					}
					ExecuteOrderFromTable(order)
					local timeSinceCastTime = 0.1
					Timers:CreateTimer(0.1,function()
						if not (timeSinceCastTime >= fanna.dagger_throw:GetCastPoint()) then
							if (fanna.dagger_throw:PredictPositionForLinearProjectiles(hTarget) - fanna.dagger_throw:CheckPositionForLinearProjectiles(hTarget,timeSinceCastTime)):Length2D() < fanna.dagger_throw:GetLevelSpecialValueFor("projectile_width",fanna.dagger_throw:GetLevel()-1) then
								-- Above is a check if the projectile will still hit, if it won't we cancel the order else the timer goes up on timeSinceCastTime.
								timeSinceCastTime = timeSinceCastTime + 0.1
								return 0.1
							else
								fanna:Stop()
								return nil
							end
						else 
						end
					end)
					--return nil
				--end
			--end)
		else
			if fanna.dagger_throw.DaggerUnit and not fanna.dagger_throw.DaggerUnit:IsNull() and fanna.dagger_throw.DaggerUnit ~= nil then
				local order = --Picking up the dagger!! Needs an evaluation system for this!
				{
					UnitIndex = fanna:entindex(), 
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					TargetIndex = nil,
					AbilityIndex = nil, 
					Position =fanna.dagger_throw.DaggerUnit:GetAbsOrigin(), 
					Queue = 1
				 }
				 ExecuteOrderFromTable(order)
			end
		end
	end   
end

function AI_fanna_SilentHeadroll(hTarget)
	if fanna:HasAbility("fanna_silent_headroll") and fanna.silent_headroll and fanna.silent_headroll:GetLevel() > 0 then
		if fanna.silent_headroll:IsCooldownReady() then
			local casterloc = fanna:GetAbsOrigin()
			local targetloc = hTarget:GetAbsOrigin()
			local targetdirection = hTarget:GetForwardVector()
			local direction = (targetloc - casterloc):Normalized()
			local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(targetdirection)).y)
			if (angle <= 180/2) then
				print("Rolling towards my own fountain")
				local order = --Rolling towards my own fountain
				
				{
					UnitIndex = fanna:entindex(), 
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					TargetIndex = nil,
					AbilityIndex = fanna.silent_headroll:entindex(), 
					Position =casterloc + (direction * fanna.silent_headroll:GetCastRange()), 
					Queue = 1
				}
				ExecuteOrderFromTable(order)
			end
		end
	end
end 

function AI_fanna_ChainBuddies(hTarget)
	if fanna:HasAbility("fanna_chain_buddies") and fanna.chain_buddies and fanna.chain_buddies:GetLevel() > 0 then
		if fanna.chain_buddies:IsCooldownReady() and (fanna:GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D() < fanna.chain_buddies:GetCastRange() then
			local order = --Chaining target to me
			{
				UnitIndex = fanna:entindex(), 
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hTarget:entindex(),
				AbilityIndex = fanna.chain_buddies:entindex(), 
				Position =nil, 
				Queue = 1
			}
			ExecuteOrderFromTable(order)
			local order = --Running to my own fountain to drag the target
			{
				UnitIndex = fanna:entindex(), 
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				TargetIndex = nil,
				AbilityIndex = nil, 
				Position =fanna.Fountain, 
				Queue = 1
			}
			ExecuteOrderFromTable(order)
			--Timers:CreateTimer(fanna.chain_buddies:GetDuration(),function()
			--	fanna:Stop()
			--end)
		end
	end
end

function AI_fanna_ApproachFromBehind(hTarget)
	-- Do not get closer then 800 range to that tower
	local nearestTower = hTarget:FindNearestTowerToUnit()
	-- The direction from our target to the enemy fountain, we try to approach from 200? units
	local wantedDirection = (fanna.enemyFountain-hTarget:GetAbsOrigin()):Normalized()
	if ((hTarget:GetAbsOrigin() + (wantedDirection * 200)) - nearestTower:GetAbsOrigin()):Length2D() > 800 then
		fanna:MoveToPosition((hTarget:GetAbsOrigin() + (wantedDirection * 200)))
	else
		--Tower too close
	end
end 



function AI_fanna_GankTarget(hTarget)  -- Better to pull the enemy away from his own nearest tower.

	if hTarget and hTarget:IsAlive() == true then
		AI_fanna_ApproachFromBehind(hTarget)
		AI_fanna_SilentHeadroll(hTarget) -- If fanna comes from behind, she tries to drag her target along
		AI_fanna_UseMedallion(hTarget)
		AI_fanna_ChainBuddies(hTarget)
		AI_fanna_DaggerThrow(hTarget) -- Throws a dagger at a predicted location

		

		local order = --Get closer to your target, or if you used all your spells
		{
			UnitIndex = fanna:entindex(), 
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex(),
			AbilityIndex = nil, 
			Position =nil, 
			Queue = 1
		}
		ExecuteOrderFromTable(order)
	end
end

function CDOTA_BaseNPC_Hero:FindNearestTowerToUnit()
	if not self.loop == nil then
		return nil
	end
	self.loop = true
	local nearest = 20000
	local units = FindUnitsInRadius( self:GetTeamNumber(), self:GetAbsOrigin(), self, 20000,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	for _,unit in pairs(units) do
		if unit:IsTower() and unit:GetTeamNumber() == self:GetTeamNumber() then
			if self:GetRangeToUnit(unit) < nearest then
				nearest = self:GetRangeToUnit(unit)
				gankTargetNearestTower = unit
			end
		end
	end
	if gankTargetNearestTower ~= nil then
		return gankTargetNearestTower
	else
		--There are no towers
		return nil
	end
end



function CDOTABaseAbility:GetAbilityDamageOnTarget(hTarget)
	local caster = self:GetCaster()
	local casterInt = caster:GetIntellect()

	local damage = self:GetAbilityDamage()
	local damageType = self:GetAbilityDamageType()
	local damageAmplifiedByInt = 1 + (casterInt*0.01)

	if damageType == DAMAGE_TYPE_PURE then
		targetResistance = 0
	elseif damageType == DAMAGE_TYPE_PHYSICAL then
		targetResistance =  ArmorToReductionPercentage(hTarget:GetPhysicalArmorValue())
	elseif damageType == DAMAGE_TYPE_MAGICAL then
		targetResistance = hTarget:GetMagicalArmorValue()
	end

	local abilityDamageOnTarget = (damage * damageAmplifiedByInt * (1-targetResistance))
	return abilityDamageOnTarget
end




function CDOTABaseAbility:PredictPositionForLinearProjectiles(hTarget) 
-- Requires the ability to have a abilitySpecial value named "projectile_speed" Defaults to 1000
	local hCaster = self:GetCaster()
	local cast_point = self:GetCastPoint()
	local projectile_speed = self:GetLevelSpecialValueFor("projectile_speed",self:GetLevel()-1)
	if projectile_speed == nil or projectile_speed == 0 then
		print("projectile_speed has not been declared in "..self:GetAbilityName())
		projectile_speed = 1000
	end
	
	local cast_range = self:GetCastRange(hCaster:GetAbsOrigin(),hTarget)
	local currTime = GameRules:GetGameTime()
	local caster_position = hCaster:GetAbsOrigin()
	local target_position = hTarget:GetAbsOrigin()
	local target_direction = hTarget:GetForwardVector()
	local target_movingspeed = hTarget:GetMovingSpeed()  -- movingspeed is current speed, so 0 if stunned (comparing units position 0.04 s ago.)
	vPredictedLocation = nil
	local targetLocationAfterCastPoint = (target_position + (target_direction * ( target_movingspeed*cast_point)))
	-- This checks in circles around caster if the target and the projectile would meet in any direction around the caster. 
	for i=50,cast_range,50 do
		local timeTravelled = i/projectile_speed 
		local targetPredictedPostion = (targetLocationAfterCastPoint + (target_direction * (target_movingspeed*timeTravelled)))
		if (caster_position- targetPredictedPostion):Length2D() < i then
			vPredictedLocation = targetPredictedPostion
			--PingMiniMapAtLocation(targetPredictedPostion)
			break
		end
	end
	if vPredictedLocation == nil or not hTarget:IsAlive()  then
		return nil
	else
		return vPredictedLocation
	end
end

function CDOTABaseAbility:CheckPositionForLinearProjectiles(hTarget,fTimeSinceCastingStarted) 
-- Requires the ability to have a abilitySpecial value named "projectile_speed" Defaults to 1000
-- To check if the ability will still hit it needs an abilitySpecial value named "projectile_width" Defaults to 200
	local hCaster = self:GetCaster()
	if fTimeSinceCastingStarted == nil then
		fTimeSinceCastingStarted = 0 
	end
	local cast_point = self:GetCastPoint() - fTimeSinceCastingStarted
	local projectile_speed = self:GetLevelSpecialValueFor("projectile_speed",self:GetLevel()-1)
	if projectile_speed == nil or projectile_speed == 0 then
		print("projectile_speed has not been declared in "..self:GetAbilityName())
		projectile_speed = 1000
	end
	local cast_range = self:GetCastRange(hCaster:GetAbsOrigin(),hTarget)
	local currTime = GameRules:GetGameTime()
	local caster_position = hCaster:GetAbsOrigin()
	local target_position = hTarget:GetAbsOrigin()
	local target_direction = hTarget:GetForwardVector()
	local target_movingspeed = hTarget:GetMovingSpeed()  -- movingspeed is current speed, so 0 if stunned (comparing units position 0.04 s ago.)
	vCheckLocation = nil
	local targetLocationAfterCastPoint = (target_position + (target_direction * ( target_movingspeed*cast_point)))
	-- This checks in circles around caster if the target and the projectile would meet in any direction around the caster. 
	for i=50,cast_range,50 do
		local timeTravelled = i/projectile_speed 
		local targetPredictedPostion = (targetLocationAfterCastPoint + (target_direction * (target_movingspeed*timeTravelled)))
		if (caster_position- targetPredictedPostion):Length2D() < i then
			vCheckLocation = targetPredictedPostion
			--PingMiniMapAtLocation(targetPredictedPostion)
			break
		end
	end
	if vCheckLocation == nil or not hTarget:IsAlive()  then
		return nil
	else
		return vCheckLocation
	end
end

function CDOTABaseAbility:PredictPositionForAreaSpells(hTarget) -- for cast delay, if used "cast_delay_time"
	local hAbility = self
	local hCaster = self:GetCaster()
	local cast_point = self:GetCastPoint()
	local cast_delay_time = self:GetLevelSpecialValueFor("cast_delay_time",hAbility:GetLevel()-1) or 0
	local cast_range = self:GetCastRange()
	local caster_position = hCaster:GetAbsOrigin()
	local target_position = hTarget:GetAbsOrigin()
	local target_direction = hTarget:GetForwardVector()
	local target_movingspeed = hTarget:GetMovingSpeed()
	local targetLocationAfterCastPoint = (target_position + (target_direction * ( target_movingspeed*(cast_point+cast_delay_time))))
	
	if targetLocationAfterCastPoint < cast_range and hTarget:IsAlive() then
		return targetLocationAfterCastPoint
	else
		return nil
	end
end


function CDOTA_BaseNPC_Hero:GetMovingSpeed()
	local currTime = GameRules:GetGameTime()
	if self.positions[math.floor((currTime*25)/25)-0.04] then
		return (self.positions[math.floor((currTime*25)/25)] - self.positions[math.floor((currTime*25)/25)-0.04]):Length2D()*25
	else
		return 0
	end
end


