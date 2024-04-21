--IMPROVEMENT
--[[In the case that there is no reason for the 1 second delay 
(seeing as it could add up over time, especially when many people are logging out), 
we could just call releaseStorage without a scheduled event]]

function onLogout(player)
  if player:getStorageValue(1000) == 1 then
    releaseStorage(player)
  end
  return true
end
--FIX
--[[However, if the 1 second delay was wanted, and we were doing something on the
client side, addEvent is no longer the function to handle matters like these. 
It doesn't have a 'delay' like when on the server. We would want to use scheduleEvent]]

function onLogout(player)
  if player:getStorageValue(1000) == 1 then
    scheduleEvent(releaseStorage(player), 1000)
  end
  return true
end


--INITIAL
local function releaseStorage(player)
  player:setStorageValue(1000, -1)
end

function onLogout(player)
  if player:getStorageValue(1000) == 1 then
    addEvent(releaseStorage, 1000, player)
  end
  return true
end