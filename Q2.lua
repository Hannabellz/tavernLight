--FIX
--[[As it presently stands, there's no way that all guilds would be printed
since there's no looping through the result]]

function printSmallGuildNames(memberCount)
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
  if resultId then
    repeat
      local guildName = result.getString(resultId, "name") --need to reference resultId since that's the reference to what we got from the query
	  print(guildName)
    until not result.next(resultId) --end condition for the repeat is when there is no more results
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