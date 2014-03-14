function paladin_ret_ooc(self)
	if myhealth < 0.8 and mymana > 0.4 and not ub("player","divine plea") then
		spell = "Flash of Light"
	elseif mymana < 0.5 then
		spell = "Divine Plea"
	end
	
 return spell
end
