--IMPROVEMENT
--FIX
[[As it presently stands, there's no way that all guilds would be printed
since there's no looping through the result]]

function printSmallGuildNames(memberCount)
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
  local tmpResultId = resultId --keep what we're working with separate from the original, especially helps when we're doing multiple things with a result
  while tmpResultId do --while there is more data to print
    local guildName = result.getString(tmpResultId, "name")
	print(guildName)
	tmpResultId = result.next(resultId) --makes sure we aren't stuck in the while loop forever
  end
  if resultId then
    result.free(resultId) --helps make sure we're only using what we need and keep things clean
  end
end

--INITIAL
function printSmallGuildNames(memberCount)
-- this method is supposed to print names of all guilds that have less than memberCount max members
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
  local guildName = result.getString("name")
  print(guildName)
end