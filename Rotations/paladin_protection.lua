function paladin_protection(self)
	-- 3.3.5a shadowstepster
	local myhealth = UnitHealth("player")/UnitHealthMax("player")
	local mymana = UnitMana("player")/UnitManaMax("player")
	local myHealthPercent = UnitHealth("player")/UnitHealthMax("player") * 100
        local targetHealthPercent = UnitHealth("target")/UnitHealthMax("target") * 100
        local myManaPercent = UnitMana("player")/UnitManaMax("player") * 100
        local health = UnitHealth("target")/UnitHealthMax("target")
        local spell = nil
        
        if IsShiftKeyDown() ~=  nil and cd("avenger's shield") == 0 then
		spell = "avenger's shield"
	elseif IsAltKeyDown() ~= nil and cd("consecration") == 0 then
		spell = "consecration"
	elseif IsControlKeyDown() ~= nil and cd("divine plea") == 0 then
		spell = "divine plea"
	elseif cd("Hammer of the Righteous") == 0 then 
		spell = "Hammer of the Righteous"
	elseif cd("judgement of wisdom") == 0 then 
		spell = "judgement of wisdom"
	elseif not ub("player","Holy shield") and cd("holy shield") == 0 then
		spell = "holy shield"
	elseif not ub("player","sacred shield") then
		spell = "Sacred Shield"
	elseif health < .2 and cd("hammer of wrath") == 0 then
		spell = "hammer of wrath"
	elseif cd("Shield of Righteousness") == 0 then 
		spell = "Shield of Righteousness"
	else RunMacroText("/startattack")
	end

        -- Return
	return spell
	end


