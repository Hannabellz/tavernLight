--IMPROVEMENT
[[In the case that there is no reason for the 1 second delay 
(seeing as it could add up over time), we could just call releaseStorage without
a scheduled event]]

function onLogout(player)
  if player:getStorageValue(1000) == 1 then
    releaseStorage(player)
  end
  return true
end
--FIX
[[However, if the 1 second delay was wanted, addEvent is no longer responsible
for handling events like these. It doesn't even have a 'delay' anymore. We would
want to use scheduleEvent]]

function onLogout(player)
  if player:getStorageValue(1000) == 1 then
    scheduleEvent(releaseStorage, 1000, player)
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