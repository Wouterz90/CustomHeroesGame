function CancelAttack (keys) -- Make sure the caster doesnt attack enemies, but still can attack allies to heal them
	local caster = keys.caster
	local attacker = keys.target

	if caster:GetTeamNumber() ~= attacker:GetTeamNumber() then
		caster:Stop()
	end
end

function ThrowHammer (keys)
	local caster = keys.caster
	local ability = keys.ability

	-- Remove the hammer
	CosmeticLib:RemoveFromSlot( caster, "weapon" )
	caster.HasHammer = false

	caster.hammer_point = keys.target_points[1]

	if caster.utherhammer == nil or caster.utherhammer:IsNull() then -- Check if the hammer is on a location or in the casters hands -- caster.HasHammer was added later :/
		caster.utherhammer = CreateUnitByName("npc_hammer_unit",caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		ability:ApplyDataDrivenModifier(caster,caster.utherhammer,"modifier_hammer_moving_dummy",{duration = 1})
		ability:ApplyDataDrivenModifier(caster,caster.utherhammer,"modifier_hammer_dummy",{duration = -1})
		caster.utherdirection = (caster.hammer_point - caster:GetAbsOrigin()):Normalized()
	else
		ability:ApplyDataDrivenModifier(caster,caster.utherhammer,"modifier_hammer_moving_dummy",{duration = 1})
		caster.utherdirection = (caster.hammer_point - caster.utherhammer:GetAbsOrigin() ):Normalized()
		caster:RemoveModifierByName("modifier_hammer_stationary_dummy")
	end
	local hammer_speed = (caster.hammer_point - caster.utherhammer:GetAbsOrigin()):Length2D() * 0.1
	local hammer_size = ability:GetLevelSpecialValueFor("Hammer_Size",ability:GetLevel()-1)

	local projectileTable =
			{
			EffectName = "",
			Ability = ability,
			vSpawnOrigin = caster.utherhammer:GetAbsOrigin(),
			vVelocity = (hammer_speed * 10) * caster.utherdirection,
			fDistance = hammer_speed * 10,
			fStartRadius = hammer_size,
			fEndRadius = hammer_size,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = true,
			bProvidesVision = true,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iVisionRadius = hammer_size,
			iVisionTeamNumber = caster:GetTeamNumber()
			}
	local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

	--Cooldown on subability to prevent bugs
	caster:FindAbilityByName("Hail_Back"):StartCooldown(1)
end

function HammerPosition (keys) -- Guide the hammer to the right location, speed is reliant on distance.
	local ability = keys.ability
	local caster = keys.caster
	local hammer_speed = (caster.hammer_point - caster.utherhammer:GetAbsOrigin()):Length2D() * 0.1
	local hammer_size = ability:GetLevelSpecialValueFor("Hammer_Size",ability:GetLevel()-1)

	caster.utherhammer:SetAbsOrigin(caster.utherhammer:GetAbsOrigin() + caster.utherdirection * hammer_speed)
end



function PickUpHammer (keys) -- Check if the caster is very close to his hammer and then pick it up
	local caster = keys.caster
	if (caster:GetAbsOrigin() - caster.utherhammer:GetAbsOrigin()):Length2D() < 200 then
		caster:RemoveModifierByName("modifier_hammer_thrown")
		caster:RemoveModifierByName("modifier_hammer_stationary_dummy")
		caster.utherhammer:RemoveSelf()
		caster.HasHammer = true -- Take the hammer back and show it
		if caster:HasModifier("modifier_argent_smite_passive") then
			CosmeticLib:ReplaceWithSlotName( caster, "weapon", 7580 )
		else
			CosmeticLib:ReplaceWithSlotName( caster, "weapon", 4246 )
		end
	end
end
function RemoveHammer (keys) -- Clean up on death
	if not caster.utherhammer:IsNull() then
		caster.utherhammer:RemoveSelf()
	end
end

function ReturnHammer (keys) -- The hammer returning to uther, damaging units in its path.
	local caster = keys.caster
	if caster.utherhammer ~= nil and not caster.utherhammer:IsNull() then
		
		local ability = caster:FindAbilityByName("Hurl_Hammer")
		local hammer_speed = (caster:GetAbsOrigin() - caster.utherhammer:GetAbsOrigin()):Length2D() * 0.1
		local direction = (caster:GetAbsOrigin() - caster.utherhammer:GetAbsOrigin()):Normalized()
		local hammer_size = ability:GetLevelSpecialValueFor("Hammer_Size",ability:GetLevel()-1)

		

		local projectileTable =
				{
				EffectName = "",
				Ability = ability,
				vSpawnOrigin = caster.utherhammer:GetAbsOrigin(),
				vVelocity = (hammer_speed * 10) * direction,
				fDistance = hammer_speed * 10,
				fStartRadius = hammer_size,
				fEndRadius = hammer_size,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = true,
				bProvidesVision = true,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iVisionRadius = hammer_size,
				iVisionTeamNumber = caster:GetTeamNumber()
				}
		local projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

		Timers:CreateTimer(function()
			if caster:HasModifier("modifier_hammer_stationary_dummy") and not caster.utherhammer:IsNull() then
				local direction = (caster:GetAbsOrigin() - caster.utherhammer:GetAbsOrigin()):Normalized()
				caster.utherhammer:SetAbsOrigin(caster.utherhammer:GetAbsOrigin() + direction * hammer_speed)
				return 0.1
			end
			
			return nil
		end)

	end
end

function LearnHurlBack(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("Hail_Back")
	if ability:GetLevel() == 0 then
		ability:SetLevel(1)
	end
end
	