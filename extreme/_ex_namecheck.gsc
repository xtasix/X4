init()
{
	level endon("ex_gameover");

	mononames = [];

	while(!level.gameEnded)
	{
		// Wait a couple of seconds
		wait 2;

		// Get the active players
		players = level.players;
		maxplayers = players.size;

		// Remove color codes from player names, and init vars
		for(i = 0; i < maxplayers; i++)
		{
			if(isPlayer(players[i])) mononames[i] = extreme\_ex_utils::monotone(players[i].name);

			// If player did not spawn yet, these vars are not available to evaluate, so define them
			if(!isDefined(players[i].ex_isunknown))
			{
				players[i].ex_isunknown = false;
				players[i].ex_ispunished = false;
				players[i].ex_isdupname = false;
			}
		}

		// If enabled, check for Unknown Soldiers and other unacceptable names
		if(level.ex_uscheck)
		{
			for(i = 0; i < maxplayers; i++)
			{
				// Proceed only if not already handled by Unknown Soldier or Duplicate Name handling code
				if(isPlayer(players[i]) && !players[i].ex_isunknown && !players[i].ex_ispunished && !players[i].ex_isdupname)
				{
					if(extreme\_ex_main::isUnknown(players[i]))
					{
						// Got one! If playing right now then start the handling code.
						if(players[i].sessionstate == "playing") players[i] thread extreme\_ex_main::handleUnknown(false);
							// Otherwise tag him, so we can handle it when he spawns.
							else players[i].ex_isunknown = true;
					}
				}
			}
		}

		// If there is nothing to compare, skip the duplicate name test
		if(maxplayers < 2) continue;

		// Check for duplicate names
		for(i = 0; i < maxplayers-1; i++)
		{
			for(j = i+1; j < maxplayers; j++)
			{
				if(mononames[i] == mononames[j])
				{
					// Got one! Proceed only if player is not already handled by Name Checker code
					if(isPlayer(players[j]) && !players[j].ex_isdupname)
					{
						// Proceed only if player is not already handled by Unknown Soldier handling code
						if(!players[j].ex_isunknown)
						{
							// If playing right now then start the handling code.
							if(players[j].sessionstate == "playing") players[j] thread extreme\_ex_main::handleDupName();
								// Otherwise tag him, so we can handle it when he spawns.
								else players[j].ex_isdupname = true;
						}
						// Otherwise tag him, so the Unknown Soldier handling code can act on it
						else players[j].ex_isdupname = true;
					}
				}
			}
		}
		// Wait a couple of seconds
		wait 2;
	}
}
