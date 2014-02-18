function paladin_ret(self)
	local health = UnitHealth("target")/UnitHealthMax("target")
	local myhealth = UnitHealth("player")/UnitHealthMax("player")
	local mymana = UnitMana("player")/UnitManaMax("player")
	
	if cd("judgement of wisdom") == 0 then 
		spell = "judgement of wisdom"
	elseif health < .2 and cd("hammer of wrath") == 0 then
		spell = "hammer of wrath"
	elseif cd("Divine Storm") == 0 then 
		spell = "divine storm"
	elseif cd("crusader strike") == 0 then 
		spell = "crusader strike"
	elseif cd("consecration") == 0 then
		spell = "consecration"
	elseif UnitBuff("player","The Art of War") and cd("exorcism") == 0 then
		spell = "exorcism"
	else RunMacroText("/startattack")
	end

 return spell
end

function paladin_ret_ooc(self)
	if myhealth < 0.8 and mymana > 0.4 then
		spell = "Flash of Light"
	end
	
 return spell
end
