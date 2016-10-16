--[[ ============================================================================================================
	Author: Rook
	Date: March 02, 2015
	Called when Betrayal is cast.  Moves the target unit to another (custom) team for the duration.
================================================================================================================= ]]
function Disconnected(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target_pid = keys.target:GetPlayerID()
	local target_player = PlayerResource:GetPlayer(target_pid)
	local duration = ability:GetDuration()

	local targets = FindUnitsInRadius(	caster:GetTeam(),
									  	caster:GetAbsOrigin(),
									  	nil,
									  	FIND_UNITS_EVERYWHERE, 
									  	DOTA_UNIT_TARGET_TEAM_ENEMY, 
									  	DOTA_UNIT_TARGET_ALL, 
									  	DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
									  	0, 
									  	false)
																		
	for _,unit in pairs(targets) do 
		if unit:GetUnitName() == "dota_fountain" or unit:IsTower() then
			ability:ApplyDataDrivenModifier(caster, unit, "protect", {duration = -1})
		end
	end

	GameRules:SetCustomGameTeamMaxPlayers(6, 1)
    GameRules:SetCustomGameTeamMaxPlayers(7, 1)
    GameRules:SetCustomGameTeamMaxPlayers(8, 1)
    GameRules:SetCustomGameTeamMaxPlayers(9, 1)
    GameRules:SetCustomGameTeamMaxPlayers(10, 1)
    GameRules:SetCustomGameTeamMaxPlayers(11, 1)
    GameRules:SetCustomGameTeamMaxPlayers(12, 1)

	
		--Custom teams are DOTA_TEAM_CUSTOM_1 through DOTA_TEAM_CUSTOM_8, which correspond with ints 6-13, inclusive.
		local found_new_team = false
		for i=6, 13, 1 do
			if found_new_team == false then
				if PlayerResource:GetNthPlayerIDOnTeam(i, 1) == -1 then  --If there are currently no players on this custom team.
					
					--Store the target's original team number, so they can be moved back to that team when Betrayal ends.
					target_player.disconnected_original_team = keys.target:GetTeam()
				
					PlayerResource:SetCustomTeamAssignment(target_pid, i)
					keys.target:SetTeam(i)
					
					--Set up health labels for every hero now that a unit has Betrayal on them.
					local herolist = HeroList:GetAllHeroes()
					if herolist ~= nil then
						for i, individual_hero in ipairs(herolist) do
							if IsValidEntity(individual_hero) then
								local pid = individual_hero:GetPlayerID()
								if pid ~= nil and PlayerResource:IsValidPlayerID(pid) and PlayerResource:IsValidPlayer(pid) then
									local individual_player = PlayerResource:GetPlayer(pid)
								end
							end
						end
					end

					found_new_team = true
				end
			end
		
		if found_new_team == false then  --If all the custom teams had at least one unit currently in them (unlikely, but possible), notify the player and restore Betrayal's mana cost and cooldown.
			keys.ability:RefundManaCost()
			keys.ability:EndCooldown()
			EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", keys.caster:GetPlayerOwner())
			
			--This makes use of the Custom Error Flash module by zedor. https://github.com/zedor/CustomError
			FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Too Many Units Affected By Betrayal (Technical Limitation)" } )
		end
	end
	
end


--[[ ============================================================================================================
	Author: Rook
	Date: March 02, 2015
	Called when Betrayal's modifier expires.  Moves the unit back to their original team.
================================================================================================================= ]]
function Destroy_Disconnected_Modifier(keys)
	--Remove health labels if no heroes have Betrayal on them anymore.
	local someone_has_betrayal = false
	local herolist = HeroList:GetAllHeroes()
	if herolist ~= nil then
		for i, individual_hero in ipairs(herolist) do
			if individual_hero ~= nil and IsValidEntity(individual_hero) and individual_hero:HasModifier("Disconnected") then
				someone_has_betrayal = true
			end
		end

		if not someone_has_betrayal then
			for i, individual_hero in ipairs(herolist) do
			end
		end
	end
	
	--Move the player back to their original team.
	local target_pid = keys.target:GetPlayerID()
	if target_pid ~= nil and PlayerResource:IsValidPlayerID(target_pid) and PlayerResource:IsValidPlayer(target_pid) then
		local target_player = PlayerResource:GetPlayer(target_pid)
		local target_current_team = keys.target:GetTeam()

		if target_player ~= nil and target_player.disconnected_original_team ~= nil and target_current_team ~= "DOTA_TEAM_GOODGUYS" and target_current_team ~= "DOTA_TEAM_BADGUYS" then  --If the disconnected_original_team was not stored, we're in trouble.
			PlayerResource:SetCustomTeamAssignment(target_pid, target_player.disconnected_original_team)
			keys.target:SetTeam(target_player.disconnected_original_team)
			target_player.disconnected_original_team = nil
		end
	end
end

function OnDamageReceived (keys)
	local attacker = keys.attacker
	local unit = keys.unit
	local caster = keys.caster
	local ability = keys.ability
	local DamageTaken = keys.DamageTaken
	if unit.disconnected_original_team == attacker.disconnected_original_team then
		if unit:GetHealth() < 1 then
			unit:RemoveModifierByName("Disconnected")
			unit:SetHealth(DamageTaken + 1)
			unit:Kill(ability, caster)
		end
	end
end

function protect_victims (keys)
	local attacker = keys.attacker
	local target = keys.target

	if target:HasModifier("Disconnected") and attacker:HasModifier("protect") then
		print(attacker:GetUnitName())
		attacker:Stop()
	end
end