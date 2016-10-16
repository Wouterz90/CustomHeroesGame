function CheckEnemieHeroesFacing( keys )
	local caster = keys.caster
	local ability = keys.ability
	local search_radius = ability:GetLevelSpecialValueFor("search_radius",ability:GetLevel()-1)
	local charges_increment = ability:GetLevelSpecialValueFor("charges_increment",ability:GetLevel()-1)
	local targets = FindUnitsInRadius(caster:GetTeam(),caster:GetAbsOrigin(),nil,search_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	caster.seen = false
	for _,target in pairs(targets) do
		local casterloc = caster:GetAbsOrigin()
		local targetloc = target:GetAbsOrigin()
		local targetdirection = target:GetForwardVector()

		local direction = (targetloc - casterloc):Normalized()
		local vision_cone = 240
		local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(targetdirection)).y)
		--print(angle)
		if (target:IsBuilding() or not (angle <= vision_cone/2)) and not caster:HasModifier("modifier_silent_headroll_channeling") then
			--print("Im seen")
			caster:SetModifierStackCount("modifier_stealth",caster,caster:GetModifierStackCount("modifier_stealth",caster) - charges_increment * 0.4)
			caster.seen = true
			break
		end
	end
	if caster.seen == false then
		caster:SetModifierStackCount("modifier_stealth",caster,caster:GetModifierStackCount("modifier_stealth",caster) + charges_increment * 0.2)
	end
end

function CheckChargesForState(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_stealth")
	local max_stealth_charges = ability:GetLevelSpecialValueFor("max_stealth_charges",ability:GetLevel()-1)

	local no_healthbar = ability:GetSpecialValueFor("no_healthbar")
	local invisibility = ability:GetSpecialValueFor("invisibility")
	local true_sight_immune = ability:GetSpecialValueFor("true_sight_immune")


	if caster:GetModifierStackCount("modifier_stealth",caster) < no_healthbar then
		caster:RemoveModifierByName("modifier_stealth_transparency")
	else
		caster:AddNewModifier(caster,ability,"modifier_stealth_transparency",{})
	end

	if caster:GetModifierStackCount("modifier_stealth",caster) < invisibility then
		caster:RemoveModifierByName("modifier_stealth_invis")
	else
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_stealth_invis",{})
	end

	if caster:GetModifierStackCount("modifier_stealth",caster) < true_sight_immune then
		caster:RemoveModifierByName("modifier_stealth_super_invis")
	else
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_stealth_super_invis",{})
	end
	if caster:GetModifierStackCount("modifier_stealth",caster) > max_stealth_charges then
		caster:SetModifierStackCount("modifier_stealth",caster,max_stealth_charges)
	end
	if caster:GetModifierStackCount("modifier_stealth",caster) < 0 then
		caster:SetModifierStackCount("modifier_stealth",caster,0)
	end


end

function RemoveChargesAfterDamage (keys)
	local caster = keys.caster
	local ability = keys.ability
	local charge_reduction_after_damage = (100 - ability:GetSpecialValueFor("charge_reduction_after_damage"))/100
	if not caster:HasModifier("modifier_stealth_just_dealt_damage") then
		caster:SetModifierStackCount("modifier_stealth",caster,caster:GetModifierStackCount("modifier_stealth",caster) * charge_reduction_after_damage )
		caster:AddNewModifier(caster,ability,"modifier_stealth_just_dealt_damage",{duration = 0.1})
	end
end

function RemoveArmor(keys)
	local caster = keys.caster
	local stealth = caster:FindModifierByName("modifier_stealth")
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("armor_reduction_duration",ability:GetLevel()-1)
	local divison = ability:GetLevelSpecialValueFor("decreased_armor_division",ability:GetLevel()-1)

	local stealthcharges = caster:GetModifierStackCount("modifier_stealth",caster)
	local armor_reduction = math.floor(stealthcharges/divison)
	if target:HasModifier("modifier_stealth_attacked") then
		target:FindModifierByName("modifier_stealth_attacked"):SetDuration(duration,true)
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_stealth_attacked",{duration = duration})
		target:SetModifierStackCount("modifier_stealth_attacked",caster,armor_reduction)
	end
end


LinkLuaModifier("modifier_stealth_just_dealt_damage","heroes/hero_fanna/stealth.lua",LUA_MODIFIER_MOTION_NONE)

modifier_stealth_just_dealt_damage = class({}) -- This modifier prevents deleting charges twice if dealt damage on very short succession (Dagger Throw for example)

function modifier_stealth_just_dealt_damage:IsHidden()
	return true
end


LinkLuaModifier("modifier_stealth_transparency","heroes/hero_fanna/stealth.lua",LUA_MODIFIER_MOTION_NONE)

modifier_stealth_transparency = class({})

function modifier_stealth_transparency:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
	return funcs
end


function modifier_stealth_transparency:IsHidden()
	return false
end

function modifier_stealth_transparency:GetModifierInvisibilityLevel()
	return 0.75
end

--[[function modifier_stealth_transparency:CheckState()
	local state = 
	{
	  [MODIFIER_STATE_NO_HEALTH_BAR] = false,
	}
  return state
end]]




