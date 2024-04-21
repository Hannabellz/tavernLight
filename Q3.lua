--FIX/IMPROVEMENT
--[[We always want our function names to help with quick identification of what
a function is responsible for. "Something" would require more time to look and
see if this is even the function we want. There'll also be smaller details that can
be adjusted here.]]

function removeMemberFromParty(playerId, membername) --now there's no need to scan the statements and loops to know what the function does, makes it easier to use and future developers knows what it does too
  player = Player(playerId)
  local party = player:getParty()
  if party then --in case the player does not have a party, we don't want to make function calls on a nil value. Checking if there is a party will prevent that.
    for k,v in pairs(party:getMembers()) do
      if v == Player(membername) then
        party:removeMember(v) --if v is already equal to the Player we want to remove, we can make this line more concise
      end
    end
  end
end

--INITIAL
function do_sth_with_PlayerParty(playerId, membername)
  player = Player(playerId)
  local party = player:getParty()
  for k,v in pairs(party:getMembers()) do
    if v == Player(membername) then
      party:removeMember(Player(membername))
    end
  end
end