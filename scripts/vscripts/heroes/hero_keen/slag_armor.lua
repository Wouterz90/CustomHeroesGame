function AttackWasHit (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel() -1)
	local radius = ability:GetLevelSpecialValueFor("siege_radius",ability:GetLevel() -1)
	local manacost = ability:GetLevelSpecialValueFor("manacost",ability:GetLevel() -1)
	local cooldown = ability:GetLevelSpecialValueFor("cooldown",ability:GetLevel() -1)
	local modifier = "modifier_slag_armor_debuff"

	if ability:IsCooldownReady() --[[and caster:GetMana() > manacost]] then
		ability:StartCooldown(cooldown)
		caster:ReduceMana(manacost)
		if caster:HasModifier("modifier_siege_mode") then
			local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP +DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, 0, 0, false )
	
			for _,unit in pairs( units ) do
				if unit:HasModifier(modifier) then
					unit:SetModifierStackCount(modifier,caster,unit:GetModifierStackCount(modifier,caster) +1)
					unit:FindModifierByName(modifier):SetDuration(duration,true)
				else
					ability:ApplyDataDrivenModifier(caster,unit,modifier,{duration = duration})
					unit:SetModifierStackCount(modifier,caster,1)
				end
			end

		else
			if not target:IsBuilding() then
				if target:HasModifier(modifier) then
					target:SetModifierStackCount(modifier,caster,target:GetModifierStackCount(modifier,caster) +1)
					target:FindModifierByName(modifier):SetDuration(duration,true)
				else
					ability:ApplyDataDrivenModifier(caster,target,modifier,{duration = duration})
					target:SetModifierStackCount(modifier,caster,1)
				end
				ability:ApplyDataDrivenModifier(caster,target,"modifier_slag_armor_damage_debuff",{duration = duration})
			else
				ability:RefundManaCost()
				ability:EndCooldown()
			end
		end
		--ability:ToggleAbility()
	end
end