function BurningDistractionAuraInterval(keys)
  local caster = keys.caster
  local player = caster:GetPlayerOwner()
  local caster = player:GetAssignedHero()
  local ability = keys.ability
  local target = keys.target
  

  local duration = ability:GetSpecialValueFor("duration")
  local maxStacks = ability:GetSpecialValueFor("max_stacks") -- 1.5 2 2.5 3% with a max of 20 30 40 50?

  if not target:HasModifier("modifier_houdini_burning_distraction") then
    target:AddNewModifier(caster,ability,"modifier_houdini_burning_distraction",{duration = duration})
    target:SetModifierStackCount("modifier_houdini_burning_distraction",caster,2)
  else
    if keys.caster:IsIllusion() then
      target:SetModifierStackCount("modifier_houdini_burning_distraction",caster,target:GetModifierStackCount("modifier_houdini_burning_distraction",caster)+1)
    else
      target:SetModifierStackCount("modifier_houdini_burning_distraction",caster,target:GetModifierStackCount("modifier_houdini_burning_distraction",caster)+2)
    end
    if target:GetModifierStackCount("modifier_houdini_burning_distraction",caster) > maxStacks then
      target:SetModifierStackCount("modifier_houdini_burning_distraction",caster,maxStacks)
    end
    target:FindModifierByName("modifier_houdini_burning_distraction"):SetDuration(duration,true)
  end
end

LinkLuaModifier("modifier_houdini_burning_distraction","heroes/hero_houdini/burning_distraction.lua",LUA_MODIFIER_MOTION_NONE)

if not modifier_houdini_burning_distraction then
  modifier_houdini_burning_distraction = class({})
end

function modifier_houdini_burning_distraction:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  }
  return funcs
end

function modifier_houdini_burning_distraction:GetModifierAttackSpeedBonus_Constant(keys)
  --if IsServer() then
    local unit = self:GetParent()
    if unit:IsAlive() then
      if unit:IsRangedAttacker() then
        return 0
      else
        local projectileSpeedDecrease = self:GetAbility():GetSpecialValueFor("projectile_speed_decrease")
        return projectileSpeedDecrease * unit:GetModifierStackCount("modifier_houdini_burning_distraction",self:GetCaster()) * -1
      end
    end
  --end
end

function modifier_houdini_burning_distraction:OnCreated()
  if IsServer() then
    self:StartIntervalThink(1)
  end
end

function modifier_houdini_burning_distraction:OnIntervalThink()
  if IsServer() then
    local unit = self:GetParent()
    if unit:IsAlive() then
      local ability = self:GetAbility()
      local abdamage = ability:GetAbilityDamage()

      local DamageTable = 
      {
        attacker = self:GetCaster(),
        damage_type = ability:GetAbilityDamageType(),
        damage = abdamage * unit:GetModifierStackCount("modifier_houdini_burning_distraction",self:GetCaster()),
        victim = unit,
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, -- Doesnt trigger abilities and items that get disabled by damage
      }
      ApplyDamage(DamageTable)
    end
  end
end

function BurningDistrationDelayProjectiles(filterTable)

  local targetIndex = filterTable["entindex_target_const"]
  local target = EntIndexToHScript(targetIndex)
  local targetname = target:GetUnitName()
  local casterIndex = filterTable["entindex_source_const"]
  local caster = EntIndexToHScript(casterIndex) -- also for attacks!
  local houdini = houdini -- Created when placed in game
  if caster then
    local casterName = caster:GetUnitName()
  else
    return filterTable
  end
  if caster:HasModifier("modifier_houdini_burning_distraction") then
    local abilityIndex = filterTable["entindex_ability_const"]
    local ability = EntIndexToHScript(abilityIndex)
    local burningAbility = houdini:FindAbilityByName("houdini_burning_distraction")
    local projectileSpeedDecrease = burningAbility:GetSpecialValueFor("projectile_speed_decrease") * 0.01
    projectileSpeedDecrease =  1 - (projectileSpeedDecrease * caster:GetModifierStackCount("modifier_houdini_burning_distraction",houdini))
    filterTable.move_speed = filterTable.move_speed * projectileSpeedDecrease
  end
  --PrintTable(filterTable) 
  return filterTable

end

  
function GetMouseLocation(hPlayer) -- Also in util, that one is required for sure.
  local player = hPlayer
  local pID = player:GetPlayerID()
  local table  =
  {
    hPlayer = pID,
    hCaster = player:GetAssignedHero(),
  }
 CustomGameEventManager:Send_ServerToPlayer(player,"GetCurrentMouseLocation",table)

  return
end