function paladin_holy(self)
	local my_mana = UnitMana("player")/UnitManaMax("player")
	local my_hp = UnitHealth("player")/UnitHealthMax("player")
	local tank, tank_hp, tank_focus
	if UnitExists("focus") then
		tank = "focus"
		tank_hp = UnitHealth(tank)/UnitHealthMax(tank)
		tank_focus = true
	end
	local spell = nil
	
	if IsModifierKeyDown(shift) then
		spell = "Divine Plea"
	elseif 
