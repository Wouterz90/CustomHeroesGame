--Gold bonus for killing and Assisting

function GameMode:KillGold( keys )
    --print( '[BAREBONES] OnEntityKilled Called' )
    --DeepPrintTable( keys )
    
    
    -- The Unit that was Killed
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    -- The Killing entity
    --local killerEntity = nil


    if keys.entindex_attacker ~= nil then
      killerEntity = EntIndexToHScript( keys.entindex_attacker )
    end



    -- Gold Bonus for killing
    if killedUnit:IsRealHero() then
      -- Search area is 1300
      local unitsinradius = FindUnitsInRadius( killedUnit:GetTeamNumber(), killedUnit:GetAbsOrigin(), killedUnit, 1300,
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
      local count = 0
      local streak = PlayerResource:GetStreak(killedUnit:GetPlayerOwnerID())
      if streak > 10 then
        streak = 10
      end
      for k, v in pairs( unitsinradius ) do
        if v:IsRealHero() then
            count = count + 1
        end
      end
        
      if killerEntity:IsOwnedByAnyPlayer() then 
        killerEntity:ModifyGold(BASIC_GOLD_PER_KILL +(streak*STREAK_GOLD_PER_KILL)+(killedUnit:GetLevel() * KILLED_HERO_LEVEL_FACTOR),true,0)
        GameRules:SetFirstBloodActive(false)
        print("Gold for killing:"..BASIC_GOLD_PER_KILL +(streak*STREAK_GOLD_PER_KILL)+(killedUnit:GetLevel() * KILLED_HERO_LEVEL_FACTOR))
        GameMode.killgold = BASIC_GOLD_PER_KILL +(streak*STREAK_GOLD_PER_KILL)+(killedUnit:GetLevel() * KILLED_HERO_LEVEL_FACTOR)
      else
        for _, unit in pairs (unitsinradius) do 
          unit:ModifyGold((BASIC_GOLD_PER_KILL + (streak * STREAK_GOLD_PER_KILL) + (killedUnit:GetLevel() * KILLED_HERO_LEVEL_FACTOR)/count),true,0)
        end
      end

      --Gold bonus for being in the area
      local killedUnitTeamNetWorth = 0
      killedUnitTeamPlayerNetWorth = {}
      for i=1,5 do
        if PlayerResource:GetNthPlayerIDOnTeam(killedUnit:GetTeamNumber(),i) ~= -1 then
          local playerPID = PlayerResource:GetNthPlayerIDOnTeam(killedUnit:GetTeamNumber(),i)
          local player = PlayerResource:GetPlayer(playerPID):GetAssignedHero()
          killedUnitTeamNetWorth = killedUnitTeamNetWorth + GetNetworth(player)
          
          killedUnitTeamPlayerNetWorth[playerPID] = GetNetworth(player)
        end
      end
     
      killedUnitTeamPlayerNetWorthSorted = {}
      local r = 1
      for k,v in spairs(killedUnitTeamPlayerNetWorth, function(t,a,b) return t[b] < t[a] end) do
        if k == killedUnit:GetPlayerOwnerID() then
          killedUnitNetWorthRanking = r
        end
        r =r +1
      end
      --print(killedUnitNetWorthRanking)
      if killedUnitNetWorthRanking == 1 or killedUnitNetWorthRanking == 2 then
        killedUnitNetWorthRankingFactor = NETWORTH_RANKING_FACTOR_MAX
      elseif killedUnitNetWorthRanking == 3 then
        killedUnitNetWorthRankingFactor = NETWORTH_RANKING_FACTOR_AVG
      elseif killedUnitNetWorthRanking == 4 or killedUnitNetWorthRanking == 5 then
        killedUnitNetWorthRankingFactor = NETWORTH_RANKING_FACTOR_MIN
      end


      local killerEntityTeamNetWorth = 0
      killerEntityTeamPlayerNetWorth = {}
      for i=1,5 do
        if PlayerResource:GetNthPlayerIDOnTeam( killerEntity:GetTeamNumber(),i) ~= -1 then
          local playerPID = PlayerResource:GetNthPlayerIDOnTeam(killerEntity:GetTeamNumber(),i)
          local player = PlayerResource:GetPlayer(playerPID):GetAssignedHero()
          killerEntityTeamNetWorth = killerEntityTeamNetWorth + GetNetworth(player)         
          

          if (player:GetAbsOrigin()-killedUnit:GetAbsOrigin()):Length2D() < 1300 then
            killerEntityTeamPlayerNetWorth[playerPID] = GetNetworth(player)
          end

          local r = 1
          for k,v in spairs(killerEntityTeamPlayerNetWorth, function(t,a,b) return t[b] < t[a] end) do
            --if k == killerEntity:GetPlayerOwnerID() then
              PlayerResource:GetPlayer(k).killerEntityNetWorthRanking = r
           -- end
            r =r +1
          end
        end
      end



     
      

       --DeepPrintTable(killerEntityTeamPlayerNetWorthSorted)
      --print("killerteamnetworth"..killerEntityTeamNetWorth)

      local NWfactor = (killedUnitTeamNetWorth/killerEntityTeamNetWorth) -1
      if NWfactor > 1 then
        NWfactor = 1
      elseif NWfactor < 0 then
        NWfactor = 0
      end
      NWDisadvantage = killedUnitTeamNetWorth - killerEntityTeamNetWorth
      if NWDisadvantage < 1 then
        NWDisadvantage = 1 
      end
      --local killedUnitNetWorthRanking = 
      
      if count == 1 then
        for _, unit in pairs (unitsinradius) do
          if PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 1 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_AVG
          end
          local gold = (ASSIST_BOUNTY[count] + (ASSIST_LEVEL_FACTOR[count]*killedUnit:GetLevel()) + (DIEING_HERO_NW_FACTOR[count] * GetNetworth(killedUnit) * NWfactor) + (TEAM_NW_DIFFERENCE_FACTOR[count] * NWDisadvantage / NW_DISADVANTAGE_DIVISION) * (1.2 - (0.1 * killedUnitNetWorthRankingFactor - 1)) * (PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue))
          unit:ModifyGold(gold,true,0)
          print(PlayerResource:GetPlayerName(unit:GetPlayerOwnerID()).." got "..gold.." gold for assisting")
          if unit == killerEntity then
            GameRules:SendCustomMessage("%s1 killed %s2 for <font color='#F0BA36'>"..gold+GameMode.killgold.."</font> gold!", 0, killerEntity:GetPlayerID())
          end
        end
      elseif count == 2 then
        for _, unit in pairs (unitsinradius) do
          if PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 1 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MAX
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 2 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MIN
          end
          local gold = (ASSIST_BOUNTY[count] + (ASSIST_LEVEL_FACTOR[count]*killedUnit:GetLevel()) + (DIEING_HERO_NW_FACTOR[count] * GetNetworth(killedUnit) * NWfactor) + (TEAM_NW_DIFFERENCE_FACTOR[count] * NWDisadvantage /NW_DISADVANTAGE_DIVISION) * (1.2 - (0.1 * killedUnitNetWorthRankingFactor -1)) * (PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue))
          unit:ModifyGold(gold,true,0)
          print(PlayerResource:GetPlayerName(unit:GetPlayerOwnerID()).." got "..gold.." gold for assisting")
          if unit == killerEntity then
            GameRules:SendCustomMessage("%s1 killed %s2 for <font color='#F0BA36'>"..gold+GameMode.killgold.."</font> gold!", 0, killerEntity:GetPlayerID())
          end

        end
      elseif count == 3 then
        for _, unit in pairs (unitsinradius) do
          if PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 1 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MAX
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 2 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_AVG
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 3 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MIN
          end 
          local gold = (ASSIST_BOUNTY[count] + (ASSIST_LEVEL_FACTOR[count]*killedUnit:GetLevel()) + (DIEING_HERO_NW_FACTOR[count] * GetNetworth(killedUnit) * NWfactor) + (TEAM_NW_DIFFERENCE_FACTOR[count] * NWDisadvantage /NW_DISADVANTAGE_DIVISION) * (1.2 - (0.1 * killedUnitNetWorthRankingFactor -1)) * (PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue))
          unit:ModifyGold(gold,true,0)
          print(PlayerResource:GetPlayerName(unit:GetPlayerOwnerID()).." got "..gold.." gold for assisting")
          if unit == killerEntity then
            GameRules:SendCustomMessage("%s1 killed %s2 for <font color='#F0BA36'>"..gold+GameMode.killgold.."</font> gold!", 0, killerEntity:GetPlayerID())
          end


        end
      elseif count == 4 then
        for _, unit in pairs (unitsinradius) do
          if PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 1 then
           PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MAX
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 2 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MAX
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 3 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MIN
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 4 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MIN
          end 
          local gold = (ASSIST_BOUNTY[count] + (ASSIST_LEVEL_FACTOR[count]*killedUnit:GetLevel()) + (DIEING_HERO_NW_FACTOR[count] * GetNetworth(killedUnit) * NWfactor) + (TEAM_NW_DIFFERENCE_FACTOR[count] * NWDisadvantage /NW_DISADVANTAGE_DIVISION) * (1.2 - (0.1 * killedUnitNetWorthRankingFactor -1)) * (PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue))
          unit:ModifyGold(gold,true,0)
          print(PlayerResource:GetPlayerName(unit:GetPlayerOwnerID()).." got "..gold.." gold for assisting")
          if unit == killerEntity then
            GameRules:SendCustomMessage("%s1 killed %s2 for <font color='#F0BA36'>"..gold+GameMode.killgold.."</font> gold!", 0, killerEntity:GetPlayerID())
          end

        end
      elseif count == 5 then
        for _, unit in pairs (unitsinradius) do
          if PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 1 or PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 2 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MAX
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 3 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_AVG
          elseif PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 4 or PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRanking == 5 then
            PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue = NETWORTH_RANKING_FACTOR_MIN
          end
          local gold = (ASSIST_BOUNTY[count] + (ASSIST_LEVEL_FACTOR[count]*killedUnit:GetLevel()) + (DIEING_HERO_NW_FACTOR[count] * GetNetworth(killedUnit) * NWfactor) + (TEAM_NW_DIFFERENCE_FACTOR[count] * NWDisadvantage /NW_DISADVANTAGE_DIVISION) * (1.2 - (0.1 * killedUnitNetWorthRankingFactor -1)) * (PlayerResource:GetPlayer(unit:GetPlayerOwnerID()).killerEntityNetWorthRankingValue))   
          unit:ModifyGold(gold,true,0)
          print(PlayerResource:GetPlayerName(unit:GetPlayerOwnerID()).."got "..gold.." gold for assisting")
          if unit == killerEntity then
            GameRules:SendCustomMessage("%s1 killed %s2 for <font color='#F0BA36'>"..gold+ GameMode.killgold.."</font> gold!", 0, killerEntity:GetPlayerID())
          end
        end
      end
    end
  end