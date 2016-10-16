function GetStartLocation(keys)
	local caster = keys.caster
	soul_grab_startlocation = caster:GetAbsOrigin()
end

function RootAndSilence(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local castrange = ability:GetCastRange()
	local minrootduration = ability:GetLevelSpecialValueFor("minrootduration",ability:GetLevel() -1)
	local maxrootduration = ability:GetLevelSpecialValueFor("maxrootduration",ability:GetLevel() -1)
	local minsilenceduration = ability:GetLevelSpecialValueFor("minsilenceduration",ability:GetLevel() -1)
	local maxsilenceduration = ability:GetLevelSpecialValueFor("maxsilenceduration",ability:GetLevel() -1)


	local distance = (soul_grab_startlocation - target:GetAbsOrigin()):Length2D()
	local factor = distance/castrange

	local rootduration = minrootduration + ((maxrootduration - minrootduration) * factor)
	local silenceduration = minsilenceduration + ((maxsilenceduration - minsilenceduration) * factor)

	target:AddNewModifier(caster,ability,"modifier_rooted",{})
	Timers:CreateTimer({
		endTime = rootduration,
		callback = function()
			target:RemoveModifierByNameAndCaster("modifier_rooted",caster)
			target:AddNewModifier(caster,ability,"modifier_silence",{duration = silenceduration})
		end
	})
end

