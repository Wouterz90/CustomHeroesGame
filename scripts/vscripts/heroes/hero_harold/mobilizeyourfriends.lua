function AllowAlliesToRacetoCaster(hCaster,hUnit)
	hCaster:FindAbilityByName("harold_mobilize_your_friends"):ApplyDataDrivenModifier(hCaster,hUnit,"modifier_harold_mobilized",{duration = 60})
end

function CancelAlliesRacingToCaster(hUnit)
	hUnit:RemoveModifierByName("modifier_harold_mobilized")
end