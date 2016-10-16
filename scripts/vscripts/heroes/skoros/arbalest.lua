if arbalest == nil then
	arbalest = class({})
end
LinkLuaModifier( "arbalest_attack_dummy", "heroes/skoros/modifiers/arbalest_attack_dummy.lua" ,LUA_MODIFIER_MOTION_NONE )


function SwapSpells (keys)
	spellowner = keys.caster
	local ability = keys.ability
	mainability =  ability:GetAbilityName()
	sub_ability_name = keys.sub_ability_name
	spellowner:AddAbility(sub_ability_name)
	local attacklevel = ability:GetLevel()
	spellowner:AddNewModifier(spellowner, ability, "arbalest_attack_dummy", {duration = ability:GetDuration()})

	local attack = keys.caster:FindAbilityByName("Arbalest_Attack")
	if attack ~= nil and attack:GetLevel() ~= attacklevel then
		attack:SetLevel(attacklevel)
	end
	spellowner:SwapAbilities(mainability, sub_ability_name, false, true)
end

function SwapSpellsBack ()
	spellowner:SwapAbilities(mainability, sub_ability_name, true, false)
	spellowner:RemoveAbility(sub_ability_name)
end

function projectilehit (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local vision = ability:GetSpecialValueFor("target_vision_radius")
	local duration = ability:GetSpecialValueFor("target_vision_duration")
	print(vision)
	print(duration)
	caster:PerformAttack(target, true, true, true, false, false)
	AddFOWViewer(caster:GetTeamNumber(),target:GetAbsOrigin(), vision , duration, true)
end

function DONTATTACK (keys)
	local caster = keys.caster
	caster:Stop()
end

function CheckTime (keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("Arbalest")

	if caster:HasModifier("Arbalest") and modifier:GetRemainingTime() < 2 then
		caster:Stop()
		ability:StartCooldown(3)
	end
end
