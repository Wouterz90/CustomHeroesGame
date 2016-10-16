function LevelUpSpell (keys)

	local caster = keys.caster
	local ability = keys.ability
	local ExchangeHeal = caster:FindAbilityByName("mikhail_exchange_pieces_hurt")

	if not ExchangeHeal:GetLevel() == nil or ability:GetLevel() ~= ExchangeHeal:GetLevel() then
		ExchangeHeal:SetLevel(ability:GetLevel())
	end
end

function ExchangePiecesHealBoth(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local exchangeother = caster:FindAbilityByName("mikhail_exchange_pieces_hurt")
	local heal = ability:GetLevelSpecialValueFor("heal",ability:GetLevel() -1) / 100
	exchangeother:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
	target:Heal(target:GetMaxHealth() * heal ,caster)
	caster:Heal(caster:GetMaxHealth() * heal ,caster)
end

function ExchangePiecesHurtBoth(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local exchangeother = caster:FindAbilityByName("mikhail_exchange_pieces_heal")

	local damage = ability:GetLevelSpecialValueFor("damage",ability:GetLevel() -1) / 100
	exchangeother:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
	local DamageTable = 
	{
		attacker = caster,
		damage_type = DAMAGE_TYPE_PURE,
		damage = caster:GetHealth() * damage,
		victim = caster
	}
	ApplyDamage(DamageTable)

	local DamageTable = 
	{
		attacker = caster,
		damage_type = DAMAGE_TYPE_PURE,
		damage = target:GetHealth() * damage,
		victim = target
	}
	ApplyDamage(DamageTable)
end

		





