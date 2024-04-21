local jumpWindow
local jumpButton --Both jump variables correspond to the Modal (window and button)
local marginRight = 0
local marginTop
local maxDist = 220 --max values away from top/right margins of the window that the button can go
local cancel --to reference the scheduled event to be cancelled when jump button is pressed
-- public functions
function init()
  g_keyboard.bindKeyDown('1', loadJump) --just so it isn't there all the time onload, press 1 to show and start the process
end

local function acrossScreen() --the function responsible for moving the jump button across the modal window.
  marginRight = marginRight+2.5 --every time it gets called move 2.5 units away from the right margin
  jumpButton:setMarginRight(marginRight)
  if marginRight<maxDist then 
	cancel = scheduleEvent(acrossScreen,100) --every 100 ms, call acrossScreen to keep moving
  else
	jump() --if it hits the left edge of the modal, go right to jump (which also gets called when jumpButton is clicked, as per the OTUI file)
  end
end

function loadJump()
  if not jumpWindow then
    jumpWindow=g_ui.displayUI('jumpbuttonmodal')
    jumpButton=jumpWindow:getChildById('jumpButton')
  else
	jumpButton:destroy() --if you want to keep playing the main game, you can close the window the same way it was opened pressing '1'
    jumpWindow:destroy()
  end
  jumpButton:setMarginRight(0) --makes sure to start the button at the far right of the window
  scheduleEvent(acrossScreen,100)
end

function jump()
  marginTop = math.random(0,maxDist) --random distance from top for the button to jump to when it's been clicked/reached the left side of the modal
  jumpButton:setMarginTop(marginTop)
  jumpButton:setMarginRight(0) --start from right side of the modal again
  marginRight=0
  removeEvent(cancel) --removes any previously scheduled events before starting the process again
  scheduleEvent(acrossScreen,100)
end

function terminate()
  jumpButton:destroy()
  jumpWindow:destroy()
  g_keyboard.unbindKeyDown('1')
end