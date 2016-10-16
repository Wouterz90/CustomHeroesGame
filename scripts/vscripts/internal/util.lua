function DebugPrint(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    print(...)
  end
end

function DebugPrintTable(...)
  local spew = Convars:GetInt('barebones_spew') or -1
  if spew == -1 and BAREBONES_DEBUG_SPEW then
    spew = 1
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function PrintTable(t, indent, done)
  --print ( string.format ('PrintTable type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


--[[Author: Noya
  Date: 09.08.2015.
  Hides all dem hats
]]
function HideWearables( event )
  local hero = event.caster
  local ability = event.ability

  hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
  local hero = event.caster

  for i,v in pairs(hero.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end

function tobool(s)
    if s=="true" or s=="1" or s==1 then
        return true
    else --nil "false" "0"
        return false
    end
end

function GetSelectedEntities( playerID )
  return GameRules.SELECTED_UNITS[playerID]
end

function IsDebuff( modifier_handle )
    local ability = modifier_handle:GetAbility()
    local modifier_name = modifier_handle:GetName()

    if ability and IsValidEntity(ability) then
        local ability_name = ability:GetAbilityName()
        local ability_table = GameRules.AbilityKV[ability_name]

        -- Check for item ability
        if not ability_table then
            ability_table = GameRules.ItemKV[ability_name]
        end

        -- Proceed only if the ability is really found
        if ability_table then
            local modifier_table = ability_table["Modifiers"][modifier_name]
            if modifier_table then
                local IsDebuff = modifier_table["IsDebuff"]
                if IsDebuff and IsDebuff == 1 then
                    return true
                end
            end
        end
    end

    return false
end

function IsBuff( modifier_handle )
    local ability = modifier_handle:GetAbility()
    local modifier_name = modifier_handle:GetName()

    if ability and IsValidEntity(ability) then
        local ability_name = ability:GetAbilityName()
        local ability_table = GameRules.AbilityKV[ability_name]

        -- Check for item ability
        if not ability_table then
            ability_table = GameRules.ItemKV[ability_name]
        end

        -- Proceed only if the ability is really found
        if ability_table then
            local modifier_table = ability_table["Modifiers"][modifier_name]
            if modifier_table then
                local IsBuff = modifier_table["IsBuff"]
                if IsBuff and IsBuff == 1 then
                    return true
                end
            end
        end
    end

    return false
end

function IsPassive( modifier_handle )
    local ability = modifier_handle:GetAbility()
    local modifier_name = modifier_handle:GetName()

    if ability and IsValidEntity(ability) then
        local ability_name = ability:GetAbilityName()
        local ability_table = GameRules.AbilityKV[ability_name]

        -- Check for item ability
        if not ability_table then
            ability_table = GameRules.ItemKV[ability_name]
        end

        -- Proceed only if the ability is really found
        if ability_table then
            local modifier_table = ability_table["Modifiers"][modifier_name]
            if modifier_table then
                local Passive = modifier_table["Passive"]
                if Passive and Passive == 1 then
                    return true
                end
            end
        end
    end

    return false
end

function IsHidden( modifier_handle )
    local ability = modifier_handle:GetAbility()
    local modifier_name = modifier_handle:GetName()

    if ability and IsValidEntity(ability) then
        local ability_name = ability:GetAbilityName()
        local ability_table = GameRules.AbilityKV[ability_name]

        -- Check for item ability
        if not ability_table then
            ability_table = GameRules.ItemKV[ability_name]
        end

        -- Proceed only if the ability is really found
        if ability_table then
            local modifier_table = ability_table["Modifiers"][modifier_name]
            if modifier_table then
                local IsHidden = modifier_table["IsHidden"]
                if IsHidden and IsHidden() == 1 then
                    return true
                end
            end
        end
    end

    return false
end