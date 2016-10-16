--------------------------------------------------------------------------------------------------------
--
--    Hero: storm
--    Perk: 
--
--------------------------------------------------------------------------------------------------------
--LinkLuaModifier( "modifier_npc_dota_hero_storm_perk", "scripts/vscripts/../abilities/hero_perks/npc_dota_hero_storm_perk.lua" ,LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------------------------------
if npc_dota_hero_storm_perk == nil then npc_dota_hero_storm_perk = class({}) end
--------------------------------------------------------------------------------------------------------
--    Modifier: modifier_npc_dota_hero_storm_perk        
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_storm_perk == nil then modifier_npc_dota_hero_storm_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_storm_perk:IsPassive()
  return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_storm_perk:IsHidden()
  return false
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_storm_perk:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED,
    }
    return funcs
end

function modifier_npc_dota_hero_storm_perk:OnUnitMoved(keys)
  PrintTable(keys)
end
