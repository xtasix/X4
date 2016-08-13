init()
{
	for(;;)
	{
		if(getDvarInt("scr_testclients") > 0) break;
		wait (1 * level.fps_multiplier);
	}

	iNumBots = getDvarInt("scr_testclients");

	if(!level.ex_bots_endgamekick) setDvar("scr_testclients", 0);

	// wait for game initialization to finish
	while(!isDefined(game["allies"]) && !isDefined(game["axis"])) wait (0.05 * level.fps_multiplier);

	wait (1 * level.fps_multiplier);

	for(i = 0; i < iNumBots; i++)
	{
		wait (1 * level.fps_multiplier);

		if(i & 1) team = "axis";
			else team = "allies";

		thread addClient(team);
	}
}

addClient(team)
{
	// this procedure is split off from init to allow the command monitor to add bots
	player = addTestClient();
	if(isDefined(player)) player thread testClient(team);
}

testClient(team)
{
	// flag the bot
	self.pers["isbot"] = true;

	// wait for player initialization to finish
	while(!isDefined(self.pers["team"])) wait (0.05 * level.fps_multiplier);

	// choose a team
	self notify("menuresponse", game["menu_team"], team);
	wait (0.05 * level.fps_multiplier);

	// select class
	if(level.ex_bots_randomclass) class = testClientClass(team, true);
		else class = testClientClass(team, false);

	// set the class
	self notify("menuresponse", game["menu_changeclass_" + team], class);
	wait (0.05 * level.fps_multiplier);

	// accept the class as it is and spawn
	self notify("menuresponse", game["menu_changeclass"] , "go");
}

testClientClass(team, randomclass)
{
	if(!isDefined(team)) team = "axis";
	if(!isDefined(randomclass)) randomclass = false;

	if(randomclass) classno = randomInt(5);
		else classno = 0;
	class = "specops";

	iterations = 0;
	while(iterations < 10)
	{
		switch(classno)
		{
			case 1: class = "assault"; break;
			case 2: class = "heavygunner"; break;
			case 3: class = "demolitions"; break;
			case 4: class = "sniper"; break;
			default: class = "specops"; break;
		}

		if(isValidClass(team, class)) break;
		iterations++;
		classno++;
		if(classno > 4) classno = 0;

		wait (0.1 * level.fps_multiplier);
	}

	return class;
}

isValidClass(team, class)
{
	dvarname = team + "_allow_" + class;

	if(getDvar(dvarname) == "")
	{
		setDvar(dvarname, "1");
		return true;
	}
	else return (getDvarInt(dvarname) == 1);
}

kickBots()
{
	botEntities = [];
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]) && isDefined(players[i].pers["isbot"]))
		{
			botEntity = players[i] getEntityNumber();
			botEntities[botEntities.size] = botEntity;
			kick(botEntity);
			wait(0.1);
		}
	}

	cleanup = true;
	if(cleanup && botEntities.size)
	{
		maxclients = getDvarInt("sv_maxclients");
		entities = getEntArray();
		for(i = 0; i < maxclients; i++)
		{
			for(j = 0; j < botEntities.size; j++)
			{
				if(i == botEntities[j])
					entities[i] = undefined;
			}
		}
	}
}