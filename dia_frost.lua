local combat = {} --array to match the array of areas for the extended animation
local animationDelay = 400 --milliseconds between each new animation start
local CONST_ME_DIAFROST = 176 --id of the effect I added into Tibia.dat
local area = { --this was used just to map out the "full" pattern (when all possible blocks would have sprites)
  {0, 0, 0, 1, 0, 0, 0},
  {0, 0, 1, 0, 1, 0, 0},
  {0, 1, 0, 1, 0, 1, 0},
  {1, 0, 1, 2, 1, 0, 1},
  {0, 1, 0, 1, 0, 1, 0},
  {0, 0, 1, 0, 1, 0, 0},
  {0, 0, 0, 1, 0, 0, 0}
}
local animArea = { --the patterns that will spawn in the tornados in intervals rather than all at once right away like above
    {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {1, 0, 0, 2, 0, 0, 1},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 1, 0, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0}
    },
    {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 2, 0, 0, 0},
      {0, 0, 0, 1, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
    {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {1, 0, 1, 2, 1, 0, 1},
      {0, 0, 0, 1, 0, 1, 0},
      {0, 0, 1, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
	{
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 2, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
	area
}

for i = 1, #animArea do --following the example of other spells, just in the array fashion needed because we will have more than one combat area based on where tornadoes are when
  combat[i] = Combat()
  combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DIAFROST) --what attack animation gets played (my version of the ice tornado)
  combat[i]:setArea(createCombatArea(animArea[i])) --creates areas of combat based on 1s in matrix
end

function executeCombat(p, i)
    local index = i%#animArea
	if index>0 then
	  p.combat[i%#animArea]:execute(p.player, p.var)
	else
	  p.combat[#animArea]:execute(p.player, p.var)
	end
end
--[[Knows which combat to execute based on what was set up in for loop.
Since we are iterating through animArea twice, we can get the proper
index with %. 1%5=6%5=1. But because areas aren't indexed at 0, there
is an else to look at the last index instead.]]

function onCastSpell(creature, variant)
  local p = {player = creature, var = variant, combat = combat}
  for i = 1, #animArea * 2 do
    addEvent(executeCombat, animationDelay * (i-1), p, i)
  end
  return true
end
--[[Setup for each area's combat to be executed based on a delay, 
which is in turn based on the number of animations played before.]]
