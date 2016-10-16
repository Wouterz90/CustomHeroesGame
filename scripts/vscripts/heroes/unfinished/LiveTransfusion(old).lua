function LiveTransfusionRoll (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[ 1 ]
	local casterLoc = caster:GetAbsOrigin()
	local speed = ability:GetLevelSpecialValueFor("transfusion_speed", ability:GetLevel() - 1 )
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability:GetLevel() - 1 )
	local hp_per_distance = ability:GetLevelSpecialValueFor("hp_cost", ability:GetLevel() - 1 )
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability:GetLevel() - 1 )
	local effect_radius = ability:GetLevelSpecialValueFor("effect_radius", ability:GetLevel() - 1 )
	local max_range = ability:GetLevelSpecialValueFor("transfusion_range", ability:GetLevel() - 1 )
	local currentPos = casterLoc
	local forwardVec = ( target - casterLoc ):Normalized()  
	local min_hp = max_range * hp_per_distance
	local intervals_per_second = speed / 100
	local particle_dummy = "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf"
	local modifierName = "modifier_Live_Transfusion_buff_datadriven"
	local playerID = caster:GetPlayerOwnerID()

	caster.LiveTransfusion_start_pos = casterLoc

	


	local distance = 0.0
	
	if caster:GetHealth() > min_hp then
		local projectileTable =
		{
			EffectName = particle_dummy,
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			vVelocity = speed * forwardVec,
			fDistance = max_range,
			fStartRadius = damage_radius,
			fEndRadius = damage_radius,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = true,
			bProvidesVision = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iVisionRadius = vision_radius,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

		-- Traverse
		Timers:CreateTimer( function()
			-- Spending health
			distance = distance + speed / intervals_per_second
			if distance >= hp_per_distance then
				-- Check if there is enough mana to cast
				local hp_to_spend = hp_per_distance
				local hp = caster:GetHealth()
				if caster:GetHealth() >= (hp_to_spend *100) then
					caster:SetHealth(hp - (hp_to_spend * 100))
				else
					-- Exit condition
					caster:RemoveModifierByName( modifierName )

					return nil
				end
				distance = distance - hp_per_distance
			end
			caster:CastAbilityOnPosition(keys.target_points[ 1 ], Blood_trail, playerID)	
			-- Update location
			currentPos = currentPos + forwardVec * ( speed / intervals_per_second )

			-- caster:SetAbsOrigin( currentPos ) -- This doesn't work because unit will not stick to the ground but rather travel in linear
			FindClearSpaceForUnit( caster, currentPos, false )
				
			-- Check if unit is close to the destination point
			if ( target - currentPos ):Length2D() <= speed / intervals_per_second then
				-- Exit condition
				caster:RemoveModifierByName( modifierName )
				caster:RemoveModifierByName( modifierDestroyTreesName )

				return nil
			else
				return 1 / intervals_per_second
			end
		end
		)
		
	else
		keys.ability:RefundManaCost()
		ability:EndCooldown()	
	end		
end

function LiveTransfusion_damage( keys )
	-- Variables
	local targetLoc = keys.target:GetAbsOrigin()
	local casterLoc = keys.caster.LiveTransfusion_start_pos
	local ability = keys.ability
	local real_damage = ability:GetAbilityDamage()
	local damageType = ability:GetAbilityDamageType()
	
	-- Calculate and damage the unit
	local damageTable = 
	{
		victim = keys.target,
		attacker = keys.caster,
		damage = real_damage,
		damage_type = damageType
	}
	ApplyDamage( damageTable )
end


function Blood_Trail( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[ 1 ]
	local casterLoc = caster:GetAbsOrigin()
	local speed = ability:GetLevelSpecialValueFor("transfusion_speed", ability:GetLevel() - 1 )
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability:GetLevel() - 1 )
	local hp_per_distance = ability:GetLevelSpecialValueFor("hp_cost", ability:GetLevel() - 1 )
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability:GetLevel() - 1 )
	local effect_radius = ability:GetLevelSpecialValueFor("effect_radius", ability:GetLevel() - 1 )
	local max_range = ability:GetLevelSpecialValueFor("transfusion_range", ability:GetLevel() - 1 )
	local currentPos = casterLoc
	local duration = ability:GetDuration()
	local forwardVec = ( target - casterLoc ):Normalized()  
	local min_hp = max_range * hp_per_distance
	local intervals_per_second = speed / 100
	local particle_dummy = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf"
	local pathLength = forwardVec
		  ExpTime = GameRules:GetGameTime() + duration
			bloodtrail_startPos = casterLoc
			bloodtrail_endPos = currentPos
	print("HELLO")


	-- Create particle effect
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, casterLoc )
	ParticleManager:SetParticleControl( pfx, 1, target )
	ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx, 3, casterLoc )

	effect_radius = math.max( effect_radius, 64 )
	local projectileRadius = effect_radius * math.sqrt(2)
	local numProjectiles = math.floor( (forwardVec:Length2D()) / (effect_radius*2) ) + 1
	local stepLength = forwardVec / ( numProjectiles - 1 )

	for i=1, numProjectiles do
		local projectilePos = startPos + caster:GetForwardVector() * (i-1) * stepLength
		
		if caster:GetHealth() > min_hp then
			local projectileTable =
			{
				EffectName = "particle_dummy",
				Ability = ability,
				vSpawnOrigin = caster:GetAbsOrigin() + caster:GetForwardVector(),
				vVelocity	= Vector( 0, 0, 0 ),
				fDistance = max_range,
				fStartRadius = effect_radius,
				fEndRadius = effect_radius,
				fExpireTime = ExpTime,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iVisionRadius = vision_radius,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
		else
		end
	end
end



function ApplyDummyModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = keys.modifier_name

	local duration = ExpTime - GameRules:GetGameTime()

	ability:ApplyDataDrivenModifier( caster, target, modifierName, { duration = duration } )
end

function Trail_Buff( event )
	local caster		= event.caster
	local target		= event.target
	local ability		= event.ability
	local pathRadius	= event.effect_radius

	local targetPos = target:GetAbsOrigin()
	targetPos.z = 0

	local distance = DistancePointSegment( targetPos, ability.bloodtrail_startPos, ability.bloodtrail_endPos )
	if distance < pathRadius then
		if target:IsOpposingTeam(caster:GetTeam()) then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_Live_Transfusion_Trail_Allies", {})
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_Live_Transfusion_Trail_Enemies", {})
		end
	end
end