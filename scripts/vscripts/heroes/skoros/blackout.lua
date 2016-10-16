function SkorosHaltChance(skoros,blackout,unit)
  if unit:HasModifier("modifier_blackout") then
  	local random = RandomFloat(0, 1) * 100
    local chance = blackout:GetLevelSpecialValueFor("halt_chance", blackout:GetLevel() -1)
    if random < chance then
      unit:Stop()
      blackout:ApplyDataDrivenModifier(skoros, unit, "modifier_block_commands", {duration = blackout:GetLevelSpecialValueFor("halt_duration",blackout:GetLevel() -1)})
      return false
  	end
  end    
end