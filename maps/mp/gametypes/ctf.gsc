#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic;
/*
	CTF by Tally
	12/17/2007
*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_setupmaps::init();
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	if(level.ex_blackscreen) maps\mp\gametypes\_blackscreen::init();
	
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "ctf", 2, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "ctf", 500, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "ctf", 1, 0, 99 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "ctf", 0, 0, 10 );
	
	level.ex_heavyflag 		= extreme\_ex_utils::dvardef("scr_ctf_heavyflag", 1, 0, 1, "int");
	level.ex_flag_returndelay 	= extreme\_ex_utils::dvardef("scr_ctf_returnflag_delay", 60, 0, 140, "int");
	level.ex_pointsfor_flag 	= extreme\_ex_utils::dvardef("scr_ctf_pointsfor_flag", 10, 0, 99, "int");

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	
	game["dialog"]["gametype"] = "Capture_the_Flag";
}

GetSpawns()
{
	if(getDvar("mapname") == "mp_pk_harbor") return true;
	if(getDvar("mapname") == "mp_qmx_matmata") return true;
	
	return false;
}

onStartGameType()
{
	setClientNameMode("auto_change");
	
	level.spawnpoints_needed = GetSpawns();

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"MISC_CTF" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"MISC_CTF" );
	maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"MISC_CTF_SCORE" );
	maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"MISC_CTF_SCORE" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"MISC_CTF_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"MISC_CTF_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	
	if(level.spawnpoints_needed)
	{
		level.custom_spawnpoints = true;
		
		maps\mp\gametypes\_spawnlogic::placeSpawnpoints( "mp_ctf_spawn_allies_start" );
		maps\mp\gametypes\_spawnlogic::placeSpawnpoints( "mp_ctf_spawn_axis_start" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints("allies", "mp_ctf_spawn_allies");
		maps\mp\gametypes\_spawnlogic::addSpawnPoints("axis", "mp_ctf_spawn_axis");
	
	}
	else
	{
		level.custom_spawnpoints = false;
		
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_allies_start" );
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_axis_start" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_sab_spawn_allies" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_sab_spawn_axis" );
	}
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	if(level.spawnpoints_needed)
	{
		level.spawn_axis 			= getentarray("mp_ctf_spawn_axis", "targetname");
		level.spawn_allies 			= getentarray("mp_ctf_spawn_allies", "targetname");
		level.spawn_axis_start 		= getentarray("mp_ctf_spawn_axis_start", "targetname");
		level.spawn_allies_start 	= getentarray("mp_ctf_spawn_allies_start", "targetname");	
	}
	else
	{
		level.spawn_axis 			= getentarray("mp_sab_spawn_axis", "classname");
		level.spawn_allies 			= getentarray("mp_sab_spawn_allies", "classname");
		level.spawn_axis_start 		= getentarray("mp_sab_spawn_axis_start", "classname");
		level.spawn_allies_start 	= getentarray("mp_sab_spawn_allies_start", "classname");
	}
	

	allowed[0] = "war";
	
	if ( getDvarInt( "scr_oldHardpoints" ) > 0 )
		allowed[1] = "hardpoint";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", level.ex_score_kill );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", level.ex_score_assist );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", level.ex_score_capture );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", level.ex_score_defend );
	maps\mp\gametypes\_rank::registerScoreInfo( "return", level.ex_score_return );
	
	if( game["allies"] == "marines" )
	{
		game["prop_flag_allies"] = "prop_flag_american";
		game["prop_flag_carry_allies"] = "prop_flag_american_carry";
	}
	else
	{
		game["prop_flag_allies"] = "prop_flag_brit";
		game["prop_flag_carry_allies"] = "prop_flag_brit_carry";
	}
	
	if( game["axis"] == "russian" )
	{ 
		game["prop_flag_axis"] = "prop_flag_russian";
		game["prop_flag_carry_axis"] = "prop_flag_russian_carry";
	}
	else
	{
		game["prop_flag_axis"] = "prop_flag_opfor";
		game["prop_flag_carry_axis"] = "prop_flag_opfor_carry";
	}
	
	game["prop_flag_base"] = "ch_industrial_lamp_off";

	if( game["allies"] == "marines" )
	{
		level.compassflag_allies = "compass_flag_marines";
		level.objpointflag_allies = "objpoint_flag_american";
		level.objpointflagmissing_allies = "objpoint_flag_x_american";
		level.hudflag_allies = "compass_flag_american";
		level.hudflagflash_allies = level.hudflag_allies;
		level.hudflagflash2_allies = "faction_128_usmc";
	}
	else
	{
		level.compassflag_allies = "compass_flag_british";
		level.objpointflag_allies = "objpoint_flag_british";
		level.objpointflagmissing_allies = "objpoint_flag_x_british";
		level.hudflag_allies = "compass_flag_british";
		level.hudflagflash_allies = level.hudflag_allies;
		level.hudflagflash2_allies = "faction_128_sas";
	}
	
	if( game["axis"] == "russian" )
	{
		level.compassflag_axis = "compass_flag_russian";
		level.objpointflag_axis = "objpoint_flag_russian";
		level.objpointflagmissing_axis = "objpoint_flag_x_russian";
		level.hudflag_axis = "compass_flag_russian";
		level.hudflagflash_axis = level.hudflag_axis;
		level.hudflagflash2_axis = "faction_128_ussr";
	}
	else
	{
		level.compassflag_axis = "compass_flag_opfor";
		level.objpointflag_axis = "objpoint_flag_opfor";
		level.objpointflagmissing_axis = "objpoint_flag_x_opfor";
		level.hudflag_axis = "compass_flag_opfor";
		level.hudflagflash_axis = level.hudflag_axis;
		level.hudflagflash2_axis = "faction_128_arab";
	}
	
	// elimination style
	if( level.roundLimit != 1 && level.numLives )
	{
		level.overrideTeamScore = true;
		level.displayRoundEndText = true;
		level.onEndGame = ::onEndGame;
	}
	
	onPrecacheGameType();
	thread initFlags();	
}

onPrecacheGameType()
{
	
	precacheModel( game["prop_flag_allies"] );
	precacheModel( game["prop_flag_axis"] );
	precacheModel( game["prop_flag_carry_allies"] );
	precacheModel( game["prop_flag_carry_axis"] );
	
	precacheShader( level.compassflag_allies );
	precacheShader( level.compassflag_axis );
	precacheShader( level.objpointflag_axis );
	precacheShader( level.objpointflag_allies );
	precacheShader( level.objpointflagmissing_allies );
	precacheShader( level.objpointflagmissing_axis );
	precacheShader(level.hudflagflash_allies);
	precacheShader(level.hudflagflash_axis);
	precacheShader(level.hudflagflash2_allies);
	precacheShader(level.hudflagflash2_axis);
	
	precacheStatusicon( level.hudflag_allies );
	precacheStatusicon( level.hudflag_axis );
}

onSpawnPlayer()
{
	self.usingObj = undefined;

	spawnteam = self.pers["team"];

	if( level.useStartSpawns )
	{
		if(spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		if(spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}
	
	self spawn( spawnPoint.origin, spawnPoint.angles );
}

onPlayerDisconnect()
{
	self dropFlag();
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{

	self dropFlag();
	self unset_sprint();
	
	if(isPlayer(attacker))
	{
		doKillcam = true;
			
		if(self.pers["team"] != attacker.pers["team"])
		{  
			gave_points = false;
					
			// if the dead person was close to the flag then give the killer a defense bonus
			if(self isnearFlag())
			{
				// let everyone know
				if(attacker.pers["team"] == "axis" )
					iprintln(&"EXTREME_DEFENDED_AXIS", attacker.name);
				else
					iprintln(&"EXTREME_DEFENDED_ALLIES", attacker.name);
						
				attacker thread [[level.onXPEvent]]( "defend" );
				givePlayerScore( "defend", attacker );
				
				gave_points = true;
				lpattacknum = attacker getEntityNumber();
				lpattackguid = attacker getGuid();

				logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + attacker.pers["team"] + ";" + attacker.name + ";" + "ctf_defended" + "\n");
			}
					
			// if the dead person was close to the flag carrier then give the killer a assist bonus
			if(self isnearCarrier(attacker))
			{
				// let everyone know
				if(attacker.pers["team"] == "axis" )
					iprintln( &"EXTREME_ASSISTED_AXIS", attacker.name);
				else
					iprintln(&"EXTREME_ASSISTED_ALLIES", attacker.name);
						
				attacker thread [[level.onXPEvent]]( "assist" );
				givePlayerScore( "assist", attacker );
				
				gave_points = true;
				lpattacknum = attacker getEntityNumber();
				lpattackguid = attacker getGuid();
				logPrint("A;" + lpattackguid + ";" + lpattacknum + ";" + attacker.pers["team"] + ";" + attacker.name + ";" + "ctf_assist" + "\n");
			}
		}
	}
}


onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + level.ex_pointsfor_flag );	
}

initFlags()
{

	maperrors = [];

	allied_flags = getentarray("allied_flag", "targetname");
	if(allied_flags.size < 1)
		maperrors[maperrors.size] = "^1No entities found with \"targetname\" \"allied_flag\"";
	else if(allied_flags.size > 1)
		maperrors[maperrors.size] = "^1More than 1 entity found with \"targetname\" \"allied_flag\"";

	axis_flags = getentarray("axis_flag", "targetname");
	if(axis_flags.size < 1)
		maperrors[maperrors.size] = "^1No entities found with \"targetname\" \"axis_flag\"";
	else if(axis_flags.size > 1)
		maperrors[maperrors.size] = "^1More than 1 entity found with \"targetname\" \"axis_flag\"";

	if(maperrors.size)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");

		return;
	}

	allied_flag = getent("allied_flag", "targetname");
	allied_flag.home_origin = allied_flag.origin;
	allied_flag.home_angles = allied_flag.angles;
	allied_flag.flagmodel = spawn("script_model", allied_flag.home_origin);
	allied_flag.flagmodel.angles = allied_flag.home_angles;
	allied_flag.flagmodel setmodel(game["prop_flag_allies"]);
	
	allied_flag.basemodel = spawn("script_model", allied_flag.home_origin + (-19, 0, 15));
	allied_flag.basemodel.angles = allied_flag.home_angles ;
	allied_flag.basemodel setmodel(game["prop_flag_base"]);	

	allied_flag.team = "allies";
	allied_flag.atbase = true;
	allied_flag.objective = 0;
	allied_flag.compassflag = level.compassflag_allies;
	allied_flag.objpointflag = level.objpointflag_allies;
	allied_flag.objpointflagmissing = level.objpointflagmissing_allies;
	allied_flag thread flag();

	axis_flag = getent("axis_flag", "targetname");
	axis_flag.home_origin = axis_flag.origin;
	axis_flag.home_angles = axis_flag.angles;
	axis_flag.flagmodel = spawn("script_model", axis_flag.home_origin);
	axis_flag.flagmodel.angles = axis_flag.home_angles;
	axis_flag.flagmodel setmodel(game["prop_flag_axis"]);
	
	axis_flag.basemodel = spawn("script_model", axis_flag.home_origin + (-19, 0, 15));
	axis_flag.basemodel.angles = axis_flag.home_angles ;
	axis_flag.basemodel setmodel(game["prop_flag_base"]);	
	
	axis_flag.team = "axis";
	axis_flag.atbase = true;
	axis_flag.objective = 1;
	axis_flag.compassflag = level.compassflag_axis;
	axis_flag.objpointflag = level.objpointflag_axis;
	axis_flag.objpointflagmissing = level.objpointflagmissing_axis;
	axis_flag thread flag();
	
}

flag()
{
	if(level.ex_objectivepoints)
	{
		objective_add(self.objective, "current", self.origin, self.compassflag);
		self createFlagWaypoint();
	}
	
	self.status = "home";
	
	for(;;)
	{
		self waittill("trigger", other);

		if(isPlayer(other) && isAlive(other) && (other.pers["team"] != "spectator"))
		{
			team = other.pers["team"];
			
			if(other.pers["team"] == self.team)
			{
				if(self.atbase)
				{
					if(isdefined(other.flag))
					{
						if(self.team == "axis")
							iprintln( &"EXTREME_CAPTURED_AXIS", other.name );
						else
							iprintln( &"EXTREME_CAPTURED_ALLIES", other.name );

						friendlyAlias = "plr_new_rank";
						enemyAlias = "mp_obj_taken";

						if(self.team == "axis")
							enemy = "allies";
						else
							enemy = "axis";

						thread playSoundOnPlayers(friendlyAlias, self.team);
						thread playSoundOnPlayers(enemyAlias, enemy);

						other.flag returnFlag();
						other detachFlag(other.flag);
						other.flag = undefined;
						other.statusicon = "";
						other thread unset_sprint();
						
						other thread [[level.onXPEvent]]( "capture" );
						givePlayerScore( "capture", other );

						if(other.pers["team"] == "allies")
							team = "allies";
						else
							team = "axis";
						[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + level.ex_pointsfor_flag );
						
						level notify( "update_allhud_score" );
						
						lpselfnum = other getEntityNumber();
						lpselfguid = other getGuid();
						logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.name + ";" + "ctf_captured_flag" + "\n");
						
						checkScoreLimit();
					}
				}
				else // Returned flag
				{
					// Returned flag
					if(self.team == "axis")
						iprintln( &"EXTREME_RETURNED_AXIS", self.name );
					else
						iprintln( &"EXTREME_RETURNED_ALLIES", self.name );
						
					friendlyAlias = "mp_obj_returned";
					thread playSoundOnPlayers(friendlyAlias, self.team);
					self returnFlag();

					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.name + ";" + "ctf_pickup_own" + "\n");
				}
			}
			else if(other.pers["team"] != self.team) // Pick Up Flag
			{
				if(self.team == "axis")
					iprintln( &"EXTREME_STOLE_ALLIES", other.name );
				else 
					iprintln( &"EXTREME_STOLE_AXIS", other.name );

				friendlyAlias = "mp_war_objective_lost";
				enemyAlias = "mp_war_objective_taken";

				if(self.team == "axis")
					enemy = "allies";
				else
					enemy = "axis";
				
				thread playSoundOnPlayers( friendlyAlias, self.team );
				thread playSoundOnPlayers( enemyAlias, enemy );

				other pickupFlag( self ); // Stolen flag
				other thread set_sprint();
				
				lpselfnum = other getEntityNumber();
				lpselfguid = other getGuid();
				logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.name + ";" + "ctf_pickedup_flag" + "\n");
			}
		}
		wait 0.05;
	}
}

set_sprint()
{
	if( !level.ex_heavyflag ) return;
	
	while(isdefined(self.flagAttached))
	{
		if(!isdefined(self.flagAttached)) return;
		self AllowSprint(false);
		wait 1;
	}
		
}

unset_sprint()
{
	if( !level.ex_heavyflag ) return;
	
	if(!isdefined(self.flagAttached))
		self AllowSprint(true);
}

pickupFlag(flag)
{
	flag notify("end_autoreturn");

	flag.origin = flag.origin + (0, 0, -10000);
	flag.flagmodel hide();
	self.flag = flag;
	
	if(self.pers["team"] == "allies")
		self.statusicon = level.hudflag_axis;
	else
		self.statusicon = level.hudflag_allies;

	self.dont_auto_balance = true;
	
	if(level.ex_objectivepoints)
	{
		flag deleteFlagWaypoint();
		flag createFlagMissingWaypoint();

		objective_onEntity(self.flag.objective, self);
		objective_team(self.flag.objective, self.pers["team"]);
	}

	self attachFlag();
}

attachFlag()
{
	if(isdefined(self.flagAttached))
		return;

	if(self.pers["team"] == "allies")
		flagModel = game["prop_flag_carry_axis"];
	else
		flagModel = game["prop_flag_carry_allies"];
	
	self attach(flagModel, "J_Spine4", true);
	self.flagAttached = true;
	
	self thread createHudIcon();
}


dropFlag()
{
	if(isdefined(self.flag))
	{
		start = self.origin + (0, 0, 10);
		end = start + (0, 0, -2000);
		trace = bulletTrace(start, end, false, undefined);

		self.flag.origin = trace["position"];
		self.flag.flagmodel.origin = self.flag.origin;
		self.flag.flagmodel show();
		self.flag.atbase = false;
		self.statusicon = "";
	
		if(level.ex_objectivepoints)
		{
			objective_position(self.flag.objective, self.flag.origin);
			objective_team(self.flag.objective, "none");
			self.flag createFlagWaypoint();
		}

		self.flag thread autoReturn();
		self detachFlag(self.flag);

		self.flag = undefined;
		self.dont_auto_balance = undefined;
	}
}

returnFlag()
{
	self notify("end_autoreturn");
	
	self.status = "home";

 	self.origin = self.home_origin;
 	self.flagmodel.origin = self.home_origin;
 	self.flagmodel.angles = self.home_angles;
	self.flagmodel show();
	self.atbase = true;
	
	if(level.ex_objectivepoints)
	{
		objective_position(self.objective, self.origin);
		objective_team(self.objective, "none");
		self createFlagWaypoint();
		self deleteFlagMissingWaypoint();
	}
}

autoReturn()
{
	self endon("end_autoreturn");

	wait level.ex_flag_returndelay;
	self thread returnFlag();
	level.announce_return = true;
	self thread announce();
}

announce()
{
	self notify("end_autoreturn");

	if(level.announce_return)
	{
		if(self.team == "axis")
			iprintln(&"EXTREME_RETURNED_BASE_AXIS");
		else
			iprintln(&"EXTREME_RETURNED_BASE_ALLIES");
	}
	
	self thread returnFlag();
	self notify("flag returned");
}

detachFlag(flag)
{
	if(!isdefined(self.flagAttached))
		return;

	if(flag.team == "allies")
		flagModel = game["prop_flag_carry_allies"];
	else
		flagModel = game["prop_flag_carry_axis"];
		
	self detach(flagModel, "J_Spine4");
	self.flagAttached = undefined;
	
	self.statusicon = "";
	
	self thread deleteHudIcon();
}

createHudIcon()
{
	if( !level.ex_objectivepoints ) return;
	
	iconSize = 40;
	icon2Size = 30;
	
	X 	= 50;
	Y 	= 150;
	X2 	= 52;
	Y2 	= 148;
	
	if( level.hardcoreMode && !level.ex_hardcore_minimap )
	{
		X 	= 30;
		Y 	= 30;
		X2 	= 32;
		Y2 	= 28;
	}
	else if( level.hardcoreMode && level.ex_hardcore_minimap )
	{
		X 	= 50;
		Y 	= 150;
		X2 	= 52;
		Y2 	= 148;
	}

	self.hud_flagflash = newClientHudElem(self);
	self.hud_flagflash.x = X;
	self.hud_flagflash.y = Y;
	self.hud_flagflash.alignX = "center";
	self.hud_flagflash.alignY = "middle";
	self.hud_flagflash.horzAlign = "left";
	self.hud_flagflash.vertAlign = "top";
	self.hud_flagflash.hideWhenInMenu = true;
	self.hud_flagflash.alpha = 0;
	self.hud_flagflash.sort = 1;
	
	self.hud_flagflash2 = newClientHudElem(self);
	self.hud_flagflash2.x = X2;
	self.hud_flagflash2.y = Y2;
	self.hud_flagflash2.alignX = "center";
	self.hud_flagflash2.alignY = "middle";
	self.hud_flagflash2.horzAlign = "left";
	self.hud_flagflash2.vertAlign = "top";
	self.hud_flagflash2.hideWhenInMenu = true;
	self.hud_flagflash2.alpha = 0;
	self.hud_flagflash2.sort = 2;

	if(self.pers["team"] == "allies")
	{
		self.hud_flagflash setShader(level.hudflagflash_axis, iconSize, iconSize);
		self.hud_flagflash2 setShader(level.hudflagflash2_axis, icon2Size, icon2Size);
	}
	else
	{
		assert(self.pers["team"] == "axis");
		self.hud_flagflash setShader(level.hudflagflash_allies, iconSize, iconSize);
		self.hud_flagflash2 setShader(level.hudflagflash2_allies, icon2Size, icon2Size);
	}
	
	self.hud_flagflash fadeOverTime(.2);
	self.hud_flagflash2 fadeOverTime(.2);
	self.hud_flagflash.alpha = 1;
	self.hud_flagflash2.alpha = 1;

	wait 180;
	
	if(isdefined(self.hud_flagflash))
	{
		self.hud_flagflash fadeOverTime(1);
		self.hud_flagflash2 fadeOverTime(1);
		self.hud_flagflash.alpha = 0;
		self.hud_flagflash2.alpha = 0;
	}
}

deleteHudIcon()
{
	if(isdefined(self.hud_flagflash))
		self.hud_flagflash destroy();
		
	if(isdefined(self.hud_flagflash2))
		self.hud_flagflash2 destroy();
}

createFlagWaypoint()
{
	self deleteFlagWaypoint();

	waypoint = newHudElem();
	waypoint.x = self.origin[0];
	waypoint.y = self.origin[1];
	waypoint.z = self.origin[2] + 100;
	waypoint.alpha = .71;
	waypoint.isShown = true;
	
	waypoint setShader(self.objpointflag, 8, 8);

	waypoint setwaypoint(true);
	self.waypoint_flag = waypoint;
}

deleteFlagWaypoint()
{
	if(isdefined(self.waypoint_flag))
		self.waypoint_flag destroy();
}

createFlagMissingWaypoint()
{
	self deleteFlagMissingWaypoint();

	waypoint = newHudElem();
	waypoint.x = self.home_origin[0];
	waypoint.y = self.home_origin[1];
	waypoint.z = self.home_origin[2] + 100;
	waypoint.alpha = .71;
	waypoint.isShown = true;

	waypoint setShader(self.objpointflagmissing, 8, 8);

	waypoint setwaypoint(true);
	self.waypoint_base = waypoint;
}

deleteFlagMissingWaypoint()
{
	if(isdefined(self.waypoint_base))
		self.waypoint_base destroy();
}

isnearFlag()
{
	// determine the opposite teams flag
	if(self.pers["team"] == "allies" )
		myflag = getent("axis_flag", "targetname");
	else
		myflag = getent("allied_flag", "targetname");

	// if the flag is not at the base then return false
	if(myflag.home_origin != myflag.origin)
		return false;
		
	dist = distance(myflag.home_origin, self.origin);
	
	// if they were close to the flag then return true
	if(dist < 850)
		return true;
		
	return false;
}

isnearCarrier(attacker)
{
	// determine the teams flag
	if(self.pers["team"] == "allies" )
		myflag = getent("allied_flag", "targetname");
	else
		myflag = getent("axis_flag", "targetname");
		
	// if the flag is at the base then return false
	if(myflag.status == "home")
		return false;
	
	// if the attacker is the carrier then return false
	if(isdefined(attacker.flag))
		return false;
		
	// Find the player with the flag
	dist = 9999;
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(!isdefined(player.flag))
			continue;

		if(player.pers["team"] != attacker.pers["team"])
			continue;

		dist = distance(self.origin, player.origin);
	}
	
	// if they were close to the flag carrier then return true
	if(dist < 850)
		return true;
		
	return false;
}