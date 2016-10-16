

function HealingWardMana(keys)
  local ability = keys.ability
  local unit = keys.unit
  local healing_ward_mana_restore_pct = 0.01 * ability:GetLevelSpecialValueFor("healing_ward_mana_restore_amount",ability:GetLevel()-1) * 0.04
  print(unit:GetName())

  unit:GiveMana(unit:GetMaxMana()*healing_ward_mana_restore_pct)
end