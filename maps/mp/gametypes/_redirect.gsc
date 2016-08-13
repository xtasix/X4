init()
{
	// If redirection disabled, exit
	if(!isDefined(level.ex_redirect) || level.ex_redirect == 0) return;
	// If no server to redirect to, exit
	if(!isDefined(level.ex_redirect_ip) || level.ex_redirect_ip == "") return;

	level thread onPlayerConnected();
}

onPlayerConnected()
{
	while(true)
	{
		self waittill("connected", player);

		// Force downloads on
		player setClientDvar("cl_allowDownload", 1);

		switch(level.ex_redirect_reason)
		{
			case 0: {
				// FULL SERVER: redirect connecting players if server is full
				// If redirect priority mode is on, non-clan players or players without
				// priority status have to give up their slot for clan players
				if(isFullServer() && !isPriorityPlayer(player)) player thread redirectPlayer(0);
				break;
			}
			case 1: {
				// PRIVATE SERVER: redirect non-clan players
				// No priority status check here. All known clans are accepted
				if(!isPriorityClan(player, 4)) player thread redirectPlayer(1);
					else if(isFullServer()) player thread redirectPlayer(0);
				break;
			}
			case 2: {
				// OLD SERVER: redirect all connecting players
				player thread redirectPlayer(2);
				break;
			}
			case 3: {
				// IS BEING SERVICED: redirect all connecting players
				player thread redirectPlayer(3);
				break;
			}
		}
	}
}

// Check if server is full (depending on logic)
isFullServer()
{
	players = level.players;
	numplayers = players.size - 1; // exclude the connecting player
	maxclients = GetDvarInt("sv_maxclients");
	privateclients = GetDvarInt("sv_privateclients");

	fullserver = 1;
	switch(level.ex_redirect_logic)
	{
		case 0: { if(numplayers < maxclients - 1) fullserver = 0; break; }
		case 1: { if(numplayers < maxclients - privateclients) fullserver = 0; break; }
		case 2: { if(numplayers < maxclients - privateclients - 1) fullserver = 0; break; }
	}

	if(fullserver) return true;
	return false;
}

// Check if player has clan-priority
isPriorityPlayer(player)
{
	if(level.ex_redirect_priority && isPriorityClan(player, level.ex_redirect_priority))
	{
		players = level.players;
		numplayers = players.size;

		lastclan2player = -1;		// Last clan2 player without priority status
		lastclan3player = -1;		// Last clan3 player without priority status
		lastclan4player = -1;		// Last clan4 player without priority status
		lastnonclanplayer = -1;	// Last non-clan player

		for(i = 0; i < numplayers; i++)
		{
			if(isPlayer(players[i]) && players[i] != player && !isDefined(players[i].ex_redirected))
			{
				switch(isRedirectCandidate(players[i], level.ex_redirect_priority))
				{
					case 1: { lastnonclanplayer = i; break; }
					case 2: { lastclan2player = i; break; }
					case 3: { lastclan3player = i; break; }
					case 4: { lastclan4player = i; break; }
				}
			}
		}

		if(lastnonclanplayer != -1)
		{
			player thread redirectMonitor(players[lastnonclanplayer]);
			players[lastnonclanplayer] thread RedirectExistingPlayer(player);
			return true;
		}
		else if(lastclan4player != -1)
		{
			player thread redirectMonitor(players[lastclan4player]);
			players[lastclan4player] thread redirectExistingPlayer(player);
			return true;
		}
		else if(lastclan3player != -1)
		{
			player thread redirectMonitor(players[lastclan3player]);
			players[lastclan3player] thread redirectExistingPlayer(player);
			return true;
		}
		else if(lastclan2player != -1)
		{
			player thread redirectMonitor(players[lastclan2player]);
			players[lastclan2player] thread redirectExistingPlayer(player);
			return true;
		}
	}

	return false;
}

// Is connecting player member of priority clan
isPriorityClan(player, mode)
{
	if(isPlayer(player) && isDefined(player.ex_clan) && isDefined(player.ex_clanid))
		if(player.ex_clanid <= mode) return true;
	return false;
}

// Is connecting player member of a priority clan
isRedirectCandidate(player, mode)
{
	if(isPlayer(player))
	{
		if(isDefined(player.pers["isbot"]) && player.pers["isbot"]) return 0; // Bot (not handled)
		if(!isDefined(player.ex_clan) && !isDefined(player.ex_clanid)) return 1; // Non-clan
		if(player.ex_clanid > mode) return player.ex_clanid; // Clan 2, 3, or 4
	}
	return 0; // Clan 1
}

// Close menus and activate spectator mode
prepareNewPlayer()
{
	self setClientDvar("g_scriptMainMenu", "");
	self closeMenu();
	self closeInGameMenu();

	self maps\mp\gametypes\_globallogic::spawnSpectator();
	self allowSpectateTeam("allies", false);
	self allowSpectateTeam("axis", false);
	self allowSpectateTeam("freelook", false);
	self allowSpectateTeam("none", true);
}

// Manage redirect. Put clan player on hold until other player is redirected
redirectMonitor(playertomonitor)
{
	self endon("disconnect");

	self prepareNewPlayer();
	self createHUD(5, false);

	self waittill("redirect_started");

	for (i = level.ex_redirect_pause + 2; i >= 0; i--)
		wait 1;

	if(isPlayer(playertomonitor))
		kick(playertomonitor getEntityNumber());

	// ***** TEST CODE BEGIN *****
	// Uncomment lines above when finished testing!
	//self.ex_redirected = undefined;
	// ***** TEST CODE END *****

	self fadeHUD();
	wait 1;
	self deleteHUD();
	wait .01;

	scriptMainMenu = game["menu_ingame"];
	//self openMenu(game["menu_serverinfo"]);
	self setClientDvar("g_scriptMainMenu", scriptMainMenu);
}

// Handle player redirection
redirectPlayer(reason)
{
	self endon("disconnect");

	self.ex_redirected = true;
	self prepareNewPlayer();
	self createHUD(reason, true);
	for (i = level.ex_redirect_pause; i >= 0; i--)
	{
		self.redirect_timeleft setValue(i);
		wait 1;
	}
	self fadeHUD();
	wait 1;
	self deleteHUD();
	wait .01;

	self [[level.ex_clientcmd]]("disconnect; connect " + level.ex_redirect_ip);
}

// Handle other player redirection
redirectExistingPlayer(playertonotify)
{
	self endon("disconnect");

	self.ex_redirected = true;
	wait .05;
	if(isDefined(playertonotify) && isPlayer(playertonotify))
		playertonotify notify("redirect_started");

	// ***** TEST CODE BEGIN *****
	//wait 30;
	//self.ex_redirected = true;
	// ***** TEST CODE END *****

	self createHUD(4, true);
	for (i = level.ex_redirect_pause; i >= 0; i--)
	{
		self.redirect_timeleft setValue(i);
		if(!isPlayer(playertonotify))
		{
			self.redirect_reason.label = &"REDIRECT_CLAN_ABORTED";
			self.redirect_to.label = &"REDIRECT_CLAN_CONTINUE";
			if(level.ex_redirect_hint)
				self.redirect_hint.label = &"REDIRECT_HINT_PRIORITY";
			self.ex_redirected = undefined;
			wait 5;
			break;
		}
		else wait 1;
	}
	self fadeHUD();
	wait 1;
	self deleteHUD();
	wait .01;

	if(isDefined(self.ex_redirected))
		self [[level.ex_clientcmd]]("disconnect; connect " + level.ex_redirect_ip);
}

// Create HUD elements
createHUD(reason, showtimer)
{
	// Background
	self.redirect_bg = newClientHudElem(self);
	self.redirect_bg.archived = false;
	self.redirect_bg.alpha = .7;
	self.redirect_bg.x = 120; //190;
	self.redirect_bg.y = 120; //45;
	self.redirect_bg.sort = 100;
	self.redirect_bg.color = (0,0,0);
	self.redirect_bg setShader("white", 400, 115);

	// Title bar
	self.redirect_titlebar = newClientHudElem(self);
	self.redirect_titlebar.archived = false;
	self.redirect_titlebar.alpha = .3;
	self.redirect_titlebar.x = 123; //193;
	self.redirect_titlebar.y = 122; //47;
	self.redirect_titlebar.sort = 101;
	self.redirect_titlebar setShader("white", 395, 21);

	// Title
	self.redirect_title = newClientHudElem(self);
	self.redirect_title.archived = false;
	self.redirect_title.x = 125; //195;
	self.redirect_title.y = 125; //50;
	self.redirect_title.sort = 101;
	self.redirect_title.fontscale = 1.5;
	self.redirect_title.label = &"REDIRECT_TITLE";

	// Separator
	self.redirect_bline = newClientHudElem(self);
	self.redirect_bline.archived = false;
	self.redirect_bline.alpha = .3;
	self.redirect_bline.x = 123; //193;
	self.redirect_bline.y = 215;
	self.redirect_bline.sort = 101;
	self.redirect_bline setShader("white", 395, 1);

	// Reason
	self.redirect_reason = newClientHudElem(self);
	self.redirect_reason.archived = false;
	self.redirect_reason.x = 320;
	self.redirect_reason.y = 165;
	self.redirect_reason.sort = 101;
	self.redirect_reason.fontscale = 1.4;
	self.redirect_reason.alignX = "center";
	self.redirect_reason.alignY = "middle";
	switch(reason)
	{
		case 0: { self.redirect_reason.label = &"REDIRECT_REASON_ISFULL"; break; }
		case 1: { self.redirect_reason.label = &"REDIRECT_REASON_ISPRIVATE"; break; }
		case 2: { self.redirect_reason.label = &"REDIRECT_REASON_ISOLD"; break; }
		case 3: { self.redirect_reason.label = &"REDIRECT_REASON_ISSERVICED"; break; }
		case 4: { self.redirect_reason.label = &"REDIRECT_REASON_CLANPRIORITY"; break; }
		case 5: { self.redirect_reason.label = &"REDIRECT_CLAN_FREEUPSLOT"; break; }
	}

	// Redirect to
	self.redirect_to = newClientHudElem(self);
	self.redirect_to.archived = false;
	self.redirect_to.x = 320;
	self.redirect_to.y = 185;
	self.redirect_to.sort = 101;
	self.redirect_to.fontscale = 1.4;
	self.redirect_to.alignX = "center";
	self.redirect_to.alignY = "middle";
	switch(reason)
	{
		case 0: { self.redirect_to.label = &"REDIRECT_TO_OTHERSERVER"; break; }
		case 1: { self.redirect_to.label = &"REDIRECT_TO_PUBLICSERVER"; break; }
		case 2: { self.redirect_to.label = &"REDIRECT_TO_NEWSERVER"; break; }
		case 3: { self.redirect_to.label = &"REDIRECT_TO_OTHERSERVER"; break; }
		case 4: { self.redirect_to.label = &"REDIRECT_TO_OTHERSERVER"; break; }
		case 5: { self.redirect_to.label = &"REDIRECT_CLAN_PLEASEWAIT"; break; }
	}

	// Hint
	if(level.ex_redirect_hint)
	{
		self.redirect_hint = newClientHudElem(self);
		self.redirect_hint.archived = false;
		self.redirect_hint.x = 320;
		self.redirect_hint.y = 200;
		self.redirect_hint.sort = 101;
		self.redirect_hint.fontscale = 1.4;
		self.redirect_hint.alignX = "center";
		self.redirect_hint.alignY = "middle";
		switch(reason)
		{
			case 0: {self.redirect_hint.label = &"REDIRECT_HINT_VISITWEBSITE"; break; }
			case 1: {self.redirect_hint.label = &"REDIRECT_HINT_VISITWEBSITE"; break; }
			case 2: {self.redirect_hint.label = &"REDIRECT_HINT_ADDTOFAV"; break; }
			case 3: {self.redirect_hint.label = &"REDIRECT_HINT_VISITWEBSITE"; break; }
			case 4: {self.redirect_hint.label = &"REDIRECT_HINT_SORRY"; break; }
			case 5: {self.redirect_hint.label = &"REDIRECT_HINT_EXTREME"; break; }
		}
	}

	// Timer
	if(showtimer)
	{
		self.redirect_timeleft = newClientHudElem(self);
		self.redirect_timeleft.archived = false;
		self.redirect_timeleft.x = 123;
		self.redirect_timeleft.y = 220;
		self.redirect_timeleft.sort = 101;
		self.redirect_timeleft.fontscale = 1.4;
		self.redirect_timeleft.label = &"REDIRECT_TIMELEFT";
	}
}

// Fade all HUD elements
fadeHUD()
{
	if(isDefined(self.redirect_timeleft)) self.redirect_timeleft fadeOverTime(1);
	if(isDefined(self.redirect_hint)) self.redirect_hint fadeOverTime(1);
	self.redirect_reason fadeOverTime(1);
	self.redirect_to fadeOverTime(1);
	self.redirect_bline fadeOverTime(1);
	self.redirect_title fadeOverTime(1);
	self.redirect_titlebar fadeOverTime(1);
	self.redirect_bg fadeOverTime(1);

	if(isDefined(self.redirect_timeleft)) self.redirect_timeleft.alpha = 0;
	if(isDefined(self.redirect_hint)) self.redirect_hint.alpha = 0;
	self.redirect_reason.alpha = 0;
	self.redirect_to.alpha = 0;
	self.redirect_bline.alpha = 0;
	self.redirect_title.alpha = 0;
	self.redirect_titlebar.alpha = 0;
	self.redirect_bg.alpha = 0;
}

// Destroy all HUD elements
deleteHUD()
{
	if(isDefined(self.redirect_timeleft)) self.redirect_timeleft destroy();
	if(isDefined(self.redirect_hint)) self.redirect_hint destroy();
	if(isDefined(self.redirect_reason)) self.redirect_reason destroy();
	if(isDefined(self.redirect_to)) self.redirect_to destroy();
	if(isDefined(self.redirect_bline)) self.redirect_bline destroy();
	if(isDefined(self.redirect_title)) self.redirect_title destroy();
	if(isDefined(self.redirect_titlebar)) self.redirect_titlebar destroy();
	if(isDefined(self.redirect_bg)) self.redirect_bg destroy();
}
