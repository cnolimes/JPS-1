function paladin_nub(self)
   
	--ACTION GOES DOWN HERE--

   	if cd("Judgement of Light") == 0 then
   		spell = "Judgement of Light"
   	elseif cd("Exorcism") == 0 then
   		spell = "exorcism"

	end

 return spell
end
