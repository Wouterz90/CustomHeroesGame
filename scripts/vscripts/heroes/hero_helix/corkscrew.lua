LinkLuaModifier("modifier_corkscrew_slow","heroes/hero_helix/modifiers/modifier_corkscrew_slow.lua",LUA_MODIFIER_MOTION_NONE)

function SlowModifier (keys)
	local caster = keys.caster
	local ability = keys.ability
	--Damage part still needs to be done
	
	if caster.positions[0.04] == caster:GetAbsOrigin()  or (caster:GetModifierStackCount("modifier_corkscrew_slow_datadriven",caster) == 75) then
		caster:RemoveModifierByName("modifier_corkscrew_slow_datadriven")
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_corkscrew_shield",{duration = ability:GetDuration() -ability:GetLevelSpecialValueFor("time_to_stop",ability:GetLevel()-1)})
		
	else
		caster:SetModifierStackCount("modifier_corkscrew_slow_datadriven",caster,caster:GetModifierStackCount("modifier_corkscrew_slow_datadriven",caster)+1)
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, ability:GetLevelSpecialValueFor("radius",ability:GetLevel()-1), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)  
		for _,unit in pairs(targets) do
			if not unit:HasModifier("modifier_corkscrew_damage_dummy") and caster ~= unit then
				ability:ApplyDataDrivenModifier(caster,unit,"modifier_corkscrew_damage_dummy",{duration = ability:GetLevelSpecialValueFor("time_to_stop",ability:GetLevel()-1)})
				unit:AddNewModifier(caster,ability,"modifier_stunned",{duration =ability:GetLevelSpecialValueFor("stun_duration",ability:GetLevel()-1)})
				local DamageTable = 
				{
					attacker = caster,
					damage_type = ability:GetAbilityDamageType(),
					damage = ability:GetAbilityDamage(),
					victim = unit
				}
				ApplyDamage(DamageTable)
			end
		end
	end
end



function CheckMovement(keys)
	local caster = keys.caster
	local ability = keys.ability
	local currTime = GameRules:GetGameTime()
	caster:AddNewModifier(caster,ability,"modifier_corkscrew_slow",{duration = ability:GetDuration()})
	
	if caster.positions[(math.floor((currTime -0.04) * 25)/25)] ~= caster:GetAbsOrigin() then
		--caster is moving
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_corkscrew_slow_datadriven",{duration = ability:GetLevelSpecialValueFor("time_to_stop",ability:GetLevel()-1)})
		caster:SetModifierStackCount("modifier_corkscrew_slow_datadriven",caster,1)
	else
		--caster is not moving, Get into shield
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_corkscrew_shield",{duration = ability:GetDuration()})
	end
end


