  function GameMode:HealTracker()
    local currTime = GameRules:GetGameTime()
    for pID, hero in pairs(GameRules.Heroes) do
      if not hero:IsNull() then
        if hero:IsRealHero() then
          hero.currenthp[math.floor(currTime*25)/25] = hero:GetHealth()
          hero.hphealed[math.floor(currTime*25)/25] = PlayerResource:GetHealing(hero:GetPlayerOwnerID())
          if  PlayerResource:GetHealing(hero:GetPlayerOwnerID()) and hero.hphealed[(math.floor((currTime -0.04) * 25)/25)]  then
            hero.healedHP = (PlayerResource:GetHealing(hero:GetPlayerOwnerID()) - hero.hphealed[(math.floor((currTime -0.04) * 25)/25)])
          else
            hero.healedHP = 0
          end

          if hero.healedHP > 20 then
            for pID, healedhero in pairs(GameRules.Heroes) do
              if not healedhero:IsNull() then
                if healedhero:IsRealHero() then
                  if healedhero.currenthp[(math.floor((currTime -0.04) * 25)/25)] ~= healedhero.currenthp[(math.floor((currTime) * 25)/25)] and hero.boostedHeal == false then -- Prevent the heal from triggering itself
                    local hpdifference = healedhero:GetHealth() - healedhero.currenthp[(math.floor((currTime -0.04) * 25)/25)]
                      if hpdifference > 10 then -- I don't think there are heals below this interval and it would require 250 hp/s regen to trigger
                        hero.boostedHeal = true
                        GameMode:OnUnitHealed(hero,healedhero,hpdifference)
                      end
                    end
                  else
                    hero.boostedHeal = false
                  end
                end
              end
            end

          for t, pos in pairs(hero.hphealed) do
            if (currTime-t) > 0.2 then
              hero.currenthp[t] = nil
              hero.hphealed[t] = nil
            else
              break
            end
          end
        end
      end
    end
  end

  function GameMode:OnUnitHealed(hCaster,hTarget,fHeal)
    --Track the heals and heals hTarget for 2nd instance.
    --print(hTarget:GetUnitName().." got healed by "..hCaster:GetUnitName().." for "..fHeal)

    if hCaster:HasModifier("modifier_spread_wisdom_passive") then
      fHeal = SpreadWisdomHealBoost(hCaster,hTarget,fHeal) -- function also heals
    end

    fHealMod = fHeal * (((hCaster:GetIntellect() /16)/100)) -- Boosting the heals by the intelligence of the caster / 1600
    --print("and that heal is boosted by "..fHealMod)
    hTarget:Heal(fHealMod,hCaster)
  end

    --[[if hCaster:HasModifier("modifier_spread_wisdom_passive") then
      fHeal = SpreadWisdomHealBoost(hCaster,hTarget,fHeal) -- function also heals
    end]]
