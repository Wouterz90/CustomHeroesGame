function MortarShot (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel() -1)

	local units = FindUnitsInRadius( caster:GetTeamNumber(), target_point, caster, radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )
	
	for _,unit in pairs( units ) do
		if unit:HasModifier("modifier_recon_systems_bot_aura") then
			unit:RemoveSelf()
			local HadRecon = 1
		end
	end

	local mortarunit = CreateUnitByName("npc_dota_unit_mortar_shot",target_point,false,caster,nil,caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster,mortarunit,"modifier_mortar_shot_thinker",{duration = duration})
	if HadRecon == 1 then
		mortarunit:SetModifierStackCount("modifier_mortar_shot_thinker",caster,2)
	else
		mortarunit:SetModifierStackCount("modifier_mortar_shot_thinker",caster,1)
	end

end

function BurningDamage (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local MortarDamage = ability:GetLevelSpecialValueFor("mortar_damage",ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("debuff_duration",ability:GetLevel() -1)
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel() -1)

	local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), caster, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 0, 0, false )

	for _,unit in pairs( units ) do

		if not unit:HasModifier("modifier_mortar_shot_damage") then
			ability:ApplyDataDrivenModifier(caster,unit,"modifier_mortar_shot_damage",{duration = duration})
			if target:GetModifierStackCount("modifier_mortar_shot_thinker",caster) == 2 then
				unit:SetModifierStackCount("modifier_mortar_shot_damage",caster,2)
			else
				unit:SetModifierStackCount("modifier_mortar_shot_damage",caster,1)
			end
		else
			if target:GetModifierStackCount("modifier_mortar_shot_thinker"	,caster) == 2 then
				unit:SetModifierStackCount("modifier_mortar_shot_damage",caster,unit:GetModifierStackCount("modifier_mortar_shot_damage",caster) + 2)
			else
				unit:SetModifierStackCount("modifier_mortar_shot_damage",caster,unit:GetModifierStackCount("modifier_mortar_shot_damage",caster) + 1)
			end
		end

		local DamageTable = 
		{
			attacker = caster,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage = unit:GetModifierStackCount("modifier_mortar_shot_damage",caster) * MortarDamage,
			victim = unit
		}
		ApplyDamage(DamageTable)
	end
end
		


function RemoveYourself (keys)
	local target = keys.target

	target:RemoveSelf()
end
