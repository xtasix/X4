#include extreme\_ex_utils;
#include extreme\_ex_weapons;

start()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_dead");

	campingtime = 0;
	snipercampingtime = 0;
	show_warning = false;
	self.ex_iscamper = false;

	while(isPlayer(self) && isAlive(self) && self.sessionstate == "playing")
	{
		wait 0.5;

		// loop if already marked
		if(self.ex_iscamper) continue;

		startpos = self.origin;
		wait 0.5;
		endpos = self.origin;

		if(isWeaponType(self getcurrentweapon(),"sniper"))
		{
			if(level.ex_campsniper_warntime)
			{
				if(distance(startpos, endpos) < 20) snipercampingtime++;
					else snipercampingtime = 0;

				// show them a warning message
				if(snipercampingtime == level.ex_campsniper_warntime && !self.ex_isunknown)
					show_warning = true;
			}
			else continue;
		}
		else
		{
			if(level.ex_campwarntime)
			{
				if(distance(startpos, endpos) < 25) campingtime++;
					else campingtime = 0;

				// show them a warning message
				if(campingtime == level.ex_campwarntime && !self.ex_isunknown)
					show_warning = true;
			}
			else continue;
		}

		if(show_warning)
		{
			self iprintlnbold(&"CAMPING_WARNING_MESSAGE_SELF", self);
			show_warning = false;
		}

		// ok, they didn't listen, punish them!
		if((campingtime >= level.ex_campobjtime || snipercampingtime >= level.ex_campsniper_objtime) && !self.ex_isunknown)
		{
			switch(level.ex_camppunish)
			{
				case 1:	self thread markTheCamper(); break;
				case 2:	self thread makeThemFart(); break;
				case 3:	self thread blowTheCamper(); break;
				case 4:	self thread shellshockPlayer(false); break;
				case 5:	self thread shellshockPlayer(true); break;
				default:
				{
					switch(randomInt(6))
					{
						case 2:	self thread makeThemFart(); break;
						case 3:	self thread blowTheCamper(); break;
						case 4:	self thread shellshockPlayer(false); break;
						case 5:	self thread shellshockPlayer(true); break;
						default:	self thread markTheCamper(); break;
					}
				}
			}
			
			campingtime = 0;
			snipercampingtime = 0;
			show_warning = false;
		}
	}
}

markTheCamper()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_dead");
	self endon("stopcamper");

	if(self.ex_iscamper || self.sessionstate != "playing") return;
 
	self removeCamper();
	self.ex_objnum = getObjective();

	if(self.ex_objnum)
	{
		self.ex_iscamper = true;

		// notify player and players
		self iprintlnbold(&"CAMPING_MARKED_MESSAGE_SELF", self);
		self iprintlnbold(&"CAMPING_TIME_MESSAGE_SELF", level.ex_camptimer);
		iprintln(&"CAMPING_MARKED_MESSAGE_ALL", self);
		iprintln(&"CAMPING_TIME_MESSAGE_ALL", level.ex_camptimer);

		compass_team = "none";
		if(self.pers["team"] == "allies") compass_icon = "compass_waypoint_target";
			else compass_icon = "compass_waypoint_target";

		objective_add(self.ex_objnum, "current", self.origin, compass_icon);
		objective_team(self.ex_objnum, compass_team);

		if(level.ex_camptimer >= 1) self thread countCamper();
	
		while(isPlayer(self) && isAlive(self) && self.pers["team"] != "spectator")
		{
			for(i=0;(i<60 && isPlayer(self) && isAlive(self));i++)
			{
				if((i <= 29) && self.ex_iscamper) objective_icon(self.ex_objnum, "compass_waypoint_target");
					else if((i >= 30) && self.ex_iscamper) objective_icon(self.ex_objnum, compass_icon);

				if(self.ex_iscamper) objective_position(self.ex_objnum, self.origin);

				wait 0.05;
			}
		}
	}
}

makeThemFart()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_dead");
	self endon("stopcamper");
	
	if(self.ex_iscamper || self.sessionstate != "playing") return;
 
	self.ex_iscamper = true;

	// notify player and players
	self iprintlnbold(&"CAMPING_FART_MESSAGE_SELF", self);
	self iprintlnbold(&"CAMPING_TIME_MESSAGE_SELF", level.ex_camptimer);
	iprintln(&"CAMPING_FART_MESSAGE_ALL", self);
	iprintln(&"CAMPING_TIME_MESSAGE_ALL", level.ex_camptimer);
	self thread countCamper();

	while(isPlayer(self) && isAlive(self) && self.pers["team"] != "spectator" && self.ex_iscamper)
	{
		if(isPlayer(self))
		{
			playfxontag ( level.ex_fartbomb, self, "pelvis" );
			self playLocalSound("fart");
		}

		wait randomInt(4) + 4;
	}
}

blowTheCamper()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_dead");

	if(self.ex_iscamper || self.sessionstate != "playing") return;

	self.ex_iscamper = true;
	
	// notify player and players
	self iprintlnbold(&"CAMPING_BLOWN_MESSAGE_SELF", self);
	iprintln(&"CAMPING_BLOWN_MESSAGE_ALL", self);

	playfx ( level.ex_blowthefag, self, self.origin );
	self playsound("grenade_explode_layer");
	wait 0.05;
	self suicide();   
}

shellshockPlayer(diswep)
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_dead");
	self endon("stopcamper");

	if(!isDefined(diswep)) diswep = false;

	if(self.ex_iscamper || self.sessionstate != "playing") return;
 
	self.ex_iscamper = true;
	time = undefined;

	// notify player and players
	self iprintlnbold(&"CAMPING_SHOCK_MESSAGE_SELF", self);
	self iprintlnbold(&"CAMPING_TIME_MESSAGE_SELF", level.ex_camptimer);
	iprintln(&"CAMPING_SHOCK_MESSAGE_ALL", self);
	iprintln(&"CAMPING_TIME_MESSAGE_ALL", level.ex_camptimer);
	self thread countCamper();

	if(diswep) self disableWeapons();

	while(isPlayer(self) && isAlive(self) && self.pers["team"] != "spectator" && self.ex_iscamper)
	{
		time = randomInt(5) + 5;
		if(isPlayer(self)) self shellshock("concussion_grenade_mp", time);
		wait time + randomInt(5);
	}

	if(diswep) self enableWeapons();
}

countCamper()
{
	self endon("disconnect");
	self endon("ex_dead");

	wait level.ex_camptimer - 1;

	if(isPlayer(self))
	{
		self.ex_iscamper = false;
		wait 1;
	}

	if(isPlayer(self))
	{
		if(isDefined(self.ex_objnum)) self removeCamper();
		self notify("stopcamper");
		self iprintlnbold(&"CAMPING_SURVIVED_MESSAGE_SELF1", self);
		self iprintlnbold(&"CAMPING_SURVIVED_MESSAGE_SELF2", self);
		iprintln(&"CAMPING_SURVIVED_MESSAGE_ALL", self);
	}
}

removeCampers()
{
	player = "";
	players = level.players;

	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]) && isDefined(players[i].ex_objnum))
			players[i] removeCamper();
	}
}

removeCamper()
{
	self endon("disconnect");
	self endon("ex_dead");

	if(isDefined(self.ex_objnum))
	{
		deleteObjective(self.ex_objnum);
		self.ex_objnum = undefined;
	}
}
