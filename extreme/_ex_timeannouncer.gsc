
init()
{
	//if(level.ex_roundbased) return;
	
	shouldcount = true;
	color = (0,1,0);
	color_changed = false;

	while(!isDefined(level.startTime)) wait(1 * level.fps_multiplier);
	
	while(shouldcount)
	{
		timePassed = (getTime() - level.startTime) / 1000;
		timeRemaining = int((level.timeLimit * 60) - timePassed);
		wait (1 * level.fps_multiplier);

		if(level.ex_gameover) return;
		if(timeRemaining > 300) continue;

		if(level.ex_timeannouncer != 2 && isDefined(level.clock) && !color_changed)
		{
			level.clock.color = color;
			color_changed = true;
		}

		if(level.scorelimit != 0 && level.ex_teamplay)
		{
			alliescore = getTeamScore("allies");
			axisscore = getTeamScore("axis");

			if(axisscore >= level.scorelimit || alliescore >= level.scorelimit) shouldcount = false;
		}

		anscore = false;
		antime = undefined;

		if (timeRemaining < 5) shouldcount = false;
		if (timeRemaining == 300) { antime = "fivemins"; color = (0,1,1); anscore = true; }	 // 5 mins
		if (timeRemaining == 120) { antime = "twomins"; color = (.1,.6,.5); anscore = true; }   // 2 mins
		if (timeRemaining == 60) { antime = "onemin"; color = (.7,.2,.2); anscore = true; }	 // 1 min
		if (timeRemaining == 30) { antime = "thirtysecs"; color = (.7,.7,.7); anscore = true; } // 30 secs
		if (timeRemaining == 20) { antime = "twentysecs"; color = (1,1,0); }					// 20 secs
		if (timeRemaining == 10) { antime = "tensecs"; color = (1,0,0); anscore = true; }	   // 10 secs
		if (timeRemaining == 5) antime = "fftto";											   // 5 secs

		if(isDefined(antime))
		{
			if(level.ex_timeannouncer != 2 && isDefined(level.clock)) level.clock.color = color;
			
			players = level.players;

			for(i = 0; i < players.size; i++)
				if(isplayer(players[i])) players[i] thread announce(antime, anscore);
		}
	}
}

announce(antime, anscore)
{
	// announce time
	if(level.ex_antime) self playLocalSound(antime);
	
	if(!anscore || !level.ex_anscore || level.scorelimit <= 0 || !level.ex_teamplay) return;

	alliescore = getTeamScore("allies");
	axisscore = getTeamScore("axis");
	team = undefined;
	aname = undefined;
	closetowin = false;

	if(axisscore == alliescore)
	{
		self iprintln(&"SCORES_LEVEL");
		return;
	}

	if(axisscore < alliescore)
	{
		ascore = level.scorelimit - alliescore;
		team = "allies";
	}
	else
	{
		ascore = level.scorelimit - axisscore;
		team = "axis";
	}

	if(ascore > (level.scorelimit - 10))
	 	closetowin = true;
	
	if( self.pers["team"] == "allies")
	{
		switch(game["axis"])
		{
			case "russian":
				aname = &"SCORES_RUSSIAN";
				break;
			case "opfor":
				aname = &"SCORES_OPFOR";
				break;
			case "arab":
				aname = &"SCORES_ARAB";
				break;
		}

		// if teams are not near winning, show scores
		if(!closetowin)
		{
			if(alliescore < axisscore)
				self iprintln(&"SCORES_YOUR_TEAM", (axisscore - alliescore), &"SCORES_BEHIND", aname);
			else if(alliescore > axisscore)
				self iprintln(&"SCORES_YOUR_TEAM", (alliescore - axisscore), &"SCORES_AHEAD", aname);
		}
	}
	else
	{
		switch(game["allies"])
		{
			case "sas":
				aname = &"SCORES_SAS";
				break;
			case "marines":
				aname = &"SCORES_MARINES";
				break;
		}
		
		// if teams are not near winning, show scores
		if(!closetowin)
		{
			if(axisscore < alliescore)
				self iprintln(&"SCORES_YOUR_TEAM", (alliescore - axisscore), &"SCORES_BEHIND", aname);
			else if(axisscore > alliescore)
				self iprintln(&"SCORES_YOUR_TEAM", (axisscore - alliescore), &"SCORES_AHEAD", aname);
		}
	}

	if(!closetowin) return;

	// a team is close to winning
	if(self.pers["team"] != team) self iprintln(&"SCORES_TEAM_LOSING_MSGA", aname, &"SCORES_TEAM_LOSING_MSGB", ascore, &"SCORES_TEAM_WINNING");
		else self iprintln(&"SCORES_YOUR_TEAM", ascore, &"SCORES_TEAM_WINNING");
}
