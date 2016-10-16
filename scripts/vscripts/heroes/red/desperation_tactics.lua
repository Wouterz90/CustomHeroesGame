Mikhail_Desperation_Tactics = class({})
LinkLuaModifier("modifier_desperation_tactics","heroes/red/modifiers/modifier_desperation_tactics.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_desperation_tactics_crit","heroes/red/modifiers/modifier_desperation_tactics_crit.lua",LUA_MODIFIER_MOTION_NONE)

function Mikhail_Desperation_Tactics:GetIntrinsicModifierName()
	return "modifier_desperation_tactics"
end
--[[
function CritCalculator (keys)
	local caster = keys.caster
	local ability = keys.ability
	local critchance = ability:GetLevelSpecialValueFor("crit_chance",ability:GetLevel()-1)
	local casterhealthpercent = 1 - caster:GetHealthPercent()

	local random = RandomInt(0,1)
	if random < (critchance*casterhealthpercent) then
		ability:ApplyDataDrivenModifier(caster,caster,pszModifierName,hModifierTable)


]]

