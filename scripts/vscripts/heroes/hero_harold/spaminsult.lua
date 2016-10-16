function SpamInsult(keys)

	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local base_duration = ability:GetLevelSpecialValueFor("base_duration",ability:GetLevel()-1) -- 2 2.5 3 3.5?

	ability:ApplyDataDrivenModifier(caster,target,"modifier_spam_insult",{duration = base_duration})
end

function PushOver (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local push_distance = ability:GetLevelSpecialValueFor("push_distance",ability:GetLevel()-1)
	target:SetAbsOrigin(target:GetAbsOrigin() + ((caster:GetForwardVector() *-1) * push_distance))
end