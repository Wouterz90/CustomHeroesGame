--------------------------------------------------------------------------------------------------------
--
--    Hero: Storm Spirit
--    Perk: Restores mana when Storm Spirit travels at high speeds. 
--    Function: Compares position every 0.1 second between the previous position, after the initial 50 units the unit will get its unit moved/10 mana
--
--------------------------------------------------------------------------------------------------------
--LinkLuaModifier( "modifier_npc_dota_hero_storm_spirit_perk", "abilities/hero_perks/npc_dota_hero_storm_spirit_perk.lua" ,LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------------------------------
if npc_dota_hero_storm_spirit_perk == nil then npc_dota_hero_storm_spirit_perk = class({}) end
--------------------------------------------------------------------------------------------------------
--    Modifier: modifier_npc_dota_hero_storm_spirit_perk        
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_storm_spirit_perk == nil then modifier_npc_dota_hero_storm_spirit_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_storm_spirit_perk:IsPassive()
  return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_storm_spirit_perk:IsHidden()
  return true
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_storm_spirit_perk:OnCreated()
  self:StartIntervalThink(0.1)
  self:GetCaster().position = {} 
end

function modifier_npc_dota_hero_storm_spirit_perk:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ABILITY_START,
  }
  return funcs
end

function modifier_npc_dota_hero_storm_spirit_perk:OnAbilityStart(keys)
  if not keys.ability:HasAbilityFlag("teleport") then
    self.oldLocation  = self:GetParent():GetAbsOrigin()
  end
end



  

function modifier_npc_dota_hero_storm_spirit_perk:OnIntervalThink()
  local manaGiven = 10
  local startPenalty = 30
  local caster = self:GetParent()

  if IsServer() then
    local currTime = math.floor(GameRules:GetGameTime()*100)/100 -- We can't be comparing floats but we don't want whole numbers either.

    caster.position[currTime] = caster:GetAbsOrigin() -- Storing the location for the next interval
    if self.oldLocation then -- oldLocation gets stored whenever an ability get's started and should overwrite the values because blink like spells may happen between the intervals
      caster.position[currTime-0.1] = self.oldLocation
      --print("oldLocation used")
      self.oldLocation = nil -- Resetting the location stored from the ability because we don't want it to get reused.
    end


    if not caster.position[currTime-0.1] then -- If this is empty, which seems to happen we use the position before, if that is nil we are starting and use the current position
      caster.position[currTime-0.1] = caster.position[currTime-0.2]
      if not caster.position[currTime-0.1] then
        caster.position[currTime-0.1] = caster:GetAbsOrigin()
      end
    end

    local distanceMoved = (caster.position[currTime-0.1] - caster:GetAbsOrigin()):Length2D()
    local distanceMovedMinusPenalty = distanceMoved - startPenalty

    if distanceMovedMinusPenalty < 1 then 
      distanceMovedMinusPenalty = 0
    end
    
    caster:GiveMana(distanceMovedMinusPenalty/manaGiven)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, distanceMovedMinusPenalty/manaGiven, nil)
    
    for t, pos in pairs(caster.position) do -- Clearing the position values we no longer use
      if (currTime-t) > 0.5 then
       caster.position[t] = nil
      else
        break
      end
    end
  end
end

