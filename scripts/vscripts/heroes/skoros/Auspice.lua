function Ghosts (keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    target.auspice_unit = target:GetName()
    local currTime = GameRules:GetGameTime()
    if not target.positions or not target.positions[(math.floor(currTime * 100)/100)-2.5] then 
    	return
    --else
    	
    end
    target.ghostloc = target.positions[(math.floor(currTime * 100)/100)-2.5]
    

    if target.auspice_illusion == nil then

    	target.auspice_illusion = CreateUnitByName(target.auspice_unit, target.ghostloc, false, caster, nil, caster:GetTeamNumber())
    	target.auspice_illusion:MakeIllusion()
		target.auspice_illusion:SetPlayerID(caster:GetPlayerID())

   		ability:ApplyDataDrivenModifier(caster, target.auspice_illusion, "modifier_auspice_invulnerability", {duration = -1})
   	else
   		if (target.ghostloc - target.auspice_illusion:GetAbsOrigin()):Length2D() > 100 then 
   			target.auspice_illusion:RemoveSelf()
   			target.auspice_illusion = nil
   		else
   			target.auspice_illusion:MoveToPosition(target.ghostloc)
   		end

   	end
end

function DestroyIllusion (keys)
	local target = keys.target
	target.auspice_illusion:RemoveSelf()
	target.auspice_illusion = nil
end
