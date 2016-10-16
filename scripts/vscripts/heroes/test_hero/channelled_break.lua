function ProjectileUnit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local breakRange = ability:GetLevelSpecialValueFor("break_range",ability:GetLevel() -1)
	local projectileSpeed = ability:GetLevelSpecialValueFor("projectile_speed",ability:GetLevel() -1) /20
	ability.projectileUnit = CreateUnitByName("npc_dota_dummy_unit",caster:GetAbsOrigin(),true,caster,caster,caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster,ability.projectileUnit,"modifier_projectile_unit_dummy",{})
	print(caster:GetAbsOrigin())
	print(ability.projectileUnit:GetAbsOrigin())

	Timers:CreateTimer(0.05,
    function()
    	if ability.projectileUnit:HasModifier("modifier_projectile_unit_dummy") then
    		if (ability.projectileUnit:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < breakRange then
    			projectileUnitDirection = (target:GetAbsOrigin()-ability.projectileUnit:GetAbsOrigin()):Normalized()
    			ability.projectileUnit:SetAbsOrigin(ability.projectileUnit:GetAbsOrigin() + (projectileSpeed * projectileUnitDirection))
    			print((ability.projectileUnit:GetAbsOrigin() - target:GetAbsOrigin()):Length2D())
    			if (ability.projectileUnit:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < projectileSpeed then
    				ability:ApplyDataDrivenModifier(caster,target,"modifier_channelled_break_break",{})
    			end
    			return 0.05
    		else
    			ability.projectileUnit:RemoveModifierByName("modifier_projectile_unit_dummy")
    			ability.projectileUnit:RemoveSelf()
    			return false
    		end
    	else
    		ability.projectileUnit:RemoveSelf()
    		return false
    	end
    end)
end


