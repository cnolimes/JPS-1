function dk_blood(self)
	-- Credit (and thanks!) to Soiidus.
 local spell = nil
       local power = UnitPower("player",6)

       if cd("player","death strike") == 0 and ud("target","frost fever") and ud("target","blood plague") then
    		spell = "Death Strike"
       elseif cd("Player","icy touch") == 0 and not ud("target","frost fever") then
       		spell = "Icy Touch"
       elseif cd("plague strike") == 0 and not ud("target","blood plague") then
       		spell = "Plague Strike"
       elseif cd("heart strike") == 0 then
       		spell = "Heart Strike"
       
       end
		 return spell
end
