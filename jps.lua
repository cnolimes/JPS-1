-- Universal
jps = {}
jps.Version = "0.0.1"
jps.RaidStatus = {}
jps.UpdateInterval = 0.1
jps.Enabled = false
jps.Combat = false
jps.Class = nil
jps.Spec = nil
jps.Interrupts = true
jps.UseCDs = false
jps.MultiTarget = false
jps.Debug = false
jps.OutofCombat = false
-- Utility
jps.Target = nil
jps.Casting = false
jps.LastCast = nil
jps.ThisCast = nil
jps.NextCast = nil
jps.Error = nil
jps.Lag = nil
jps.Moving = nil
jps.IconSpell = nil
jps.PvP = false
-- Class Specific
jps.Havoc = false
jps.Opening = true
jps.Panther = false
-- Misc.
jps.MacroSpam = false
jps.Fishing = false
jps.Macro = "jpsMacro"

-- Slash Cmd
SLASH_jps1 = '/jps'

-- Function Shorthands
cd = GetSpellCooldown
ub = UnitBuff
ud = UnitDebuff

combatFrame = CreateFrame("FRAME", nil)
combatFrame:RegisterEvent("PLAYER_LOGIN")
combatFrame:RegisterEvent("PLAYER_ALIVE")
combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
combatFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
combatFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
combatFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
combatFrame:RegisterEvent("UNIT_SPELLCAST_START")
combatFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
combatFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
combatFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
combatFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
combatFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
combatFrame:RegisterEvent("UI_ERROR_MESSAGE")
combatFrame:RegisterEvent("UNIT_HEALTH")
combatFrame:RegisterEvent("BAG_UPDATE")

function combatEventHandler(self, event, ...)
	if event == "PLAYER_ALIVE" or event == "PLAYER_LOGIN" then
		jps.Class = UnitClass("player")
		jps.Spec = jps.Specs[jps.Class][jps.lolfindspec()]
		if jps.Spec then print (":::: JPS Online for your",jps.Spec,jps.Class,"::::") end
		if not jps.Enabled then IconFrame:Hide() end
	elseif event == "PLAYER_REGEN_DISABLED" then
		jps.Combat = true
		if jps.Enabled then combat() end
	elseif event == "PLAYER_REGEN_ENABLED" then
		jps.Combat = false
		jps.Opening = true
		jps.OutofCombat = true
		if jps.OutofCombatEnabled then outofcombat() end
		jps.RaidStatus = {}
		collectgarbage("collect")
	-- Casting - Credit (and thanks!) to walkistalki for the channeling and pet stuff.
	elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_SENT" then
		if ... == "player" then
			jps.Casting = true
		end
  elseif (event == "UNIT_SPELLCAST_SUCCEEDED" and (UnitChannelInfo("player") == nil)) or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if ... == "player" then
			jps.Casting = false
		end
  elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or (event == "UNIT_SPELLCAST_CHANNEL_UPDATE" and (UnitChannelInfo("player")==nil))then
		if ... == "player" then
			jps.Casting = false
		end
	-- Fishes
	elseif event == "BAG_UPDATE" and jps.Fishing then
		RunMacro("MG")
		RunMacro("MGG")
	-- UI Error checking - for LoS and Shred-fails.
	elseif event == "UI_ERROR_MESSAGE" and jps.Enabled then
		jps.Error = ...
		if jps.Error == "You must be behind your target." and jps.ThisCast == "shred" then
			jps.Cast("mangle(cat form)")
		elseif jps.Error == "You must be behind your target." and jps.ThisCast == "hemorrhage" then
			jps.Cast("mutilate")
		end
	-- RaidStatus Update
	elseif event == "UNIT_HEALTH" and jps.Enabled then
		local unit = ...
		if UnitIsFriend("player",unit) then
			jps.RaidStatus[unit] = { ["hp"] = UnitHealth(unit), ["hpmax"] = UnitHealthMax(unit), ["freshness"] = 0 }
		end
	end
end

function jps.lolfindspec()
	
	--Do you know Crusader Strike? Then you're a Ret Pally.
	if IsSpellKnown(35395) == true then return 18 end
	
	--Do you know Holy Light, Rank 1? 
	--Do you not have enough talents to really be defined in a spec? 
	--Then you're a nub Pally.
	if IsSpellKnown(635) == true and not (IsSpellKnown(35395)) then return 10 end
	
	--Do you know Mutilate? Then you're an Assassination Rogue.
	if IsSpellKnown(1329) == true then return 22
	
	end
end
	

combatFrame:SetScript("OnEvent", combatEventHandler)

function SlashCmdList.jps(msg, editbox)
	if msg == "toggle" or msg == "t" then
		if jps.Enabled == false then msg = "e"
		else msg = "d" end
	end
	if msg == "disable" or msg == "d" then
		jps.Enabled = false
		IconFrame:Hide()
		print "JPS Disabled."
	elseif msg == "enable" or msg == "e" then
		jps.Enabled = true
		jps.NextCast = nil
		IconFrame:Show()
		print "JPS Enabled."
	elseif msg == "outofcombaton" or msg == "ooce" then
		jps.OutofCombat = true
		jps.nextcast = nil
		IconFrame:Show()
		print "Out of Combat behaviors enabled"
	elseif msg == "outofcombatoff" or msg == "oocd" then
		jps.OutofCombat = false
		IconFrame:Hide()
		print "Out of combat behaviors disabled"
	elseif msg == "panther" then
		jps.Panther = not jps.Panther
		print("T11 4pc use set to",jps.Panther)
	elseif msg == "fishing" then
		jps.Fishing = not jps.Fishing
		print("Murglesnout & Grey Deletion now",jps.Fishing)
	elseif msg == "debug" then
		jps.Debug = not jps.Debug
		print("Debug mode set to",jps.Debug)
	elseif msg == "multi" or msg == "multitarget" then
		jps.MultiTarget = not jps.MultiTarget
		print("MultiTarget mode set to",jps.MultiTarget)
	elseif msg == "cds" then
		jps.UseCDs = not jps.UseCDs
		print("Cooldown use set to",jps.UseCDs)
	elseif msg == "int" or msg == "interrupts" then
		jps.Interrupts = not jps.Interrupts
		print("Interrupt use set to",jps.Interrupts)
	elseif msg == "spam" or msg == "macrospam" or msg == "macro" then
		jps.MacroSpam = not jps.MacroSpam
		print("MacroSpam flag is now set to",jps.MacroSpam)
	elseif msg == "havoc" then
		jps.Havoc = not jps.Havoc
		print("Bane of Havoc flag is now set to",jps.Havoc)
	elseif msg == "opening" then
		jps.Opening = not jps.Opening
		print("Opening flag is now set to",jps.Opening)
	elseif msg == "pvpe" then
		jps.PvP = true
	elseif msg == "pvpd" then
		jps.PvP = false
	elseif msg == "help" then
		print("Slash Commands:")
		print("/jps - Show enabled status.")
		print("/jps enable/disable - Enable/Disable the addon.")
		print("/jps spam - Toggle spamming of a given macro.")
		if jps.Spec == "Feral" then
			print("/jps panther - Toggle Feral T11 4pc.")
		end
		print("/jps cds - Toggle use of cooldowns.")
		print("/jps pew - Spammable macro to do your best moves, if for some reason you don't want it fully automated")
		print("/jps interrupts - Toggle interrupting")
		print("/jps pvpe - Enable PvP behaviors")
		print("/jps pvpd - Disable PvP behaviors")
		print("/jps ooce - Enable the out of combat behaviors")
		print("/jps oocd - Disable the out of combat behaviors")
		print("/jps help - Show this help text.")
	elseif msg == "pew" then
		combat()
	else
		if jps.Enabled then
			print("JPS v"..jps.Version.." Enabled - Ready and Waiting.")
		else 
			print "JPS Disabled - Waiting on Standby."
		end
		print("jps.UseCDs:",jps.UseCDs)
		print("jps.Opening:",jps.Opening)
		print("jps.Interrupts:",jps.Interrupts)
		if jps.Spec == "Feral" then
			print("jps.Panther:",jps.Panther)
		end
		print("jps.MacroSpam:",jps.MacroSpam)
		print("jps.Fishing:",jps.Fishing)
	end
end

function JPS_OnUpdate(self,elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed
	if (self.TimeSinceLastUpdate > jps.UpdateInterval) then
		if jps.MacroSpam and not jps.Casting then
			RunMacro(jps.Macro)
		elseif jps.Combat and jps.Enabled then
			combat()
			self.TimeSinceLastUpdate = 0
		end
	end
end

function combat(self) 
	-- Rotations
	jps.Rotations = { 
		["Druid"] = { ["Feral"] = druid_feral, ["Balance"] = druid_balance, ["Restoration"] = druid_resto },
		["Death Knight"] = { ["Blood"] = dk_blood },
		["Shaman"] = { ["Enhancement"] = shaman_enhancement, ["Elemental"] = shaman_elemental },
		["Paladin"] = { ["Protection"] = paladin_protadin, ["Retribution"] = paladin_ret, ["NubPally"] = paladin_nub },
		["Warlock"] = { ["Destruction"] = warlock_destro, ["Demonology"] = warlock_demo, ["Affliction"] = warlock_affliction},
		["Hunter"] = { ["Marksmanship"] = hunter_mm, ["Beast Mastery"] = hunter_bm },
		["Mage"] = { ["Fire"] = mage_fire, ["Arcane"] = mage_arcane },
		["Warrior"] = { ["Fury"] = warrior_fury, ["Protection"] = warrior_prot },
		["Priest"] = { ["Shadow"] = priest_shadow, ["Holy"] = priest_shadow },
		["Rogue"] = { ["Assassination"] = rogue_assassination, ["Combat"] = rogue_combat, ["Subtlety"] = rogue_subtlety}
	}
	-- Check for the Rotation
	if not jps.Rotations[jps.Class] or not jps.Rotations[jps.Class][jps.Spec] then
		print("Sorry! JPS does not yet have a rotation for your",jps.Spec,jps.Class.."...yet.")
		jps.Enabled = false
		return
	end
	-- Lag
	_,_,jps.Lag = GetNetStats()
	jps.Lag = jps.Lag/100
	-- Movement
	jps.Moving = GetUnitSpeed("player") > 0
	-- Get spell from rotation.
	jps.ThisCast = jps.Rotations[jps.Class][jps.Spec]()
	-- Check spell usability.
	if jps.ThisCast then
		jps.Cast(jps.ThisCast)
	end
	-- Hide Error
	StaticPopup1:Hide()
	-- Return spellcast.
	return jps.ThisCast
end

function outofcombat(self) 
	-- Rotations
	jps.Rotations = { 
		["Druid"] = { ["Feral"] = druid_feral, ["Balance"] = druid_balance, ["Restoration"] = druid_resto },
		["Death Knight"] = { ["Blood"] = dk_blood },
		["Shaman"] = { ["Enhancement"] = shaman_enhancement, ["Elemental"] = shaman_elemental },
		["Paladin"] = { ["Protection"] = paladin_protadin, ["Retribution"] = paladin_ret, ["NubPally"] = paladin_nub },
		["Warlock"] = { ["Destruction"] = warlock_destro, ["Demonology"] = warlock_demo, ["Affliction"] = warlock_affliction},
		["Hunter"] = { ["Marksmanship"] = hunter_mm, ["Beast Mastery"] = hunter_bm },
		["Mage"] = { ["Fire"] = mage_fire, ["Arcane"] = mage_arcane },
		["Warrior"] = { ["Fury"] = warrior_fury, ["Protection"] = warrior_prot },
		["Priest"] = { ["Shadow"] = priest_shadow, ["Holy"] = priest_shadow },
		["Rogue"] = { ["Assassination"] = rogue_assassination, ["Combat"] = rogue_combat, ["Subtlety"] = rogue_subtlety}
	}
	-- Check for the Rotation
	if not jps.Rotations[jps.Class] or not jps.Rotations[jps.Class][jps.Spec] then
		print("Sorry! JPS does not yet have a rotation for your",jps.Spec,jps.Class.."...yet.")
		jps.Enabled = false
		return
	end
	-- Lag
	_,_,jps.Lag = GetNetStats()
	jps.Lag = jps.Lag/100
	-- Movement
	jps.Moving = GetUnitSpeed("player") > 0
	-- Get spell from rotation.
	jps.ThisCast = jps.Rotations[jps.Class][jps.Spec][ooc]()
	-- Check spell usability.
	if jps.ThisCast then
		jps.Cast(jps.ThisCast)
	end
	-- Hide Error
	StaticPopup1:Hide()
	-- Return spellcast.
	return jps.ThisCast
end
