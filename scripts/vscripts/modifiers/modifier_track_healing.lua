if modifier_track_healing == nil
	then modifier_track_healing = class({})
end
modifier_track_healing = class({})
function modifier_track_healing:DeclareFunctions()
	local funcs =
	{ 
	MODIFIER_EVENT_ON_HEALTH_GAINED
	}
	return funcs
end

function modifier_track_healing:GetAttributes() 
    return 
    {
    MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE,
    MODIFIER_ATTRIBUTE_PERMANENT
	}
end

function modifier_track_healing:IsHidden()
    return true
end

function modifier_track_healing:OnHealthGained( keys )
	if IsServer() then
		local unit = self:GetParent()
		local currTime = GameRules:GetGameTime()
		unit.healedHP =  unit:GetHealth() - unit.currenthp[(math.floor((currTime -0.04) * 25)/25)]
		--print(keys.process_procs)
		if keys.process_procs == true and unit.healedHP > 1 then
			for pID, hero in pairs(GameRules.Heroes) do
				if not hero:IsNull() then
					if hero:IsRealHero() then
					    Timers:CreateTimer(0.04,
					    function()
					    	local currTime = GameRules:GetGameTime()
							if hero.hphealed[(math.floor((currTime -0.04) * 25)/25)] ~= hero.hphealed[(math.floor((currTime) * 25)/25)] and unit.boostedHeal == false then -- Prevent the heal from triggering itself
								unit.boostedHeal = true
								GameMode:OnUnitHealed(hero,unit,unit.healedHP)
							end
						end)
					unit.boostedHeal = false					
					end
				end
			end
		end
	end
end
