function SwapTeam(keys)

	local caster = keys.caster
	local target = keys.target
	print(target:GetTeamNumber())
	GameRules:SetCustomGameTeamMaxPlayers(GameRules:GetCustomGameTeamMaxPlayers(target:GetTeamNumber()) +1,target:GetTeamNumber())


	if target:GetTeamNumber() == caster:GetTeamNumber() then
		ProjectileManager:ProjectileDodge(target)
	end

	if target:GetTeamNumber() == 2 then
		target:SetTeam(3)
	elseif target:GetTeamNumber() == 3 then
		target:SetTeam(2)
	end
end

function SwapBack(keys)

	local caster = keys.caster
	local target = keys.target
	print(target:GetTeamNumber())
	



	if target:GetTeamNumber() == 2 then
		target:SetTeam(3)
	elseif target:GetTeamNumber() == 3 then
		target:SetTeam(2)
	end

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		ProjectileManager:ProjectileDodge(target)
	end
	GameRules:SetCustomGameTeamMaxPlayers(GameRules:GetCustomGameTeamMaxPlayers(target:GetTeamNumber()) -1,target:GetTeamNumber())
end
