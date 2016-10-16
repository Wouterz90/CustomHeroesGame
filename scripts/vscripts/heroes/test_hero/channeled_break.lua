function ProjectileUnit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local breakRange = ability:GetLevelSpecialValueFor("break_range",ability:GetLevel() -1)
	local projectileSpeed = ability:GetLevelSpecialValueFor("projectile_speed",ability:GetLevel() -1) /20
	local projectileUnit = CreateUnitByName("npc_dota_unit_dummy",caster:GetAbsOrigin(),true,caster,caster,caster:GetTeamNumber())

	Timers:CreateTimer(0.05,
    function()
    	if projectileUnit:HasModifier("modifier_projectile_unit_dummy") then
    		if projectileUnit:GetAbsOrigin() - target:GetAbsOrigin() < breakRange then
    			projectileUnitDirection = target:GetAbsOrigin()-projectileUnit:GetAbsOrigin():Normalized()
    			projectileUnit:SetAbsOrigin(projectileUnit:GetAbsOrigin() + (projectileSpeed * projectileUnitDirection))
    			return 0.05
    		elseif projectileUnit:GetAbsOrigin() - target:GetAbsOrigin() < 50 then
    			ability:ApplyDataDrivenModifier(caster,target,"modifier_channeled_break_break",{})
    		else
    			projectileUnit:RemoveModifierByName("modifier_projectile_unit_dummy")
    			return false
    		end
    	else
    		return false
    	end
    end)
end


