TrackReceivedHealing = class({})
function TrackReceivedHealing (keys)
	local unit = self:GetCaster()
	local currTime = GameRules:GetGameTime()
	local healedHP =  unit:GetHealth() - unit.currenthp[(math.floor((currTime -0.04) * 25)/25)]
	--if healedHP > 4 then
	DeepPrintTable(keys)
	if keys.process_procs then
		print("procs")
		for pID, hero in pairs(GameRules.Heroes) do
			if not hero:IsNull() then
				if hero:IsRealHero() then
				    Timers:CreateTimer(0.04,
				    function()
				    	local currTime = GameRules:GetGameTime()
						if hero.hphealed[(math.floor((currTime -0.04) * 25)/25)] ~= hero.hphealed[(math.floor((currTime) * 25)/25)] and unit.boostedHeal == false then
							ExtendedHeal(hero,unit,healedHP)
						end
					end)					
				end
			end
		end
	end
end
