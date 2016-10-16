function GameMode:FilterExecuteOrder( filterTable )
    local units = filterTable["units"]
    local issuer = filterTable["issuer_player_id_const"]
    local order_type = filterTable["order_type"]
    local abilityIndex = filterTable["entindex_ability"]
    local ability = EntIndexToHScript(abilityIndex)
    local targetIndex = filterTable["entindex_target"]
    local target = EntIndexToHScript(targetIndex)
    if filterTable.position_x then
        orderVector = Vector(filterTable.position_x,filterTable.position_y,filterTable.position_z)
    end
    --print(orderVector)

    --PrintTable(filterTable)
    
    for n, unit_index in pairs(units) do
        local unit = EntIndexToHScript(unit_index)
        if not unit then return true end
        local owner_ID = unit:GetPlayerOwnerID()
        
        --local order_rule_0 = PlayerResource:IsValidPlayerID(issuer) and PlayerResource:IsValidPlayerID(owner_ID) and (owner_ID == issuer)--[[ and ability.isVectorTarget ~= true ]]
        
        --if order_rule_0 == false--[[ and ability and not ability.isVectorTarget == true]] then -- Something went wrong with the VectorTargets and this fixes it.
        --  return true 
        --end
        
        
        --local order_rule_5 = unit:HasModifier("modifier_skating_passive") and unit:FindModifierByName("modifier_skating_passive"):GetAbility():IsCooldownReady() and order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION
    
        --local order_rule_6 = unit:HasModifier("modifier_harold_mobilizable") and (order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) and (unit:GetTeamNumber() == target:GetTeamNumber())
        
        --local order_rule_7 = unit:HasModifier("modifier_harold_mobilized")
        
        -- Skoros Blackout
        if SkorosHaltChance(skoros,blackout,unit) == true then
            return true
        end

        -- Uther Argent Smite
        local utherArgentSmite = require('heroes/uther/argent_smite')
        AllowAlliedAttacks(unit,target,order_type)
        if CancelOtherAlliedAttacks(unit,target,order_type) == false then
            return false
        end
        StopAllowingAlliedAttacks(unit,target,order_type)

        -- Uther Compass
        local utherCompass = require('heroes/uther/Compass')
        if UtherCompassFilterOrders(unit,target,order_type,orderVector) == false then
            return false
        end

        --[[ Helix
        if order_rule_5 then
            StartSkating(helix,unit,orderVector)
        end]]

        --[[Harold
        if order_rule_6 then
            AllowAlliesToRacetoCaster(harold,unit)
        end
        if order_rule_7 then
            CancelAlliesRacingToCaster(unit)
        end]]
        
        
        --return true 
        
    end
    --return VectorTarget:OrderFilter(filterTable)
    return true
end
--[[    local order_rule_5 = unit:HasModifier("modifier_ddosed") and EntIndexToHScript(issuer) ~= nil

        local order_rule_6 = unit:HasModifier("modifier_ads_everywhere") and EntIndexToHScript(issuer) ~= nil

        local order_rule_7 = unit:HasModifier("modifier_ads_everywhere") and order_type == (DOTA_UNIT_ORDER_CAST_POSITION or order_type == DOTA_UNIT_ORDER_CAST_TARGET or order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE or order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET or order_type == DOTA_UNIT_ORDER_CAST_TOGGLE) and EntIndexToHScript(issuer) ~= nil
        
    
        if order_rule_5 then
            Timers:CreateTimer({
                endTime = 2, -- Needs to retrieve value from kv!
                callback = function()
                    if unit:IsAlive() then
                        local ddostable = {
                        
                            UnitIndex = unit:entindex(), 
                            OrderType = order_type,
                            TargetIndex = targetIndex,  --Only used when targeting units
                            AbilityIndex = abilityIndex, --Optional.  Only used when casting abilities
                            Position =  Vector(filterTable.position_x, filterTable.position_y, filterTable.position_z), --Optional.  Only used when targeting the ground
                            Queue = 1, --Optional.  Used for queueing up abilities
                        }
                        ExecuteOrderFromTable(ddostable)
                        return false
                    end
                end
            })
        end
        if order_rule_6 then
            ads_cancelled = false
        end
        if order_rule_7 then
            local modifier = "modifier_ads_everywhere"
            local factor = ads_everywhere:GetLevelSpecialValueFor("cast_time_increase",ads_everywhere:GetLevel() -1)
            local modifierstackcount =  unit.modifier_ads:GetStackCount()
            unit:Stop()
            StartAnimation(unit, {duration=5, activity=ACT_DOTA_CAST_ABILITY_1, rate=5})

            ads_cancelled = true 
            Timers:CreateTimer({
                endTime = 1,
                callback = function()
                    if ads_cancelled == true and unit:IsAlive() then
                        local adstable = {
                        
                            UnitIndex = unit:entindex(), 
                            OrderType = order_type,
                            TargetIndex = targetIndex,  --Only used when targeting units
                            AbilityIndex = abilityIndex, --Optional.  Only used when casting abilities
                            Position =  Vector(filterTable.position_x, filterTable.position_y, filterTable.position_z), --Optional.  Only used when targeting the ground
                            Queue = 0, --Optional.  Used for queueing up abilities
                        }
                        ExecuteOrderFromTable(adstable) 
                    end
                end
            })
            return false 
        end]]