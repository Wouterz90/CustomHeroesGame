function KillYourself(keys)
local caster = keys.caster
local target = keys.target
local ability = keys.ability

local birds = {}

local units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, 99999,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	for _,unit in pairs(units) do
		if unit:GetUnitName() == "npc_dota_birdie" then

			for i=1,10 do
				if birds[i] == nil then
					birds[i] = unit
					break
				end
			end
		end
	end
	if #birds > 0 and caster:IsHero() then
		local casterloc = caster:GetAbsOrigin()
		local birdloc  = birds[1]:GetAbsOrigin()
		caster:SetAbsOrigin(birdloc)
		birds[1]:SetAbsOrigin(casterloc)
		--FindClearSpaceForUnit(birds[1],casterloc,true)
		--FindClearSpaceForUnit(caster,birdloc,true)
		
		caster:SetHealth(birds[1]:GetHealth())
		--ability:ApplyDataDrivenModifier(caster,birds[1],"modifier_tag_exploding",{})
		ability:ApplyDataDrivenModifier(caster,birds[1],"modifier_tag_exploded",{})
		local DamageTable = 
		{
			attacker = caster,
			damage_type = DAMAGE_TYPE_PURE,
			damage = 9999,
			victim = birds[1]
		}
		ApplyDamage(DamageTable)
	else
		ability:ApplyDataDrivenModifier(caster,birds[1],"modifier_tag_exploded",{})
		local DamageTable = 
		{
			attacker = caster,
			damage_type = DAMAGE_TYPE_PURE,
			damage = 9999,
			victim = caster
		}
		ApplyDamage(DamageTable)
		
	end
	

	
end
function MarkTime(keys)
	local ability = keys.ability
	ability.StartTime = GameRules:GetGameTime()
end

function CountDown (keys)
	local caster = keys.caster
	local ability = keys.ability
	local locked_duration = ability:GetLevelSpecialValueFor( "locked_duration", ability:GetLevel() - 1 )
	local allHeroes = HeroList:GetAllHeroes()
	local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
	local preSymbol = 0 -- Empty
	local digits = 2 -- "5.0" takes 2 digits
	local number = GameRules:GetGameTime() - ability.StartTime - locked_duration - 0.1 --the minus .1 is needed because think interval

	local integer = math.floor(math.abs(number))
	local decimal = math.abs(number) % 1

	if decimal < 0.5 then 
		decimal = 1 -- ".0"
	else 
		decimal = 8 -- ".5"
	end

	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			-- Don't display the 0.0 message
			if integer == 0 and decimal == 1 then
				
			else
				local particle = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_OVERHEAD_FOLLOW, caster, PlayerResource:GetPlayer( v:GetPlayerID() ) )
				
				ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle, 1, Vector( preSymbol, integer, decimal) )
				ParticleManager:SetParticleControl( particle, 2, Vector( digits, 0, 0) )
			end
		end
	end

end