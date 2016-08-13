/**/
spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	// clean player hud
	self thread extreme\_ex_hud::cleanPlayerHud();

	// remove existing ready-up spawn ticket
	if(!level.ex_readyup || (level.ex_readyup && isDefined(game["readyup_done"])) )
		self.pers["readyup_spawnticket"] = undefined;

	self.sessionstate = "spectator";
	self.statusicon = "";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	if(isdefined(self.pers["team"]) && self.pers["team"] == "spectator")
		self.statusicon = "";

	if(level.ex_currentgt != "dm" && level.ex_currentgt != "sd" && level.ex_currentgt != "lms" || level.ex_currentgt != "hm")
	{
		self.psoffsettime = 0;
		maps\mp\gametypes\_spectating::setSpectatePermissions();
	}

	if(level.ex_currentgt == "sd" || level.ex_currentgt == "rbctf" || level.ex_currentgt == "rbcnq" || level.ex_currentgt == "esd")
	{
		if(!isdefined(self.skip_setspectatepermissions))
			maps\mp\gametypes\_spectating::setSpectatePermissions();
	}

	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpointname = "mp_global_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	//if(!level.ex_roundbased) self setClientCvar("cg_objectiveText", "");

	//if(level.ex_currentgt == "hq") level maps\mp\gametypes\hq::hq_removeall_hudelems(self);
	//if(level.ex_currentgt == "esd") level maps\mp\gametypes\esd::updateTeamStatus();
	//if(level.ex_currentgt == "lts") level maps\mp\gametypes\lts::updateTeamStatus();
	//if(level.ex_currentgt == "rbcnq") level maps\mp\gametypes\rbcnq::updateTeamStatus();
	//if(level.ex_currentgt == "rbctf") level maps\mp\gametypes\rbctf::updateTeamStatus();
	//if(level.ex_currentgt == "sd") level maps\mp\gametypes\sd::updateTeamStatus();

	[[level.updatetimer]]();
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawned");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if(level.ex_currentgt != "dm" || level.ex_currentgt != "lms")
	{
		self.psoffsettime = 0;
		self.friendlydamage = undefined;
	}

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	//if(level.ex_currentgt == "hq") level maps\mp\gametypes\hq::hq_removeall_hudelems(self);

	[[level.updatetimer]]();
}
