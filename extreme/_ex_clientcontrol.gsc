
exPlayerConnect()
{
	// check security status for player
	checkInit();

	if(isDefined(self.ex_clan))
	{
		if(level.ex_clanann[self.ex_clanid])
		{
			iprintln(&"CLIENTCONTROL_CONNECTING", self);
			splay = true;
		}
		else splay = false;
	}
	else
	{
		iprintln(&"CLIENTCONTROL_CONNECTING", self);
		splay = true;
	}

	if(level.ex_plcdsound && splay)
	{
		players = level.players;
		for(m = 0; m < players.size; m++)
			players[m] playLocalSound("playerjoined");
	}
}

exPlayerJoinedServer()
{	
	//self thread setOneOffVars();

	// detect forced auto-assign
	teamselect = 1;
	teamchange = 1;
	if(!isDefined(self.pers["isbot"]))
	{
		if(level.ex_autoassign == 1) teamselect = 0;
			else if(level.ex_autoassign == 2 && !isDefined(self.ex_clan)) teamselect = 0;
	}

	if(!teamselect)
	{
		self setClientDvar("ui_allow_teamselect", "0");

		// detect team-switch ability for auto-assigned players
		if(level.ex_autoassign_noswitch == 1) teamchange = 0;
			else if(level.ex_autoassign_noswitch == 2 && !isDefined(self.ex_clan)) teamchange = 0;

		if(teamchange) self setClientDvar("ui_allow_teamchange", "1");
			else self setClientDvar("ui_allow_teamchange", "0");

		// auto-assign a team
		if(level.ex_autoassign_team)
			self notify("menuresponse", game["menu_team"], level.ex_autoassign_nonclanteam);
	}
	else
	{
		self setClientDvar("ui_allow_teamselect", "1");
		self setClientDvar("ui_allow_teamchange", "1");

		// auto-assign a team
		if(level.ex_autoassign_team && !isDefined(self.pers["isbot"]))
			self notify("menuresponse", game["menu_team"], level.ex_autoassign_clanteam);
	}

	if(isDefined(self.ex_clan))
	{
		if(level.ex_clanann[self.ex_clanid])
			iprintln(&"CLIENTCONTROL_HASJOINED", self);
	}
	else iprintln(&"CLIENTCONTROL_HASJOINED", self);
	
	// tagged & bagged
	//if(level.ex_tagged) self thread extreme\_ex_tagged::playerSpawned();
}

exPrintJoinedTeam(team)
{
	//if(!isDefined(self.name)) return;

	//if ( !isDefined( team ) ) return;
		//else 
		if (team == "allies") 
		{
			switch(game["allies"])
			{
				case "marines":
					iprintln(&"CLIENTCONTROL_RECRUIT_MARINES", self);
					break;
				case "sas":
					iprintln(&"CLIENTCONTROL_RECRUIT_SAS", self);
					break;
			}
		}	
		else if (team == "axis") 
		{
			switch(game["axis"])
			{
				case "opfor":
					iprintln(&"CLIENTCONTROL_RECRUIT_OPFOR", self);
					break;
				case "russian":
					iprintln(&"CLIENTCONTROL_RECRUIT_RUSSIAN", self);
					break;
			}
		}
}

exPlayerDisconnect()
{
	if(isDefined(self.ex_clan))
	{
		if(level.ex_clanann[self.ex_clanid])
		{
			iprintln(&"CLIENTCONTROL_DISCONNECTED", self);
			splay = true;
		}
		else splay = false;
	}
	else
	{
		iprintln(&"CLIENTCONTROL_DISCONNECTED", self);
		splay = true;
	}

	if(level.ex_plcdsound && splay)
	{
		players = level.players;
		for(m = 0; m < players.size; m++)
			players[m] playLocalSound("playerleft");
	}
}

getSessionState(ss)
{
	switch(ss)
	{
		case "spectator":
		case "intermission":
		case "dead":
		return true;
		
		default:
		return false;
	}
}

setOneOffVars()
{

}

checkInit()
{
	self endon("disconnect");

	self.ex_clan = undefined;
	self.ex_clanid = 0;

	// check if guid number is authorised for extra privileges
	if(level.ex_security && !self checkGUID()) return;

	// check what clan they are in
	self checkClan();
}

checkGUID()
{
	self endon("disconnect");

	playerGUID = self getGUID();

	if(!playerGUID) return false;

	count = 0;
	for(;;)
	{
		guid = [[level.ex_dvardef]]("ex_guid_", 0, 0, 999999, "int");

		if(!guid) break;
			else if(guid == playerGUID) return true;
				else count ++;
	}

	return false;
}

checkClan()
{
	self endon("disconnect");

	clan_num = false;

	for(i = 1; i < 5; i++)
	{
		if(checkClanID(i))
		{
			clan_num = i;
			break;
		}
	}

	if(!clan_num) return;

	self.ex_clan = level.ex_clantag[clan_num];
	self.pers["ex_clan"] = self.ex_clan;
	self.ex_clanid = clan_num;

	//clantag = [];
	//clantag[1] = &"CUSTOM_CLAN1_TAG";
	//clantag[2] = &"CUSTOM_CLAN2_TAG";
	//clantag[3] = &"CUSTOM_CLAN3_TAG";
	//clantag[4] = &"CUSTOM_CLAN4_TAG";
	//self.pers["ex_clan"] = clantag[self.ex_clid];

	return;
}

checkClanID(check)
{
	// decolorize name and tag
	namestr = extreme\_ex_utils::monotone(self.name);
	tagstr = extreme\_ex_utils::monotone(level.ex_clantag[check]);

	if(namestr.size <= tagstr.size) return false;
	sizediff = namestr.size - tagstr.size;

	// check clan tag in front or at end of player's name
	cnfront = "";
	cnback = "";
	for(i = 0; i < tagstr.size; i++)
	{
		cnfront += namestr[i];
		cnback  += namestr[sizediff + i];
	}

	if(cnfront == tagstr || cnback == tagstr) return true;

	return false;
}
