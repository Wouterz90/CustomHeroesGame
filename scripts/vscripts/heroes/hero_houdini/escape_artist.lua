if not houdini_escape_artist then
  houdini_escape_artist = class({})
end

if not modifier_escape_artist_passive then
  modifier_escape_artist_passive = class({})
end

if not modifier_escape_artist_attack_fail_check then
  modifier_escape_artist_attack_fail_check = class({})
end

LinkLuaModifier("modifier_escape_artist_passive","heroes/hero_houdini/escape_artist.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_escape_artist_attack_fail_check","heroes/hero_houdini/escape_artist.lua",LUA_MODIFIER_MOTION_NONE)


function houdini_escape_artist:OnSpellStart(keys)
  local caster = self:GetCaster()
  local ability = self
 
  if (caster:IsStunned()) == false and (caster:IsRooted()) == false then
    ability:RefundManaCost()
    ability:EndCooldown()
    local pID = caster:GetPlayerID()
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text="This ability can only be activated when stunned or rooted.", duration=4, style={color="red"}, continue=false}) 
    return false 
  end
  GetMouseLocation(caster:GetPlayerOwner())

  Timers:CreateTimer(0.1,function()
    local panaromamaTarget = caster.currentMousePosition
    
  

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster.currentMousePosition, nil, ability:GetSpecialValueFor("search_range"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
    for _,unit in pairs(units) do
      if caster:GetRangeToUnit(unit) < ability:GetSpecialValueFor("cast_range") and unit ~= caster then
        ability.target = unit
      end
    end
   
    caster.currentMousePosition = nil
    local target = ability.target
    ability.target = nil
    if not target then
      local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetSpecialValueFor("cast_range"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
      local target = units[1]
      if target == caster then
        target = units[2] or nil
      end
    end

    if not target then
      local pID = caster:GetPlayerID()
      --Notifications:ClearBottom(pID)
      Notifications:Bottom(pID, {text="There are no target's to switch with.", duration=4, style={color="red"}, continue=false})
      ability:RefundManaCost()
      ability:EndCooldown()
      return false
    end

    if (caster:IsStunned() or caster:IsRooted()) then
     
      local casterLocation = caster:GetAbsOrigin()
      local targetLocation = target:GetAbsOrigin()
      ProjectileManager:ProjectileDodge(caster)
      EmitSoundOn("Hero_Shredder.TimberChain.Retract", caster)
      --EmitSoundOn("Hero_WarlockGolem.Attack", target )

      FindClearSpaceForUnit(caster,targetLocation,true)
      FindClearSpaceForUnit(target,casterLocation,true)

      local effectCaster = ParticleManager:CreateParticle("particles/houdini/houdini_escape_artist_effect.vpcf",PATTACH_OVERHEAD_FOLLOW,caster)
      local effectTarget = ParticleManager:CreateParticle("particles/houdini/houdini_escape_artist_effect.vpcf",PATTACH_OVERHEAD_FOLLOW,target)

      ParticleManager:SetParticleControl(effectCaster,0,caster:GetAbsOrigin())
      ParticleManager:SetParticleControl(effectTarget,0,target:GetAbsOrigin())

      Timers:CreateTimer(2,function()
        ParticleManager:DestroyParticle(effectCaster,true)
        ParticleManager:DestroyParticle(effectTarget,true)

      end)

    else
      ability:RefundManaCost()
      ability:EndCooldown()
      local pID = caster:GetPlayerID()
      Notifications:ClearBottom(pID)
      Notifications:Bottom(pID, {text="This ability can only be activated when stunned or rooted.", duration=4, style={color="red"}, continue=false})
    end
  end)
end

function houdini_escape_artist:GetIntrinsicModifierName()
  return "modifier_escape_artist_passive"
end

function modifier_escape_artist_passive:DeclareFunctions()
    local funcs = {
      MODIFIER_EVENT_ON_PROJECTILE_DODGE,
    }
    return funcs
end

function modifier_escape_artist_passive:IsPassive()
  return true
end

function modifier_escape_artist_passive:AllowIllusionDuplicate()
  return false
end

function modifier_escape_artist_passive:IsAura()
  return true
end

function modifier_escape_artist_passive:GetModifierAura()
  return "modifier_escape_artist_attack_fail_check"
end

function modifier_escape_artist_passive:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_escape_artist_passive:GetAuraDuration()
    return 0.1
end

function modifier_escape_artist_passive:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO
end

function modifier_escape_artist_passive:GetAuraRadius()
  return 2000 -- I doubt attacks will fail from further.
end

function modifier_escape_artist_passive:OnProjectileDodge(keys)
  if IsServer() then
    if keys.ranged_attack == false then
      local hCaster = self:GetParent()
      local hTarget = hCaster.perkTarget
      local ability = self:GetAbility() -- This is the ability that the caster always owns, while reflectingAbility is the stolen ability
      if not hCaster.reflectedAbility then
        print("The ability to reflect has not been stored, something went wrong.")
        return 
      end
      local random = RandomInt(0,100)
      local chance = ability:GetSpecialValueFor("dodge_chance")

      local reflectingAbility = hCaster:AddAbility(hCaster.reflectedAbility:GetAbilityName()) -- the stolen ability
      if reflectingAbility and random <= chance then
        reflectingAbility:SetStolen(true) 
        reflectingAbility:SetHidden(true)  
        reflectingAbility:SetLevel(hCaster.reflectedAbility:GetLevel())
        hCaster:SetCursorCastTarget(hCaster.perkTarget)
        reflectingAbility:OnSpellStart()
        if hCaster.oldReflectedAbilityThree and not hCaster.oldReflectedAbilityThree:IsNull() then
          hCaster:RemoveAbility(hCaster.oldReflectedAbilityThree:GetAbilityName())
        end
        -- Saving the abilities so that I can remove them again, doing this with ID values gives weird errors
        if hCaster.oldReflectedAbilityTwo then
          hCaster.oldReflectedAbilityThree = hCaster.oldReflectedAbilityTwo
        end
        if hCaster.oldReflectedAbilityOne then
          hCaster.oldReflectedAbilityTwo = hCaster.oldReflectedAbilityOne
        end
        hCaster.oldReflectedAbilityOne = reflectingAbility
      end
    end
  end
end 


function EscapeArtistReflect(filterTable) -- caster = the caster of the spell, not the dodging unit that is target

  local targetIndex = filterTable["entindex_target_const"]
  local target = EntIndexToHScript(targetIndex)
  local targetname = target:GetUnitName()
  local casterIndex = filterTable["entindex_source_const"]
  local caster = EntIndexToHScript(casterIndex) -- also for attacks!

  if caster then
    local casterName = caster:GetUnitName()
  else
    return filterTable
  end
  local abilityIndex = filterTable["entindex_ability_const"]
  local ability = EntIndexToHScript(abilityIndex)
  if ability then
    if target:HasModifier("modifier_escape_artist_passive") then
      filterTable.dodgeable = 1
      target.perkTarget = caster
      target.reflectedAbility = ability
    end
  end
  return filterTable
end

function modifier_escape_artist_attack_fail_check:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_ATTACK_FAIL,
  }
  return funcs
end

function modifier_escape_artist_attack_fail_check:IsHidden()
  return true
end

function modifier_escape_artist_attack_fail_check:OnAttackFail(keys)
  if IsServer() then
    local caster = self:GetCaster()
    local unit = self:GetParent()
    local attacker = keys.attacker
    local target = keys.target

    if target == caster and unit == attacker then
      local ability = self:GetAbility()
      local random = RandomInt(0,100)
      local chance = ability:GetSpecialValueFor("dodge_chance")

      if random <= chance  then
        caster:PerformAttack(unit,true,true,true,true,true)
      end
    end
  end
end


