function heal (keys)

	local caster = keys.caster
	local ability = keys.ability
	local interval = ability:GetSpecialValueFor("Interval")
	local healvalue = ability:GetSpecialValueFor("Heal") *interval
	

	maxhp = caster:GetMaxHealth()
	currenthp = caster:GetHealth()
	caster:Heal((maxhp*healvalue*interval), caster)
end