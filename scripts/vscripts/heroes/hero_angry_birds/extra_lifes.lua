LinkLuaModifier("modifier_bird_clone","heroes/hero_angry_birds/modifiers/modifier_bird_clone.lua",LUA_MODIFIER_MOTION_NONE)

function CreateBird (keys)

	local caster = keys.caster
	local ability = keys.ability
	local max_units = ability:GetLevelSpecialValueFor("Max_Units",ability:GetLevel() -1) 
	local strength_factor = ability:GetLevelSpecialValueFor("strength_factor",ability:GetLevel() -1)
	local pID = caster:GetPlayerOwnerID()
	local birds = {}
	local units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, 99999,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--DeepPrintTable(units)

	for _,unit in pairs(units) do
		if unit:GetUnitName() == "npc_dota_birdie" then

			for ability_id = 0, 15 do
				local ability = unit:GetAbilityByIndex(ability_id)
				if ability then
					if ability:GetAbilityName() == "angry_birds_extra_lifes" then
					else
						if ability:GetLevel() ~= caster:GetAbilityByIndex(ability_id):GetLevel() then	
							ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
						end

					end
				end
			end
			--unit:SetMaxHealth( 180 + (caster:GetStrength()*19))
			unit:SetBaseDamageMin(caster:GetBaseDamageMin()*strength_factor)
			unit:SetBaseDamageMax(caster:GetBaseDamageMax()*strength_factor)
			unit:SetBaseMoveSpeed(caster:GetIdealSpeed())
			

			for i=1,10 do
				if birds[i] == nil then
					--print(i)
					birds[i] = unit
					break
				end
			end
		end
	end
	--print(#birds)
	local ability = keys.ability


	if #birds < max_units and ability:IsCooldownReady() then
		local birdie = CreateUnitByName("npc_dota_birdie",caster:GetAbsOrigin(),true,caster,caster, caster:GetTeamNumber())
		birdie:SetControllableByPlayer(pID,false)
		birdie:SetTeam(caster:GetTeamNumber())
		birdie:SetOwner(caster)
		birdie:AddNewModifier(caster,ability,"modifier_bird_clone",{})
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
		--birdie:SetMaxHealth( 180 + (caster:GetStrength()*19))
		birdie:SetBaseDamageMin(caster:GetBaseDamageMin()*strength_factor)
		birdie:SetBaseDamageMax(caster:GetBaseDamageMax()*strength_factor)
		birdie:SetBaseMoveSpeed(caster:GetIdealSpeed())
		birdie:SetTeam(caster:GetTeamNumber())
		--birdie:SetHealth(birdie:GetMaxHealth()*strength_factor)
		--birdie:SetMana(birdie:GetMaxMana())
	end
	for i=1,10 do
		birds[i] = nil
	end
end

function KillBirds(keys)
	local caster = keys.caster
	local units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, 99999,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		if unit:GetUnitName() == "npc_dota_birdie" then
			unit:RemoveSelf()
		end

	end
end

		