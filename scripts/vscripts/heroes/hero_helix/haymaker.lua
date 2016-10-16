    function StoreAttacker(keys)
    -- Runs in OnAttacked
    	local ability= keys.ability
    	local attacker = keys.attacker
        if attacker:IsHero() then
            
    		ability.attacker = attacker

        end
    end

    function DisableSpell(keys)
    -- Runs every 0.1 interval
       -- print("DisableSpell")
    	local caster = keys.caster
        local ability = keys.ability

        local Max_Range = ability:GetSpecialValueFor("Max_Range")
        --print((caster:GetAbsOrigin() - ability.attacker:GetAbsOrigin()):Length2D())
        if ability.attacker then
            
            if (caster:GetAbsOrigin() - ability.attacker:GetAbsOrigin()):Length2D() > Max_Range and ability:GetCooldownTimeRemaining() < 0.2 then
                
            	--ability:StartCooldown(0.1)
                ability:SetActivated(false)
            else
                ability:SetActivated(true)
            end
        else
            --ability:StartCooldown(0.1)
            ability:SetActivated(false)
        end
    end

    function Haymaker(keys)
    -- Runs OnSpellStart
    	local caster = keys.caster
        local ability = keys.ability
        local wave_width = ability:GetSpecialValueFor("wave_width")
        if ability.attacker then
            
            local projectileTable =
            {
                EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
                Ability = ability,
                vSpawnOrigin = caster:GetAbsOrigin(),
                vVelocity = (ability.attacker:GetAbsOrigin() -caster:GetAbsOrigin()):Normalized() * 1000,
                fDistance = (caster:GetAbsOrigin() - ability.attacker:GetAbsOrigin()):Length2D() + wave_width,
                fStartRadius = wave_width,
                fEndRadius = wave_width,
                Source = caster,
                bHasFrontalCone = false,
                bReplaceExisting = false,
                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
            }
            -- Saving the projectile ID so that we can destroy it later
            projectile_id = ProjectileManager:CreateLinearProjectile( projectileTable )
        end
    end

    function HaymakerHit(keys)
    	local caster = keys.caster
        local target = keys.target
        local ability = keys.ability
        local extra_damage = ability:GetLevelSpecialValueFor("extra_damage",ability:GetLevel()-1)/100

        
        local damageTable = 
        {
        victim = target,
        attacker = caster,
        ability = ability,
        damage = caster:GetAverageTrueAttackDamage() * extra_damage,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        }
     
    ApplyDamage(damageTable)


    end

