function BashDuration(keys)
-- Runs after OnAttackLanded and the Random is true
    --print("BashDuration")
	local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local attacker = keys.attacker
    local base_duration = ability:GetLevelSpecialValueFor("base_duration",ability:GetLevel()-1)
    local extra_duration = ability:GetLevelSpecialValueFor("extra_duration",ability:GetLevel()-1)
    local modifier = target:FindModifierByName("modifier_scuffle_bashed")
    --print(attacker:GetUnitName())
    --print(target:GetUnitName())
    if target:HasModifier("modifier_scuffle_counter") then
    	target:SetModifierStackCount("modifier_scuffle_counter",caster,target:GetModifierStackCount("modifier_scuffle_counter",caster)+1)
        ability:ApplyDataDrivenModifier(caster,target,"modifier_scuffle_bashed",{duration = base_duration  + (target:GetModifierStackCount("modifier_scuffle_counter",caster) * extra_duration)})
    else
        ability:ApplyDataDrivenModifier(caster,target,"modifier_scuffle_counter",{duration = ability:GetDuration()})
      	target:SetModifierStackCount("modifier_scuffle_counter",caster,0)
        ability:ApplyDataDrivenModifier(caster,target,"modifier_scuffle_bashed",{duration = base_duration})
    end
end

function StoreAttackTarget (keys)
--Runs at "OnAttack"
    --print("StoreAttackTarget") 
	local caster = keys.caster
    local ability = keys.ability 
    local target = keys.target
    local attacker = keys.attacker
    ability:ApplyDataDrivenModifier(caster,caster,"modifier_scuffle_just_attacked",{duration = (caster:GetBaseAttackTime()/((100+caster:GetIncreasedAttackSpeed())*0.01))})
    if not target:IsTower() then
        ability.AttackedUnit = target
    end
end

function AttackWhileMoving(keys)
--Runs at .05 intervals
   --print("AttackWhileMoving")
    local caster = keys.caster
    local ability = keys.ability
    local range = ability:GetSpecialValueFor("Attack_Range")
	
	if ability.AttackedUnit then
        if ((caster:GetAbsOrigin() - ability.AttackedUnit:GetAbsOrigin()):Length2D() < range) and not caster:HasModifier("modifier_scuffle_just_attacked") then
	       caster:PerformAttack(ability.AttackedUnit,true,true,true,true,false)
            ability:ApplyDataDrivenModifier(caster,caster,"modifier_scuffle_just_attacked",{duration = (caster:GetBaseAttackTime()/((100+caster:GetIncreasedAttackSpeed())*0.01))})
            local castereffect = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
            ParticleManager:SetParticleControl( castereffect, 0, caster:GetAbsOrigin() )
            ParticleManager:SetParticleControl( castereffect, 1, caster:GetAbsOrigin() )
            local targeteffect = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, ability.AttackedUnit)
            ParticleManager:SetParticleControl( targeteffect, 0, ability.AttackedUnit:GetAbsOrigin() )
            ParticleManager:SetParticleControl( targeteffect, 1, ability.AttackedUnit:GetAbsOrigin() )
             Timers:CreateTimer({
                endTime = 2,
                callback = function()
                   ParticleManager:DestroyParticle(targeteffect,true)
                end
            })
        else
    	   --ability.AttackedUnit = nil
	   end
    end
end
function CheckStunned (keys)
   -- print("CheckStunned")
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target

    if not target:IsStunned() then
        target:RemoveModifierByName("modifier_scuffle_counter")
    end
end

function NilAttacker(keys)
    local ability = keys.ability
    ability.AttackedUnit = nil
end