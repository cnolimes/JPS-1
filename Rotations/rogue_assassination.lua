function rogue_assassination(self)
	local cp = GetComboPoints("player","target")
	local hfb = UnitBuff("player","Hunger for Blood")
	local snd = UnitBuff("player","Slice and Dice")
	local energy = UnitMana("player")
	local stealth = UnitBuff("player","stealth")
	local overkill = UnitBuff("player","overkill")
	local bleeding = UnitBuff("target","Garrote") or UnitBuff("target","Rend") or UnitBuff("target","Rake") or UnitBuff("target","Rip") or UnitBuff("target","Rupture")
	local spell = nil
	
	if stealth and not hfb then
		spell = "Garrote"
	elseif jps.should_kick("target") then
		spell = "Kick"
	--elseif not overkill then
		--spell = "Vanish"
	elseif IsUsableSpell("Hunger for Blood") and not hfb then
		spell = "Hunger for Blood"
	elseif cp > 0 and not snd then
		spell = "Slice and Dice"
	elseif jps.buff_duration("player","slice and dice") < 3 and cp > 0 then
		spell = "Envenom"
	elseif cp > 3 then
		spell = "Envenom"
	elseif cp < 4 then
		spell = "Mutilate"
	else RunMacroText("/startattack")
	end
  return spell
end

function rogue_assassination_ooc(self)

end
