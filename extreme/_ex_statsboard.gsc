main()
{
	if(prepareStats())
	{
		// play music if there is no end music playing
		//if(level.ex_statsmusic)
		//{
		//	statsmusic = randomInt(10);
		//	musicplay("gom_music_" + statsmusic);
		//}
		runStats();
	}
}

prepareStats()
{
	// Create the statsboard data structure
	level.stats = spawnstruct();
	if(level.ex_stbd_icons) level.stats.maxplayers = 3;
		else level.stats.maxplayers = 5;
	level.stats.players = 0;
	level.stats.maxcategories = 0;
	level.stats.categories = 0;
	level.stats.maxtime = level.ex_stbd_time;
	level.stats.time = level.stats.maxtime;
	level.stats.hasdata = false;
	level.stats.cat = [];

	thread [[level.ex_clearlnb]]("all",5);
	game["menu_team"] = "";

	// Valid players available?
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		// Only get stats from real players
		player.stats_player = false;
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionteam != "spectator")
			player.stats_player = true;

		if(player.stats_player) level.stats.players++;
	}

	if(level.stats.players == 0) return false;
	if(level.stats.players > level.stats.maxplayers) level.stats.players = level.stats.maxplayers;

	// Make all players spectators with limited permissions
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isPlayer(player)) continue;

		player setClientdvar("g_scriptMainMenu", "");
		player closeMenu();
		player allowSpectateTeam("allies", false);
		player allowSpectateTeam("axis", false);
		player allowSpectateTeam("freelook", false);
		player allowSpectateTeam("none", true);

		if(!isPlayer(player) || !player.stats_player) continue;

		player.statsicon = player thread getStatsIcon();

		if(level.ex_stbd_se)
		{
			// set player score and efficiency
			if(isDefined(player.score)) player.pers["score"] = player.score;
				else player.pers["score"] = 0;

			if(player.pers["kill"] == 0 || (player.pers["kill"] - player.pers["death"]) <= 0) player.pers["efficiency"] = 0;
				else player.pers["efficiency"] = int( (100 / player.pers["kill"]) * (player.pers["kill"] - player.pers["death"]) );
			if(player.pers["efficiency"] > 100) player.pers["efficiency"] = 0;
		}
	}

	category = 0;
	for(;;)
	{
		category_str = GetCategoryStr(category);
		if(category_str == "") break;
		level.stats.maxcategories++;
		
		if( (level.ex_stbd_kd && category_str != "score") || (level.ex_stbd_se && category_str == "score") )
		{
			level.stats.cat[category_str] = [];
			level.stats.categories++;

			category_kill_str = GetCategoryKillStr(category);
			category_death_str = GetCategoryDeathStr(category);

			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				if(!isPlayer(player) || !player.stats_player) continue;

				if(category_kill_str != "-") kills = player.pers[category_kill_str];
					else kills = 0;
				if(category_death_str != "-") deaths = player.pers[category_death_str];
					else deaths = 0;

				if(level.stats.cat[category_str].size < level.stats.maxplayers)
				{
					// Add array element with players's stats
					level.stats.cat[category_str][level.stats.cat[category_str].size] = spawnstruct();
					level.stats.cat[category_str][level.stats.cat[category_str].size-1].player = player;
					level.stats.cat[category_str][level.stats.cat[category_str].size-1].statsicon = player.statsicon;
					level.stats.cat[category_str][level.stats.cat[category_str].size-1].kills = kills;
					level.stats.cat[category_str][level.stats.cat[category_str].size-1].deaths = deaths;

					if(kills || deaths) level.stats.hasdata = true;
				}
				else
				{
					// Array full: check if players's stats are better than stats in array
					for(j = 0; j < level.stats.cat[category_str].size; j++)
					{
						if(category_kill_str != "-")
						{
							// If category manages kills, use those
							if(kills > level.stats.cat[category_str][j].kills)
							{
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].player = player;
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].statsicon = player.statsicon;
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].kills = kills;
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].deaths = deaths;
							}
						}
						else
						{
							// Category does not manage kills, so use deaths instead
							if(deaths > level.stats.cat[category_str][j].deaths)
							{
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].player = player;
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].statsicon = player.statsicon;
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].kills = kills;
								level.stats.cat[category_str][level.stats.cat[category_str].size-1].deaths = deaths;
							}
						}
					}
				}
				// Sort the scores in this category
				// Do not check on maxplayers, because it will not sort if stats.players < stats.maxplayers
				if(level.stats.cat[category_str].size >= level.stats.players)
					sortScores(category_str, 0, level.stats.cat[category_str].size - 1);
			}
		}

		category++;
	}

	// Dump stats to log
	if(level.ex_stbd_log)
	{
		logprint("STATSBOARD [categories][" + level.stats.categories + "]\n");
		for(i = 0; i < level.stats.maxcategories; i++)
		{
			category_str = GetCategoryStr(i);
			if(isDefined(level.stats.cat[category_str]))
			{
				logprint("STATSBOARD [" + category_str + "][" + level.stats.cat[category_str].size + "]\n");
				for(j = 0; j < level.stats.cat[category_str].size; j++)
				{
					logprint("  [" + category_str + "][" + j + "][" + level.stats.cat[category_str][j].player.name + "][" +
						level.stats.cat[category_str][j].kills + ":" + level.stats.cat[category_str][j].deaths + "]\n");
				}
			}
		}
	}

	// No data - no stats
	if(!level.stats.hasdata) return false;
	return true;
}

runStats()
{
	createLevelHUD();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread playerStatsLogic();

	thread levelStatsLogic();
	level waittill("stats_finished");

	if(level.ex_stbd_fade) fadeAllHUD(1);
	deleteAllHUD();
}

playerStatsLogic()
{
	self endon("disconnect");
	level endon("stats_done");

	self createPlayerHUD();
	
	// Initialize player vars
	self.stats_category = 99;
	self nextCategory();

	// Now loop until the thread is signaled to end
	for (;;)
	{
		wait .01;

		// Attack (FIRE) button for next category
		if(isplayer(self) && self attackButtonPressed() == true)
		{
			self nextCategory();
			while(isPlayer(self) && self attackButtonPressed() == true)
				wait.01;
		}

		// Melee button for previous category
		if(isplayer(self) && self meleeButtonPressed() == true)
		{
			self previousCategory();
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

levelStatsLogic()
{
	if(level.ex_stbd_tps)
	{
		level.stats.maxtime = level.stats.categories * level.ex_stbd_tps;
		level.stats.time = level.stats.maxtime;
	}

	for(i = 0; i < level.stats.maxtime; i++)
	{
		wait 1;
		players = getentarray("player", "classname");
		for(j = 0; j < players.size; j++)
		{
			player = players[j];
			if(!isDefined(player.stats_player))
				player thread playerStatsLogic();
		}
		level.stats.time--;
		level.statshud[6] setValue(level.stats.time);
	}
	level notify("stats_done");

	// If things are needed between the "done" and "finished" signals, first clean HUD
	//if(level.ex_stbd_fade) fadeAllHUD(1);
	//deleteAllHUD();
	wait 1;

	level notify("stats_finished");
}

nextCategory()
{
	self endon("disconnect");
	level endon("stats_done");

	oldcategory = self.stats_category;
	self.stats_category++;
	while(true)
	{
		if(self.stats_category >= level.stats.maxcategories) self.stats_category = 0;
		category_str = getCategoryStr(self.stats_category);
		if(isDefined(level.stats.cat[category_str]) && hasData(category_str)) break;
		self.stats_category++;
		if(self.stats_category == oldcategory) break; // Complete cycle, so end
	}

	if(self.stats_category != oldcategory)
	{
		self playLocalSound("mp_capture_flag");
		if(level.ex_stbd_fade)
		{
			self fadePlayerHUD(0.5);
			wait 0.5;
		}
		self showCategory(self.stats_category);
	}
}

previousCategory()
{
	self endon("disconnect");
	level endon("stats_done");

	oldcategory = self.stats_category;
	self.stats_category--;
	while(true)
	{
		if(self.stats_category < 0) self.stats_category = level.stats.maxcategories-1;
		category_str = getCategoryStr(self.stats_category);
		if(isDefined(level.stats.cat[category_str]) && hasData(category_str)) break;
		self.stats_category--;
		if(self.stats_category == oldcategory) break; // Complete cycle, so end
	}

	if(self.stats_category != oldcategory)
	{
		self playLocalSound("mp_capture_flag"); 
		if(level.ex_stbd_fade)
		{
			self fadePlayerHUD(0.5);
			wait 0.5;
		}
		self showCategory(self.stats_category);
	}
}

showCategory(newcategory)
{
	self endon("disconnect");
	level endon("stats_done");

	category_str = GetCategoryStr(newcategory);
	if(!isDefined(level.stats.cat[category_str]) || category_str == "") return;

	category_locstr = getCategoryLocStr(newcategory);
	self.pstatshud_head[0].label = category_locstr;
	self.pstatshud_head[0].alpha = 1;

	category_header = getCategoryHeader(newcategory);
	self.pstatshud_head[1].label = category_header;
	self.pstatshud_head[1].alpha = 1;

	if(level.ex_stbd_icons)
	{
		for(i = 0; i < level.stats.players; i++)
		{
			self.pstatshud_col1[i] setShader(level.stats.cat[category_str][i].statsicon, 14,14);
			self.pstatshud_col1[i].alpha = 1;
		}
	}

	for(i = 0; i < level.stats.players; i++)
	{
		if(isPlayer(level.stats.cat[category_str][i].player))
		{
			self.pstatshud_col2[i] setPlayerNameString(level.stats.cat[category_str][i].player);
			self.pstatshud_col2[i].alpha = 1;
		}
		else
		{
			self.pstatshud_col2[i] setText(&"STATSBOARD_PLAYERLEFT");
			self.pstatshud_col2[i].alpha = 1;
		}
	}

	category_kill_str = GetCategoryKillStr(newcategory);
	for(i = 0; i < level.stats.players; i++)
	{
		if(category_kill_str != "-")
		{
			self.pstatshud_col3[i] setValue(level.stats.cat[category_str][i].kills);
			self.pstatshud_col3[i].alpha = 1;
		}
		else self.pstatshud_col3[i].alpha = 0;
	}

	category_death_str = GetCategoryDeathStr(newcategory);
	for(i = 0; i < level.stats.players; i++)
	{
		if(category_death_str != "-")
		{
			self.pstatshud_col4[i] setValue(level.stats.cat[category_str][i].deaths);
			self.pstatshud_col4[i].alpha = 1;
		}
		else self.pstatshud_col4[i].alpha = 0;
	}
}

hasData(category_str)
{
	self endon("disconnect");
	level endon("stats_done");

	for(i = 0; i < level.stats.cat[category_str].size; i++)
		if(level.stats.cat[category_str][i].kills != 0 || level.stats.cat[category_str][i].deaths != 0)
		  return true;

	return false;
}

sortScores(category_str, start, max)
{
	for(i = start; i < max; i++)
	{
		for(j = start; j < max-i; j++)
		{
			r = compareScores(category_str, j, j + 1);
			if(r == 2) swapScores(category_str, j, j + 1);
		}
	}
}

compareScores(category_str, s1, s2)
{
	if(category_str == "score") special = true;
		else special = false;
	k = level.stats.cat[category_str][s1].kills - level.stats.cat[category_str][s2].kills;
	d = level.stats.cat[category_str][s1].deaths - level.stats.cat[category_str][s2].deaths;
	if(k == 0)
	{
		if(d == 0) return 0;
		if(!special)
		{
			if(d > 0) return 2;
				else return 1;
		}
		else
		{
			if(d > 0) return 1;
				else return 2;
		}
	}
	else
	{
		if(k > 0) return 1;
			else return 2;
	}
}

swapScores(category_str, s1, s2)
{
	temp = spawnstruct();
	temp = level.stats.cat[category_str][s1];
	level.stats.cat[category_str][s1] = level.stats.cat[category_str][s2];
	level.stats.cat[category_str][s2] = temp;
}

createLevelHUD()
{
	// Create all level HUD elements
	maxLines = level.stats.players + 2;
	//maxLines = level.stats.maxplayers + 2;

	level.statshud = [];
	
	// Background
	level.statshud[0] = newHudElem();
	level.statshud[0].archived = false;
	level.statshud[0].alpha = .7;
	level.statshud[0].x = 190 + level.ex_stbd_movex;
	level.statshud[0].y = 45;
	level.statshud[0].sort = 100;
	level.statshud[0].color = (0,0,0);
	level.statshud[0] setShader("white", 260, 75 + (maxLines * 16));

	// Title bar
	level.statshud[1] = newHudElem();
	level.statshud[1].archived = false;
	level.statshud[1].alpha = .3;
	level.statshud[1].x = 193 + level.ex_stbd_movex;
	level.statshud[1].y = 47;
	level.statshud[1].sort = 101;
	level.statshud[1] setShader("white", 255, 21);

	// Separator (top)
	level.statshud[2] = newHudElem();
	level.statshud[2].archived = false;
	level.statshud[2].alpha = .3;
	level.statshud[2].x = 193 + level.ex_stbd_movex;
	level.statshud[2].y = 100;
	level.statshud[2].sort = 101;
	level.statshud[2] setShader("white", 255, 1);

	// Separator (bottom)
	level.statshud[3] = newHudElem();
	level.statshud[3].archived = false;
	level.statshud[3].alpha = .3;
	level.statshud[3].x = 193 + level.ex_stbd_movex;
	level.statshud[3].y = 100 + (maxLines * 16);
	level.statshud[3].sort = 101;
	level.statshud[3] setShader("white", 255, 1);

	// Title
	level.statshud[4] = newHudElem();
	level.statshud[4].archived = false;
	level.statshud[4].x = 195 + level.ex_stbd_movex;
	level.statshud[4].y = 50;
	level.statshud[4].sort = 102;
	level.statshud[4].fontscale = 1.4;
	level.statshud[4].label = &"STATSBOARD_TITLE";

	// How-to instructions
	level.statshud[5] = newHudElem();
	level.statshud[5].archived = false;
	level.statshud[5].x = 320 + level.ex_stbd_movex;
	level.statshud[5].y = 83 + (maxLines * 16);
	level.statshud[5].sort = 102;
	level.statshud[5].fontscale = 1.4;
	level.statshud[5].alignX = "center";
	level.statshud[5].label = &"STATSBOARD_HOWTO";

	// Time left
	level.statshud[6] = newHudElem();
	level.statshud[6].archived = false;
	level.statshud[6].x = 195 + level.ex_stbd_movex;
	level.statshud[6].y = 105 + (maxLines * 16);
	level.statshud[6].sort = 102;
	level.statshud[6].fontscale = 1.4;
	level.statshud[6].label = &"STATSBOARD_TIMELEFT";
	level.statshud[6] setValue(level.ex_stbd_time);
}

createPlayerHUD()
{
	self endon("disconnect");
	level endon("stats_done");

	// Create all player based HUD elements for single player (self)
	self.pstatshud_head = [];
	self.pstatshud_col1 = [];
	self.pstatshud_col2 = [];
	self.pstatshud_col3 = [];
	self.pstatshud_col4 = [];

	// Category
	self.pstatshud_head[0] = newClientHudElem(self);
	self.pstatshud_head[0].archived = false;
	self.pstatshud_head[0].x = 195 + level.ex_stbd_movex;
	self.pstatshud_head[0].y = 80;
	self.pstatshud_head[0].sort = 103;
	self.pstatshud_head[0].fontscale = 1.4;

	// Column header
	self.pstatshud_head[1] = newClientHudElem(self);
	self.pstatshud_head[1].archived = false;
	self.pstatshud_head[1].x = 445 + level.ex_stbd_movex;
	self.pstatshud_head[1].y = 80;
	self.pstatshud_head[1].sort = 103;
	self.pstatshud_head[1].fontscale = 1.4;
	self.pstatshud_head[1].alignX = "right";

	if(level.ex_stbd_icons)
	{
		for(i = 0; i < level.stats.players; i++)
		{
			self.pstatshud_col1[i] = newClientHudElem(self);
			self.pstatshud_col1[i].archived = false;
			self.pstatshud_col1[i].x = 195 + level.ex_stbd_movex;
			self.pstatshud_col1[i].y = 105 + i * 16;
			self.pstatshud_col1[i].sort = 103;
		}
		namex = 215;
	}
	else namex = 195;

	for(i = 0; i < level.stats.players; i++)
	{
		self.pstatshud_col2[i] = newClientHudElem(self);
		self.pstatshud_col2[i].archived = false;
		self.pstatshud_col2[i].x = namex + level.ex_stbd_movex; 
		self.pstatshud_col2[i].y = 105 + i * 16;
		self.pstatshud_col2[i].sort = 103;
		self.pstatshud_col2[i].fontscale = 1.4;
		self.pstatshud_col2[i].color = (1,1,1);
	}

	for(i = 0; i < level.stats.players; i++)
	{
		self.pstatshud_col3[i] = newClientHudElem(self);
		self.pstatshud_col3[i].archived = false;
		self.pstatshud_col3[i].x = 375 + level.ex_stbd_movex;
		self.pstatshud_col3[i].y = 105 + i * 16;
		self.pstatshud_col3[i].sort = 103;
		self.pstatshud_col3[i].fontscale = 1.4;
		self.pstatshud_col3[i].color = (1,1,1);
	}

	for(i = 0; i < level.stats.players; i++)
	{
		self.pstatshud_col4[i] = newClientHudElem(self);
		self.pstatshud_col4[i].archived = false;
		self.pstatshud_col4[i].x = 415 + level.ex_stbd_movex;
		self.pstatshud_col4[i].y = 105 + i * 16;
		self.pstatshud_col4[i].sort = 103;
		self.pstatshud_col4[i].fontscale = 1.4;
		self.pstatshud_col4[i].color = (1,1,1);
	}
}

fadeAllHUD(fadetime)
{
	// Fade all HUD elements
	thread fadeAllPlayerHUD(fadetime);
	thread fadeLevelHUD(fadetime);
	wait fadetime;
}

fadeLevelHUD(fadetime)
{
	// Fade all level based HUD elements
	for(i = 0; i < level.statshud.size; i++)
	{
		if(isDefined(level.statshud[i]))
		{
			level.statshud[i] fadeOverTime(fadetime);
			level.statshud[i].alpha = 0;
		}
	}
}

fadeAllPlayerHUD(fadetime)
{
	// Fade all player based HUD elements for all players
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isPlayer(players[i])) players[i] fadePlayerHUD(fadetime);
}

fadePlayerHUD(fadetime)
{
	self endon("disconnect");
	level endon("stats_done");

	// Fade all player based HUD elements for single player (self)
	// We take the paranoid approach to check player existence

	if(isPlayer(self)) elements = self.pstatshud_head.size;
		else elements = 0;
	for(i = 0; i < elements; i++)
	{
		if(isPlayer(self) && isDefined(self.pstatshud_head[i]))
		{
			self.pstatshud_head[i] fadeOverTime(fadetime);
			self.pstatshud_head[i].alpha = 0;
		}
	}

	if(isPlayer(self)) elements = self.pstatshud_col1.size;
		else elements = 0;
	for(i = 0; i < elements; i++)
	{
		if(isPlayer(self) && isDefined(self.pstatshud_col1[i]))
		{
			self.pstatshud_col1[i] fadeOverTime(fadetime);
			self.pstatshud_col1[i].alpha = 0;
		}
	}

	if(isPlayer(self)) elements = self.pstatshud_col2.size;
		else elements = 0;
	for(i = 0; i < elements; i++)
	{
		if(isPlayer(self) && isDefined(self.pstatshud_col2[i]))
		{
			self.pstatshud_col2[i] fadeOverTime(fadetime);
			self.pstatshud_col2[i].alpha = 0;
		}
	}

	if(isPlayer(self)) elements = self.pstatshud_col3.size;
		else elements = 0;
	for(i = 0; i < elements; i++)
	{
		if(isPlayer(self) && isDefined(self.pstatshud_col3[i]))
		{
			self.pstatshud_col3[i] fadeOverTime(fadetime);
			self.pstatshud_col3[i].alpha = 0;
		}
	}

	if(isPlayer(self)) elements = self.pstatshud_col4.size;
		else elements = 0;
	for(i = 0; i < elements; i++)
	{
		if(isPlayer(self) && isDefined(self.pstatshud_col4[i]))
		{
			self.pstatshud_col4[i] fadeOverTime(fadetime);
			self.pstatshud_col4[i].alpha = 0;
		}
	}
}

deleteAllHud()
{
	// Destroy all player HUD elements
	// We take the paranoid approach to check player existence
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isPlayer(player)) elements = player.pstatshud_head.size;
			else elements = 0;
		for(j = 0; j < elements; j++)
			if(isPlayer(player) && isDefined(player.pstatshud_head[j]))
				player.pstatshud_head[j] destroy();

		if(isPlayer(player)) elements = player.pstatshud_col1.size;
			else elements = 0;
		for(j = 0; j < elements; j++)
			if(isPlayer(player) && isDefined(player.pstatshud_col1[j]))
				player.pstatshud_col1[j] destroy();

		if(isPlayer(player)) elements = player.pstatshud_col2.size;
			else elements = 0;
		for(j = 0; j < elements; j++)
			if(isPlayer(player) && isDefined(player.pstatshud_col2[j]))
				player.pstatshud_col2[j] destroy();

		if(isPlayer(player)) elements = player.pstatshud_col3.size;
			else elements = 0;
		for(j = 0; j < elements; j++)
			if(isPlayer(player) && isDefined(player.pstatshud_col3[j]))
				player.pstatshud_col3[j] destroy();

		if(isPlayer(player)) elements = player.pstatshud_col4.size;
			else elements = 0;
		for(j = 0; j < elements; j++)
			if(isPlayer(player) && isDefined(player.pstatshud_col4[j]))
				player.pstatshud_col4[j] destroy();
	}

	// Destroy all level HUD elements
	for(i = 0; i < level.statshud.size; i++)
		if(isDefined(level.statshud[i]))
			level.statshud[i] destroy();
}

getStatsIcon()
{
	self endon("disconnect");
	level endon("stats_done");

	statsicon = "objective_spectator";

	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		{
			if(self.pers["team"] == "allies")
			{
				switch(game["allies"])
				{
					case "marines":
						statsicon = "faction_128_usmc";
						break;
					case "sas":
						statsicon = "faction_128_sas";
						break;
					default:
						statsicon = "faction_128_usmc";
						break;
				}
			}
			else if(self.pers["team"] == "axis")
			{
				switch(game["axis"])
				{
					case "opfor":
					case "arab":
						statsicon = "faction_128_arab";
						break;

					case "russian":
						statsicon = "faction_128_ussr";
						break;

					default:
						statsicon = "faction_128_arab";
						break;
				}
			}
		}
	}

	return statsicon;
}

getCategoryStr(category)
{
	// Categories
	switch(category)
	{
		case  0: return "killsdeaths";
		case 1:  return "kill";
		case 2:  return "claymorekill";
		case 3:  return "grenadekill";
		case 4:  return "headshotkill";
		case 5:  return "sniperkill";
		case 6:  return "knifekill";
		case 7:  return "napalmkill";
		case 8:  return "airstrikekill";
		case 9:  return "napalmkill";
		case 10: return "ac130kill";
		case 11: return "spawnkill";
		case 12: return "spamkill";
		case 13: return "teamkill";
		case 14: return "carkill";
		case 15: return "c4kill";
		case 16: return "nukekill";
		case 17: return "-";
		case 18: return "carkill";
		case 19: return "ac130kill"; 
  		case 20: return "nukekill";   
  		case 21: return "helostrikekill";
  		case 22: return "m203kill"; 
  		case 23: return "sawkill"; 
		default: return "";
	}
}

getCategoryKillStr(category)
{
	// Kills
	switch(category)
	{
		case 0: return "kill";
		case 1: return "grenadekill";
		case 2: return "claymorekill";
		case 3: return "headshotkill";
		case 4: return "sniperkill";
		case 5: return "knifekill";
		case 6: return "airstrikekill";
		case 7: return "napalmkill";
		case 8: return  "rpgkill";
		case 9: return "spawnkill";
		case 10: return "c4kill";
		case 11: return "spamkill";
		case 12: return "teamkill";
		case 13: return "-"; //was planedeath but not shure if we we want to use this 
		case 14: return "-"; //was mod fallingdeath but was counting as a falldeath after detaching for the ac130
		case 15: return "-";
		case 16: return "-";
		case 17: return "score";
		case 18: return "carkill";
		case 19: return "ac130kill"; 
  		case 20: return "nukekill";   
  		case 21: return "helostrikekill"; 
  		case 22: return "m203kill"; 
  		case 23: return "sawkill"; 
		default: return "";
	}
}

getCategoryDeathStr(category)
{
	// Deaths
	switch(category)
	{
		case  0: return "death";
		case  1: return "grenadedeath";
		case  2: return "claymoredeath";
		case  3: return "headshotdeath";
		case  4: return "sniperdeath";
		case  5: return "knifedeath";
		case  6: return "airstrikedeath";
		case 7:  return "napalmdeath";
		case 8:  return "rpgdeath";
		case 9:  return "spawndeath";
		case 10: return "c4death";
		case 11: return "-";
		case 12: return "-";
		case 13: return "-"; //was planedeath but not shure if we we want to use this 
		case 14: return "-"; //was mod fallingdeath but was counting as a falldeath after detaching for the ac130
		case 15: return "minefielddeath";
		case 16: return "suicide";
		case 17: return "efficiency";
		case 18: return "cardeath";
		case 19: return "ac130death"; 
  		case 20: return "nukedeath";   
  		case 21: return "helostrikedeath"; 
  		case 22: return "m203death"; 
  		case 23: return "sawdeath"; 
		default: return "";
	}
}

getCategoryLocStr(category)
{
	// Localized strings for categories
	switch(category)
	{
		case  0: return &"STATSBOARD_KILLS_DEATHS";
		case  1: return &"STATSBOARD_GRENADES";
		case  2: return &"STATSBOARD_CLAYMORES";
		case  3: return &"STATSBOARD_HEADSHOTS";
		case  4: return &"STATSBOARD_SNIPERS";
		case  5: return &"STATSBOARD_KNIVES";
		case  6: return &"STATSBOARD_AIRSTRIKES";
		case 7:  return &"STATSBOARD_NAPALM";
		case 8:  return &"STATSBOARD_RPG";
		case 9:  return &"STATSBOARD_SPAWN";
		case 10: return &"STATSBOARD_C4";
		case 11: return &"STATSBOARD_SPAM_KILLS";
		case 12: return &"STATSBOARD_TEAM_KILLS";
		case 13: return &"STATSBOARD_PLANE_DEATHS"; //planedeath but not shure if we we want to use this 
		case 14: return &"STATSBOARD_FALLING_DEATHS"; //was mod fallingdeath but was counting as a falldeath after detaching for the ac130
		case 15: return &"STATSBOARD_MINEFIELD_DEATHS";
		case 16: return &"STATSBOARD_SUICIDE_DEATHS";
		case 17: return &"STATSBOARD_SCORE_EFFICIENCY";
		case 18: return &"STATSBOARD_CAR"; 
		case 19: return &"STATSBOARD_AC130"; 
		case 20: return &"STATSBOARD_NUKE"; 
		case 21: return &"STATSBOARD_HELICOPTER";
		case 22: return &"STATSBOARD_M203";  
		case 23: return &"STATSBOARD_SAW";  
		default: return "";
	}
}

getCategoryHeader(category)
{
	// localized strings for column headers
	switch(category)
	{
		case 17: return &"STATSBOARD_HEADER_SE";
		default: return &"STATSBOARD_HEADER_KD";
	}
}
