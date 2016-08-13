
init()
{
	level endon("ex_gameover");

	if(level.ex_callvote_delay)
	{
		level.ex_callvote_indelay = true;

		level.ex_callvote_timer = 0;
		voteSetStatus(false, false);

		if(level.ex_callvote_delay_players)
		{
			for(;;)
			{
				players = level.players;
				playercount = players.size;
				for(i = 0; i < players.size; i++)
				{
					if(isDefined(players[i].pers["team"]) && players[i].pers["team"] == "spectator" || players[i].sessionteam == "spectator")
						playercount--;
				}
				if(playercount >= level.ex_callvote_delay_players) break;
				wait(1 * level.fps_multiplier);
			}
		}

		level.ex_callvote_timer = level.ex_callvote_delay;
		while(level.ex_callvote_timer > 0)
		{
			wait(1 * level.fps_multiplier);
			level.ex_callvote_timer--;
		}

		level.ex_callvote_indelay = undefined;
	}

	for(;;)
	{
		level.ex_callvote_timer = level.ex_callvote_enable_time;
		voteSetStatus(true, true);

		if(level.ex_callvote_mode == 1) break;

		while(level.ex_callvote_timer > 0)
		{
			wait(1 * level.fps_multiplier);
			level.ex_callvote_timer--;
		}

		level.ex_callvote_timer = level.ex_callvote_disable_time;
		voteSetStatus(false, true);

		if(level.ex_callvote_mode == 2) break;

		while(level.ex_callvote_timer > 0)
		{
			wait(1 * level.fps_multiplier);
			level.ex_callvote_timer--;
		}
	}
}

voteSetStatus(status, showmsg)
{
	if(status)
	{
		setDvar("g_allowvote", "1");
		wait (1.5 * level.fps_multiplier);
	}
	else
	{
		setDvar("g_allowvote", "0");
		wait (1.5 * level.fps_multiplier);
	}

	if(showmsg) voteShowStatus();
}

voteShowStatus()
{
	if(!level.ex_callvote_mode) return;

	status = getDvarInt("g_allowvote");

	if(isPlayer(self)) global = false;
		else global = true;

	if(!global)
	{
		// for a spawning player, show only message if in delayed callvote mode 
		if(isDefined(level.ex_callvote_indelay))
		{
			if(level.ex_callvote_timer == 0)
			{
				if(level.ex_callvote_msg == 2 || level.ex_callvote_msg == 3)
					self iprintln(&"MISC_CALLVOTE_WAITDELAY");
			}
			else
			{
				if(level.ex_callvote_msg == 2 || level.ex_callvote_msg == 3)
					self iprintln(&"MISC_CALLVOTE_DELAY", level.ex_callvote_timer);
			}
		}
	}
	else
	{
		// show messages to all players (depending on msg setting)
		if(level.ex_callvote_mode == 1)
		{
			if(level.ex_callvote_msg == 1 || level.ex_callvote_msg == 3)
				iprintln(&"MISC_CALLVOTE_ENABLED");
			return;
		}

		if(status)
		{
			if(level.ex_callvote_msg == 1 || level.ex_callvote_msg == 3)
				iprintln(&"MISC_CALLVOTE_TMPENABLED", level.ex_callvote_timer);
		}
		else
		{
			if(level.ex_callvote_mode == 2)
			{
				if(level.ex_callvote_msg == 2 || level.ex_callvote_msg == 3)
					iprintln(&"MISC_CALLVOTE_DISABLED");
			}
			else
			{
				if(level.ex_callvote_msg == 2 || level.ex_callvote_msg == 3)
					iprintln(&"MISC_CALLVOTE_TMPDISABLED", level.ex_callvote_timer);
			}
		}
	}
}
