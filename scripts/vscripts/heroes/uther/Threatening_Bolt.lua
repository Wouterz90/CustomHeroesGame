function Launch_Bolt (keys) -- KV OnSpellStart
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]
	local duration = ability:GetDuration()
	local attacksneeded = ability:GetLevelSpecialValueFor("attacks_needed",ability:GetLevel() -1)
	
	local caster_loc = caster:GetAbsOrigin()
	utherbolts = {}

	for i=1,100 do --Allow for up to 100 utherbolts to be used, creating them below
		if utherbolts[i] == nil or utherbolts[i]:IsNull() then
				local bolt_direction = (target_point - caster_loc):Normalized()
				utherbolts[i] = CreateUnitByName("npc_bolt_unit",caster_loc, true, caster, caster, caster:GetTeamNumber())
				utherbolts[i]:SetControllableByPlayer(caster:GetPlayerID(), false)
				utherbolts[i]:SetForwardVector(bolt_direction)
				ability:ApplyDataDrivenModifier(caster,utherbolts[i],"modifier_bolt_dummy",{duration = duration})
				utherbolts[i]:SetHealth(attacksneeded)
				break
		end 
	end 
	
end

function Direct_Bolt (keys) -- KV OnIntervalThink
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local target_location = target:GetAbsOrigin()
	local bolt_speed = ability:GetLevelSpecialValueFor("bolt_speed",ability:GetLevel()-1) * 0.1
	local hammersize = caster:FindAbilityByName("Hurl_Hammer"):GetSpecialValueFor("Hammer_Size")

	-- Get the direction so we can push it forward in this direction. The user can turn the unit.

	local bolt_direction = target:GetForwardVector()
	--[[ I dont think this is still relevant
	if target.bolt_direction == nil then
		target.bolt_direction = bolt_direction
	end
	]]


	target:SetAbsOrigin(target_location + bolt_direction * bolt_speed)
	
	local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_NEUTRALS + DOTA_TEAM_GOODGUYS, target:GetAbsOrigin(), nil, hammersize, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do
		if unit:GetUnitName() == "npc_hammer_unit" then
			target:RemoveModifierByName("modifier_bolt_dummy")
		end
	end
end

function LoseHP (keys) -- KV OnAttacked
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local target = keys.target
	target.attacksneeded = target:GetHealth()

	--If uther himself attacks then destroy else remove 1 hp

	if caster:GetTeamNumber() == attacker:GetTeamNumber() then	
		target:RemoveModifierByName("modifier_bolt_dummy")
	elseif caster:GetTeamNumber() ~= attacker:GetTeamNumber() then
		target.attacksneeded = target.attacksneeded - 1
		target:SetHealth(target.attacksneeded)
		if target.attacksneeded == 0 then
			target:RemoveModifierByName("modifier_bolt_dummy")
		end
	end
end


function destroy (keys) -- KV OnDestroy
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local explosionRadius = ability:GetSpecialValueFor("explosion_radius")

	--Damage every unit around

	local targets =  FindUnitsInRadius(DOTA_TEAM_BADGUYS, target:GetAbsOrigin(), nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do
		local DamageTable =
		{
			victim = unit,
			attacker = caster,
			damage = ability:GetLevelSpecialValueFor("damage",ability:GetLevel()-1),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(DamageTable)
	end
	--Reset values
	target.attacksneeded = nil
	bolt_direction = nil
	
	--Explosing effect
	local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf",PATTACH_ABSORIGIN,caster)
	ParticleManager:SetParticleControl(effect,0,target:GetAbsOrigin())
	-- Remove the unit from the game
	target:RemoveSelf()
end