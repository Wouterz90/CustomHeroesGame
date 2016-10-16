function GameMode:FilterModifierGained( filterTable )

	local modifierCasterIndex = filterTable["entindex_caster_const"]
	local modifierCaster = EntIndexToHScript(modifierCasterIndex)
	local modifierAbilityIndex = filterTable["entindex_ability_const"]
	if modifierAbilityIndex then
		local modifierAbility = EntIndexToHScript(modifierAbilityIndex)
	end
	local modifierDuration = filterTable["duration"]
	local modifierTargetIndex =  filterTable["entindex_parent_const"]
	local modifierTarget = EntIndexToHScript(modifierTargetIndex)
	local modifierName = filterTable["name_const"]

	--Uther Argent Smite
	local utherArgentSmite = require('heroes/uther/argent_smite')
	if argentSmiteDoNotDebuffAllies(filterTable) == false then
		return false
	end



	if modifierTarget:HasModifier("modifier_Offense_is_the_best_defense_debuff_decrease") and modifierCaster:GetTeamNumber() ~= modifierTarget:GetTeamNumber() then
		if modifierTarget:GetModifierStackCount("modifier_Offense_is_the_best_defense_debuff_decrease",modifierTarget) == 1 then
			filterTable["duration"] = modifierDuration * (1 - (0.01* modifierTarget:FindAbilityByName("Mikhail_Offense_is_the_best_Defense"):GetLevelSpecialValueFor("debuff_shortening_time",modifierTarget:FindAbilityByName("Mikhail_Offense_is_the_best_Defense"):GetLevel() -1) *2))
		else
			filterTable["duration"] = modifierDuration *  (1 - (0.01* modifierTarget:FindAbilityByName("Mikhail_Offense_is_the_best_Defense"):GetLevelSpecialValueFor("debuff_shortening_time",modifierTarget:FindAbilityByName("Mikhail_Offense_is_the_best_Defense"):GetLevel() -1)))
		end
		print(filterTable["duration"])
	end

	return true
end


