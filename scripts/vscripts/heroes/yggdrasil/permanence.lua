function IncreaseDuration (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration_increase = ability:GetLevelSpecialValueFor("duration_increase",ability:GetLevel() -1)

	local modifiers = target:FindAllModifiers()
	for k,mod in pairs(modifiers) do
		if mod:GetCaster() == caster then
			if caster:GetTeamNumber() ~= target:GetTeamNumber() and IsDebuff(mod) --[[and not IsHidden(mod)]] then
				mod:SetDuration(mod:GetRemainingTime() + duration_increase ,true)
			elseif caster:GetTeamNumber() == target:GetTeamNumber() and IsBuff(mod) and not IsPassive(mod) --[[and not IsHidden(mod)]] then
				mod:SetDuration(mod:GetRemainingTime() + duration_increase ,true)
			end
		end
	end
end

	