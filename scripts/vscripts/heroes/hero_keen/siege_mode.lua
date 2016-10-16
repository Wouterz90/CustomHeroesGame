LinkLuaModifier("modifier_siege_mode_no_movement","heroes/hero_keen/modifiers/modifier_siege_mode_no_movement.lua",LUA_MODIFIER_MOTION_NONE)

function MinAttackRange (keys)
	local caster = keys.caster
	local target = keys.target

	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < 400 then
		caster:Stop()

	end
end

function SplashAttack (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = caster:FindAbilityByName("keen_commander_guerrilla_mode")
	local radius = ability:GetLevelSpecialValueFor("splash_radius",ability:GetLevel() -1 )

	local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP +DOTA_UNIT_TARGET_HERO, 0, 0, false )
	
	for _,unit in pairs( units ) do
		if unit ~= target then
			local DamageTable = 
			{
				attacker = caster,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage = caster:GetAttackDamage(),
				victim = unit
			}
			ApplyDamage(DamageTable)
		end
	end
end

function GetGuerrillaModeSpell (keys)
	local caster = keys.caster
	local ability = "keen_commander_siege_mode"
	local swapability = "keen_commander_guerrilla_mode"
	local mortar_shot = "keen_commander_mortar_shot"
	local mortar_shot_siege = "keen_commander_mortar_shot_siege"
	caster:AddAbility(swapability)
	caster:FindAbilityByName(swapability):SetLevel(caster:FindAbilityByName(ability):GetLevel())
	caster:SwapAbilities(ability,swapability,false,true)
	caster:RemoveAbility(ability)
	--caster:AddNewModifier(caster,nil,"modifier_siege_mode_no_movement",{})

	caster:AddAbility(mortar_shot_siege)
	caster:FindAbilityByName(mortar_shot_siege):SetLevel(caster:FindAbilityByName(mortar_shot):GetLevel())
	caster:SwapAbilities(mortar_shot,mortar_shot_siege,false,true)
	caster:RemoveAbility(mortar_shot)

end

function GetSiegeModeSpell (keys)
	local caster = keys.caster
	local swapability = "keen_commander_siege_mode"
	local ability = "keen_commander_guerrilla_mode"
	local mortar_shot = "keen_commander_mortar_shot"
	local mortar_shot_siege = "keen_commander_mortar_shot_siege"

	caster:AddAbility(swapability)
	caster:FindAbilityByName(swapability):SetLevel(caster:FindAbilityByName(ability):GetLevel())
	caster:SwapAbilities(ability,swapability,false,true)
	caster:RemoveAbility(ability)
	--caster:RemoveModifierByName("modifier_siege_mode_no_movement")
	caster:AddAbility(mortar_shot)
	caster:FindAbilityByName(mortar_shot):SetLevel(caster:FindAbilityByName(mortar_shot_siege):GetLevel())
	caster:SwapAbilities(mortar_shot,mortar_shot_siege,true,false)
	caster:RemoveAbility(mortar_shot_siege)


end