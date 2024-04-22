local mType = Game.createMonsterType(" ") --name of monster, display as blank
local monster = {}
monster.description = "temporary copy of player"
monster.speed = 0 -- keep from moving

monster.flags = {
	attackable = false, --more illusions than monsters, so won't try to attack and cannot be attacked
	hostile = false,
	challengeable = false,
	convinceable = false,
	ignoreSpawnBlock = false,
	illusionable = true
}
mType:register(monster)
