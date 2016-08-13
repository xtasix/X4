#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_globallogic;
/*
	HTF 4 COD4 by Tally
	12/26/2007
	Hold the Flag - X4 mod compatible version
	Author : La Truffe
	Credits : Bell (AWE mod, HTF 1.0)
	
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
	
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( "htf", 2, 0, 99);
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "htf", 5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "htf", 500, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "htf", 1, 0, 99 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "htf", 0, 0, 99 );
	
	level.mode 							= extreme\_ex_utils::dvardef("scr_htf_mode", 2, 0, 3, "int");
	level.holdtime 						= extreme\_ex_utils::dvardef("scr_htf_holdtime", 90, 1, 99999, "int");
	level.heavyflag 					= extreme\_ex_utils::dvardef("scr_htf_heavyflag", 1, 0, 1, "int");
	level.flagrecovertime 				= extreme\_ex_utils::dvardef("scr_htf_returnflag_delay", 60, 0, 140, "int");
	level.randomflagspawns 				= extreme\_ex_utils::dvardef("scr_htf_randomflagspawns", 2, 0, 2, "int");
	level.flagspawndelay 				= extreme\_ex_utils::dvardef("scr_htf_flagspawndelay", 15, 0, 9999, "int");
	level.spawndistance 				= extreme\_ex_utils::dvardef("scr_htf_spawndistance", 1000, 1, 999999, "int");
	level.spawndistancemax 				= extreme\_ex_utils::dvardef("scr_htf_spawndistance_max", 3000, level.spawndistance, 99999, "int");
	level.flagprotectiondistance 		= extreme\_ex_utils::dvardef("scr_htf_flagprotectiondistance", 800, 1, 999999, "int");
	level.PointsForKillingFlagCarrier	= extreme\_ex_utils::dvardef ("scr_htf_pointsforkillingflagcarrier", 2, 0, 100, "int");
	level.PointsForAssistingFlagCarrier	= extreme\_ex_utils::dvardef ("scr_htf_pointsforassistingflagcarrier", 1, 0, 100, "int");
	level.PointsForHoldingFlag 			= extreme\_ex_utils::dvardef ("scr_htf_pointsforholdingflag", 2, 0, 100, "int");
	level.PointsForStealingFlag 		= extreme\_ex_utils::dvardef ("scr_htf_pointsforstealingflag", 3, 0, 100, "int");

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	
	level.team["allies"] = 0;
	level.team["axis"] = 0;
	level.hasspawned["axis"] = false;
	level.hasspawned["allies"] = false;
	level.hasspawned["flag"] = false;
	level.teamholdtime["axis"] = 0;
	level.teamholdtime["allies"] = 0;
	level.oldteamholdtime["allies"] = level.teamholdtime["allies"];
	level.oldteamholdtime["axis"] = level.teamholdtime["axis"];
	level.allies_cap_count = 0;
	level.axis_cap_count =0;
	
	game["dialog"]["gametype"] = "Hold_the_Flag";
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

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"EXTREME_OBJ_TEXT_NOSCORE" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"EXTREME_OBJ_TEXT_NOSCORE" );
	maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"EXTREME_OBJ_TEXT" );
	maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"EXTREME_OBJ_TEXT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"MISC_HTF_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"MISC_HTF_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	

	if(level.spawnpoints_needed)
	{
		level.custom_spawnpoints = true;
		
		maps\mp\gametypes\_spawnlogic::placeSpawnpoints( "mp_ctf_spawn_allies_start" );
		maps\mp\gametypes\_spawnlogic::placeSpawnpoints( "mp_ctf_spawn_axis_start" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints("allies", "mp_ctf_spawn_allies");
		maps\mp\gametypes\_spawnlogic::addSpawnPoints("axis", "mp_ctf_spawn_axis");
		
		level.custom_spawnpoints = false;
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );

	}
	else
	{
		level.custom_spawnpoints = false;
		
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_allies_start" );
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sab_spawn_axis_start" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_sab_spawn_allies" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_sab_spawn_axis" );
		
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	}

	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	if(level.spawnpoints_needed)
	{
		level.custom_spawnpoints = true;
		
		level.spawn_axis 			= getentarray("mp_ctf_spawn_axis", "targetname");
		level.spawn_allies 			= getentarray("mp_ctf_spawn_allies", "targetname");
		level.spawn_axis_start 		= getentarray("mp_ctf_spawn_axis_start", "targetname");
		level.spawn_allies_start 	= getentarray("mp_ctf_spawn_allies_start", "targetname");

	}
	else
	{
		level.custom_spawnpoints = false;
		
		level.spawn_axis 			= getentarray("mp_sab_spawn_axis", "classname");
		level.spawn_allies 			= getentarray("mp_sab_spawn_allies", "classname");
		level.spawn_axis_start 		= getentarray("mp_sab_spawn_axis_start", "classname");
		level.spawn_allies_start 	= getentarray("mp_sab_spawn_allies_start", "classname");
	}
	
	
	allowed[0] = "htf";
	
	if ( getDvarInt( "scr_oldHardpoints" ) > 0 )
		allowed[1] = "hardpoint";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", level.ex_score_kill );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", level.PointsForAssistingFlagCarrier );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", level.PointsForKillingFlagCarrier );
	maps\mp\gametypes\_rank::registerScoreInfo( "steal", level.PointsForStealingFlag );
	maps\mp\gametypes\_rank::registerScoreInfo( "holding", level.PointsForHoldingFlag );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture_team_complete", level.ex_score_capture_team_complete );
	
	switch( game["allies"] )
	{
		case "marines":
			game["hudicon_allies"] = "faction_128_usmc";
			break;
		case "sas":
			game["hudicon_allies"] = "faction_128_sas";
			break;
		default:
			game["hudicon_allies"] = "faction_128_usmc";
			break;
	}
	switch( game["axis"] )
	{
		case "russian":
			game["hudicon_axis"] = "faction_128_ussr";
			break;
		case "arab":
		case "opfor":
			game["hudicon_axis"] = "faction_128_arab";
			break;
		default:
			game["hudicon_axis"] = "faction_128_arab";
			break;
	}

	game["prop_flag_neutral"] = "prop_flag_neutral";
	level.compassflag_neutral = "compass_waypoint_neutral";
	level.objectpoint_neutral = "objpoint_default";
	
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

	if( game["allies"] == "marines" )
	{
		level.compassflag_allies = "compass_flag_marines";
		level.objpointflag_allies = "objpoint_flag_american";
		level.hudflag_allies = "compass_flag_american";
		level.hudflagflash_allies = level.hudflag_allies;
		level.hudflagflash2_allies = "faction_128_usmc";
	}
	else
	{
		level.compassflag_allies = "compass_flag_british";
		level.objpointflag_allies = "objpoint_flag_british";
		level.hudflag_allies = "compass_flag_british";
		level.hudflagflash_allies = level.hudflag_allies;
		level.hudflagflash2_allies = "faction_128_sas";
	}
	
	if( game["axis"] == "russian" )
	{
		level.compassflag_axis = "compass_flag_russian";
		level.objpointflag_axis = "objpoint_flag_russian";
		level.hudflag_axis = "compass_flag_russian";
		level.hudflagflash_axis = level.hudflag_axis;
		level.hudflagflash2_axis = "faction_128_ussr";
	}
	else
	{
		level.compassflag_axis = "compass_flag_opfor";
		level.objpointflag_axis = "objpoint_flag_opfor";
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
	FindTeamSides();
	thread InitFlag();	
}

onPrecacheGameType()
{
	
	precacheModel( game["prop_flag_neutral"] );
	precacheModel( game["prop_flag_allies"] );
	precacheModel( game["prop_flag_axis"] );
	precacheModel( game["prop_flag_carry_allies"] );
	precacheModel( game["prop_flag_carry_axis"] );
	
	precacheShader( game["hudicon_allies"] );
	precacheShader( game["hudicon_axis"] );
	
	precacheShader( level.compassflag_allies );
	precacheShader( level.compassflag_axis );
	precacheShader( level.objpointflag_axis );
	precacheShader( level.objpointflag_allies );
	
	precacheShader( level.objectpoint_neutral );
	precacheShader( level.compassflag_neutral );
	
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
	
	thread CheckForFlag();
}

onPlayerDisconnect()
{
	self dropFlag();
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{

	if(isdefined(self.flag))
		flagcarrier = true;
	else
		flagcarrier = undefined;

	self dropFlag();
	self unset_sprint();
	
	if(isPlayer(attacker))
	{
		doKillcam = true;
			
		if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
		{
			// Was the flagcarrier killed?
			if(isdefined(flagcarrier) && attacker != self)
			{
				attacker iprintlnbold(&"EXTREME_YOU_TEAMKILLED_FLAG_CARRIER");
				_setPlayerScore( attacker, _getPlayerScore( attacker ) - level.PointsForKillingFlagCarrier );
			}
		}
		else
		{
			// Was the flagcarrier killed?
			if(isdefined(flagcarrier))
			{
				attacker iprintlnbold (&"EXTREME_YOU_KILLED_FLAG_CARRIER");
				attacker thread [[level.onXPEvent]]( "defend" );
				givePlayerScore( "defend", attacker );
			}
			else
			{
				if(attacker AssistedFlagCarrier(self.origin))
				{
					attacker iprintlnbold (&"EXTREME_YOU_ASSISTED_FLAG_CARRIER");
					attacker thread [[level.onXPEvent]]( "assist" );
					givePlayerScore( "assist", attacker );
				}
			}
		}
	}
}

onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 20 );	
}

InitFlag()
{

	flagpoint = GetFlagPoint();
	position = flagpoint.origin;
	angles = flagpoint.angles;
	origin = FindGround( position );

	// Spawn a script origin
	level.flag = spawn("script_origin", origin);
	level.flag.targetname = "htf_flaghome";
	level.flag.origin = origin;
	level.flag.angles = angles;
	level.flag.home_origin = origin;
	level.flag.home_angles = angles;
	level.flag.last_origin = origin;
	
	// Spawn the Neutral Flag to Start
	level.flag.flagmodel = spawn("script_model", level.flag.home_origin);
	level.flag.flagmodel.angles = level.flag.home_angles;
	level.flag.flagmodel setmodel(game["prop_flag_neutral"]);
	level.flag.flagmodel hide();

	// Set flag properties
	level.flag.team = "none";
	level.flag.atbase = false;
	level.flag.stolen = false;
	level.flag.lastteam = "none";
	level.flag.objective = 0;
	level.flag.compassflag = level.compassflag_neutral;
	level.flag.objpointflag = level.objectpoint_neutral;

	wait 0.05;

	SetupHud();

	level.flag returnFlag();
}

GetFlagPoint()
{
	p1 = level.teamside["axis"];
	p2 = level.teamside["allies"];

	// Find center
	x = p1[0] + (p2[0] - p1[0]) / 2;
	y = p1[1] + (p2[1] - p1[1]) / 2;
	z = p1[2] + (p2[2] - p1[2]) / 2;

	// Get nearest spawn
	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	flagpoint = maps\mp\gametypes\_spawnlogic::NearestSpawnpoint(spawnpoints, (x,y,z));

	return flagpoint;
}

pickupFlag(flag)
{
	flag notify("end_autoreturn");

	// What is my team?
	myteam = self.sessionteam;
	if(myteam == "allies")
		otherteam = "axis";
	else
		otherteam = "allies";

	flag.origin = flag.origin + (0, 0, -10000);
	flag.flagmodel hide();
	
	if(myteam == "allies")
		flag.flagmodel setmodel(game["prop_flag_allies"]);
	else
		flag.flagmodel setmodel(game["prop_flag_axis"]);
	
	self.flag = flag;
	self.dont_auto_balance = true;

	if(myteam == "allies")
		self.statusicon = level.hudflag_allies;
	else
		self.statusicon = level.hudflag_axis;

	flag.carrier = self;

	flag.team = self.sessionteam;
	flag.atbase = false;

	if(myteam == "allies")
	{
		flag.compassflag = level.compassflag_allies;
		flag.objpointflag = level.objpointflag_allies;
	}
	else
	{
		flag.compassflag = level.compassflag_axis;
		flag.objpointflag = level.objpointflag_axis;
	}

	if( level.ex_objectivepoints )
	{
		flag deleteFlagWaypoint();
	
		objective_icon( self.flag.objective, flag.compassflag );
		objective_state( self.flag.objective, "current" );
	}

	thread playSoundOnPlayers( "mp_war_objective_lost", myteam );
	thread playSoundOnPlayers( "mp_war_objective_taken", otherteam );
	
	self attachFlag();
	self thread Start_Scoring();
	self thread set_sprint();

}

set_sprint()
{
	if( !level.heavyflag ) return;
	
	while(isdefined(self.flagAttached))
	{
		if(!isdefined(self.flagAttached)) return;
		self AllowSprint(false);
		wait 1;
	}
		
}

unset_sprint()
{
	if( !level.heavyflag ) return;
	
	if(!isdefined(self.flagAttached))
		self AllowSprint(true);
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
		self.flag.stolen = false;

		self.flag.carrier = undefined;
		
		if( level.ex_objectivepoints )
		{
			// set compass flag position on player
			objective_position(self.flag.objective, self.flag.origin);
			objective_state(self.flag.objective, "current");
			
			self.flag createFlagWaypoint();
		}

		self.flag thread autoReturn();
		self detachFlag(self.flag);

		self.flag = undefined;
		self.dont_auto_balance = undefined;
		thread playSoundOnPlayers("mp_war_objective_lost");
	}
}

returnFlag()
{
	self notify("end_autoreturn");

	self deleteFlagWaypoint();
	objective_delete(self.objective);
	objective_delete(self.objective + 1);

	// Wait delay before spawning flag
	wait level.flagspawndelay + 0.05;

	// Do not spawn flag unless there are alive players in both teams
	while( !(alivePlayers("allies") && alivePlayers("axis")) )
		wait 1;

	if(!level.hasspawned["flag"])
	{
		self.origin = self.home_origin;
 		self.flagmodel.origin = self.home_origin;
	 	self.flagmodel.angles = self.home_angles;
		if(level.randomflagspawns)	level.hasspawned["flag"] = true;
	}
	else
	{
		if(level.randomflagspawns == 2)
			spawnpoint = GetSpawnPointAwayFromPlayers();
		else
		{
			spawnpointname = "mp_tdm_spawn";
			spawnpoints = getentarray(spawnpointname, "classname");
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
		}

		self.origin = spawnpoint.origin;
 		self.flagmodel.origin = spawnpoint.origin;
	 	self.flagmodel.angles = spawnpoint.angles;
	}

	self.flagmodel show();
	self.atbase = true;
	self.stolen = false;
	self.lastteam = "none";

	self.carrier = undefined;
	
	if( level.ex_objectivepoints )
	{
		// set compass flag position on player
		objective_add(self.objective, "current", self.origin, self.compassflag);
		objective_position(self.objective, self.origin);
		objective_state(self.objective, "current");
	
		self createFlagWaypoint();
	}

	if(level.randomflagspawns)
		self thread autoReturn();
}

autoReturn()
{
	if(!level.flagrecovertime)
		return;

	self endon("end_autoreturn");

	wait level.flagrecovertime;

	iprintln(&"EXTREME_FLAG_TIMEOUT", level.flagrecovertime);

	// Hide the flag
	self.flagmodel hide();
	self.compassflag = level.compassflag_neutral;
	self.objpointflag = level.objectpoint_neutral;

	// Prevent players from stealing it until it respawns
	self.stolen = true;

	self thread returnFlag();
}

attachFlag()
{
	if(isdefined(self.flagAttached))
		return;

	if(self.pers["team"] == "allies")
		flagModel = game["prop_flag_carry_allies"];
	else
		flagModel = game["prop_flag_carry_axis"];
	
	self attach(flagModel, "J_Spine4", true);
	self.flagAttached = true;
	
	self thread createOwnHudIcon();
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
	
	self thread deleteOwnHudIcon();
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

createOwnHudIcon()
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

	self.hud_flagflashOwn = newClientHudElem(self);
	self.hud_flagflashOwn.x = X;
	self.hud_flagflashOwn.y = Y;
	self.hud_flagflashOwn.alignX = "center";
	self.hud_flagflashOwn.alignY = "middle";
	self.hud_flagflashOwn.horzAlign = "left";
	self.hud_flagflashOwn.vertAlign = "top";
	self.hud_flagflashOwn.hideWhenInMenu = true;
	self.hud_flagflashOwn.alpha = 0;
	self.hud_flagflashOwn.sort = 1;
	
	self.hud_flagflashOwn2 = newClientHudElem(self);
	self.hud_flagflashOwn2.x = X2;
	self.hud_flagflashOwn2.y = Y2;
	self.hud_flagflashOwn2.alignX = "center";
	self.hud_flagflashOwn2.alignY = "middle";
	self.hud_flagflashOwn2.horzAlign = "left";
	self.hud_flagflashOwn2.vertAlign = "top";
	self.hud_flagflashOwn2.hideWhenInMenu = true;
	self.hud_flagflashOwn2.alpha = 0;
	self.hud_flagflashOwn2.sort = 2;

	if(self.pers["team"] == "allies")
	{
		self.hud_flagflashOwn setShader(level.hudflagflash_allies, iconSize, iconSize);
		self.hud_flagflashOwn2 setShader(level.hudflagflash2_allies, icon2Size, icon2Size);
	}
	else
	{
		assert(self.pers["team"] == "axis");
		self.hud_flagflashOwn setShader(level.hudflagflash_axis, iconSize, iconSize);
		self.hud_flagflashOwn2 setShader(level.hudflagflash2_axis, icon2Size, icon2Size);
	}
	
	self.hud_flagflashOwn fadeOverTime(.2);
	self.hud_flagflashOwn2 fadeOverTime(.2);
	self.hud_flagflashOwn.alpha = 1;
	self.hud_flagflashOwn2.alpha = 1;

	wait 180;
	
	if(isdefined(self.hud_flagflashOwn))
	{
		self.hud_flagflashOwn fadeOverTime(1);
		self.hud_flagflashOwn2 fadeOverTime(1);
		self.hud_flagflashOwn.alpha = 0;
		self.hud_flagflashOwn2.alpha = 0;
	}
}

deleteOwnHudIcon()
{
	if(isdefined(self.hud_flagflashOwn))
		self.hud_flagflashOwn destroy();
		
	if(isdefined(self.hud_flagflashOwn2))
		self.hud_flagflashOwn2 destroy();
}

FindTeamSides()
{
	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	maxdist = 0;
	p1 = spawnpoints[0];
	p2 = spawnpoints[0];
	for(i=0;i<spawnpoints.size;i++)
	{
		for(j=0;j<spawnpoints.size;j++)
		{
			if(i==j) continue;
			dist = distance(spawnpoints[i].origin,spawnpoints[j].origin);
			if(dist>maxdist)
			{
				maxdist = dist;
				p1 = spawnpoints[i];
				p2 = spawnpoints[j];
			}
		}
	}

	// Save teamsides for initial spawning
	if(randomInt(2))
	{
		level.teamside["axis"] = p1.origin;
		level.teamside["allies"] = p2.origin;
	}
	else
	{
		level.teamside["axis"] = p2.origin;
		level.teamside["allies"] = p1.origin;
	}
}

FindGround(position)
{
	return (physicstrace (position + (0, 0, 20), position + (0, 0, -20)));
}

CheckForFlag()
{
	level endon("intermission");

	self.flag = undefined;
	count=0;
	oldorigin = self.origin;

	// What is my team?
	myteam = self.sessionteam;
	if(myteam == "allies")
		otherteam = "axis";
	else
		otherteam = "allies";
	
	while (isAlive(self) && self.sessionstate == "playing" && myteam == self.sessionteam) 
	{
		// Does the flag exist and is not currently being stolen?
		if(!level.flag.stolen)
		{
			// Am I touching it and it is not currently being stolen?
			if(self isTouchingFlag() && !level.flag.stolen)
			{
				level.flag.stolen = true;
		
				// Steal flag
				self pickupFlag(level.flag);

				oldorigin = self.origin;

				if(self.flag.lastteam != myteam)
				{
					iprintlnbold(&"EXTREME_STOLE_FLAG", self.name);

					// Get personal score
					self thread [[level.onXPEvent]]( "steal" );
					givePlayerScore( "steal", self );

					if(level.mode == 2)
						level.teamholdtime[otherteam] = 0;

					lpselfnum = self getEntityNumber();
					lpselfguid = self getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + myteam + ";" + self.name + ";" + "htf_stole" + "\n");
				}
				else
				{
					iprintlnbold( &"EXTREME_STOLE_FLAG", self.name );
				}
				
				self.flag.lastteam = self.flag.team;

				if(myteam == "axis")
					level.iconaxis scaleOverTime(1, 22, 22);
				else
					level.iconallies scaleOverTime(1, 22, 22);
				
				count = 0;
			}
		}

		// Update objective on compass
		if(isdefined(self.flag))
		{
			// Update the objective for my team
			objective_position(self.flag.objective, self.origin);		

			wait 0.05;

			// Make sure flag still exist
			if(isdefined(self.flag))
			{
				count++;
				if(count>=20)
				{
					count = 0;
					
					// Update the other teams objective (lags 1 second behind)
					objective_position(self.flag.objective+1, oldorigin);		
					oldorigin = self.origin;
	
					if(level.mode == 1 && level.teamholdtime[otherteam])
						level.teamholdtime[otherteam]--;
					else
						level.teamholdtime[myteam]++;

					if(level.teamholdtime[myteam] >= level.holdtime)
					{
						if(myteam == "allies")
						{
							iprintlnbold (&"EXTREME_ALLIED_SCORED", level.holdtime);
							thread allies_flag_count();
						}
						else
						{
							iprintlnbold (&"EXTREME_AXIS_SCORED", level.holdtime);
							thread axis_flag_count();
						}

						thread playSoundOnPlayers("plr_new_rank", myteam);
						thread playSoundOnPlayers("mp_obj_taken", otherteam);

						level.teamholdtime[myteam] = 0;
						if(level.mode == 3)
							level.teamholdtime[otherteam] = 0;

						// Get personal score
						self thread [[level.onXPEvent]]( "holding" );
						givePlayerScore( "holding", self );

						// Give all other team members 1 point
						players = getentarray("player", "classname");
						for(i = 0; i < players.size; i++)
						{
							player = players[i];
					
							if(!isDefined(player.pers["team"]) || player.pers["team"] != myteam || player == self)
								continue;
							
							player thread [[level.onXPEvent]]( "capture_team_complete" );	
							givePlayerScore( "capture_team_complete", player );
						}

						lpselfnum = self getEntityNumber();
						lpselfguid = self getGuid();
						logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + myteam + ";" + self.name + ";" + "htf_scored" + "\n");
						
						level notify("update_allhud_score");

						if(myteam == "allies")
							level.numallies setValue(level.allies_cap_count);
						else
							level.numaxis setValue(level.axis_cap_count);

						checkScoreLimit();

						self detachFlag(self.flag);
						self thread unset_sprint();

						// Return flag
						self.flag thread ReturnFlag();

						// Clear flags
						self.flag = undefined;	

						if(myteam == "axis")
							level.iconaxis scaleOverTime(1, 18, 18);
						else
							level.iconallies scaleOverTime(1, 18, 18);
					}

					UpdateHud();
				}
			}
		}
		else
			wait 0.2;		
	}

	//player died or went spectator
	self dropFlag();
}

//score 1 every second
Start_Scoring()
{
	myteam = self.sessionteam;
	if( self.pers["team"] == "allies" )
		myteam = "allies";
	else
		myteam = "axis";
	
	count = 0;
	
	while( 1 )
	{
		if( count == level.holdtime || !isdefined(self.flagAttached) ) 
			break;
			
		count++;
		
		[[level._setTeamScore]]( myteam, _getTeamScore(myteam) + 1 );
		level notify("update_allhud_score");
		wait 1;
	}
}

axis_flag_count()
{
	level endon("intermission");

	level.axis_cap_count++;
}

allies_flag_count()
{
	self endon("intermission");
	
	level.allies_cap_count++;
}

isTouchingFlag()
{
	if(distance(self.origin, level.flag.origin) < 50)
		return true;
	else
		return false;
}

SetupHud()
{
	level endon("awe_killthreads");
	
	X = undefined;
	y = undefined;
	
	if( level.hardcoreMode && level.ex_hardcore_minimap )
	{
		X = 370;
		y = 30;
	}
	else if( level.hardcoreMode && !level.ex_hardcore_minimap )
	{
		X = 320;
		y = 15;
	}
	else
	{
		X = 370;
		y = 30;
	}
		
	barsize = 200;
	

	level.scoreback = newHudElem();
	level.scoreback.x = X;
	level.scoreback.y = y;
	level.scoreback.alignX = "center";
	level.scoreback.alignY = "middle";
	level.scoreback.alpha = 0.3;
	level.scoreback.color = (0.2,0.2,0.2);
	level.scoreback setShader("white", barsize*2+4, 12);

	level.scoreallies = newHudElem();
	level.scoreallies.x = X;
	level.scoreallies.y = y;
	level.scoreallies.alignX = "right";
	level.scoreallies.alignY = "middle";
	level.scoreallies.color = (1,0,0);
	level.scoreallies.alpha = 0.5;
	level.scoreallies setShader("white", 1, 10);

	level.scoreaxis = newHudElem();
	level.scoreaxis.x = X;
	level.scoreaxis.y = y;
	level.scoreaxis.alignX = "left";
	level.scoreaxis.alignY = "middle";
	level.scoreaxis.color = (0,0,1);
	level.scoreaxis.alpha = 0.5;
	level.scoreaxis setShader("white", 1, 10);

	level.iconallies = newHudElem();
	level.iconallies.x = X - barsize - 3;
	level.iconallies.y = y;
	level.iconallies.alignX = "right";
	level.iconallies.alignY = "middle";
	level.iconallies.color = (1,1,1);
	level.iconallies.alpha = 1;
	level.iconallies setShader(game["hudicon_allies"], 20, 20);

	level.iconaxis = newHudElem();
	level.iconaxis.x = X + barsize + 3;
	level.iconaxis.y = y;
	level.iconaxis.alignX = "left";
	level.iconaxis.alignY = "middle";
	level.iconaxis.color = (1,1,1);
	level.iconaxis.alpha = 1;
	level.iconaxis setShader(game["hudicon_axis"], 20, 20);

	level.numallies = newHudElem();
	level.numallies.x = X - barsize - 30;
	level.numallies.y = y-2;
	level.numallies.alignX = "right";
	level.numallies.alignY = "middle";
	level.numallies.color = (1,1,0);
	level.numallies.alpha = 1;
	level.numallies.fontscale = 1.4;
	level.numallies setValue(0);

	level.numaxis = newHudElem();
	level.numaxis.x = X + barsize + 35;
	level.numaxis.y = y-2;
	level.numaxis.alignX = "right";
	level.numaxis.alignY = "middle";
	level.numaxis.color = (1,1,0);
	level.numaxis.alpha = 1;
	level.numaxis.fontscale = 1.4;
	level.numaxis setValue(0);
}

CleanUp()
{
	level.numaxis.alpha = 0;
	level.numallies.alpha = 0;
	level.iconaxis.alpha = 0;
	level.iconallies.alpha = 0;
	level.scoreaxis.alpha = 0;
	level.scoreallies.alpha = 0;
	level.scoreback.alpha = 0;
}

UpdateHud()
{
	y = 10;
	barsize = 200;

	axis = int(level.teamholdtime["axis"] * barsize / (level.holdtime - 1) + 1);
	allies = int(level.teamholdtime["allies"] * barsize / (level.holdtime - 1) + 1);

	if(level.teamholdtime["allies"] != level.oldteamholdtime["allies"])
		level.scoreallies scaleOverTime(1,allies,10);
	if(level.teamholdtime["axis"] != level.oldteamholdtime["axis"])
		level.scoreaxis	scaleOverTime(1,axis,10);

	level.oldteamholdtime["allies"] = level.teamholdtime["allies"];
	level.oldteamholdtime["axis"] = level.teamholdtime["axis"];
}

AssistedFlagCarrier(victim_origin)
{
	flag = level.flag;

	if (! isdefined (flag.carrier))
		// No carrier for the flag
		return (false);

	if (flag.carrier == self)
		// No "self-assistance"
		return (false);
			
	if (flag.carrier.pers["team"] != self.pers["team"])
		// No assistance for ennemy carrier
		return (false);

	dist = distance (victim_origin, flag.carrier.origin);
		
	return (dist < level.flagprotectiondistance);
}

GetSpawnPointAwayFromPlayers()
{
	// Determine the center position of all players
	x = 0;
	y = 0;
	z = 0;
	numplayers = 0;
	players = getentarray ("player", "classname");
	for (i = 0; i < players.size; i ++)
	{
		player = players[i];
		if (isDefined (player.pers["team"]) && (player.sessionstate == "playing") && isAlive(player))
		{
			x += player.origin[0];
			y += player.origin[1];
			z += player.origin[2];
			numplayers ++;
		}
	}
	centerpoint = (x / numplayers, y / numplayers, z / numplayers);

	// Find the farthest spawn point from the center
	spawnpointname = "mp_tdm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");

	spawnpoint = FarthestSpawnpoint(spawnpoints, centerpoint);
	level.flag.last_origin = spawnpoint.origin;
	return (spawnpoint);
}

FarthestSpawnpoint(aeSpawnpoints, vPosition)
{
	eFarthestSpot = aeSpawnpoints[0];
	fFarthestDist = distance(vPosition, aeSpawnpoints[0].origin);
	for(i = 1; i < aeSpawnpoints.size; i++)
	{
		fDist = distance(vPosition, aeSpawnpoints[i].origin);
		if ((fDist > fFarthestDist) && (aeSpawnpoints[i].origin != level.flag.last_origin))
		{
			eFarthestSpot = aeSpawnpoints[i];
			fFarthstDist = fDist;
		}
	}
	
	return eFarthestSpot;
}

IsAwayFromFlag()
{
	dist = distance (self.origin, level.flag.origin);
	return ((dist >= level.spawndistance) && (dist <= level.spawndistancemax));
}

alivePlayers(team)
{
	allplayers = getentarray("player", "classname");
	alive = [];
	for(i = 0; i < allplayers.size; i++)
	{
		if(allplayers[i].sessionstate == "playing" && allplayers[i].sessionteam == team)
			alive[alive.size] = allplayers[i];
	}
	return alive.size;
}