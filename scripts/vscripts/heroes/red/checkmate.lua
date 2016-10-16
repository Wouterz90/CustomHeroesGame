function CheckHP(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damageTaken = keys.DamageTaken
	local cooldown = ability:GetCooldown(ability:GetLevel() -1)
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )

	if not caster:HasModifier("modifier_checkmate_buff") then
		if caster:GetHealth() < 2 and ability:IsCooldownReady() then
			ability:StartCooldown(cooldown)
			caster:SetHealth(1)
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_checkmate_buff",{duration = duration})
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_checkmate_buff_counter",{duration = duration})
		end
	end
end

function LoseInt (keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_checkmate_buff_counter")
	local int_loss = ability:GetLevelSpecialValueFor( "int_loss" , ability:GetLevel() - 1  ) * -1
	if caster:GetIntellect() > int_loss then
		caster:SetHealth(1)
		if caster:GetModifierStackCount("modifier_checkmate_buff_counter",caster) == nil then
			caster:SetModifierStackCount("modifier_checkmate_buff_counter",caster,1)
		else
			caster:SetModifierStackCount("modifier_checkmate_buff_counter",caster,caster:GetModifierStackCount("modifier_checkmate_buff_counter",caster)+1)
		end
	end
end

function Keepatone (keys)
	local caster = keys.caster
	caster:SetHealth(1)
end