function HealingAttack (keys) 
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local attacker = keys.attacker
	
	
	local Heal_Factor = ability:GetLevelSpecialValueFor("Heal_Factor",ability:GetLevel()-1)

	if caster == attacker then -- only the modifier owner should heal, else enemies would heal too
		target:Heal(caster:GetAttackDamage() * Heal_Factor,caster)
	end
end

function GiveUtherNewHammer(keys) -- HasHammer gets first declared in the game INIT phase and Activating HurlHammer sets it to false, getting the hammer back is true again
	local caster = keys.caster
	if caster.HasHammer == true then
		CosmeticLib:ReplaceWithSlotName( keys.caster, "weapon", 7580 )
	end
end
function GiveUtherOldHammer(keys)
	local caster = keys.caster
	if caster.HasHammer == true then
		CosmeticLib:ReplaceWithSlotName( keys.caster, "weapon", 4246 )
	end
end


--OrderFilter
function AllowAlliedAttacks(hUnit,hTarget,iOrderType)
	if (iOrderType == DOTA_UNIT_ORDER_ATTACK_TARGET) and 
		hUnit:HasModifier("modifier_argent_smite_passive") and 
		(hUnit:GetTeamNumber() == hTarget:GetTeamNumber()) then

		local Argent_Smite = hUnit:FindAbilityByName("Argent_Smite")
	  Argent_Smite:ApplyDataDrivenModifier(hUnit,hTarget,"modifier_specially_deniable",{duration = -1}) -- This allows allied attacks
	  Argent_Smite:ApplyDataDrivenModifier(hUnit,hUnit,"modifier_argent_smite",{duration = -1})

	  hUnit.argentSmiteTarget = hTarget -- Storing this to remove the modifier later
	end
end

--OrderFilter
function CancelOtherAlliedAttacks (hUnit,hTarget,iOrderType)
	-- When an ally of Uther tries to attack an ally the order gets changed to Move here.
	if not hTarget then return end
	if (iOrderType == DOTA_UNIT_ORDER_ATTACK_TARGET) and 
		not hUnit:HasModifier("modifier_argent_smite_passive") and
		(hTarget:HasModifier("modifier_specially_deniable")) and
		(hUnit:GetTeamNumber() == hTarget:GetTeamNumber()) then

		hUnit:MoveToNPC(hTarget) 
    return false
  end
end

--OrderFilter
function StopAllowingAlliedAttacks (hUnit,hTarget,iOrderType)
	-- If uther does something other than attack an ally we remove all the effects that have something to do with that here.
	if hUnit:HasModifier("modifier_argent_smite")
		and ((iOrderType ~= DOTA_UNIT_ORDER_ATTACK_TARGET) or (hUnit:GetTeamNumber() ~= hTarget:GetTeamNumber())) then

		hUnit:RemoveModifierByName("modifier_argent_smite")
		if not hUnit.argentSmiteTarget:IsNull() then
			if hUnit.argentSmiteTarget:HasModifier("modifier_specially_deniable") then
				hUnit.argentSmiteTarget:RemoveModifierByName("modifier_specially_deniable")
			end
		end
	end
end

--DamageFilter
function damageFilterArgentSmite(filterTable) -- Setting the damage uther deals to allies to 0
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

	if damageFilterTable.attacker and damageFilterTable.victim then
		if damageFilterTable.attacker:HasModifier("modifier_argent_smite") 
		and damageFilterTable.victim:HasModifier("modifier_specially_deniable")
		and not damageFilterTable.inflictor then
			filterTable["damage"] = 0
		end
	end
	return filterTable
end


--Modifier Gained filter
function argentSmiteDoNotDebuffAllies(filterTable)
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

	local hCaster = modifierCaster
	local hTarget = modifierTarget
	local sModifierName = modifierName


	local modifierTable = {
		modifier_sange_buff = true,
		modifier_bashed = true,
		modifier_sange_and_yasha_buff = true,
		modifier_item_skadi_slow = true,
		modifier_silver_edge_debuff = true,
		modifier_desolator_buff = true,
		modifier_item_orb_of_venom_slow = true,
		modifier_blight_stone_buff = true,
		modifier_blight_stone_debuff = true,
	}
	if hCaster:HasModifier("modifier_argent_smite") and hCaster:GetTeamNumber() == hTarget:GetTeamNumber() and modifierTable[sModifierName] then
		return false
	end
end