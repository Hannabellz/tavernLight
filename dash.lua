function destroyMonster(monster)
  doRemoveCreature(monster) --called after half a second to remove all the clones
end

function spawnCopies(outfit, loc) --responsible for spawning the clones on each of the blocks between start and end destination
  local monster = doSummon(" ", Position(loc[1], loc[2], loc[3])) --summons the clone referenced in mimic.lua and places it on specific tile
  if monster then
    monster:setHiddenHealth(true) --hides health bar
    monster:setDirection(loc[5]) --clone will face in the same direction as player
    monster:setOutfit(outfit) --set the outfit to match the player's appearance
    addEvent(destroyMonster, 500, monster:getId()) --make sure they get destroyed
  end 
end

function outfitAndTeleport(player, outfit, newPosition)
  local play = Player(player) --creating a new player reference prevents warning about sending direct player reference as being unsafe
  play:setOutfit(outfit) --setting outfit back to what it was before dash began
  play:teleportTo(newPosition) --teleporting player into final position
end

function onExtendedOpcode(player, opcode, buffer) --responsible for communication with client side, receives the information sent
  if opcode == 52 then
    local myValue = {} --this will be a table of tables. Each "row" will consist of a position's x, y, z, the total distance traveled from the starting location to that space, and the direction the player's facing for the command
	local i = 1
	for loc in string.gmatch(buffer, '[^$]+') do
	  table.insert(myValue, {}) --set up each row. In the buffer, they were separated by $
	  for coord in string.gmatch(loc, '[^,]+') do
	    table.insert(myValue[i], coord) --insert each of the aforementioned values, which were input into the buffer separated by ,
	  end
	  i = i+1
	end
	local endLoc = myValue[#myValue] --the information for the last tile the player will end up on
	local newPosition = Position(endLoc[1], endLoc[2], endLoc[3])
	local outfit = getCreatureOutfit(player:getId()) --get reference to base player appearance
	player:setOutfit({}) -- makes player invisible
	for i = 1, #myValue-1 do --for each index aside from the last since we don't want to try to spawn a clone where the player is
	  addEvent(spawnCopies, 100*i-1, outfit, myValue[i]) --call in to spawn the cloned creatures with a slight delay between each
	end
	addEvent(outfitAndTeleport, 100*#myValue, player:getId(), outfit, newPosition) --reset the outfit back to how it had been prior to change, teleport player to ending location
  end
end

