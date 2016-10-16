LinkLuaModifier("momentum_break_limit", "heroes/eurus/modifiers/momentum_break_limit.lua", LUA_MODIFIER_MOTION_NONE )


function Momentum (keys)
	local caster = keys.caster
	local casterloc = caster:GetAbsOrigin()
	local ability = keys.ability
	local ondistancemoved = ability:GetLevelSpecialValueFor("ondistancemoved", ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
	local modifier = caster:FindModifierByName("momentum_charges")
	local currTime = GameRules:GetGameTime()


    caster:AddNewModifier(caster, ability, "momentum_break_limit", {duration = -1})

	if distance_moved == nil then
		momentum_ms = caster:GetBaseMoveSpeed()
		distance_moved = 0
	end

	if caster.positions[(math.floor((currTime -0.04) * 25)/25)] ~= nil then
		local momentum_last_location = caster.positions[(math.floor((currTime -0.04) * 25)/25)]
		if (casterloc - momentum_last_location):Length2D() < 700 then
			distance_moved = distance_moved + (casterloc - momentum_last_location):Length2D()
		end
	end

	if distance_moved >= ondistancemoved then
		distance_moved = 0
		if not caster:HasModifier("momentum_charges") then
			ability:ApplyDataDrivenModifier(caster, caster, "momentum_charges", {duration = duration})
			caster:SetModifierStackCount("momentum_charges", caster, 1)
		else
			local stacks = caster:GetModifierStackCount("momentum_charges", caster)
			modifier:SetDuration(duration, false)
			if caster:GetIdealSpeed() >= 650 then
				caster:SetModifierStackCount("momentum_charges", caster, stacks)
			else
				caster:SetModifierStackCount("momentum_charges", caster, stacks +1)
			end
		end
	end
end

function MomentumAttack ( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ms_damage = ability:GetLevelSpecialValueFor("ms_damage", ability:GetLevel() -1) / 100

	local charges = caster:GetModifierStackCount("momentum_charges", caster)
	local bonusspeed = caster:GetIdealSpeed() - momentum_ms
	momentum_bonusdamage = bonusspeed * ms_damage

	--[[local DamageTable =   -- Done in the modifier now.
	{
		victim = target,
		attacker = caster,
		damage = bonusdamage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(DamageTable)]]
	caster:RemoveModifierByName("momentum_charges")
end

function NilValue ()
	distance_moved = nil
	momentum_bonusdamage = 0
end

