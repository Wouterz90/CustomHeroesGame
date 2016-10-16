function TargetTookDamage(keys)
  local caster = keys.caster
  local unit = keys.unit
  local attacker = keys.attacker
  local ability = keys.ability
  
  -- Now we need the values to check whether or not the damage should do something
  local damage_treshold = ability:GetLevelSpecialValueFor("spell_damage_mana_burn_threshold",ability:GetLevel()-1) -- -1 because the txt files start at 0, and this at 1
  local manaburn = ability:GetLevelSpecialValueFor("mana_burn",ability:GetLevel()-1)
  local TakenDamage = keys.DamageTaken
  
  print("TakenDamage ="..TakenDamage)
  if ability.damagetaken == nil then -- This checks if it is the first instance of damage
    ability.damagetaken = 0
  end
  
  ability.damagetaken = ability.damagetaken + TakenDamage
   print("Total Damage ="..ability.damagetaken)
  if ability.damagetaken > damage_treshold then
    unit:RemoveModifierByName("modifier_spellbind")
    unit:ReduceMana(manaburn)
    ability.damagetaken = nil -- To reset the damage counter
  end
-- This was the part where the target was hurt/checked. Now the mana/damage part
--DAMAGE TO MANA RESTORE : 30/40/50/60% THIS IS MISSING
  local damagetomanarestore = ability:GetLevelSpecialValueFor("damagetomanarestore",ability:GetLevel()-1) / 100 -- From 30% to 0.3
  attacker:GiveMana(damagetomanarestore * TakenDamage)
end