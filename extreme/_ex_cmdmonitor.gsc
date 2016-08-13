#include extreme\_ex_punishments;

init()
{
	// Clears command dvars, just incase
	setdvar("sodamachine", ""); 
	setdvar("toilet", ""); 
	setdvar("piano", ""); 
	setdvar("chicken", ""); 
	setdvar("tree", ""); 
	setdvar("tombstone", ""); 
	setdvar("toilet", "");
	setdvar("original", "");
	setdvar("team", "");
	setdvar("disableweapon", "");
	setdvar("enableweapon", "");
	setdvar("warp", "");
	setdvar("lock", "");
	setdvar("unlock", "");
	setdvar("suicide", "");
	setdvar("smite", "");
	setdvar("torch", "");
	setdvar("fire", "");
	setdvar("spank", "");
	setdvar("arty", "");
	setdvar("endmap", "");
	setdvar("sayall", "");
	setdvar("sayallcenter", "");
	setdvar("switchplayerallies", "");
	setdvar("switchplayeraxis", "");
	setdvar("botallies", "");
	setdvar("botaxis", "");
	
	v_SodaPlayer = undefined;
	v_PianoPlayer = undefined;
	v_ChickenPlayer = undefined;
	v_ToiletPlayer = undefined;
	v_TreePlayer = undefined;
	v_TombstonePlayer = undefined;
	v_OriginalPlayer = undefined;

	//make sure only running once
	if(isDefined(level.ex_cmdmonon)) return;

	level.ex_cmdmonon = true;

	while(!level.ex_gameover)
	{
		if(level.ex_cmdmonitor_models)
		{
			v_TombstonePlayer = getdvar("tombstone");
			v_TreePlayer = getdvar("tree");
			v_ChickenPlayer = getdvar("chicken");
			v_PianoPlayer = getdvar("piano");
			v_ToiletPlayer = getdvar("toilet");
			v_SodaPlayer = getdvar("sodamachine");
			v_OriginalPlayer = getdvar("original");
		}
		
		v_DisableWeaponPlayer = getdvar("disableweapon");
		v_EnableWeaponPlayer = getdvar("enableweapon");
		v_WarpPlayer = getdvar("warp");
		v_LockPlayer = getdvar("lock");
		v_UnLockPlayer = getdvar("unlock");
		v_SuicidePlayer = getdvar("suicide");
		v_SmitePlayer = getdvar("smite");
		v_TorchPlayer = getdvar("torch");
		v_FirePlayer = getdvar("fire");
		v_SpankPlayer = getdvar("spank");
		v_ArtyPlayer = getdvar("arty");
		v_EndMap = getdvar("endmap");
		v_SayAll = getdvar("sayall");
		v_SayAllCenter = getdvar("sayallcenter");
		v_SwitchPlayerAllies = getdvar("switchplayerallies");
		v_SwitchPlayerAxis = getdvar("switchplayeraxis");
		v_BotAllies = getdvar("botallies");
		v_BotAxis = getdvar("botaxis");

		if(level.ex_cmdmonitor_models)
		{
			if(v_TombstonePlayer != "") thread changePlayerModel(v_TombstonePlayer, "tombstone");
			if(v_TreePlayer != "") thread changePlayerModel(v_TreePlayer, "tree");
			if(v_ChickenPlayer != "") thread changePlayerModel(v_ChickenPlayer, "chicken");
			if(v_PianoPlayer != "") thread changePlayerModel(v_PianoPlayer, "piano");
			if(v_ToiletPlayer != "") thread changePlayerModel(v_ToiletPlayer, "toilet");
			if(v_SodaPlayer != "") thread changePlayerModel(v_SodaPlayer, "sodamachine");
			if(v_OriginalPlayer != "") thread changePlayerModel(v_OriginalPlayer, "original");
		}
		
		if(v_DisableWeaponPlayer != "") thread setStatusweaponPlayer(v_DisableWeaponPlayer, true);
		if(v_EnableWeaponPlayer != "") thread setStatusweaponPlayer(v_EnableWeaponPlayer, false);
		if(v_WarpPlayer != "") thread messWithPlayer(v_WarpPlayer, "warp");
		if(v_LockPlayer != "") thread messWithPlayer(v_LockPlayer, "lock");
		if(v_UnLockPlayer != "") thread messWithPlayer(v_UnLockPlayer, "unlock");
		if(v_SuicidePlayer != "") thread messWithPlayer(v_SuicidePlayer, "suicide");
		if(v_SmitePlayer != "") thread messWithPlayer(v_SmitePlayer, "smite");
		if(v_TorchPlayer != "") thread messWithPlayer(v_TorchPlayer, "torch");
		if(v_FirePlayer != "") thread messWithPlayer(v_FirePlayer, "fire");
		if(v_SpankPlayer != "") thread messWithPlayer(v_SpankPlayer, "spank");
		if(v_ArtyPlayer != "") thread messWithPlayer(v_ArtyPlayer, "arty");
		if(v_EndMap != "") thread endMap();
		if(v_SayAll != "") thread sayAll(v_SayAll, 0);
		if(v_SayAllCenter != "") thread sayAll(v_SayAllCenter, 1);
		if(v_SwitchPlayerAllies != "") thread switchSide(v_SwitchPlayerAllies, "allies");
		if(v_SwitchPlayerAxis != "") thread switchSide(v_SwitchPlayerAxis, "axis");
		if(v_BotAllies != "") thread addBot("allies");
		if(v_BotAxis != "")  thread addBot("axis");

		wait 5;
	}
}

addBot(team)
{
	// First clear the buffer
	if(team == "allies") setdvar("botallies", "");
		else setdvar("botaxis", "");

	thread extreme\_ex_bots::addClient(team);
}

setStatusweaponPlayer(PlayerEntID, lever)
{
	// First clear the buffer
	if(lever) setdvar("disableweapon", "");
		else setdvar("enableweapon", "");

	// Do we want to set teams
	v_team = getdvar("team");
	setdvar("team", "");

	playerEntID = int(PlayerEntID);
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		player = players[i];
		entID = player getEntityNumber();

		if(player.sessionstate == "playing" && ((entID == playerEntID) || (playerEntID == -1) || (v_team != "" && player.pers["team"] == v_team)) )
		{
			if(lever)
			{
				if(isAlive(player))
				{
					player thread setWeaponStatus(lever);
					player iprintlnbold(&"CMDMONITOR_DISABLEWEAPONS");
					if(level.ex_linux) iprintln(&"CMDMONITOR_DISABLEWEAPONSB", player.name);
						else iprintln(&"CMDMONITOR_DISABLEWEAPONSB", player);
					wait 1;
				}
			}
			else
			{
				if(isAlive(player))
				{
					player thread setWeaponStatus(lever);
					player iprintlnbold(&"CMDMONITOR_ENABLEWEAPONS");
					if(level.ex_linux) iprintln(&"CMDMONITOR_ENABLEWEAPONSB", player.name);
						else iprintln(&"CMDMONITOR_ENABLEWEAPONSB", player);
					wait 1;
				}
			}
		}
	}
}

changePlayerModel(PlayerEntID, mode)
{
	//first clear the buffer
	setdvar(mode, "");
	
	// Do we want to set teams
	v_team = getdvar("team");
	setdvar("team", "");

	models = [];
	pmsg = undefined;
	amsg = undefined;

	// Setup model's
	switch(mode)
	{
		case "chicken":
		models[0] = "chicken";
		pmsg = &"CMDMONITOR_CHICKEN";
		amsg = &"CMDMONITOR_CHICKENB";
		break;

		case "sodamachine":
		models[0] = "ad_sodamachine";
		pmsg = &"CMDMONITOR_SODA";
		amsg = &"CMDMONITOR_SODAB";
		break;

		case "piano":
		models[0] = "ch_piano_light";
		pmsg = &"CMDMONITOR_PIANO";
		amsg = &"CMDMONITOR_PIANOB";
		break;

		case "toilet":
		models[0] = "bathroom_toilet";
		pmsg = &"CMDMONITOR_TOILET";
		amsg = &"CMDMONITOR_TOILETB";
		break;

		case "tree":
		models[0] = "foliage_red_pine_lg";
		pmsg = &"CMDMONITOR_TREE";
		amsg = &"CMDMONITOR_TREEB";
		break;

		case "tombstone":
		models[0] = "wetwork_grave4";
		pmsg = &"CMDMONITOR_TOMBSTONE";
		amsg = &"CMDMONITOR_TOMBSTONEB";
		break;

		case "original":
		models[0] = "original";
		pmsg = &"CMDMONITOR_ORIGINAL";
		amsg = &"CMDMONITOR_ORIGINALB";
		break;

		default: return;
	}

	modeltype = models[randomInt(models.size)];

	playerEntID = int(PlayerEntID);
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		player = players[i];
		entID = player getEntityNumber();

		if((entID == playerEntID) || (playerEntID == -1))
		{
			if(isAlive(player))
			{
				player thread setPlayerModel(v_team, modeltype);
				player iprintlnbold(pmsg);
				if(level.ex_linux) iprintln(amsg, player.name);
					else iprintln(amsg, player);
				wait 1;
			}
		}
	}
}

messWithPlayer(PlayerEntID, mode)
{
	// First clear the buffer
	setdvar(mode, "");

	// Do we want to set teams
	v_team = getdvar("team");
	setdvar("team", "");

	pmsg = undefined;
	amsg = undefined;

	playerEntID = int(PlayerEntID);
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		player = players[i];
		entID = player getEntityNumber();

		if(playerEntID == -1 && mode == "cheater") return;

		if(player.sessionstate == "playing" && ((entID == playerEntID) || (playerEntID == -1) || (v_team != "" && player.pers["team"] == v_team)) )
		{
			if(isAlive(player))
			{
				switch(mode)
				{
					case "warp":
					player.health = 0;
					player thread doWarp(true);
					pmsg = &"CMDMONITOR_WARP";
					amsg = &"CMDMONITOR_WARPB";
					break;

					case "lock":
					player thread doAnchor(true);
					pmsg = &"CMDMONITOR_LOCK";
					amsg = &"CMDMONITOR_LOCKB";
					break;

					case "unlock":
					player thread doAnchor(false);
					pmsg = &"CMDMONITOR_UNLOCK";
					amsg = &"CMDMONITOR_UNLOCKB";
					break;

					case "suicide":
					player thread doSuicide();
					pmsg = &"CMDMONITOR_SUICIDE";
					amsg = &"CMDMONITOR_SUICIDEB";
					break;

					case "smite":
					player thread doSmite();
					pmsg = &"CMDMONITOR_SMITE";
					amsg = &"CMDMONITOR_SMITEB";
					break;

					case "torch":
					player thread doTorch(false);
					pmsg = &"CMDMONITOR_TORCH";
					amsg = &"CMDMONITOR_TORCHB";
					break;

					case "fire":
					player thread doFire();
					pmsg = &"CMDMONITOR_FIRE";
					amsg = &"CMDMONITOR_FIREB";
					break;

					case "spank":
					player thread doSpank();
					pmsg = &"CMDMONITOR_SPANK";
					amsg = &"CMDMONITOR_SPANKB";
					break;

					case "arty":
					player thread doArty();
					pmsg = &"CMDMONITOR_ARTY_SELF";
					amsg = &"CMDMONITOR_ARTY_ALL";
					break;

					default: return;
				}

				player iprintlnbold(pmsg);
				if(level.ex_linux) iprintln(amsg, player.name);
					else iprintln(amsg, player);
				wait 1;
			}
		}
	}
}

sayAll(Message, CenterScreen)
{
	if(CenterScreen == 1)
	{
		iprintlnbold(Message);
		setdvar("sayallcenter", "");
	}
	else
	{
		iprintln(Message);
		setdvar("sayall", "");
	}
}

endMap()
{
	// First clear the buffer
	setdvar("endmap", "");

	// Make the announcement to all players
	iprintlnbold(&"CMDMONITOR_ENDMAP");

	// End the map gracefully
	wait 10;
	level thread maps\mp\gametypes\_globallogic::forceEnd();
}

switchSide(playerEntID, side)
{
	playerEntID = int(PlayerEntID);

	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		player = players[i];
		entID = player getEntityNumber();

		if((entID == playerEntID) || (playerEntID == -1))
		{
			if(side != player.pers["team"])
			{
				player thread maps\mp\gametypes\_teams::changeTeam(side);

				if(playerEntID != -1)
				{
					if(level.ex_linux) iprintln(&"CMDMONITOR_SWITCHSIDES", player.name);
						else iprintln(&"CMDMONITOR_SWITCHSIDES", player);
				}
				player iprintlnbold(&"CMDMONITOR_SWITCHSIDESB");
			}
		}
	}
}
