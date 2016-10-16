function GameMode:FilterDamage( filterTable )
	--DeepPrintTable(filterTable)

	local damageFilterTable = {}

	local attackerIndex = filterTable["entindex_attacker_const"]
	if attackerIndex then
		damageFilterTable.attacker = EntIndexToHScript(attackerIndex)
	end
	
	local victimIndex = filterTable["entindex_victim_const"]
	if victimIndex then
		damageFilterTable.victim = EntIndexToHScript(victimIndex)
	end

	local inflictorIndex = filterTable["entindex_inflictor_const"]
	if inflictorIndex then
		damageFilterTable.inflictor = EntIndexToHScript(inflictorIndex)
	end

	local damageType = filterTable["damagetype_const"]
	local damage = filterTable["damage"]

	filterTable = damageFilterArgentSmite(filterTable)
	
	if damageFilterTable.attacker and damageFilterTable.victim then
		if damageFilterTable.attacker:HasModifier("modifier_spread_wisdom_passive") then
      		filterTable["damage"] = SpreadWisdomDamageBoost(damageFilterTable.attacker,damageFilterTable.victim,filterTable["damage"])
		end
	end
	return true
end

