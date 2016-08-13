init()
{
	level.ex_maps = [];

	// Catch-all map. KEEP THIS INDEX 0!
	level.ex_maps[0] = spawnstruct();
	level.ex_maps[0].mapname = "";
	level.ex_maps[0].longname = "Non-localized map name";
	level.ex_maps[0].loclname = &"Non-localized map name";
	level.ex_maps[0].gametype = "dm war";

	// Add stock and custom maps
	config\_ex_votemaps::init();

	// Check if all maps in the list actually exist on the server
	// WARNING: DISABLED BECAUSE THE MAPEXISTS FUNCTION BREAKS ON-DEMAND DOWNLOADING
/*
	for(i = 1; i < level.ex_maps.size; i++)
	{
		if(!mapexists(level.ex_maps[i].mapname))
		{
			logprint("ERROR: map " + level.ex_maps[i].mapname + " does not exist. Map has been removed from the list!\n");
			for(j = i; j < level.ex_maps.size - 1; j++)
			{
				level.ex_maps[j].mapname = level.ex_maps[j + 1].mapname;
				level.ex_maps[j].longname = level.ex_maps[j + 1].longname;
				level.ex_maps[j].loclname = level.ex_maps[j + 1].loclname;
				level.ex_maps[j].gametype = level.ex_maps[j + 1].gametype;
			}
			level.ex_maps[level.ex_maps.size - 1] = undefined;
			i--;
		}
		else
		{
			if(!isDefined(level.ex_maps[i].gametype))
				level.ex_maps[i].gametype = level.ex_maps[0].gametype;
		}
	}
*/

	// Dump list to log (unsorted)
	//for(i = 1; i < level.ex_maps.size; i++)
	//	logprint("map " + i + ": " + extreme\_ex_utils::monotone(level.ex_maps[i].longname) + " (" + level.ex_maps[i].mapname + ")\n");

	// Sort the array
	bubbleSort(1, level.ex_maps.size - 1);

	// Dump list to log (sorted)
	//for(i = 1; i < level.ex_maps.size; i++)
	//	logprint("map " + i + ": " + extreme\_ex_utils::monotone(level.ex_maps[i].longname) + " (" + level.ex_maps[i].mapname + ")\n");

	// Pre-cache map long names
	for(i = 0; i < level.ex_maps.size; i++)
		PrecacheString(level.ex_maps[i].loclname);
}

bubbleSort(start, max)
{
	for(i = start; i < max; i++)
	{
		for(x = start; x <= max-i; x++)
		{
			r = strCompare(x, x+1);
			if(r == 2) mapSwap(x, x+1);
		}
	}
}

start()
{
	wait(1);
	if(PrepareMapVote()) RunMapVote();
}

strCompare(istr1, istr2)
{
	ascii = " !#$%&'()*+,-.0123456789:;<=>?@AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz[]^_`{|}~";
	if(level.ex_maps[istr1].longname.size <= level.ex_maps[istr2].longname.size)
	{
		mode = 1;
		str1 = extreme\_ex_utils::monotone(level.ex_maps[istr1].longname);
		str2 = extreme\_ex_utils::monotone(level.ex_maps[istr2].longname);
	}
	else
	{
		mode = 2;
		str1 = extreme\_ex_utils::monotone(level.ex_maps[istr2].longname);
		str2 = extreme\_ex_utils::monotone(level.ex_maps[istr1].longname);
	}
	size1 = str1.size;
	size2 = str2.size;
	for(i = 0; i < str1.size; i++)
	{
		chr1 = str1[i];
		pos1 = -1;
		for(j = 0; j < ascii.size; j++)
			if(chr1 == ascii[j]) { pos1 = j; break; }

		chr2 = str2[i];
		pos2 = -1;
		for(j = 0; j < ascii.size; j++)
			if(chr2 == ascii[j]) { pos2 = j; break; }

		if(mode == 1)
		{
			if(pos1 < pos2) return 1;
			if(pos1 > pos2) return 2;
		}
		else
		{
			if(pos1 < pos2) return 2;
			if(pos1 > pos2) return 1;
		}
	}
	if(size1 == size2) return 0;
	if(mode == 1) return 1;
		else return 2;
}

mapSwap(i, j)
{
	temp = [];
	temp[0] = spawnstruct();

	temp[0]	= level.ex_maps[i];
	level.ex_maps[i] = level.ex_maps[j];
	level.ex_maps[j] = temp[0];
	
	temp[0] = undefined;
	temp = undefined;
}

PrepareMapVote()
{
	game["menu_team"] = "";

	// Prepare players for vote
	votingplayers = 0;
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player notify("reset_outcome");
		player setClientDvars("cg_everyoneHearsEveryone", 1,
			"g_deadChat", 1,
			"ui_hud_hardcore", 1,
			"cg_drawSpectatorMessages", 0,
			"g_compassShowEnemies", 0);

		player [[level.spawnSpectator]]();
		player setClientdvar("g_scriptMainMenu", "");
		player closeMenu();
		player closeInGameMenu();

		player allowSpectateTeam("allies", false);
		player allowSpectateTeam("axis", false);
		player allowSpectateTeam("freelook", false);
		player allowSpectateTeam("none", true);

		player.mv_allowvote = true;

		// No voting for spectators
		if(isDefined(player.pers["team"]) && player.pers["team"] == "spectator" || player.sessionteam == "spectator")
			player.mv_allowvote = false;

		// No voting for testclients (bots)
		if(isDefined(player.pers["isbot"]) && player.pers["isbot"])
			player.mv_allowvote = false;

		// No voting for non-clan players if clan voting enabled, unless it should be ignored
		if(level.ex_clanvoting && !level.ex_mapvote_ignore_clanvoting)
			if(!isDefined(player.ex_clan) || !isDefined(player.ex_clanid) || !level.ex_clanvote[player.ex_clanid])
				player.mv_allowvote = false;

		// No voting for this player
		//if(player.name == "PatmanSan")
		//	player.mv_allowvote = false;

		if(player.mv_allowvote) votingplayers++;
	}

	// Any players?
	if(votingplayers == 0)
		return false;

	// Use map rotation (mode 0 - 3) or map list (mode 4 and 5)?
	if(level.ex_mapvote_mode < 4)
	{
		// Rotation: get the map rotation queue
		switch(level.ex_mapvote_mode)
		{
			case 1: { x = extreme\_ex_maprotation::GetRandomMapRotation(); break; }
			case 2: { x = extreme\_ex_maprotation::GetPlayerBasedMapRotation(); break; }
			case 3: { x = extreme\_ex_maprotation::GetRandomPlayerBasedMapRotation(); break; }
			default: { x = extreme\_ex_maprotation::GetPlainMapRotation(); break; }
		}

		mv_maprot = undefined;
		if(isDefined(x))
		{
			if(isDefined(x.maps)) mv_maprot = x.maps;
			x delete();
		}

		// Any maps to begin with?
		if(!isDefined(mv_maprot))
			return false;

		// Prepare final array
		if(level.ex_mapvote_max > mv_maprot.size)
		{
			mv_mapvotemax = mv_maprot.size;
			if(level.ex_mapvote_replay) mv_mapvotemax++;
		}
		else mv_mapvotemax = level.ex_mapvote_max;

		// If map vote memory enabled, update the memory
		if(level.ex_mapvote_memory) mapvoteMemory(mv_mapvotemax, level.ex_currentmap);

		level.mv_items = [];
		lastgametype = level.ex_currentgt;
		i = 0;

		// Get candidates
		for(j = 0; j < mv_maprot.size; j++)
		{
			// Make sure we know the game type
			if(!isDefined(mv_maprot[j]["gametype"])) mv_maprot[j]["gametype"] = lastgametype;
				else lastgametype = mv_maprot[j]["gametype"];

			// If map vote memory enabled, skip map if it is in memory
			if(level.ex_mapvote_memory && mapvoteInMemory(mv_maprot[j]["map"]))
				continue;

			// Skip current map and gametype combination
			if(mv_maprot[j]["map"] == level.ex_currentmap && mv_maprot[j]["gametype"] == level.ex_currentgt)
				continue;

			// Fill the candidate entry
			level.mv_items[i]["map"] = mv_maprot[j]["map"];
			level.mv_items[i]["mapname"] = extreme\_ex_maps::getmapstring(mv_maprot[j]["map"]);
			level.mv_items[i]["gametype"] = mv_maprot[j]["gametype"];
			level.mv_items[i]["gametypename"] = extreme\_ex_maps::getgtstringshort(mv_maprot[j]["gametype"]);
			level.mv_items[i]["exec"] = mv_maprot[j]["exec"];
			level.mv_items[i]["votes"] = 0;

			i++;
			if(i == mv_mapvotemax) break;
		}

		// Do we need the last slot for current map (replay)?
		if(level.ex_mapvote_replay)
		{
			if(level.mv_items.size)
			{
				if(level.mv_items.size == level.ex_mapvote_max) replayentry = level.mv_items.size - 1;
					else replayentry = level.mv_items.size;
			}
			else replayentry = 0;

			level.mv_items[replayentry]["map"] = level.ex_currentmap;
			level.mv_items[replayentry]["mapname"] = &"MAPVOTE_REPLAY";
			level.mv_items[replayentry]["gametype"] = level.ex_currentgt;
			level.mv_items[replayentry]["gametypename"] = extreme\_ex_maps::getgtstringshort(level.ex_currentgt);
			level.mv_items[replayentry]["votes"] = 0;
		}

		level.mv_itemsmax = level.mv_items.size;
	}
	else
	{
		// Map List: copy maps from list
		mv_maplist = undefined;
		for(i = 0; i < level.ex_maps.size - 1; i++)
		{
			mv_maplist[i]["map"] = level.ex_maps[i+1].mapname;
			mv_maplist[i]["mapname"] = level.ex_maps[i+1].loclname;
			mv_maplist[i]["gametype"] = level.ex_maps[i+1].gametype;
		}

		// Any maps to begin with?
		if(!isDefined(mv_maplist))
			return false;

		// Randomize list if requested (mode 5, but take anything above 4)
		if(level.ex_mapvote_mode > 4)
		{
			for(i = 0; i < 20; i++)
			{
				for(j = 0; j < mv_maplist.size; j++)
				{
					r = randomInt(mv_maplist.size);
					element = mv_maplist[j];
					mv_maplist[j] = mv_maplist[r];
					mv_maplist[r] = element;
				}
			}
		}

		// Prepare final array
		if(level.ex_mapvote_max > mv_maplist.size)
		{
			mv_mapvotemax = mv_maplist.size;
			if(level.ex_mapvote_replay) mv_mapvotemax++;
		}
		else mv_mapvotemax = level.ex_mapvote_max;

		// If map vote memory enabled, load the memory and add the map we just played
		if(level.ex_mapvote_memory) mapvoteMemory(mv_mapvotemax, level.ex_currentmap);

		level.mv_items = [];
		i = 0;

		// Get candidates
		for(j = 0; j < mv_maplist.size; j++)
		{
			// If map vote memory enabled, skip map if it is in memory
			if(level.ex_mapvote_memory && mapvoteInMemory(mv_maplist[j]["map"]))
				continue;

			// Skip current map
			if(mv_maplist[j]["map"] == level.ex_currentmap)
				continue;

			// Make sure we have a game type to vote for
			if(mv_maplist[j]["gametype"] == "") mv_maplist[j]["gametype"] = "dm tdm";

			level.mv_items[i]["map"] = mv_maplist[j]["map"];
			level.mv_items[i]["mapname"] = mv_maplist[j]["mapname"];
			level.mv_items[i]["gametype"] = mv_maplist[j]["gametype"];
			level.mv_items[i]["gametypename"] = "";
			level.mv_items[i]["votes"] = 0;

			i++;
			if(i == mv_mapvotemax) break;
		}

		// Do we need the last slot for current map (replay)?
		if(level.ex_mapvote_replay)
		{
			if(level.mv_items.size)
			{
				if(level.mv_items.size == level.ex_mapvote_max) replayentry = level.mv_items.size - 1;
					else replayentry = level.mv_items.size;
			}
			else replayentry = 0;

			level.mv_items[replayentry]["map"] = level.ex_currentmap;
			level.mv_items[replayentry]["mapname"] = &"MAPVOTE_REPLAY";
			level.mv_items[replayentry]["gametype"] = level.ex_currentgt;
			level.mv_items[replayentry]["gametypename"] = extreme\_ex_maps::getgtstringshort(level.ex_currentgt);
			level.mv_items[replayentry]["votes"] = 0;
		}

		level.mv_itemsmax = level.mv_items.size;
	}

	// Any maps left?
	if(level.mv_itemsmax == 0) return false;
	return true;
}

RunMapVote()
{
	level.mv_perpage = 7; // default: 8
	level.mv_width = 260; // default: 260. max: 640. eXtremeGamerz setting: 460
	level.mv_originx1 = int((640 - level.mv_width) / 2);
	level.mv_originx2 = level.mv_originx1 + level.mv_width; // int( 320 + (level.mv_width / 2));

	if(level.ex_mapvote_mode < 4) thread VoteLogicRotation();
		else thread VoteLogicList();

	level waittill("VotingComplete");
}

VoteLogicRotation()
{
	// Big brother is watching votes (rotation based)
	CreateHud();

	// Start voting threads for players
	level.mv_stage = 1;
	players = level.players;
	for(i = 0; i < players.size; i++)
		if(players[i].mv_allowvote) players[i] thread PlayerVoteMAP();
			else players[i] thread PlayerNoVote();

	for(; level.ex_mapvote_time >= 0; level.ex_mapvote_time--)
	{
		for(t = 0; t < 10; t++)
		{
			// Reset votes
			for(i = 0; i < level.mv_itemsmax; i++) level.mv_items[i]["votes"] = 0;

			// Get current players
			players = level.players;

			// Spawn no-vote thread for new players (joined during vote)
			for(i = 0; i < players.size; i++)
			{
				if(isPlayer(players[i]) && !isDefined(players[i].mv_allowvote))
				{
					players[i].mv_allowvote = false;
					players[i] thread PlayerNoVote();
				}
			}

			// Recount votes
			for(i = 0; i < players.size; i++)
				if(players[i].mv_allowvote && players[i].mv_choice != 0)
					level.mv_items[players[i].mv_choice - 1]["votes"]++;

			// Update votes on player's HUD, depending on page displayed (scary stuff)
			for(i = 0; i < players.size; i++)
			{
				if(players[i].mv_allowvote)
				{
					if(players[i].mv_flipchoice != 0) isonpage = onPage(players[i].mv_flipchoice);
						else isonpage = onPage(players[i].mv_choice);
					for(j = 0; j < maxItemsOnPage(isonpage); j++)
						players[i].mv_votes[j] setValue(level.mv_items[(isonpage * level.mv_perpage)-level.mv_perpage+j]["votes"]);
				}
			}

			wait .1;
		}
		// Update time left HUD
		level.mv_timeleft setValue(level.ex_mapvote_time);
	}

	// Signal voting threads to end, and wait for threads to die
	level notify("VotingDone");
	wait 0.2;

	// Fade HUD elements
	FadeHud();

	// Destroy all HUD elements
	DeleteHud();

	// Count the votes
	mv_newitemnum = 0;
	mv_topvotes = 0;
	for(i = 0; i < level.mv_itemsmax; i++)
	{
		if(level.mv_items[i]["votes"] > mv_topvotes)
		{
			mv_newitemnum = i;
			mv_topvotes = level.mv_items[i]["votes"];
		}
	}

	// Select the winning map and game type
	map = level.mv_items[mv_newitemnum]["map"];
	mapname = level.mv_items[mv_newitemnum]["mapname"];
	gametype = level.mv_items[mv_newitemnum]["gametype"];
	gametypename = extreme\_ex_maps::getgtstring(gametype);
	exec = level.mv_items[mv_newitemnum]["exec"];

	// Write to cvars
	if(!isDefined(exec)) exec = "";
		else exec = " exec " + exec;
	setDvar("sv_maprotationcurrent", exec + " gametype " + gametype + " map " + map);
	wait 0.1;

	// Announce winner
	WinnerIs(mapname, gametypename);

	// Signal the end of map vote
	level notify("VotingComplete");
}

VoteLogicList()
{
	// Big brother is watching votes (list based)
	CreateHud();

	// Start voting threads for players
	level.mv_stage = 1;
	players = level.players;
	for(i = 0; i < players.size; i++)
		if(players[i].mv_allowvote) players[i] thread PlayerVoteMAP();
			else players[i] thread PlayerNoVote();

	for(; level.ex_mapvote_time >= 0; level.ex_mapvote_time--)
	{
		for(t = 0; t < 10; t++)
		{
			// Reset votes
			for(i = 0; i < level.mv_itemsmax; i++) level.mv_items[i]["votes"] = 0;

			// Get current players
			players = level.players;

			// Spawn no-vote thread for new players (joined during vote)
			for(i = 0; i < players.size; i++)
			{
				if(isPlayer(players[i]) && !isDefined(players[i].mv_allowvote))
				{
					players[i].mv_allowvote = false;
					players[i] thread PlayerNoVoteNewPlayer();
				}
			}

			// Recount votes
			for(i = 0; i < players.size; i++)
				if(players[i].mv_allowvote && players[i].mv_choice != 0)
					level.mv_items[players[i].mv_choice - 1]["votes"]++;

			// Update votes on player's HUD, depending on page displayed (scary stuff)
			for(i = 0; i < players.size; i++)
			{
				if(players[i].mv_allowvote)
				{
					if(players[i].mv_flipchoice != 0) isonpage = onPage(players[i].mv_flipchoice);
						else isonpage = onPage(players[i].mv_choice);
					for(j = 0; j < maxItemsOnPage(isonpage); j++)
						players[i].mv_votes[j] setValue(level.mv_items[(isonpage * level.mv_perpage)-level.mv_perpage+j]["votes"]);
				}
			}

			wait .1;
		}
		// Update time left HUD
		level.mv_timeleft setValue(level.ex_mapvote_time);
	}

	// Signal voting threads to end, and wait for threads to die
	level notify("VotingStage1Done");
	wait 0.2;

	// Fade HUD elements
	FadePlayerHUDStage1();

	// Destroy the HUD elements which will be recreated for stage 2
	DeletePlayerHudStage1();

	// Count the votes
	mv_newitemnum = 0;
	mv_topvotes = 0;
	for(i = 0; i < level.mv_itemsmax; i++)
	{
		if(level.mv_items[i]["votes"] > mv_topvotes)
		{
			mv_newitemnum = i;
			mv_topvotes = level.mv_items[i]["votes"];
		}
	}

	// Select the winning map
	map = level.mv_items[mv_newitemnum]["map"];
	mapname = level.mv_items[mv_newitemnum]["mapname"];

	// Prepare for game type voting
	gt_array = strtok(level.mv_items[mv_newitemnum]["gametype"], " ");
	if(!isDefined(gt_array) || gt_array.size == 0)
		gt_array[0] = "dm";

	level.mv_items = undefined;
	for(j = 0; j < gt_array.size; j++)
	{
		level.mv_items[j]["map"] = map;
		level.mv_items[j]["mapname"] = mapname;
		level.mv_items[j]["gametype"] = gt_array[j];
		level.mv_items[j]["gametypename"] = extreme\_ex_maps::getgtstring(gt_array[j]);
		level.mv_items[j]["votes"] = 0;
	}

	level.mv_itemsmax = level.mv_items.size;

	// Do we have enough game types to vote for?
	if(level.mv_itemsmax > 1)
	{
		level.mv_stage = 2;
		players = level.players;
		for(i = 0; i < players.size; i++)
			if(players[i].mv_allowvote) players[i] thread PlayerVoteGT();

		// Game type voting in progress
		for (; level.ex_mapvote_timegt >= 0; level.ex_mapvote_timegt--)
		{
			for(t = 0; t < 10; t++)
			{
				// Reset votes
				for(i = 0; i < level.mv_itemsmax; i++) level.mv_items[i]["votes"] = 0;

				// Get current players
				players = level.players;

				// Spawn no-vote thread for new players (joined during vote)
				for(i = 0; i < players.size; i++)
				{
					if(isPlayer(players[i]) && !isDefined(players[i].mv_allowvote))
					{
						players[i].mv_allowvote = false;
						players[i] thread PlayerNoVoteNewPlayer();
					}
				}

				// Recount votes
				for(i = 0; i < players.size; i++)
					if(players[i].mv_allowvote && players[i].mv_choice != 0)
						level.mv_items[players[i].mv_choice - 1]["votes"]++;

				// Update votes on player's HUD, depending on page displayed (scary stuff)
				for(i = 0; i < players.size; i++)
				{
					if(players[i].mv_allowvote)
					{
						if(players[i].mv_flipchoice != 0) isonpage = onPage(players[i].mv_flipchoice);
							else isonpage = onPage(players[i].mv_choice);
						for(j = 0; j < maxItemsOnPage(isonpage); j++)
							players[i].mv_votes[j] setValue(level.mv_items[(isonpage * level.mv_perpage)-level.mv_perpage+j]["votes"]);
					}
				}

				wait .1;
			}
			// Update time left HUD
			level.mv_timeleft setValue(level.ex_mapvote_timegt);
		}

		// Signal voting threads to end, and wait for threads to die
		level notify("VotingStage2Done");
		wait 0.2;
	}

	// Fade HUD elements
	FadeHud();

	// Destroy all HUD elements
	DeleteHud();

	// Count the votes
	mv_newitemnum = 0;
	mv_topvotes = 0;
	for(i = 0; i < level.mv_itemsmax; i++)
	{
		if(level.mv_items[i]["votes"] > mv_topvotes)
		{
			mv_newitemnum = i;
			mv_topvotes = level.mv_items[i]["votes"];
		}
	}

	// Select the winning game type
	gametype = level.mv_items[mv_newitemnum]["gametype"];
	gametypename = extreme\_ex_maps::getgtstring(gametype);

	// Write to cvars
	setDvar("sv_maprotationcurrent", "gametype " + gametype + " map " + map);
	wait 0.1;

	// Announce winner
	WinnerIs(mapname, gametypename);

	// Signal the end of map vote
	level notify("VotingComplete");
}

PlayerNoVoteNewPlayer()
{
	self endon("disconnect");

	self notify("reset_outcome");
	self setClientDvars("cg_everyoneHearsEveryone", 1,
		"g_deadChat", 1,
		"ui_hud_hardcore", 1,
		"cg_drawSpectatorMessages", 0,
		"g_compassShowEnemies", 0);

	self [[level.spawnSpectator]]();
	self setClientdvar("g_scriptMainMenu", "");
	self closeMenu();
	self closeInGameMenu();

	self allowSpectateTeam("allies", false);
	self allowSpectateTeam("axis", false);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", true);

	self thread PlayerNoVote();
}

PlayerNoVote()
{
	// Thread for players not allowed to vote (all modes)
	// For players joining the vote during VoteLogic(), create HUD elements in this thread
	// not in CreateHUD()
	level endon("VotingDone");
	self endon("disconnect");

	// To vertically center HUD elements, find out how many map lines are displayed
	// If less than 5 maps, make sure we have enough space for HUD elements
	minMapLinesOnPage = maxItemsOnPage(1);
	if(minMapLinesOnPage < 5) minMapLinesOnPage = 5;

	// Map vote in progress
	self.mv_inprogress = newClientHudElem(self);
	self.mv_inprogress.x = 320;
	self.mv_inprogress.y = 70 + int(minMapLinesOnPage / 2) * 16;
	self.mv_inprogress.sort = 103;
	self.mv_inprogress.fontscale = 1.5;
	self.mv_inprogress.color = (0, 1, 0);
	self.mv_inprogress.alignX = "center";
	self.mv_inprogress.alignY = "middle";
	self.mv_inprogress.label = &"MAPVOTE_INPROGRESS";

	// You are not allowed to vote
	self.mv_notallowed = newClientHudElem(self);
	self.mv_notallowed.x = 320;
	self.mv_notallowed.y = 95 + int(minMapLinesOnPage / 2) * 16;
	self.mv_notallowed.sort = 103;
	self.mv_notallowed.fontscale = 1.4;
	self.mv_notallowed.color = (1, 0, 0);
	self.mv_notallowed.alignX = "center";
	self.mv_notallowed.alignY = "middle";
	self.mv_notallowed.label = &"MAPVOTE_NOTALLOWED";

	// Please wait...
	self.mv_wait = newClientHudElem(self);
	self.mv_wait.x = 320;
	self.mv_wait.y = 111 + int(minMapLinesOnPage / 2) * 16;
	self.mv_wait.sort = 103;
	self.mv_wait.fontscale = 1.4;
	self.mv_wait.color = (1, 0, 0);
	self.mv_wait.alignX = "center";
	self.mv_wait.alignY = "middle";
	self.mv_wait.label = &"MAPVOTE_PLEASEWAIT";

	// Now loop until the thread is signaled to end
	for(;;)
	{
		wait .1;
		if(isPlayer(self))
		{
			self.sessionstate = "spectator";
			self.spectatorclient = -1;
		}
	}
}

PlayerVoteMAP()
{
	// Thread for players allowed to vote (modes 0 - 3: map and GT; mode 4/5: map only)
	level endon("VotingDone");
	level endon("VotingStage1Done");
	self endon("disconnect");

	// Players start without a vote
	self.mv_choice = 0;
	self.mv_flipchoice = 0;

	// Create HUD elements for maps
	for(i = 0; i <= maxItemsOnPage(onPage(self.mv_choice))-1; i++)
	{
		self.mv_items[i] = newClientHudElem(self);
		self.mv_items[i].archived = false;
		self.mv_items[i].x = level.mv_originx1 + 5; //195;
		self.mv_items[i].y = 105 + i * 16;
		self.mv_items[i].sort = 104;
		self.mv_items[i].fontscale = 1.4;
		self.mv_items[i].label = level.mv_items[i]["mapname"];
		if(level.ex_mapvote_mode < 4) self.mv_items[i] setText(level.mv_items[i]["gametypename"]);
	}

	// Create HUD elements for voting slots
	for(i = 0; i <= maxItemsOnPage(onPage(self.mv_choice))-1; i++)
	{
		self.mv_votes[i] = newClientHudElem(self);
		self.mv_votes[i].archived = false;
		self.mv_votes[i].x = level.mv_originx2 - 20; //430;
		self.mv_votes[i].y = 105 + i * 16;
		self.mv_votes[i].sort = 104;
		self.mv_votes[i].fontscale = 1.4;
		self.mv_votes[i] setValue(level.mv_items[i]["votes"]);
	}

	// Update page info
	self.mv_page setValue(onPage(self.mv_choice));

	// Create HUD element for selection bar. It starts invisible.
	// Keep sort number less than maps and votes, so it appears behind them
	self.mv_indicator = newClientHudElem(self);
	self.mv_indicator.x = level.mv_originx1 + 3; //193;
	self.mv_indicator.y = 104;
	self.mv_indicator.archived = false;
	self.mv_indicator.sort = 103;
	self.mv_indicator.alpha = 0;
	self.mv_indicator.color = (0, 0, 1);
	self.mv_indicator setShader("white", level.mv_width - 6, 17); //254;

	// Now loop until the thread is signaled to end
	for (;;)
	{
		wait .01;

		// Attack (FIRE) button to vote
		if(isplayer(self) && self attackButtonPressed() == true)
		{
			nextMap(self);
			while(isPlayer(self) && self attackButtonPressed() == true)
				wait.01;
		}

		// Melee button to flip pages
		if(isplayer(self) && self meleeButtonPressed() == true)
		{
			if(maxPages() > 1) flipPage(self);
			while(isPlayer(self) && self meleeButtonPressed() == true)
				wait.01;
		}

		if(isPlayer(self))
		{
			self.sessionstate = "spectator";
			self.spectatorclient = -1;
		}
	}
}

PlayerVoteGT()
{
	// Thread for players allowed to vote (mode 4 and 5: game type)
	level endon("VotingStage2Done");
	self endon("disconnect");

	// Players start without a vote
	self.mv_choice = 0;
	self.mv_flipchoice = 0;

	// Create HUD elements for game types
	for(i = 0; i <= maxItemsOnPage(onPage(self.mv_choice))-1; i++)
	{
		self.mv_items[i] = newClientHudElem(self);
		self.mv_items[i].archived = false;
		self.mv_items[i].x = level.mv_originx1 + 5; //195;
		self.mv_items[i].y = 105 + i * 16;
		self.mv_items[i].sort = 104;
		self.mv_items[i].fontscale = 1.4;
		self.mv_items[i].label = level.mv_items[i]["gametypename"];
	}

	// Create HUD elements for voting slots
	for(i = 0; i <= maxItemsOnPage(onPage(self.mv_choice))-1; i++)
	{
		self.mv_votes[i] = newClientHudElem(self);
		self.mv_votes[i].archived = false;
		self.mv_votes[i].x = level.mv_originx2 - 20; //430;
		self.mv_votes[i].y = 105 + i * 16;
		self.mv_votes[i].sort = 104;
		self.mv_votes[i].fontscale = 1.4;
		self.mv_votes[i] setValue(level.mv_items[i]["votes"]);
	}

	// Update page info
	self.mv_page setValue(onPage(self.mv_choice));

	// Create HUD element for selection bar. It starts invisible.
	// Keep sort number less than maps and votes, so it appears behind them
	self.mv_indicator = newClientHudElem(self);
	self.mv_indicator.x = level.mv_originx1 + 3; //193;
	self.mv_indicator.y = 104;
	self.mv_indicator.archived = false;
	self.mv_indicator.sort = 103;
	self.mv_indicator.alpha = 0;
	self.mv_indicator.color = (0, 0, 1);
	self.mv_indicator setShader("white", level.mv_width - 6, 17); //254;

	// Now loop until the thread is signaled to end
	for (;;)
	{
		wait .01;

		// Attack (FIRE) button to vote
		if(isplayer(self) && self attackButtonPressed() == true)
		{
			nextMap(self);
			while(isPlayer(self) && self attackButtonPressed() == true)
				wait.01;
		}

		// Melee button to flip pages
		if(isplayer(self) && self meleeButtonPressed() == true)
		{
			if(maxPages() > 1) flipPage(self);
			while(isPlayer(self) && self meleeButtonPressed() == true)
				wait.01;
		}

		if(isPlayer(self))
		{
			self.sessionstate = "spectator";
			self.spectatorclient = -1;
		}
	}
}

nextMap(player)
{
	// Show indicator if first vote
	if(player.mv_choice == 0)
		player.mv_indicator.alpha = .8;

	// Is this first click after page flipping?
	if(player.mv_flipchoice != 0)
	{
		if(onPage(player.mv_choice) == onPage(player.mv_flipchoice)) player.mv_choice++;
			else player.mv_choice = player.mv_flipchoice;
		player.mv_indicator.alpha = .8;
		player.mv_flipchoice = 0;

	}
	else player.mv_choice++;

	if (player.mv_choice > level.mv_itemsmax)
		player.mv_choice = 1;

	showChoice(player, player.mv_choice);
}

flipPage(player)
{
	// IMPORTANT: do not change player's choice during page flipping!
	// Hide the indicator
	player.mv_indicator.alpha = 0;

	// Init temporary choice on first flip
	if(player.mv_flipchoice == 0) player.mv_flipchoice = player.mv_choice;

	// Set next page. Rotate if on last page already
	page = onPage(player.mv_flipchoice);
	page++;
	if(page > maxPages()) page = 1;

	// Calculate temporary choice based on new page.
	player.mv_flipchoice = (page * level.mv_perpage)-(level.mv_perpage-1);

	showChoice(player, player.mv_flipchoice);

	// Show indicator if this is the page with the player's choice on it
	if(player.mv_choice != 0 && (onPage(player.mv_choice) == onPage(player.mv_flipchoice)))
		player.mv_indicator.alpha = .8;
}

showChoice(player, choice)
{
	// Show players's choice, and auto-flip page if needed
	if(choice == 1) oldpage = maxPages();
		else oldpage = onPage(choice-1);
	newpage = onPage(choice);

	// Is a page flip needed?
	if(newpage != oldpage)
	{
		// Remove old maps and votes
		for(i = 0; i <= maxItemsOnPage(oldpage)-1; i++)
		{
			player.mv_items[i].alpha = 0;
			player.mv_votes[i].alpha = 0;
		}
		// Show new maps and votes
		for(i = 0; i <= maxItemsOnPage(newpage)-1; i++)
		{
			if(level.mv_stage == 1)
			{
				player.mv_items[i].label = level.mv_items[(newpage * level.mv_perpage)-level.mv_perpage+i]["mapname"];
				if(level.ex_mapvote_mode < 4) player.mv_items[i] setText(level.mv_items[(newpage * level.mv_perpage)-level.mv_perpage+i]["gametypename"]);
			}
			else
			{
				player.mv_items[i].label = level.mv_items[(newpage * level.mv_perpage)-level.mv_perpage+i]["gametypename"];
			}
			player.mv_votes[i] setValue(level.mv_items[(newpage * level.mv_perpage)-level.mv_perpage+i]["votes"]);
			player.mv_items[i].alpha = 1;
			player.mv_votes[i].alpha = 1;
		}
		// Update page info
		player.mv_page setValue(newpage);
	}
	// Update indicator, and show selected map if not in page flipping mode
	if(player.mv_flipchoice == 0)
	{
		indpos = (level.mv_perpage - 1) - ((newpage * level.mv_perpage) - choice);
		self.mv_indicator.y = 104 + (indpos * 16);
		self playLocalSound("flagchange");
	}
}

WinnerIs(mapname, gametypename)
{
	// Announce the winning map
	wait 1;

	// And the winner is...
	level.mv_winner = newHudElem();
	level.mv_winner.archived = false;
	level.mv_winner.x = 320;
	level.mv_winner.y = 90;
	level.mv_winner.fontscale = 1.4;
	level.mv_winner.alignX = "center";
	level.mv_winner.label = &"MAPVOTE_WINNER";

	// Winning map name
	level.mv_winner_map = newHudElem();
	level.mv_winner_map.archived = false;
	level.mv_winner_map.x = 320;
	level.mv_winner_map.y = 110;
	level.mv_winner_map.color = (0,1,0);
	level.mv_winner_map.fontscale = 3;
	level.mv_winner_map.alignX = "center";
	level.mv_winner_map.label = mapname;

	// Winning game type
	level.mv_winner_gt = newHudElem();
	level.mv_winner_gt.archived = false;
	level.mv_winner_gt.x = 320;
	level.mv_winner_gt.y = 144;
	level.mv_winner_gt.fontscale = 1.6;
	level.mv_winner_gt.alignX = "center";
	level.mv_winner_gt.label = gametypename;

	wait 5;

	level.mv_winner fadeOverTime(1);
	level.mv_winner.alpha = 0;
	level.mv_winner_map fadeOverTime(1);
	level.mv_winner_map.alpha = 0;
	level.mv_winner_gt fadeOverTime(1);
	level.mv_winner_gt.alpha = 0;

	wait 1;

	level.mv_winner destroy();
	level.mv_winner_map destroy();
	level.mv_winner_gt destroy();
}

CreateHud()
{
	// Create basic HUD elements
	// Make sure the vote window is at least 5 map lines high
	minMapLinesOnPage = maxItemsOnPage(1);
	if(minMapLinesOnPage < 5) minMapLinesOnPage = 5;

	// Background
	level.mv_bg = newHudElem();
	level.mv_bg.archived = false;
	level.mv_bg.alpha = .7;
	level.mv_bg.x = level.mv_originx1; //190;
	level.mv_bg.y = 45;
	level.mv_bg.sort = 100;
	level.mv_bg.color = (0,0,0);
	level.mv_bg setShader("white", level.mv_width, 85 + minMapLinesOnPage * 16); //260;

	// Title bar
	level.mv_titlebar = newHudElem();
	level.mv_titlebar.archived = false;
	level.mv_titlebar.alpha = .3;
	level.mv_titlebar.x = level.mv_originx1 + 3; //193;
	level.mv_titlebar.y = 47;
	level.mv_titlebar.sort = 101;
	level.mv_titlebar setShader("white", level.mv_width - 5, 21); //255;

	// Separator (bottom line)
	level.mv_bline = newHudElem();
	level.mv_bline.archived = false;
	level.mv_bline.alpha = .3;
	level.mv_bline.x = level.mv_originx1 + 3; //193;
	level.mv_bline.y = 110 + minMapLinesOnPage * 16;
	level.mv_bline.sort = 101;
	level.mv_bline setShader("white", level.mv_width - 5, 1); //255;
	
	// Time left
	level.mv_timeleft = newHudElem();
	level.mv_timeleft.archived = false;
	level.mv_timeleft.x = level.mv_originx1 + 5; //195;
	level.mv_timeleft.y = 115 + minMapLinesOnPage * 16;
	level.mv_timeleft.sort = 102;
	level.mv_timeleft.fontscale = 1.4;
	level.mv_timeleft.label = &"MAPVOTE_TIMELEFT";
	level.mv_timeleft setValue(level.ex_mapvote_time);

	// Title
	level.mv_title = newHudElem();
	level.mv_title.archived = false;
	level.mv_title.x = level.mv_originx1 + 5; //195;
	level.mv_title.y = 50;
	level.mv_title.sort = 102;
	level.mv_title.fontscale = 1.5;
	level.mv_title.label = &"MAPVOTE_TITLE";

	// Create additional info ONLY for players allowed to vote
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		// Catch players joining the map vote just now (do not allow them to vote)
		if(isPlayer(players[i]) && !isDefined(players[i].mv_allowvote))
			players[i].mv_allowvote = false;

		if(players[i].mv_allowvote)
		{
			// Votes column header
			players[i].mv_headers = newClientHudElem(players[i]);
			players[i].mv_headers.archived = false;
			players[i].mv_headers.x = level.mv_originx2 - 5; //445;
			players[i].mv_headers.y = 90;
			players[i].mv_headers.sort = 102;
			players[i].mv_headers.fontscale = 1.4;
			players[i].mv_headers.alignX = "right";
			players[i].mv_headers.label = &"MAPVOTE_HEADERS";

			// How-to instructions
			players[i].mv_howto = newClientHudElem(players[i]);
			players[i].mv_howto.archived = false;
			players[i].mv_howto.x = 320;
			players[i].mv_howto.y = 80;
			players[i].mv_howto.sort = 102;
			players[i].mv_howto.fontscale = 1.4;
			players[i].mv_howto.alignX = "center";
			players[i].mv_howto.alignY = "middle";
			players[i].mv_howto.label = &"MAPVOTE_HOWTO";

			// Page info
			players[i].mv_page = newClientHudElem(players[i]);
			players[i].mv_page.archived = false;
			players[i].mv_page.x = level.mv_originx2 - 5; //445;
			players[i].mv_page.y = 115 + minMapLinesOnPage * 16;
			players[i].mv_page.sort = 102;
			players[i].mv_page.fontscale = 1.4;
			players[i].mv_page.alignX = "right";
			players[i].mv_page.label = &"MAPVOTE_PAGE";
			players[i].mv_page setValue(1);
		}
	}
}

FadePlayerHudStage1()
{
	// Fade all player-based HUD elements
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]) && isDefined(players[i].mv_allowvote))
		{
			if(players[i].mv_allowvote)
			{
				// For players allowed to vote
				for(j = 0; j < maxItemsOnPage(1); j++)
				{
					if(isDefined(players[i].mv_votes[j]))
					{
						players[i].mv_votes[j] fadeOverTime(1);
						players[i].mv_votes[j].alpha = 0;
					}
				}

				for(j = 0; j < maxItemsOnPage(1); j++)
				{
					if(isDefined(players[i].mv_items[j]))
					{
						players[i].mv_items[j] fadeOverTime(1);
						players[i].mv_items[j].alpha = 0;
					}
				}

				if(isDefined(players[i].mv_indicator))
				{
					players[i].mv_indicator fadeOverTime(1);
					players[i].mv_indicator.alpha = 0;
				}
			}
		}
	}
	
	wait(1);
}

FadeHud()
{
	// Fade all player-based HUD elements
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]) && isDefined(players[i].mv_allowvote))
		{
			if(players[i].mv_allowvote)
			{
				// For players allowed to vote
				for(j = 0; j < maxItemsOnPage(1); j++)
				{
					if(isDefined(players[i].mv_votes[j]))
					{
						players[i].mv_votes[j] fadeOverTime(1);
						players[i].mv_votes[j].alpha = 0;
					}
				}

				for(j = 0; j < maxItemsOnPage(1); j++)
				{
					if(isDefined(players[i].mv_items[j]))
					{
						players[i].mv_items[j] fadeOverTime(1);
						players[i].mv_items[j].alpha = 0;
					}
				}

				if(isDefined(players[i].mv_indicator))
				{
					players[i].mv_indicator fadeOverTime(1);
					players[i].mv_indicator.alpha = 0;
				}

				if(isDefined(players[i].mv_page))
				{
					players[i].mv_page fadeOverTime(1);
					players[i].mv_page.alpha = 0;
				}

				if(isDefined(players[i].mv_howto))
				{
					players[i].mv_howto fadeOverTime(1);
					players[i].mv_howto.alpha = 0;
				}

				if(isDefined(players[i].mv_headers))
				{
					players[i].mv_headers fadeOverTime(1);
					players[i].mv_headers.alpha = 0;
				}
			}
			else
			{
				// For players not allowed to vote
				if(isDefined(players[i].mv_inprogress))
				{
					players[i].mv_inprogress fadeOverTime(1);
					players[i].mv_inprogress.alpha = 0;
				}

				if(isDefined(players[i].mv_notallowed))
				{
					players[i].mv_notallowed fadeOverTime(1);
					players[i].mv_notallowed.alpha = 0;
				}

				if(isDefined(players[i].mv_wait))
				{
					players[i].mv_wait fadeOverTime(1);
					players[i].mv_wait.alpha = 0;
				}
			}
		}
	}

	// Fade all level-based HUD elements
	level.mv_timeleft fadeOverTime(1);
	level.mv_bline fadeOverTime(1);
	level.mv_title fadeOverTime(1);
	level.mv_titlebar fadeOverTime(1);
	level.mv_bg fadeOverTime(1);

	level.mv_timeleft.alpha = 0;
	level.mv_bline.alpha = 0;
	level.mv_title.alpha = 0;
	level.mv_titlebar.alpha = 0;
	level.mv_bg.alpha = 0;
	
	wait(1);
}

DeletePlayerHudStage1()
{
	// Destroy all player-based HUD elements for maps
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]) && isDefined(players[i].mv_allowvote))
		{
			if(players[i].mv_allowvote)
			{
				// For players allowed to vote
				for(j = 0; j < maxItemsOnPage(1); j++)
					if(isDefined(players[i].mv_votes[j]))
						players[i].mv_votes[j] destroy();

				for(j = 0; j < maxItemsOnPage(1); j++)
					if(isDefined(players[i].mv_items[j]))
						players[i].mv_items[j] destroy();

				if(isDefined(players[i].mv_indicator))
					players[i].mv_indicator destroy();
			}
		}
	}
}

DeleteHud()
{
	// Destroy all player-based HUD elements
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]) && isDefined(players[i].mv_allowvote))
		{
			if(players[i].mv_allowvote)
			{
				// For players allowed to vote
				for(j = 0; j < maxItemsOnPage(1); j++)
					if(isDefined(players[i].mv_votes[j]))
						players[i].mv_votes[j] destroy();

				for(j = 0; j < maxItemsOnPage(1); j++)
					if(isDefined(players[i].mv_items[j]))
						players[i].mv_items[j] destroy();

				if(isDefined(players[i].mv_indicator))
					players[i].mv_indicator destroy();

				if(isDefined(players[i].mv_page))
					players[i].mv_page destroy();

				if(isDefined(players[i].mv_howto))
					players[i].mv_howto destroy();

				if(isDefined(players[i].mv_headers))
					players[i].mv_headers destroy();
			}
			else
			{
				// For players not allowed to vote
				if(isDefined(players[i].mv_inprogress))
					players[i].mv_inprogress destroy();

				if(isDefined(players[i].mv_notallowed))
					players[i].mv_notallowed destroy();

				if(isDefined(players[i].mv_wait))
					players[i].mv_wait destroy();
			}
		}
	}
	// Destroy all level-based HUD elements
	if(isDefined(level.mv_timeleft)) level.mv_timeleft destroy();
	if(isDefined(level.mv_bline)) level.mv_bline destroy();
	if(isDefined(level.mv_title)) level.mv_title destroy();
	if(isDefined(level.mv_titlebar)) level.mv_titlebar destroy();
	if(isDefined(level.mv_bg)) level.mv_bg destroy();
}

maxPages()
{
	// Calculate the number of pages available
	pages = int((level.mv_itemsmax + (level.mv_perpage - 1)) / level.mv_perpage);
	return pages;
}

onPage(choice)
{
	// Calculate which page the player is on
	if(choice != 0)
	{
		page = int((choice + (level.mv_perpage - 1)) / level.mv_perpage);
		if(page > maxPages()) page = 1;
	}
	else page = 1;
	return page;
}

maxItemsOnPage(page)
{
	// Calculate number of items on page
	items = level.mv_itemsmax;
	itemsonpage = 0;
	for(i = 1; i <= page; i++)
	{
		if(items >= level.mv_perpage)
		{
			itemsonpage = level.mv_perpage;
			items = items - level.mv_perpage;
		}
		else
		{
			if(items != 0)
			{
				itemsonpage = items;
				items = 0;
			}
			else itemsonpage = 0;
		}
	}
	return itemsonpage;
}

mapvoteMemory(maxmaps, mapname)
{
	level.ex_mapmemory = [];

	// limit the map vote memory to two-third of the maps available for voting
	maxtwothird = int( (maxmaps / 3) * 2);
	if(maxtwothird < 2) maxtwothird = 2;
	//logprint("MAPVOTE DEBUG: maxtwothird " + maxtwothird + " versus memorymax " + level.ex_mapvote_memory_max + "\n");
	if(level.ex_mapvote_memory_max > maxtwothird) level.ex_mapvote_memory_max = maxtwothird;

	mapvoteLoadMemory();
	mapvoteAddMemory(mapname);
	mapvoteSaveMemory();
}

mapvoteLoadMemory()
{
	count = 0;
	for(;;)
	{
		mapmemory = [[level.ex_dvardef]]("ex_mapmemory_" + count, "", "", "", "string");
		if(mapmemory == "") break;
		if(level.ex_mapmemory.size < level.ex_mapvote_memory_max)
		{
			level.ex_mapmemory[level.ex_mapmemory.size] = mapmemory;
			count++;
		}
		else break;
	}
}

mapvoteAddMemory(mapname)
{
	if(level.ex_mapmemory.size >= level.ex_mapvote_memory_max) startentry = level.ex_mapvote_memory_max - 1;
		else startentry = level.ex_mapmemory.size;

	for(i = startentry; i > 0; i--)
		level.ex_mapmemory[i] = level.ex_mapmemory[i - 1];

	level.ex_mapmemory[0] = extreme\_ex_utils::lowercase(mapname);
}

mapvoteSaveMemory()
{
	for(i = 0; i < level.ex_mapmemory.size; i++)
	{
		mapmemory = "ex_mapmemory_" + i;
		setDvar(mapmemory, level.ex_mapmemory[i]);
	}
}

mapvoteInMemory(mapname)
{
	lcmapname = extreme\_ex_utils::lowercase(mapname);

	for(i = 0; i < level.ex_mapmemory.size; i++)
		if(level.ex_mapmemory[i] == lcmapname)
		{
			//logprint("MAPVOTE DEBUG: map " + mapname + " in memory. OMITTED!\n");
			return true;
		}

	return false;
}
