
welcomeMessages()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(isDefined(self.pers["ex_welcomedone"])) return;
	self.pers["ex_welcomedone"] = true;

	if(isDefined(self.ex_clan) && level.ex_clan_welcomemode) self thread clanWelcome();
		else self thread nonclanWelcome();
}

nonclanwelcome()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(!level.ex_welcomemsg) return;
		
	// welcome message line 1 
	if(level.ex_welcomemsg >= 1) 
	{ 
		if(isSubStr(level.ex_welcomemsg_1, "&&1")) self iprintlnbold (level.ex_welcomemsg_1, self.name);
			else self iprintlnbold (level.ex_welcomemsg_1);
	} 
	else return; 

	// welcome message line 2
	if(level.ex_welcomemsg >= 2)
	{
		wait (level.ex_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_welcomemsg_2);
	}
	else return;

	// welcome message line 3
	if(level.ex_welcomemsg >= 3)
	{
		wait (level.ex_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_welcomemsg_3);
	}
	else return;

	// welcome message line 4
	if(level.ex_welcomemsg >= 4)
	{
		wait (level.ex_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_welcomemsg_4);
	}
	else return;

	// welcome message line 5
	if(level.ex_welcomemsg == 5)
	{
		wait (level.ex_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_welcomemsg_5);
	}
}

clanwelcome()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(!level.ex_welcomemsg) return;

	// welcome message line 1
	if(level.ex_clanmsg[self.ex_clanid] >= 1)
	{
		if(isSubStr(level.ex_clan_welcomemsg_1, "&&1")) self iprintlnbold (level.ex_clan_welcomemsg_1, self.name);
			else self iprintlnbold (level.ex_clan_welcomemsg_1);
	}
	else return;

	// welcome message line 2
	if(level.ex_clanmsg[self.ex_clanid] >= 2)
	{
		wait (level.ex_clan_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_clan_welcomemsg_2);
	}
	else return;

	// welcome message line 3
	if(level.ex_clanmsg[self.ex_clanid] >= 3)
	{
		wait (level.ex_clan_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_clan_welcomemsg_3);
	}
	else return;

	// welcome message line 4
	if(level.ex_clanmsg[self.ex_clanid] >= 4)
	{
		wait (level.ex_clan_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_clan_welcomemsg_4);
	}
	else return;

	// welcome message line 5
	if(level.ex_clanmsg[self.ex_clanid] == 5)
	{
		wait (level.ex_clan_welcomemsg_delay * level.fps_multiplier);
		self iprintlnbold (level.ex_clan_welcomemsg_5);
	}
}

serverMessages()
{
	svrmsg = [];
	svrmsg[0] = level.ex_servermsg_1;
	svrmsg[1] = level.ex_servermsg_2;
	svrmsg[2] = level.ex_servermsg_3;
	svrmsg[3] = level.ex_servermsg_4;
	svrmsg[4] = level.ex_servermsg_5;
	svrmsg[5] = level.ex_servermsg_6;
	svrmsg[6] = level.ex_servermsg_7;
	svrmsg[7] = level.ex_servermsg_8;
	svrmsg[8] = level.ex_servermsg_9;
	svrmsg[9] = level.ex_servermsg_10;

	while(!level.ex_gameover)
	{
		if(level.ex_servermsg_loop) wait ((level.ex_servermsg_delay_main / 2) * level.fps_multiplier);
			else wait (level.ex_servermsg_delay_main);

		for(i = 0; i < level.ex_servermsg; i++)
		{
			iprintln(svrmsg[i]);
			wait (level.ex_servermsg_delay_msg * level.fps_multiplier);
		}

		if(level.ex_servermsg_info) extreme\_ex_maps::displayMapRotation();

		if(!level.ex_servermsg_loop) break;

		wait ((level.ex_servermsg_delay_main / 2) * level.fps_multiplier);
	}
}

motdRotate()
{
	level.ex_motdmsg = [];

	count = 1;
	for(;;)
	{
		cvarname = "ex_motd_" + count;
		msg = getDvar(cvarname);
		if(!isDefined(msg) || msg == "") break;
		level.ex_motdmsg[level.ex_motdmsg.size] = msg;
		count++;
	}

	if(level.ex_motdmsg.size > 0)
		level thread motdOnPlayerConnect();
}

motdOnPlayerConnect()
{
	level endon("ex_gameover");

	for(;;)
	{
		level waittill("connected", player);
		if(!isDefined(player.pers["isbot"]))
		{
			//logprint("MOTD DEBUG: player connected\n");
			player thread motdWaitForStart();
			player thread motdWaitForStop();
		}
	}
}

motdWaitForStart()
{
	level endon("ex_gameover");
	self endon("disconnect");

	for(;;)
	{
		self waittill("startmotd");
		//logprint("MOTD DEBUG: signal start\n");
		self thread motdStartRotation();
	}
}

motdWaitForStop()
{
	level endon("ex_gameover");
	self endon("disconnect");

	for(;;)
	{
		self waittill("stopmotd");
		//logprint("MOTD DEBUG: signal stop\n");
		self notify("stop_motd_rotation");
	}
}

motdStartRotation()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("joined_spectators");

	self notify("stop_motd_rotation");
	waittillframeend;
	self endon("stop_motd_rotation");

	while(true)
	{
		for(i = 0; i < level.ex_motdmsg.size; i++)
		{
			msg = level.ex_motdmsg[i];
			self setClientDvar("ui_motd", msg);
			wait (level.ex_motd_delay * level.fps_multiplier);
		}
	}
}
