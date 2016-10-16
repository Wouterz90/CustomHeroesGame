--------------------------------------------------------------------------------------------------------
--
--    Hero: shadow_shaman
--    Perk: All hexes get an instant refund in their manacosts and cooldowns get reduced by 20%
--
--------------------------------------------------------------------------------------------------------
--LinkLuaModifier( "modifier_npc_dota_hero_shadow_shaman_perk", "scripts/vscripts/../abilities/hero_perks/npc_dota_hero_shadow_shaman_perk.lua" ,LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------------------------------
if npc_dota_hero_shadow_shaman_perk == nil then npc_dota_hero_shadow_shaman_perk = class({}) end
--------------------------------------------------------------------------------------------------------
--    Modifier: modifier_npc_dota_hero_shadow_shaman_perk       
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_shadow_shaman_perk == nil then modifier_npc_dota_hero_shadow_shaman_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_shadow_shaman_perk:IsPassive()
  return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_shadow_shaman_perk:IsHidden()
  return true
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------

function modifier_npc_dota_hero_shadow_shaman_perk:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    --MODIFIER_EVENT_ON_ABILITY_EXECUTED,
  }
  return funcs
end

function modifier_npc_dota_hero_shadow_shaman_perk:OnAbilityFullyCast(keys)
  if IsServer() then 
    local caster = self:GetParent()
    local ability = keys.ability
    local abilityTargetType = ability:GetBehavior()
    --Comparing the issuer doesn't seem to work, so I'm using a counter and check whether I can divide by 2.

    allowedAbilityTargetTypes = {
      16 = true, --DOTA_ABILITY_BEHAVIOR_POINT
      32 = true, --DOTA_ABILITY_BEHAVIOR_AOE
      1024 = true, --DOTA_ABILITY_BEHAVIOR_DIRECTIONAL
      8192 = true, --DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET
      16384 = true, --DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT

    }

    if not self.counter then self.counter = 1 end
    if allowedAbilityTargetTypes[abilityTargetType] then
      if math.fmod(self.counter, 2) == 1 then
        
        ability:RefundManaCost()
        ability:EndCooldown()

        local abilityCastRange = ability:GetCastRange()
        local randomOffset = RandomVector(RandomInt(0,abilityCastRange)) 
        local casterPosition = caster:GetAbsOrigin()
        local targetLocation = casterPosition + randomOffset
        local order = 
        {
          UnitIndex = caster:entindex(), 
          OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
          TargetIndex = nil,
          AbilityIndex = ability:entindex(), 
          Position = targetLocation, 
          Queue = 0
        }
        ExecuteOrderFromTable(order)

      end
    self.counter = self.counter +1
    end
  end
  
end