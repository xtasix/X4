
setWeaponStatus(lever)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	if(lever) self disableWeapons();
		else self enableWeapons();
}

setPlayerModel(v_team, modeltype)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	if(modeltype == "original")
	{
		self thread maps\mp\gametypes\_teams::setPlayerModels();
		if(isdefined(self.ex_newmodel)) self.ex_newmodel = undefined;
		return;
	}	

	if(v_team == "allies" && self.pers["team"] == "allies" && self.sessionstate == "playing")
		self thread doModelChange(modeltype);

	if(v_team == "axis" && self.pers["team"] == "axis" && self.sessionstate == "playing")
		self thread doModelChange(modeltype);

	if(v_team == "" && self.sessionstate == "playing")
		self thread doModelChange(modeltype);
}

doModelChange(modeltype)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	self detachall();
	self setModel(modeltype);
	self.ex_newmodel = true;
}

doWarp(readrules)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	if(!isDefined(readrules)) readrules = true;

	ix = self.origin[0];
	iy = self.origin[1];
	iz = 1000;
	if(iz > (level.ex_mapArea_Max[2] - 150)) iz = level.ex_mapArea_Max[2] - 150;
	startpoint = self.origin + (0, 0, 24);
	endpoint = (ix, iy, iz);
	distance = distance(startpoint, endpoint);

	self.ex_anchor = spawn("script_model",(0,0,0));
	self.ex_anchor.origin = self.origin;
	self.ex_anchor.angles = self.angles;
	self linkto(self.ex_anchor);

	lifttime = distance/100 + randomint(6);
	self.ex_anchor.origin = startpoint;
	self.ex_anchor moveto(endpoint, lifttime);

	//if(level.ex_flagbased && isDefined(self.flag)) self maps\mp\gametypes\ctf::dropflag();
	self maps\mp\gametypes\_weapons::dropWeaponForDeath();

	wait(3); // Allow player to read the command monitor message
	self disableweapons();
	[[level.ex_clearlnb]]("self", 5);
	
	svrrules = warpJustNumbers(level.ex_svrrules);
	self thread warpShowRules(svrrules);

	self waittill("warp_over");

	if(isPlayer(self))
	{
		self unlink();
		self.health = 1;
		if(isDefined(self.ex_anchor)) self.ex_anchor delete();
	}

	wait(3);

	// huh? Still here? Stupid map! Blow them up
	if(isPlayer(self) && self.sessionstate == "playing")
	{
		playfx(level.ex_effect["barrel"], self.origin);
		self playsound("artillery_explosion");
		wait(0.05);
		self.ex_cmdmondeath = true;
		if(isPlayer(self)) self suicide();
	}
}

warpShowRules(svrrules)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	self iprintlnbold(&"EXTREME_RULES_FAIL");
	wait(3);
	for(i = 1; i < svrrules.size; i++)
	{
		ruleno = int(svrrules[i]);
		showrule = warpGetRule(i);
		self iprintlnbold(showrule);
		wait(3);
	}
	self iprintlnbold(&"EXTREME_RULES_WARN");
	wait(3);

	self notify("warp_over");
}

warpGetRule(ruleno)
{
	rulestr = "";

	switch(ruleno)
	{
		case 1: { rulestr = level.ex_serverrule_1; break; }
		case 2: { rulestr = level.ex_serverrule_2; break; }
		case 3: { rulestr = level.ex_serverrule_3; break; }
		case 4: { rulestr = level.ex_serverrule_4; break; }
		case 5: { rulestr = level.ex_serverrule_5; break; }
		case 6: { rulestr = level.ex_serverrule_6; break; }
		case 7: { rulestr = level.ex_serverrule_7; break; }
		case 8: { rulestr = level.ex_serverrule_8; break; }
		case 9: { rulestr = level.ex_serverrule_9; break; }
		case 0: { rulestr = level.ex_serverrule_10; break; }
	}
	return rulestr;
}

warpJustNumbers(strIn)
{
	if(!isDefined(strIn) || strIn == "") return "";

	numbers = "0123456789";
	strOut = "";

	for(i = 0; i < strIn.size; i++)
	{
		chr = strIn[i];
		for(j = 0; j < numbers.size; j++)
		{
			if(chr == numbers[j]) strOut += numbers[j];
		}
	}
	return strOut;
}

doAnchor(lever)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	if(lever)
	{
		self.ex_anchor = spawn("script_origin", self.origin);
		self linkTo(self.ex_anchor);
	}
	else
	{
		self unlink();
		if(isdefined(self.ex_anchor)) self.ex_anchor delete();
	}
}

doSuicide()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	wait .25;
	if(isPlayer(self))
	{
		self.ex_cmdmondeath = true;
		self suicide();
	}
}

doSmite()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	wait 1.5;
	playfx(level.ex_effect["barrel"], self.origin);

	if(isPlayer(self))
	{
		self playsound("artillery_explosion");
		self.ex_cmdmondeath = true;
		self suicide();
	}
}

doTorch(special, eAttacker)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	if(!isDefined(special)) special = false;
	if(!isDefined(eAttacker)) eAttacker = self;

	self thread doFire();

	for(i = 0; i < 10; i++)
	{
		if(isPlayer(self) && special) self thread [[level.callbackPlayerDamage]](eAttacker, eAttacker, randomInt(2) + 2, 1, "MOD_PROJECTILE", "napalm_mp", undefined, (0,0,1), "none",0);
		wait 2;
	}

	if(special) return;

	if(isPlayer(self))
	{
		self.ex_cmdmondeath = true;
		self suicide();
	}
}

doFire()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	self playsound("scream");

	for(;;)
	{
		wait .2;
		if(isPlayer(self))
		{
			playfxontag(level.ex_effect["bodyfire"], self, "j_elbow_le");
			playfxontag(level.ex_effect["bodyfire"], self, "j_elbow_ri");
			playfxontag(level.ex_effect["bodyfire"], self, "torso_stabilizer");
		}
	}
}

doSpank()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	self thread spankMe(15);
	self shellshock("default", 15);
}

spankMe(time)
{
	level endon("ex_gameover");
	self notify("ex_spankme");
	self endon("ex_spankme");
	self endon("ex_spawned");
	self endon("ex_dead");

	for(i = 0; i < (time*5); i++)
	{
		if(isPlayer(self))
		{
			self setClientDvar("cl_stance", "2");
			self thread maps\mp\gametypes\_weapons::dropWeaponForDeath();
		}

		wait 0.2;
	}
}

doArty()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_spawned");
	self endon("ex_dead");

	wait(2);
	self iprintlnbold(&"CMDMONITOR_ARTY_SELF_RUN");
	wait(5);

	self.ex_cmdmondeath = true;
	while(isPlayer(self) && isAlive(self))
	{
		arty = spawn("script_origin", self.origin);
		arty goArty(self);
	}
}

goArty(player)
{
	shellStartPos = (level.ex_playArea_Min[0], level.ex_playArea_Min[1], player.origin[2]);
	shellTargetPos = player.origin;

	self thread goArtyShell(player, shellStartPos, shellTargetPos);

	self waittill("arty_shell_impact");
	self delete();
}

goArtyShell(player, shellStartPos, shellTargetPos)
{
	shellStartPos = (shellTargetPos[0]-100, shellTargetPos[1]-100, level.ex_mapArea_Max[2]);

	shell = spawn("script_model", shellStartPos);
	shell setModel("projectile_slamraam_missile");
	shell.angles = vectorToAngles(vectorNormalize(shellTargetPos - shellStartPos));
	shell playSound("artillery_incoming");

	shellDist = distance(shellTargetPos, shellStartPos);
	shellDist = int(shellDist * 0.0254);
	shellSpeed = 50;
	shellInAir = goArtyShellTime(shellDist, shellSpeed);
	shell moveTo(shellTargetPos + (0,0,-100), shellInAir);
	wait(shellInAir);
	shell goArtyBoom(player);

	self notify("arty_shell_impact");
}

goArtyBoom(player)
{
	playfx(level.ex_effect["barrel"], self.origin);
	self playSound("artillery_explosion");
	self thread extreme\_ex_utils::scriptedfxradiusdamage(self, undefined, "MOD_EXPLOSIVE", "artillery_mp", level.ex_artillery_radius,	level.ex_artillery_max,	level.ex_artillery_min,	"explosion_dirt", undefined, true, true, true);

	self hide();
	wait(3);
	self delete();
}

goArtyShellTime(distvalue, speedvalue)
{
	distunit = 1;	// Metres
	speedunit = 1; // Metres per second
	timeinsec = (distvalue * distunit) / (speedvalue * speedunit);
	if(timeinsec <= 0) timeinsec = 0.1;
	return timeinsec;
}

// eXtreme+ anti-run punishments
antirunPunish()
{
	if(!isDefined(self.antirun_punlevel))
		self.antirun_punlevel = 0;

	if(!isDefined(self.antirun_puninprog))
		self.antirun_puninprog = false;

	if(self.antirun_puninprog) return;

	self.antirun_puninprog = true;
	self iprintlnbold(&"EXTREME_RUNWARNINGA");
	self iprintlnbold(&"EXTREME_RUNWARNINGB");

	switch(self.antirun_punlevel)
	{
		case 0:
			self.antirun_punlevel++;
			self iprintlnbold(&"EXTREME_FIRST_PLAYER");
			if(level.ex_linux) iprintln(&"EXTREME_FIRST_ALL", self.name);
				else iprintln(&"EXTREME_FIRST_ALL", self);
			self [[level.ex_clientcmd]]("gocrouch");
			self disableWeapons();
			self shellshock("default", 5);
			wait(5);
			self enableWeapons();
			break;

		case 1:
			self.antirun_punlevel++;
			self iprintlnbold(&"EXTREME_SECOND_PLAYER");
			if(level.ex_linux) iprintln(&"EXTREME_SECOND_ALL", self.name);
				else iprintln(&"EXTREME_SECOND_ALL", self);
			self [[level.ex_clientcmd]]("gocrouch");
			self.health = int(self.health / 2);
			self disableWeapons();
			self shellshock("default", 10);
			wait(10);
			self enableWeapons();
			break;

		case 2:
			self.antirun_punlevel++;
			self iprintlnbold(&"EXTREME_THIRD_PLAYER");
			if(level.ex_linux) iprintln(&"EXTREME_THIRD_ALL", self.name);
				else iprintln(&"EXTREME_THIRD_ALL", self);
			self suicide();
			self [[level.ex_clientcmd]]("gocrouch");
			self thread extreme\_ex_punishments::doWarp(true);
			wait(30);
			break;

		case 3:
			self.antirun_punlevel = 0;
			self iprintlnbold(&"EXTREME_FOURTH_PLAYERA");
			self [[level.ex_clientcmd]]("gocrouch");
			self disableWeapons();
			self shellshock("default", 5);
			wait(5);
			self iprintlnbold(&"EXTREME_FOURTH_PLAYERB");
			wait(3);
			if(level.ex_linux) iprintln(&"EXTREME_FOURTH_ALL", self.name);
				else iprintln(&"EXTREME_FOURTH_ALL", self);
			kick(self getEntityNumber());
			break;
	}

	self.antirun_puninprog = false;
}

ForceHipShotPunish()
{
	self endon ( "disconnect" );
	self endon ("death");
	
	self.ispunishblackon = false;
	self.ex_IsHipPunished = true;
	
	if(level.ex_playerishipshootingmsg != "") 
		iprintln("^1" + self.name + " " + level.ex_playerishipshootingmsg);
		
	self iPrintLnBold(level.ex_playermsg);
	
	if(level.ex_hipshotdisableweapon == 1) self disableWeapons();

	if(level.ex_hipshotbloodscreen == 1) self thread extreme\_ex_bloodyscreen::Splatter_View();

	if(level.ex_hipshotblackscreen == 1)
	{
		self.ispunishblackon = true;
		self.HipShotblackscreentext = newClientHudElem(self); 
		self.HipShotblackscreentext.sort = -1; 
		self.HipShotblackscreentext.archived = false; 
		self.HipShotblackscreentext.alignX = "center"; 
		self.HipShotblackscreentext.alignY = "middle"; 
		self.HipShotblackscreentext.fontscale = 2.5; 
		self.HipShotblackscreentext.x = 320; 
		self.HipShotblackscreentext.y = 220; 
		self.HipShotblackscreentext.alpha = 0; 
		self.HipShotblackscreen = newClientHudElem(self); 
		self.HipShotblackscreen.sort = -2; 
		self.HipShotblackscreen.archived = false; 
		self.HipShotblackscreen.alignX = "center"; 
		self.HipShotblackscreen.alignY = "middle";
		self.HipShotblackscreen.horzAlign = "center_safearea";
		self.HipShotblackscreen.vertAlign = "center_safearea"; 
		self.HipShotblackscreen.x = 0; 
		self.HipShotblackscreen.y = 0; 
		self.HipShotblackscreen.alpha = 0; 
		self.HipShotblackscreen setShader("black", 900, 900); 
		self.HipShotblackscreen fadeOverTime(0.1); 
		self.HipShotblackscreen.alpha = 1; 
	}
	
	if(level.ex_hipshotpunish == 1) self shellshock("damage_mp", level.ex_hipshotpunishtime);
		if(level.ex_hipshotpunish == 2) self shellshock("default", level.ex_hipshotpunishtime);
			if(level.ex_hipshotpunish == 3) self freezeControls( true );

	wait(level.ex_hipshotpunishtime);
	
	if(level.ex_hipshotblackscreen == 1)
	{
		self.HipShotblackscreen destroy(); 
		self.HipShotblackscreentext destroy(); 
		self.ispunishblackon = false;
	}
	
	if(level.ex_hipshotdisableweapon == 1 && !self.ex_spawnprotected) self enableWeapons();
		if(level.ex_hipshotpunish == 3 && !self.ex_spawnprotected) self freezeControls( false );
		
	self.ex_IsHipPunished = false;
}
