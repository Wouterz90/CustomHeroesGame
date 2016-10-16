angry_birds_catapult = class ({})
angry_birds_catapult_target = class ({})

function angry_birds_catapult_target:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	caster.target = target
	if caster ~= target then
		local ability = self
		caster.switch = nil
		local switchabilityname = "angry_birds_catapult"
		

		local abilitylevel = self:GetLevel()
		caster:AddAbility(switchabilityname)
		local switchability = caster:FindAbilityByName("angry_birds_catapult")
		switchability:SetLevel(abilitylevel)
		caster:SwapAbilities(self:GetAbilityName(),switchabilityname,false,true)
		caster:RemoveAbility(self:GetAbilityName())

		Timers:CreateTimer(2,function()
			if caster.switch == nil then
				SwitchAbilitiesBack(caster)
				self:RefundManaCost()
				self:EndCooldown()
			end
		end)
	else
		self:RefundManaCost()
		self:EndCooldown()
	end

end
function angry_birds_catapult:OnSpellStart()
	local caster = self:GetCaster()
	self.isVectorTarget = true
	--[[local targets = FindUnitsInRadius(DOTA_TEAM_BADGUYS + DOTA_TEAM_NEUTRALS + DOTA_TEAM_GOODGUYS, self:GetInitialPosition() , nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
	for _,unit in pairs(targets) do
		if caster ~= unit then
			self.target = unit
			break
		end
	end
	local target = self.target]]
	local target = caster.target
	local direction = (self:GetDirectionVector())
	

	if target then
		if not target:IsNull() then
		

			

			local min_throw_range = self:GetSpecialValueFor("min_throw")
			local speed = self:GetLevelSpecialValueFor("speed",self:GetLevel()-1) / 20
			local cast_range = self:GetLevelSpecialValueFor("speed",self:GetLevel()-1)
			local width = self:GetLevelSpecialValueFor("width",self:GetLevel()-1)
			local throw_range = cast_range + min_throw_range - (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() 



			target:AddNewModifier(caster,self,"modifier_phase",{})	
			local startPos = target:GetAbsOrigin()
			local endPos = startPos + direction * throw_range

			local info = 
			{
				Ability = self,
	        	EffectName = "	",
	        	vSpawnOrigin = target:GetAbsOrigin(),
	        	fDistance = throw_range,
	        	fStartRadius = width,
	        	fEndRadius = width,
	        	Source = caster,
	        	bHasFrontalCone = false,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = false,
				vVelocity = direction * (speed * 20) * 1,
				bProvidesVision = true,
				iVisionRadius = 1000,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			ProjectileManager:CreateLinearProjectile(info)

			Timers:CreateTimer(function()
				if (target:GetAbsOrigin() - endPos):Length2D() > 50 then
					if not self.check then
						self.check = 1
					elseif self.check < 35  and not target:HasModifier("modifier_tag_exploded") then 
						self.check = self.check +1 
						target:SetAbsOrigin(target:GetAbsOrigin() + (direction * speed))
					else
						return false
					end	
					return 0.05
				else 
					target:RemoveModifierByName("modifier_phase")
					GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(),width,false)
					return false

				end
			end)

		end
		if target:GetPlayerOwnerID() ~= caster:GetPlayerOwnerID() then
			local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 99999,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,unit in pairs(units) do
				if unit:GetUnitName() == "npc_dota_birdie" or unit:GetUnitName() == "npc_dota_hero_visage" then
					--print(unit:GetUnitName()..unit:GetPlayerOwnerID())
					--local unitability = unit:FindAbilityByName("angry_birds_catapult")
					local unitability2 = unit:FindAbilityByName("angry_birds_catapult_target")
					--unitability:StartCooldown(self:GetCooldown(self:GetLevel()-1))
					if unitability2 == nil then
						SwitchAbilitiesBack(unit)
						--local unitability2 = unit:FindAbilityByName("angry_birds_catapult_target")
						
					end
					local unitability2 = unit:FindAbilityByName("angry_birds_catapult_target")
					unit.unitability2:StartCooldown(unit.unitability2:GetCooldown(unit.unitability2:GetLevel()-1))
				end
			end
			

		end
		local unitability2 = caster:FindAbilityByName("angry_birds_catapult_target")
		if unitability2 == nil then
			SwitchAbilitiesBack(caster)		
		end
		
	else
		self:RefundManaCost()
		self:EndCooldown()
	end

	
	
	
end    


function angry_birds_catapult:OnProjectileHit(hTarget,vLocation)
	local caster = self:GetCaster()
	local target = hTarget

	if target ~= nil then
		local DamageTable = 
		{
			attacker = caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage = self:GetAbilityDamage(),
			victim = target
		}
		ApplyDamage(DamageTable)
	end
end

function SwitchAbilitiesBack(caster)
	
	--print(caster:GetUnitName())
	local catapult = caster:FindAbilityByName("angry_birds_catapult")
	local abilitylevel = catapult:GetLevel()
	caster.switch = 1
	caster:AddAbility("angry_birds_catapult_target")
	local catapult_target = caster:FindAbilityByName("angry_birds_catapult_target")
	caster:SwapAbilities("angry_birds_catapult_target","angry_birds_catapult",true,false)
	catapult_target:SetLevel(abilitylevel)
	caster:RemoveAbility("angry_birds_catapult")
	caster.unitability2 = catapult_target
	--catapult_target:StartCooldown(catapult_target:GetCooldown(catapult_target:GetLevel()-1))
end