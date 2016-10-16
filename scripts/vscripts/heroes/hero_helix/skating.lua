function StartSkatingCooldown (keys)
	local caster = keys.caster
	local ability = keys.ability

	ability:StartCooldown(ability:GetCooldown(ability:GetLevel()-1))
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_skating_slow",{duration = ability:GetCooldown(ability:GetLevel()-1)})

	
end

function StartSkating(hCaster,hUnit,vPosition_x, vPosition_y, vPosition_z)
	local skating = hCaster:FindAbilityByName("helix_skating")
    local skating_max_range = skating:GetLevelSpecialValueFor("max_range", skating:GetLevel() -1)
    local skating_ms = skating:GetLevelSpecialValueFor("movement_speed", skating:GetLevel() -1)
    local position =  Vector(vPosition_x, vPosition_y, vPosition_z)

    if ((hUnit:GetAbsOrigin()-position):Length2D() < skating_max_range) and not (hUnit:HasModifier("modifier_corkscrew_slow_datadriven") or hUnit:HasModifier("modifier_corkscrew_shield")) then
                
      	skating:ApplyDataDrivenModifier(hUnit,hUnit,"modifier_skating",{duration = (skating_max_range/skating_ms)})
        hUnit:AddNewModifier(hUnit,skating,"modifier_break_speed_limit",{duration = (skating_max_range/skating_ms)})
        skating:StartCooldown(skating:GetCooldown(skating:GetLevel()-1)*2)
    end
end