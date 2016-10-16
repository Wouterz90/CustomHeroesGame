-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


-- Orders.lua has the orderfilter in it. I took it out of the gamemode to make it easier to see what should be edited.
require('orders')
require('modifiergained')
require('damage')
--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end


--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold

  if hero:GetGold() == 0 and hero:GetLevel() == 1 then
      hero:SetGold(650, false)
  end

  if not hero:IsIllusion() then
      if hero:GetUnitName() == "npc_dota_hero_clinkz" then 
          skoros = hero
          blackout = skoros:FindAbilityByName("Blackout")
          local ability = skoros:FindAbilityByName("Third_Eye_Blind")
          ability:SetLevel(1)
          ability:SetAbilityIndex(5)
      elseif hero:GetUnitName() == "npc_dota_hero_razor" then
          hero:UpgradeAbility(hero:FindAbilityByName("Positive_Charge"))
          hero:UpgradeAbility(hero:FindAbilityByName("Negative_Charge"))
          hero:SetAbilityPoints(1)
          borus_caster = hero
      elseif hero:GetUnitName() == "npc_dota_hero_omniknight" then
          hero:UpgradeAbility(hero:FindAbilityByName("Hail_Back"))
          hero:SetAbilityPoints(1)
      elseif hero:GetUnitName() == "npc_dota_hero_tinker" then
          whizzi = hero
          ads_everywhere = whizzi:FindAbilityByName("Ads_Everywhere")
      end

  end


  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  --local item = CreateItem("item_example_item", hero, hero)
  --hero:AddItem(item)

   GameRules.Heroes[hero:GetPlayerID()] = hero
    hero.positions = {}

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")
  Timers:CreateTimer({   --Putting a modifier on towers to prevent them from attacking units with the disconnected modifiers
    endTime = 61,
    callback = function()   
      if hero:GetUnitName() == npc_dota_hero_tinker then
        local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
          for _,unit in pairs(targets) do 
            if unit:IsTower() then
              local ability = hero:FindAbilityByName("Global_Disconnect")
              ability:ApplyDataDrivenModifier(hero, unit, "protect", {duration = -1})
            end
          end
        end
      end
    })]]
end
-- main think loop
function Think(  )
    local currTime = GameRules:GetGameTime()
    for pID, hero in pairs(GameRules.Heroes) do
        if not hero:IsNull() then
            if not hero:IsIllusion() then
              --print(hero:GetUnitName())
              if not hero.positions[math.floor(currTime*100)/100] then
                  hero.positions[math.floor(currTime*100)/100] = hero:GetAbsOrigin()
              end
              for t, pos in pairs(hero.positions) do
                  if (currTime-t) > 4 then
                      hero.positions[t] = nil
                  else -- the rest of the times in the table are <= 4.
                      break
                  end
              end
            end
        end
    end
end
--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  --[[Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)]]
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  
  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()
  GameRules.Heroes = {}
  GameRules.Think = Timers:CreateTimer(function() Think() return .01 end) 
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode,"FilterExecuteOrder"),self)
  GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode,"FilterModifierGained"),self)
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode,"FilterDamage"),self)



  GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
  GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
  GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")

  --GameRules.SELECTED_UNITS = {}

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function GameMode:OnConnectFull(keys)
  GameMode:CaptureGameMode()
   local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  local userID = keys.userid

  self.vUserIds = self.vUserIds or {}
  self.vUserIds[userID] = ply
end

function GameMode:CaptureGameMode()
  if mode == nil then
    -- Set GameMode parameters
    mode = GameRules:GetGameModeEntity()

    
  end
end


-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end





--[[function GameMode:DebugCalls()
    if not GameRules.DebugCalls then
        print("Starting DebugCalls")
        GameRules.DebugCalls = true

        debug.sethook(function(...)
            local info = debug.getinfo(2)
            local src = tostring(info.short_src)
            local name = tostring(info.name)
            if name ~= "__index" then
                print("Call: ".. src .. " -- " .. name)
            end
        end, "c")
    else
        print("Stopped DebugCalls")
        GameRules.DebugCalls = false
        debug.sethook(nil, "c")
    end
end

function GameMode:OnPlayerChat(keys)
  local text = keys.text
  local userID = keys.userid
    local playerID = self.vUserIds[userID] and self.vUserIds[userID]:GetPlayerID()
    if not playerID then return end

    -- Handle '-command'
    if StringStartsWith(text, "-") then
        text = string.sub(text, 2, string.len(text))
    end

  local input = split(text)
  local command = input[1]
  if DEBUG_CODES[command] then
        DEBUG_CODES[command](input[2])
  end        
end

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function StringStartsWith( fullstring, substring )
    local strlen = string.len(substring)
    local first_characters = string.sub(fullstring, 1 , strlen)
    return (first_characters == substring)
end

DEBUG_CODES = {
    ["debug_trees"] = function(...) GameMode:DebugTrees(...) end,           -- Prints the trees marked as pathable
    ["debug_blight"] = function(...) GameMode:DebugBlight(...) end,         -- Prints the positions marked for undead buildings
    ["debug_food"] = function(...) GameMode:DebugFood(...) end,             -- Prints the food count for all players, checking for inconsistencies
    ["debug_c"] = function(...) GameMode:DebugCalls(...) end,               -- Spams the console with every lua call
    ["debug_l"] = function(...) GameMode:DebugLines(...) end,               -- Spams the console with every lua line
}
]]