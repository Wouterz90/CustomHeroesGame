function SliceandDice (keys)
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("range",ability:GetLevel() -1)
	local casterloc = caster:GetAbsOrigin()
	local difference = (casterloc - target_point):Length2D()
	slice_and_dice_direction = (target_point - casterloc):Normalized() 
	--ProjectileManager:ProjectileDodge(caster)
	if difference > range then
		target_point = casterloc + (slice_and_dice_direction * range)
	end
	slice_and_dice_traveled = 0
	slice_and_dice_dash_speed = (caster:GetAbsOrigin() - target_point):Length2D() * 0.03
	
		
end
function Dash (keys)
	local caster = keys.caster
	
	if slice_and_dice_traveled < (slice_and_dice_dash_speed * 33) then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + slice_and_dice_direction * slice_and_dice_dash_speed)
		slice_and_dice_traveled = slice_and_dice_traveled + slice_and_dice_dash_speed
	end
end

function DealDamage (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ms_damage = ability:GetLevelSpecialValueFor("ms_damage", ability:GetLevel() -1) / 100
	local movespeed = caster:GetIdealSpeed()

	local DamageTable = 
	{
		victim = target,
		attacker = caster,
		damage = ms_damage * movespeed,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}	
	ApplyDamage(DamageTable)
end