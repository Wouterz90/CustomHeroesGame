	
		local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	



	target_damage = GetAgility(caster) + GetIntellect(caster)
	print(target_damage)
	local damageTable = 
	{
	victim = target,
	attacker = caster,
	damage = target_damage,
	damage_type = DAMAGE_TYPE_MAGICAL,
	}

ApplyDamage(DamageTable)