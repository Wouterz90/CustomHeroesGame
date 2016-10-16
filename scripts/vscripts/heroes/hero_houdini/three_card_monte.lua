function CreateHoudiniIllusions(keys)
  local caster = keys.caster
  local ability = keys.ability
  local player = caster:GetPlayerID()
  local casterLocation = caster:GetAbsOrigin()

  local numberOfIllusions =  ability:GetSpecialValueFor("illusions")
  if caster:HasScepter() then
    numberOfIllusions = numberOfIllusions + 1
  end
  local outgoingDamage  = ability:GetSpecialValueFor("outgoing_damage_percentage")
  local duration = ability:GetSpecialValueFor("duration")
  caster:Purge(false,true,false,true,true)
  ability:ApplyDataDrivenThinker(caster,casterLocation,"modifier_houdini_three_card_monte_special_effects",{duration = 1})

  ProjectileManager:ProjectileDodge(caster)
  caster:AddNoDraw()
  caster:AddNewModifier(caster,ability,"modifier_invulnerable",{})
  if ability.illusionOne and not ability.illusionOne:IsNull() then
    ability.illusionOne:RemoveSelf()
  end
  if ability.illusionTwo and not ability.illusionTwo:IsNull() then
    ability.illusionTwo:RemoveSelf()
  end

  
  
  -- Taken from the spelllibrary, credits go to Ractidous and Noya
  --
  -- Setup a table of potential spawn positions
  local vRandomSpawnPos = {
    Vector( 150, 0, 0 ),   -- North
    Vector( 0, 150, 0 ),   -- East
    Vector( -150, 0, 0 ),  -- South
    Vector( 0, -150, 0 ),  -- West
  }
  
  for i=#vRandomSpawnPos, 2, -1 do  -- Simply shuffle them
    local j = RandomInt( 1, i )
    vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
  end
  --
  numberOfIllusions = numberOfIllusions + 1 -- adding the real hero
  -- Spawn the first illusion
  ability.illusionOne = CreateUnitByName(caster:GetUnitName(),casterLocation +vRandomSpawnPos[1],true,caster,caster:GetOwner(),caster:GetTeamNumber())
  table.remove(vRandomSpawnPos, 1)
  ability.illusionOne:MakeIllusion()
  ability.illusionOne:SetControllableByPlayer(player,true) 
  ability.illusionOne:SetPlayerID(player)
  ability.illusionOne:SetHealth(caster:GetHealth())
  ability.illusionOne:SetMana(caster:GetMana())
  ability:ApplyDataDrivenModifier(caster,ability.illusionOne,"modifier_houdini_three_card_monte_illusion",{duration = duration})
  ability.illusionOne:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration})

  local casterLevel = caster:GetLevel()
  for i=1,casterLevel-1 do
    ability.illusionOne:HeroLevelUp(false)
  end

  -- Set the skill points to 0 and learn the skills of the caster
  ability.illusionOne:SetAbilityPoints(0)
    for abilitySlot=0,15 do
      local abilityTemp = caster:GetAbilityByIndex(abilitySlot)
      
      if abilityTemp then 
        local abilityLevel = abilityTemp:GetLevel()
        if abilityLevel > 0 then
          local abilityName = abilityTemp:GetAbilityName()
          local illusionAbility = ability.illusionOne:FindAbilityByName(abilityName)
          if illusionAbility then
            illusionAbility:SetLevel(abilityLevel)
          end
        end
      end
    end
   

    -- Recreate the items of the caster
    for itemSlot=0,5 do
      local item = caster:GetItemInSlot(itemSlot)
      if item then
        local itemName = item:GetName()
        local newItem = CreateItem(itemName, ability.illusionOne, ability.illusionOne)
        ability.illusionOne:AddItem(newItem)
      end
    end
    
  
  

  -- Spawn the second illusion 
  ability.illusionTwo = CreateUnitByName(caster:GetUnitName(),casterLocation +vRandomSpawnPos[1],true,caster,caster:GetOwner(),caster:GetTeamNumber())
  table.remove(vRandomSpawnPos, 1)
  ability.illusionTwo:MakeIllusion()
  ability.illusionTwo:SetControllableByPlayer(player,true)
  ability.illusionTwo:SetPlayerID(player)
  --ability.illusionTwo:SetOwner(caster)
  ability:ApplyDataDrivenModifier(caster,ability.illusionTwo,"modifier_houdini_three_card_monte_illusion",{duration = duration})
  ability.illusionTwo:SetHealth(caster:GetHealth())
  ability.illusionTwo:SetMana(caster:GetMana())
  ability.illusionTwo:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration})

  local casterLevel = caster:GetLevel()
  for i=1,casterLevel-1 do
    ability.illusionTwo:HeroLevelUp(false)
  end

  -- Set the skill points to 0 and learn the skills of the caster
  ability.illusionTwo:SetAbilityPoints(0)
  for abilitySlot=0,15 do
    local abilityTemp = caster:GetAbilityByIndex(abilitySlot)
    if abilityTemp then 
      local abilityLevel = abilityTemp:GetLevel()
      if abilityLevel > 0 then
        local abilityName = abilityTemp:GetAbilityName()
        local illusionAbility = ability.illusionTwo:FindAbilityByName(abilityName)
        if illusionAbility then
          illusionAbility:SetLevel(abilityLevel)
        end
      end
    end
  end

  -- Recreate the items of the caster
  for itemSlot=0,5 do
    local item = caster:GetItemInSlot(itemSlot)
    if item then
      local itemName = item:GetName()
      local newItem = CreateItem(itemName, ability.illusionTwo, ability.illusionTwo)
      ability.illusionTwo:AddItem(newItem)
    end
  end
  
  if caster:HasScepter() then
  -- Spawn the third illusion
    ability.illusionThree = CreateUnitByName(caster:GetUnitName(),casterLocation +vRandomSpawnPos[1],true,caster,caster:GetOwner(),caster:GetTeamNumber())
    table.remove(vRandomSpawnPos, 1)
    ability.illusionThree:MakeIllusion()
    ability.illusionThree:SetControllableByPlayer(player,true)
    ability.illusionThree:SetPlayerID(player)
    --ability.illusionThree:SetOwner(caster)
    ability:ApplyDataDrivenModifier(caster,ability.illusionThree,"modifier_houdini_three_card_monte_illusion",{duration = duration})
    ability.illusionThree:SetHealth(caster:GetHealth())
    ability.illusionThree:SetMana(caster:GetMana())
    ability.illusionThree:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration})

    local casterLevel = caster:GetLevel()
    for i=1,casterLevel-1 do
      ability.illusionThree:HeroLevelUp(false)
    end

    -- Set the skill points to 0 and learn the skills of the caster
    ability.illusionThree:SetAbilityPoints(0)
    for abilitySlot=0,15 do
      local abilityTemp = caster:GetAbilityByIndex(abilitySlot)
      if abilityTemp then 
        local abilityLevel = abilityTemp:GetLevel()
        if abilityLevel > 0 then
          local abilityName = abilityTemp:GetAbilityName()
          local illusionAbility = ability.illusionThree:FindAbilityByName(abilityName)
          if illusionAbility then
            illusionAbility:SetLevel(abilityLevel)
          end
        end
      end
    end
  

    -- Recreate the items of the caster
    for itemSlot=0,5 do
      local item = caster:GetItemInSlot(itemSlot)
      if item then
        local itemName = item:GetName()
        local newItem = CreateItem(itemName, ability.illusionThree, ability.illusionThree)
        ability.illusionThree:AddItem(newItem)
      end
    end
  end

  -- Placing the caster in a random location
  caster:SetAbsOrigin(casterLocation +vRandomSpawnPos[1])
  caster:RemoveNoDraw()
  
  caster:RemoveModifierByName("modifier_invulnerable")
  ability:ApplyDataDrivenModifier(caster,caster,"modifier_houdini_three_card_monte_illusion",{duration = duration})

  table.remove(vRandomSpawnPos, 1)

  if caster:HasScepter() then
    caster:AddNewModifier(caster,ability,"modifier_invisible",{duration = duration})
  end

  -- Select the units if caster was selected
  if PlayerResource:IsUnitSelected(player, caster:entindex()) then
    PlayerResource:NewSelection(player,caster:entindex())
    PlayerResource:AddToSelection(player, ability.illusionOne:entindex())
    PlayerResource:AddToSelection(player, ability.illusionTwo:entindex())
    if caster:HasScepter() then -- select the caster only.
      PlayerResource:NewSelection(player,caster:entindex())
    end   
  end
 
  -- Stop the caster from revealing itself by following it's latest order
  caster:Stop()
  ability.illusionOne:Stop()  
  ability.illusionTwo:Stop()
  if caster:HasScepter() then
    ability.illusionThree:Stop()
  end
end

function threeCardMonteDamaged(keys)
  local caster = keys.caster
  local unit = keys.unit
  local ability = keys.ability
  local attacker = keys.attacker
  local damageToTrigger = ability:GetSpecialValueFor("damage_to_trigger")
  local waitTime = ability:GetSpecialValueFor("wait_time")

  if unit:IsIllusion() then
    if keys.takenDamage > damageToTrigger then
      caster:Purge(false,true,false,true,true)
      -- 
      CreateHoudiniIllusions(keys)
      local damageTable = 
      {
        victim = attacker,
        attacker = caster,
        damage = keys.takenDamage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability,
      }
      ApplyDamage(damageTable)
      Timers:CreateTimer(0.04,function()
        ability.illusionsTookDamage = true
      end)
    end
  else
    if keys.takenDamage > damageToTrigger then
      ability.illusionsTookDamage = false
      Timers:CreateTimer(waitTime,function()
        if ability.illusionsTookDamage == false then
          if ability.illusionOne and not ability.illusionOne:IsNull() then
            ability.illusionOne:RemoveSelf()
          end
          if ability.illusionTwo and not ability.illusionTwo:IsNull() then
            ability.illusionTwo:RemoveSelf()
          end
        end
      end)
    end
  end
end
