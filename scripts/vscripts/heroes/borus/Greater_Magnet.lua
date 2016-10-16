LinkLuaModifier("modifier_borus_greater_magnet_positive_aura_offensive","heroes/borus/modifiers/modifier_borus_greater_magnet_positive_aura_offensive.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_greater_magnet_negative_aura_offensive","heroes/borus/modifiers/modifier_borus_greater_magnet_negative_aura_offensive.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_greater_magnet_positive_aura_defensive","heroes/borus/modifiers/modifier_borus_greater_magnet_positive_aura_defensive.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_greater_magnet_negative_aura_defensive","heroes/borus/modifiers/modifier_borus_greater_magnet_negative_aura_defensive.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_positive_effect_enemies","heroes/borus/modifiers/modifier_borus_positive_effect_enemies.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_negative_effect_enemies","heroes/borus/modifiers/modifier_borus_negative_effect_enemies.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_positive_effect_allies","heroes/borus/modifiers/modifier_borus_positive_effect_allies.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borus_negative_effect_allies","heroes/borus/modifiers/modifier_borus_negative_effect_allies.lua",LUA_MODIFIER_MOTION_NONE)

	


function greater_magnet_field (keys)
	local caster = keys.caster
	local ability = keys.ability

	
	local wall_vacuum = ability:GetSpecialValueFor("radius")
	local wall_aoe = wall_vacuum - 100 
	local radius = ability:GetSpecialValueFor("radius")-100
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	local pos_charge = caster:FindAbilityByName("Positive_Charge")
	local neg_charge = caster:FindAbilityByName("Negative_Charge")
	local unit = keys.target
	
	local casterloc = caster:GetAbsOrigin()
	local targetloc = unit:GetAbsOrigin()
	local distance = (casterloc - targetloc):Length2D()
	local direction = (casterloc - targetloc):Normalized()

	-- Decrease Movement speed and Attack speed for positive charges
	-- Decrease Movement speed and cast speed for negative charges
	-- Base it on position? Fits the magnetic theme and rewards smart magnetic uses.


	
end
	
function start_greater_magnet (keys)
	local caster = keys.caster
	local ability = keys.ability
	local pos_charge = caster:FindAbilityByName("Positive_Charge")
	local neg_charge = caster:FindAbilityByName("Negative_Charge")
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	local radius = ability:GetSpecialValueFor("radius")-100
	
	caster.greater_magnet_cast_point_increase = ability:GetLevelSpecialValueFor("cast_point_increase", ability:GetLevel() -1)
	caster.greater_magnet_attackspeed_increase = ability:GetLevelSpecialValueFor("attackspeed_increase", ability:GetLevel() -1)
	caster.greater_magnet_ms_increase = ability:GetLevelSpecialValueFor("ms_increase", ability:GetLevel() -1)

	local random = RandomFloat(0, 1)
	if not (caster:HasModifier("Positive_Charge_Magnetic") or caster:HasModifier("Negative_Charge_Magnetic")) then
		if random < 0.5 then 
			pos_charge:ApplyDataDrivenModifier(caster,caster, "Positive_Charge_Magnetic", {duration = duration})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_positive_aura_offensive" ,{})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_positive_aura_defensive" ,{})
			changeparticle = 1
			oldparticle = 0

		
		else
			neg_charge:ApplyDataDrivenModifier(caster,caster, "Negative_Charge_Magnetic", {duration = duration})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_negative_aura_offensive" ,{})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_negative_aura_defensive" ,{})
			changeparticle = 2
			oldparticle = 0 
		end
	else
		if caster:HasModifier("Positive_Charge_Magnetic") then
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_positive_aura_offensive" ,{})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_positive_aura_defensive" ,{})
			changeparticle = 1
			oldparticle = 0
		elseif caster:HasModifier("Negative_Charge_Magnetic") then
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_negative_aura_offensive" ,{})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_negative_aura_defensive" ,{})
			changeparticle = 2
			oldparticle = 0 
		end
	end
end

function createparticles(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")-100

	if oldparticle == changeparticle then
	else
		if changeparticle == 1 then
			caster:RemoveModifierByName("modifier_borus_greater_magnet_negative_aura_offensive")
			caster:RemoveModifierByName("modifier_borus_greater_magnet_negative_aura_defensive")
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_positive_aura_offensive" ,{})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_positive_aura_defensive" ,{})
			ability:ApplyDataDrivenModifier(caster, caster, "posdummy", {})
			caster:RemoveModifierByName("negdummy")

		elseif changeparticle == 2 then
			caster:RemoveModifierByName("modifier_borus_greater_magnet_positive_aura_offensive")
			caster:RemoveModifierByName("modifier_borus_greater_magnet_positive_aura_defensive")
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_negative_aura_offensive" ,{})
			caster:AddNewModifier(caster,ability, "modifier_borus_greater_magnet_negative_aura_defensive" ,{})
			ability:ApplyDataDrivenModifier(caster, caster, "negdummy", {})
			caster:RemoveModifierByName("posdummy")

		end
	end 

	oldparticle = changeparticle
	if caster:HasModifier("Positive_Charge_Magnetic") then
		changeparticle = 1
	elseif caster:HasModifier("Negative_Charge_Magnetic") then
		changeparticle = 2
	end
end

function removeparticles(keys)
	local caster = keys.caster
	caster:RemoveModifierByName("posdummy")
	caster:RemoveModifierByName("negdummy")
	caster:RemoveModifierByName("modifier_borus_greater_magnet_positive_aura_offensive")
	caster:RemoveModifierByName("modifier_borus_greater_magnet_positive_aura_defensive")
	caster:RemoveModifierByName("modifier_borus_greater_magnet_negative_aura_offensive")
	caster:RemoveModifierByName("modifier_borus_greater_magnet_negative_aura_defensive")
	changeparticle = nil
	oldparticle = nil
end

function posdummy (keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")-100
	particle_pos = ParticleManager:CreateParticle("particles/borus/borus_greater_magnet_field_positive.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_pos, 1, Vector(radius, radius, radius))
end

function negdummy (keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")-100

	particle_neg = ParticleManager:CreateParticle("particles/borus/borus_greater_magnet_field_negative.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_neg, 1, Vector(radius, radius, radius))
end

function posdummy_clean (keys)
	local caster = keys.caster
	ParticleManager:DestroyParticle( particle_pos, false )
end
function negdummy_clean (keys)
	local caster = keys.caster
	ParticleManager:DestroyParticle( particle_neg, false )
end









