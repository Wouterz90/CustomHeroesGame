function ChainToSelf(keys)
	local caster = keys.caster
	local ability = keys.ability
	local abilitylevel = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel()-1) 
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed",ability:GetLevel() -1)
	local extended_chain_length = ability:GetLevelSpecialValueFor("extended_chain_length",ability:GetLevel() -1)
	caster.target = keys.target
	local target = keys.target

	
	--Throw the projectile at your target and deal damage
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = "particlecles/fanna/chain_buddies_projectile.vpcf",
		bDodgeable = false,
		bProvidesVision = false, 
		iMoveSpeed = projectile_speed,
    iVisionRadius = 0,
    iVisionTeamNumber = caster:GetTeamNumber(), 
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	local projectile1 = ProjectileManager:CreateTrackingProjectile(info)


	local damageTable = 
	{
		victim = caster.target,
		attacker = caster,
		damage = ability:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
	}
	ApplyDamage(damageTable)


	--Set the distance the units can go from each other
	caster.chainlength = (target:GetAbsOrigin()-caster:GetAbsOrigin()):Length2D() + extended_chain_length

	--Create particles
	ability:ApplyDataDrivenModifier(caster, target, "modifier_chain_buddies_chained", {duration = duration})
  ability:ApplyDataDrivenModifier(caster, caster, "modifier_chain_buddies_chained", {duration = duration})
	caster.chain = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)
  ParticleManager:SetParticleControlEnt(caster.chain, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(caster.chain, 1, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(caster.chain, 2, Vector(duration,0,0))

  --This is stored for checking the distance
	caster.target2 = caster

	--Swap the ability to be able to throw it at a 2nd target
	caster:AddAbility("fanna_chain_buddies_2nd")
	local ability2 = caster:FindAbilityByName("fanna_chain_buddies_2nd")
	ability2:SetLevel(abilitylevel)
	caster:SwapAbilities("fanna_chain_buddies","fanna_chain_buddies_2nd",false,true)
	caster:RemoveAbility("fanna_chain_buddies")


	Timers:CreateTimer(duration,function()
		--Swapping the abilities
		if caster:HasAbility("fanna_chain_buddies_2nd") then
			local ability2 = caster:FindAbilityByName("fanna_chain_buddies_2nd")
			local abilitylevel = ability2:GetLevel()
			caster:AddAbility("fanna_chain_buddies")
			caster:SwapAbilities("fanna_chain_buddies","fanna_chain_buddies_2nd",true,false)
			local ability = caster:FindAbilityByName("fanna_chain_buddies")
			ability:SetLevel(abilitylevel)
			caster:RemoveAbility("fanna_chain_buddies_2nd")
		end
	end)

end

function ThrowChains(keys)
	local caster = keys.caster

	--Swapping the abilities
	local ability2 = caster:FindAbilityByName("fanna_chain_buddies_2nd")
	local abilitylevel = ability2:GetLevel()
	caster:AddAbility("fanna_chain_buddies")
	caster:SwapAbilities("fanna_chain_buddies","fanna_chain_buddies_2nd",true,false)
	local ability = caster:FindAbilityByName("fanna_chain_buddies")
	ability:SetLevel(abilitylevel)
	caster:RemoveAbility("fanna_chain_buddies_2nd")

	
	local target = caster.target
	caster.target2 = keys.target
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed",ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel() -1)
	local extended_chain_length = ability:GetLevelSpecialValueFor("extended_chain_length",ability:GetLevel() -1)

	--Get the remaining duration on the chains
	local duration = caster:FindModifierByName("modifier_chain_buddies_chained"):GetDuration()


	-- Destroy the old particle effects
	ParticleManager:DestroyParticle(caster.chain,true)
	caster.target:RemoveModifierByName("modifier_chain_buddies_chained")
	caster:RemoveModifierByName("modifier_chain_buddies_chained")

	if caster.target2:GetName() == "" then
		--print("tree")
		--local tree = GetEntityIndexForTreeId(caster.target2:entindex())
		--caster.target2 = EntIndexToHScript(tree)
	else
	
	--Throw the projectile at the second target
		local info2 =  
		{
			Target = caster.target2,
			Source = caster,
			Ability = ability,
			EffectName = "particlecles/fanna/chain_buddies_projectile.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = projectile_speed,
		    iVisionRadius = 0,
		    iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}
		local projectile2 = ProjectileManager:CreateTrackingProjectile(info2)
	end
	
	
	-- Store the new distance
	caster.chainlength = (target:GetAbsOrigin()-caster.target2:GetAbsOrigin()):Length2D() + extended_chain_length
	
	--Check if the target is a tree, a tree has an empty name
	if caster.target2:GetName() ~= "" then
		--Applying the particles
		caster.chain = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(caster.chain, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(caster.chain, 1, caster.target2, PATTACH_POINT, "attach_hitloc", caster.target2:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(caster.chain, 2, Vector(duration,0,0))
        ability:ApplyDataDrivenModifier(caster, target, "modifier_chain_buddies_chained", {duration = duration})
        ability:ApplyDataDrivenModifier(caster, caster.target2, "modifier_chain_buddies_chained", {duration = duration})
        
		if caster.target2:GetTeamNumber() ~= caster:GetTeamNumber() then

			local damageTable = 
			{
				victim = caster.target2,
				attacker = caster,
				damage = ability:GetAbilityDamage(),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability,
			}
			ApplyDamage(damageTable)
		end
	else -- The target was a tree
		caster.chain = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(caster.chain, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(caster.chain, 1, caster.target2:GetAbsOrigin() + Vector(0,0,128))
        ParticleManager:SetParticleControl(caster.chain, 2, Vector(duration,0,0))
        ability:ApplyDataDrivenModifier(caster, target, "modifier_chain_buddies_chained", {duration = duration})
        --caster.treelocation = caster.target2:GetAbsOrigin()
	end
	
end
 
function CheckChains (keys)
	local ability = keys.ability
	local caster = keys.caster
	if (caster.target:IsAlive() and (caster.target2:IsAlive()) or (caster.target:IsAlive() and caster.target2:IsStanding())) then
		if (caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Length2D() > caster.chainlength + 250 and not caster:HasModifier("modifier_silent_headroll_channeling") then
			ParticleManager:DestroyParticle(caster.chain,true)
			caster.target:RemoveModifierByName("modifier_chain_buddies_chained")
			caster.target2:RemoveModifierByName("modifier_chain_buddies_chained")
		elseif (caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Length2D() > caster.chainlength then
			local direction = (caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Normalized()
			if caster.target2:GetName() ~= "" and caster.target2:GetName() ~= "npc_dota_dagger_unit" then -- So it's not a tree nor the dagger
				caster.target:SetAbsOrigin(caster.target:GetAbsOrigin() - direction * (((caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Length2D()-caster.chainlength)/2))
				caster.target2:SetAbsOrigin(caster.target2:GetAbsOrigin() + direction * (((caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Length2D()-caster.chainlength)/2))
			else
				caster.target:SetAbsOrigin(caster.target:GetAbsOrigin() - direction * (((caster.target:GetAbsOrigin() - caster.target2:GetAbsOrigin()):Length2D()-caster.chainlength))) 
			end
		end
	else
		ParticleManager:DestroyParticle(caster.chain,true)
		caster.target:RemoveModifierByName("modifier_chain_buddies_chained")
		caster.target2:RemoveModifierByName("modifier_chain_buddies_chained")
	end
end



