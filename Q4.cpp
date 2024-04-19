//FIXING THE MEMORY LEAK
/*With languages like C++ that can dynamically allocate memory, whenever a developer
asks for it to do so, it is up to them to also give that memory back once it is done
being used. Otherwise, it leads to a memory leak with the one below. When we have
player = new Player(nullptr);
the "new" keyword is what we need to be wary of. And without there being a "delete"
before the few possible function returns, we know there is a problem.*/

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);
	bool newPlayer = false; //since player could be already initalized, we want to know when the new keyword gets used
	if (!player) {
		player = new Player(nullptr);
		newPlayer = true;
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			delete(player); //one of the places where it can return, we want to delete what's associated with new
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		if (newPlayer){
			delete(player); //another return spot
		}
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}
	if (newPlayer){
		delete(player); //and since this is the last return spot of the function, we'll delete here too
	}
}

/*When doing research about this, I had seen notes about the benefits of RAII.
If I had known for sure that the client/server support the unique pointers
that can be made so that the deallocation happened on its own at the end of
scope, along with if player was always using the new keyword, I would've been
more tempted to use it. But considering these things and knowing for sure that delete
handles it when it's hit- it's just a matter of making sure it gets hit- I went
with this method for now.*/



//INITIAL
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);
	if (!player) {
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}
}