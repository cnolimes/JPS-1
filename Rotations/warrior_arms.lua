function warrior_arms(self)
   local spell = nil
   local playerHealth = UnitHealth("player")/UnitHealthMax("player")
   local targetHealth = UnitHealth("target")/UnitHealthMax("target")
   local nSang = UnitBuff("player","Bloodsurge")
   local nEnrage = UnitBuff("player","Enrage")
   local nRage = UnitBuff("player","Berserker Rage")
   local nVict = UnitBuff("player","Victorious")
   local nPower = UnitPower("Player",1) -- Rage est PowerType 1



   if cd("Battle Shout")==0 and not ub("player","Battle Shout") and not ub("player","Roar of Courage") and not ub("player","Horn of Winter") and not ub("player","Strength of earth totem") then
      spell = "Battle Shout" 
   elseif ub("player","cheap shot") then
      spell = "berserker rage"
   elseif cd("Pummel")==0 and IsSpellInRange("Pummel","target")==1 and jps.ShouldKick("target") then
      spell = "Pummel"
   elseif nVict~=nil and playerHealth<0.9 then 
      spell = "Victory Rush"
   elseif cd("Execute")==0 and targetHealth<0.2 then 
      spell = "Execute"
   elseif cd("rend")==0 and not ub("target","Rend") then
      spell = "Rend"
   elseif cd("mortal strike")==0 then
      spell = "mortal Strike"
   elseif cd("Heroic Strike")==0 and nPower>80 then
      spell = "Heroic Strike"
   elseif cd("overpower")==0 then
      spell = "overpower"
   elseif cd("Slam")==0 then
      spell = "Slam"
   end
   return spell
end
