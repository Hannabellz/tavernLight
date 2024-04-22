local direction --in reference to North, South, East, and West for player direction
local currPosition --what can be a valid landing position so long as player can move at least one tile
local maxDistance = 6 --can only dash up to 6 blocks at a time
local nextPosition --to look and see if the next tile can be valid to get to
local nextTile --works in conjunction with nextPosition to see if a Tile is walkable

---will be used for comparing against the direction--
local NORTH = 2
local EAST = 1
local SOUTH = 0

function init()
  g_keyboard.bindKeyDown('3', dash) --makes it so the dash ability is activated when 3 is pressed
end

function positionCheck(currPos) --responsible for updating nextPosition based on the direction the player is facing. Change x for East and West, Change Y for North and South
  nextPosition = {x=currPos.x, y=currPos.y, z=currPos.z}
  if direction == NORTH then
	nextPosition.y = currPos.y+1
  elseif direction == EAST then
    nextPosition.x = currPos.x+1
  elseif direction == SOUTH then
    nextPosition.y = currPos.y-1
  else
    nextPosition.x = currPos.x-1
  end
  return nextPosition
end

function stringifyInfo(pos, dist, dir) --responsible for preparing what will get sent to the server. Consists of a valid position to go to, the distance traveled from the starting tile, and the direction the player is dashing
  local stringify = pos.x .. "," .. pos.y .. "," .. pos.z .. "," .. dist .. "," .. dir
  return stringify --the commas separating each of the values will help with the client's splitting of the buffer
end

function dash()
  player = g_game.getLocalPlayer() --get reference to player about to dash
  direction=player:getDirection() --get the direction they're facing (cardinal coordinates)
  currPosition = player:getPosition() --get the coordinates of where they're presently standing
  local toTravel = 0 --will be used to compare against maxDistance and keep track of how far player can/will go
  local toSend = "" --will be the final string sent through to the server
  nextPosition = positionCheck(currPosition) --get the first tile that may or may not be able to be walked on
  nextTile = g_map.getTile(nextPosition) --obtained to check if the next position can be walked on or if there's something obstructing the path
  while toTravel<maxDistance and nextTile and nextTile:isWalkable(false) do --while the player's traveled < 6 tiles and the next tile is walkable
    toTravel = toTravel+1
	currPosition = nextPosition --if it's gotten this far in, we can move currPosition to next
	toSend = toSend .. stringifyInfo(currPosition, toTravel,direction) .. "$" --each separate valid position that can be traveled will be able to be separated on the server side by the $
	nextPosition = positionCheck(currPosition) 
	nextTile = g_map.getTile(nextPosition) --update to the next tile to redo the checking sequence
  end
  if toTravel > 0 then --so long as traveling did happen
	local protocolGame = g_game.getProtocolGame()
	if protocolGame then
	  protocolGame:sendExtendedOpcode(52, toSend) --send with the extended opcode to the server
	end
  end
end

function terminate() --clean up when done
  g_keyboard.unbindKeyDown('3')
  local direction = nil
  local currPosition = nil
  local maxDistance = nil
  local nextPosition = nil
  local nextTile = nil
  local NORTH = nil
  local EAST = nil
  local SOUTH = nil
end