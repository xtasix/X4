#include maps\mp\_utility;

//******************************************************************************
// extreme launch main threads
//******************************************************************************
main()
{
	// fps auto-updater by BulletWorm
	level thread extreme\_ex_fps::monitorFPS();

	// get the map dimensions and playing field dimensions
	extreme\_ex_utils::GetMapDim();
	extreme\_ex_utils::GetFieldDim();

	// set up map rotation
	if(getDvar("ex_maprotdone") == "")
	{
		// set up player based rotation
		if(level.ex_pbrotate) extreme\_ex_maprotation::pbrotation();
		// save rotation for rotation stacker
		setDvar("ex_maprotation", getDvar("sv_maprotation"));
		setDvar("ex_maprotdone","1");
	}

	// rotation stacker
	if(!level.ex_pbrotate)
	{
		ex_maprotation = getDvar("ex_maprotation");
		maprotcur = getDvar("sv_maprotationcurrent");
		if(maprotcur == "")
		{
			maprotno = getDvar("ex_maprotno");
			if(maprotno == "") maprotno = 0;
				else maprotno = getDvarInt("ex_maprotno");
			maprotno++;
			maprot = getDvar("sv_maprotation" + maprotno);
			if(maprot != "")
			{
				setDvar("sv_maprotation", maprot);
				setDvar("ex_maprotno", maprotno);
			}
			else if(maprotno != 1)
			{
				maprotno = 0;
				setDvar("sv_maprotation", ex_maprotation);
				setDvar("ex_maprotno", maprotno);
			}
		}
	}

	// fix the map rotation
	if(level.ex_fixmaprotation) level extreme\_ex_maprotation::fixMapRotation();

	// set a random map rotation
	if(level.ex_randommaprotation) level thread extreme\_ex_maprotation::randomMapRotation();

	// eXtreme+ command monitor
	if(level.ex_cmd_monitor) level thread extreme\_ex_cmdmonitor::init();

	// rotating motd
	if(level.ex_motd_rotate) level thread extreme\_ex_messages::motdRotate();

	// firstaid
	if(level.ex_firstaid_kits) level thread extreme\_ex_firstaid::init();

	// call vote delay
	if(level.ex_callvote_mode) level thread extreme\_ex_callvote::init();

	// clear any camping players
	if(level.ex_campwarntime || level.ex_campsniper_warntime) level thread extreme\_ex_camper::removeCampers();

	// turrets
	if(!level.ex_turrets) level thread extreme\_ex_turrets::removeTurrets();
	else if(level.ex_turretoverheat) level thread extreme\_ex_turrets::monitorTurrets();

	// server messages
	if(level.ex_servermsg || level.ex_servermsg_info) level thread extreme\_ex_messages::serverMessages();

	// livestats
	if(level.ex_livestats) level thread extreme\_ex_livestats::init();

	// show logo
	if(level.ex_logo) level thread extreme\_ex_logo::init();

	// launch name checker
	if(level.ex_namechecker) level thread extreme\_ex_namecheck::init();

	// time announcer
	if(level.ex_timeannouncer) level thread extreme\_ex_timeannouncer::init();

	// rotate if empty
	if(level.ex_rotateifempty) level thread extreme\_ex_rotate::init();
	
	// text logos for mod and server
	if(level.ex_modinfo) level thread extreme\_ex_modinfo::init();
	
	// ammo crates
	if(level.ex_amc_perteam) level thread extreme\_ex_ammocrates::spawnCrates();
		
	// flares
	if(level.ex_flares >= 1) level thread extreme\_ex_flares_ambient::init();
	
	// planes
	if(level.ex_planes >= 1) level thread extreme\_ex_airplanes::init();
	
	// artillery
	if(level.ex_artillery >= 1) level thread extreme\_ex_ambient_artillery::init();
	
	// tracers
	if(level.ex_tracers) for(tracers=0;tracers<level.ex_tracers;tracers++) level thread extreme\_ex_ambient_skyeffects::tracers();

	// flak fx
	if(level.ex_flakfx) for(flak=0;flak<level.ex_flakfx;flak++) level thread extreme\_ex_ambient_skyeffects::flakfx();
	
	// test clients (bots)
	level thread extreme\_ex_bots::init();

	// AC130
	level thread extreme\_ex_ac130::main();
	
	// UAV Drone
	level thread extreme\_ex_uav::main();
	
}

//******************************************************************************
// extreme launch player threads
//******************************************************************************
playerThreads()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");
	
	// monitor player´s behaviour
	self thread monitorPlayer();
	
	// fullwarfare x4
	if(level.ex_fullwarfare) self thread maps\mp\gametypes\_fullwarfare::start_threads();
		
	// gold camo unlocks
	if(level.ex_gold_camo_unlock) self thread extreme\_ex_main::gold_camo_unlocks();

	// forced dvars
	if(level.ex_forcedvar_mode) self thread extreme\_ex_forcedvar::start();

	// start player bob factor
	if(level.ex_bobfactor) self thread extreme\_ex_bobfactor::start();

	// spawn protection
	if(level.ex_spawnprot) self thread extreme\_ex_spawnprot::start();
	
	// healthbar
	if(level.ex_healthbar) self thread extreme\_ex_healthbar::start();

	// firstaid
	if(level.ex_firstaid_kits) self thread extreme\_ex_firstaid::start();

	// apply laser dot
	if(level.ex_laserdot) self thread extreme\_ex_laserdot::start();
	
	// apply static crosshair
	if(level.ex_staticcross) self thread extreme\_ex_laserdot::draw_cross();

	// rangefinder
	if(level.ex_rangefinder) self thread extreme\_ex_rangefinder::start();
	
	// stats 1 at a time
	if(level.ex_hudstats) self thread extreme\_ex_hudstats::main();
	
	// stats all on button press
	if(level.ex_hudstatsuse) self thread extreme\_ex_hudstats::statsonuse();
	
	// camper check
	if(level.ex_campwarntime || level.ex_campsniper_warntime) self thread extreme\_ex_camper::start();
	
	// sniper zoom level monitor
	if(level.ex_zoom) self thread extreme\_ex_zoom::start();
	
	// voip chat display
	if(level.ex_TeamChat_Name) self thread extreme\_ex_teamchat::Start_ChatName();

	// show welcome messages 
	self thread handleWelcome();
	
	// bodysearch
	while( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
	{
		if(level.ex_bodysearch) self thread extreme\_ex_body::SearchBody();
		wait 0.05;
	}
	
	// show call vote delay status
	self thread extreme\_ex_callvote::voteShowStatus();

	// If this is a bot, freeze (if enabled) and stop here
	if(isDefined(self.pers["isbot"]))
	{
		if(!isDefined(getDvarInt("scr_botfreeze"))) setDvar("scr_botfreeze", 0);
			else if(getDvarInt("scr_botfreeze") == 1) self extreme\_ex_punishments::doAnchor(true);
		return;
	}
	
	// Positioning shows you your exact position on a map (in devmap mode only)
	//self thread extreme\_ex_tools::ShowPlayerPosition();
	
	// Positioning shows you your exact position on a map
	if(level.ex_showcoordinates) self thread show_location();
}

//******************************************************************************
// extreme player spawn handling
//******************************************************************************
exPreSpawn()
{
	level endon("ex_gameover");
	self endon("disconnect");

	// stop rotating motd
	if(level.ex_motd_rotate) self notify("stopmotd");

	// set spawn variables
	setPlayerVariables();
}

exPostSpawn()
{
	level endon("ex_gameover");
	self endon("disconnect");

	// wait for threads to die
	//wait 0.05;

	if(isPlayer(self)) self thread playerThreads();
}

setPlayerVariables()
{
	self thread resetFlagVars();

	// apply these stats if not defined already
	count = 1;
	for(;;)
	{
		stat = getPlayerVariable(count);
		if(stat == "GTSRESET" || stat == "") break;
			else if(isPlayer(self) && !isDefined(self.pers[stat])) self.pers[stat] = 0;
		count++;
	}

	// misc variables
	if(!isDefined(game[self.name])) game[self.name] = [];

	// set streak variables to 0
	self.pers["noobstreak"] = 0;
	self.pers["weaponstreak"] = 0;
}

resetPlayerVariables()
{
	self thread resetFlagVars();

	// reset the stats
	count = 1;
	for(;;)
	{
		stat = getPlayerVariable(count);
		if(stat == "GTSRESET") continue;
			else if(stat == "") break;

		if(isPlayer(self)) self.pers[stat] = 0;
		count++;
	}

	// misc variables
	if(isDefined(game[self.name])) game[self.name] = [];
	game[self.name]["conseckill"] = 0;

	self.score = 0;
	self.deaths = 0;
}

resetFlagVars()
{
	// eXtreme+
	self.ex_bleeding = false;
	
	self.ex_bsoundinit = false;
	self.ex_bshockinit = false;
	self.ex_invulnerable = false;
	self.ex_cmdmondeath = undefined;
	self.ex_firstaidkits = 0;
	self.ex_forcedsuicide = undefined;
	self.ex_inmenu = false;
	self.ex_iscamper = false;
	self.ex_ishealing = undefined;
	if(!isDefined(self.ex_isdupname)) self.ex_isdupname = false;
	if(!isDefined(self.ex_isunknown)) self.ex_isunknown = false;
	self.ex_ispunished = false;
	self.ex_spawnprotected = false;
	self.ex_weaponpause = false;
	self.ex_hardpointtype = undefined;
	self.issearching = false;
	// stock
	self.spamdelay = undefined;
}

getPlayerVariable(stat)
{
	switch(stat)
	{
		// kills
		case 1:  return "kill";
		case 2:  return "grenadekill";
		case 3:  return "claymorekill";
		case 4:  return "headshotkill";
		case 5:  return "sniperkill";
		case 6:  return "knifekill";
		case 7:  return "helostrikekill";
		case 8:  return "rpgkill";
		case 9:  return "airstrikekill";
		case 10: return "napalmkill";
		case 11: return "ac130kill";
		case 12: return "spawnkill";
		case 13: return "spamkill";
		case 14: return "teamkill";
		case 15: return "carkill";
		case 16: return "c4kill";
		case 17: return "nukekill";
  		case 18: return "m203kill"; 
  		case 19: return "sawkill"; 

		// deaths
		case 20: return "death";
		case 21: return "grenadedeath";
		case 22: return "claymoredeath";
		case 23: return "headshotdeath";
		case 24: return "sniperdeath";
		case 25: return "rpgdeath";
		case 26: return "knifedeath";
		case 27: return "helostrikedeath";
		case 28: return "airstrikedeath";
		case 29: return "napalmdeath";
		case 30: return "nukedeath";
		case 31: return "ac130death";
		case 32: return "spawndeath";
		case 33: return "planedeath"; //planedeath but not shure if we we want to use this 
		case 34: return "cardeath";
		case 35: return "fallingdeath"; //mod fallingdeath is counting as a falldeath after detaching from the ac130
		case 36: return "minefielddeath";
		case 37: return "suicide";
		case 38: return "c4death";
		case 39: return "cardeath";
  		case 40: return "m203death"; 
  		case 41: return "sawdeath"; 

		// other
		case 42: return "turretkill";
		case 43: return "noobstreak";
		case 44: return "conseckill";
		case 45: return "weaponstreak";
		case 46: return "roundshown";
		case 47: return "longdist";
		case 48: return "longhead";
		case 49: return "longspree";
		case 50: return "flagpoints";
		case 51: return "bonus";
		case 52: return "knife_kill";
		case 53: return "grenade_kill";
		case 54: return "headshot_kill";

		// reset only when using gametype start delay
		case 55: return "GTSRESET";
		case 56: return "score";
		case 57: return "deaths";
		default: return "";
	}
}

//******************************************************************************
// extreme damage and kill hooks
//******************************************************************************
exPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	self endon("disconnect");
	self notify("ex_damaged");

	// abort if either attacher or victim is spawn protected
	if(isDefined(eAttacker) && isPlayer(eAttacker) && eAttacker.ex_spawnprotected) return;
	if(self.ex_spawnprotected && sMeansOfDeath != "MOD_EXPLOSIVE") return;

	// bullet holes
	if(level.ex_bulletholes && (sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET"))
		self thread extreme\_ex_bulletholes::bullethole();

	if(isPlayer(eAttacker))
	{
		// pain sound
		if(level.ex_painsound && (randomInt(100) < level.ex_painsound_chance))
			self thread extreme\_ex_utils::playSoundOnPlayer("generic_pain", "pain");
	}

	// bleeding
	if(level.ex_bleeding)
		self thread extreme\_ex_bleeding::playerBleed(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

	// damage modifiers
	iDamage = extreme\_ex_main::WeaponDamageMod( self, eAttacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );
	
	// closekill
	if(level.ex_closekill)
	{
		if(isDefined(eAttacker) && isPlayer(eAttacker)) 
		{ 
			yards = int((distance(eAttacker.origin, self.origin)) * 0.02778); //to match _ex_obits was 0.03778 
			if(yards < level.ex_killyards) 
			{ 
				eAttacker iprintlnBold( "^7That shot was only ^1" + yards + " yards" ); 
				eAttacker iprintlnBold( "^7NO KILLING BELOW ^140 yards^7 SNIPER!" ); 
				self iprintln( eAttacker.name, "^7 is trying to shoot you from ^1" + yards + " yards" ); 

				if(!isDefined(eAttacker.ckcount)) eAttacker.ckcount = 0; 
				eAttacker.ckcount++; 
				//logprint("CLOSEKILL DEBUG: " + eAttacker.name + ":" + eAttacker.ckcount + "\n"); 

				if(eAttacker.ckcount == 1) eAttacker shellshock("default", 8); 
					else if(eAttacker.ckcount == 2) eAttacker shellshock("flashbang", 10); 
						else if(eAttacker.ckcount == 3) 
						{ 
							eAttacker.ckcount = 0; 
							eAttacker suicide(); 
						} 
				return; 
			} 
		}
	}

	if(isAlive(self))
	{	
		switch(sHitLoc)
		{
			case "right_hand":
			case "left_hand":
			case "gun":
			if(level.ex_droponhandhit != 0 && randomInt(100) < level.ex_droponarmhit) self thread maps\mp\gametypes\_weapons::dropWeaponForDeath(); //mayDropWeapon();
			break;
			
			case "right_arm_lower":
			case "left_arm_lower":
			if(level.ex_droponarmhit != 0 && randomInt(100) < level.ex_droponarmhit) self thread maps\mp\gametypes\_weapons::dropWeaponForDeath(); //mayDropWeapon();
			break;
	
			case "right_foot":
			case "left_foot":
			if(level.ex_triponfoothit && randomInt(100) < level.ex_triponfoothit) self thread extreme\_ex_punishments::spankMe(2);
			break;

			case "right_leg_lower":
			case "left_leg_lower":
			if(level.ex_triponleghit && randomInt(100)<level.ex_triponleghit) self thread extreme\_ex_punishments::spankMe(2);
			break;
		}
	}
	
	[[level.ex_callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

exPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("disconnect");
	self notify("ex_dead");
	
	if(self.sessionteam == "spectator") return;
	
	// dropping medikits
	if(level.ex_firstaid_kits && level.ex_firstaid_drop) self extreme\_ex_firstaid::healthDrop();
	
	// bloodyscreen
	if(level.ex_bloodyscreen) self thread extreme\_ex_bloodyscreen::CleanupSpawned();
	
	// grenade cookbar
	if(level.ex_grenadecookbar) self thread extreme\_ex_grenadecookbar::CleanupSpawned();
	
	/*
	switch(sMeansOfDeath)
	{
		case "MOD_MELEE":
			break;
		case "MOD_PROJECTILE":
		case "MOD_PROJECTILE_SPLASH":
		case "MOD_GRENADE_SPLASH":
		case "MOD_EXPLOSIVE":
		case "MOD_HEAD_SHOT":
			break;
		default:
			break;
	}
	*/
	
	//knife-headshot-grenade counter edited by [105]HolyMoly
	
	if(sMeansOfDeath == "MOD_MELEE")
	{
		attacker.pers["knife_kill"]++;
		
		if(level.ex_showbashbold)
		{
			bashmsg5[0] = "^1------^6>^5YOU SLICED HIS NUTS OFF!^6<^1------^7";
			bashmsg5[1] = "^1------^6>^5HE WAS UNMANNED!^6<^1------^7";
			bashmsg5[2] = "^1------^6>^5HIS BOYS ARE GONE!^6<^1------^7";
			bashmsg5[3] = "^1------^6>^5HE HAD A SEX CHANGE!^6<^1------^7";
			bashmsg5[4] = "^1------^6>^5YOU STOLE HIS FAMILY JEWELS!^6<^1------^7";
			bashmsg5[5] = "^1------^6>^5YOU WACKED HIS WILLIE!^6<^1------^7";
			bashmsg5[6] = "^1------^6>^5YOU VIOLATED HIM BIG TIME!^6<^1------^7";
			
			attacker iprintlnbold(bashmsg5[randomInt(bashmsg5.size)]);
			attacker iprintlnbold ("^1------^6>^5KNIFEKILL ^2#" + attacker.pers["knife_kill"] + "^6<^1------");
		}
		
		if(level.ex_showbashcount)
		{
			iprintln(attacker.name + " ^7sliced " + self.name + " ^7to death with his ^6knife" + " ^5(Knifekill #" + attacker.pers["knife_kill"] + "^5)");
		}
	}
	
	if(sWeapon == "frag_grenade_mp")
	{
		if(attacker == self) return;
		attacker.pers["grenade_kill"]++;
		
		if(level.ex_shownadebold)
		{ 
			nademsg4[0] = "^1------^6>^5PERFECT PINEAPPLE!^6<^1------^7";
			nademsg4[1] = "^1------^6>^5SHOVED THAT DOWN HIS THROAT!^6<^1------^7";
			nademsg4[2] = "^1------^6>^5HE DIDN'T SEE IT COMING!^6<^1------^7";
			nademsg4[3] = "^1------^6>^5NOW THAT WAS LUCKY!^6<^1------^7";
			nademsg4[4] = "^1------^6>^5HOLY CRAP!^6<^1------^7";
			
			attacker iprintlnbold(nademsg4[randomInt(nademsg4.size)]);
			attacker iprintlnbold ("^1------^6>^5NADE KILL ^2#" + attacker.pers["grenade_kill"] + "^6<^1------");
		}
		
		if(level.ex_shownadecount)	
		{ 
			iprintln(attacker.name + " ^7blew " + self.name + " ^7to tiny pieces" + " ^5(NADE KILL #" + attacker.pers["grenade_kill"] + "^5)");
		}
	}
	
	if(sMeansOfDeath == "MOD_HEAD_SHOT")
	{
		attacker.pers["headshot_kill"]++;
		
		if(level.ex_showheadbold)
		{
			headmsg4[0] = "^1------^6>^5IN 1 EAR & OUT THE OTHER!^6<^1------^7";
			headmsg4[1] = "^1------^6>^5BULLSEYE!^6<^1------^7";
			headmsg4[2] = "^1------^6>^5YOU PARTTED HIS HAIR!^6<^1------^7";
			headmsg4[3] = "^1------^6>^5HE WAS JUST ASKING FOR IT!^6<^1------^7";
			headmsg4[4] = "^1------^6>^5HIS HEAD EXPLODED LIKE A MELON!^6<^1------^7";
			attacker iprintlnbold(headmsg4[randomInt(headmsg4.size)]);
			attacker iprintlnbold ("^1------^6>^5HEADSHOT ^2#" + attacker.pers["headshot_kill"] + "^6<^1------");
		}
		
		if(level.ex_showheadcount)
		{
			iprintln(attacker.name + " ^7scoped in on " + self.name + " ^7and took his head clean off" + "^5 (Headshot #" + attacker.pers["headshot_kill"] + "^5)");
		}
	}
	
	// clean the hud
	self extreme\_ex_hud::cleanPlayerHud();
}

//******************************************************************************
// extreme game start and end hooks
//******************************************************************************
exStartGame()
{
	level.ex_gameover = false;
	level notify("ex_gamestart");
	wait (0.05 * level.fps_multiplier);
}

exEndGameCleanUp()
{
	level.ex_gameover = true;
	level notify("ex_gameover");
	
	wait (0.05 * level.fps_multiplier);

	// kick all bots
	if(level.ex_bots_endgamekick) thread extreme\_ex_bots::kickBots();

	// clear player hud elements and vars
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isPlayer(players[i]))
		{
			players[i] thread extreme\_ex_hud::cleanPlayerHud();
			players[i] thread setPlayerVariables();
		}
	}

	// clear hud elements
	level thread extreme\_ex_hud::cleanLevelHud();
}

exEndGame()
{
	// if playerbased map rotation is enabled and map voting is disabled change the rotation
	// now that the player size may have changed from the start of the game
	if(level.ex_pbrotate && !level.ex_mapvote) extreme\_ex_maprotation::pbRotation();

	// launch statsboard
	if(level.ex_stbd) 
	{
		extreme\_ex_statsboard::main();
		wait 2;
	}
	
	// launch mapvote
	if(level.ex_mapvote) extreme\_ex_mapvote::start();
}

//******************************************************************************
// extreme player monitor
//******************************************************************************
monitorPlayer()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	self.ex_moving = false;
	self.ex_pace = false;
	self.ex_stance = 0;
	self.ex_sprinting = false;
	self.ex_jumping = false;

	self thread monitorAds();
	self thread monitorMovement();
	self thread monitorStance();
	self thread monitorSprint();
	self thread monitorJump();
}

monitorAds()
{
	self endon ( "disconnect" );
	self endon ("death");

	for ( ;; )
	{	
		self.ex_wasfromthehip = false;
		self.ex_playerdead = false;
		self.ex_playerinjured = false;
		self.ex_IsPunished = false;
		self.ex_IsHipPunished = false;
		
		self waittill ( "begin_firing" );
		
		if(!self.ex_IsHipPunished)
		{		
			self.ex_wasfromthehip = false;

			// check that the shots are from a sightable weapon...		
			curWeapon = self getCurrentWeapon();

			switch ( weaponClass( curWeapon ) )
			{
				case "rifle":   // rifle can ADS
					if(self playerADS() == 0) self.ex_wasfromthehip = true;
					break;
				case "pistol":	// pistol can ADS
					if(self playerADS() == 0) self.ex_wasfromthehip = true;
					break;
				case "smg":	// SMG can ADS
					if(self playerADS() == 0) self.ex_wasfromthehip = true;
					break;
				case "mg":	// MG can ADS
					if(self playerADS() == 0) self.ex_wasfromthehip = true;
					break;
				default:
					break;
			}
		}
		if(level.ex_hipshotenforement == 1)
		{
			if(self.ex_wasfromthehip && !self.ex_IsPunished) self thread extreme\_ex_punishments::ForceHipShotPunish();
		}
	}
}

monitorMovement()
{	
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(level.ex_antirun) self.antirun_puninprog = false;

	while(isPlayer(self) && isAlive(self) && self.sessionstate == "playing")
	{
		if(isPlayer(self))
		{
			// Calculate current speed
			mark = self.origin;
			wait 0.1;

			if(isPlayer(self))
			{
				//dist = distance(mark, self.origin);
				dist = distance2d(mark, self.origin);

				if(dist > 1) self.ex_moving = true;
					else self.ex_moving = false;

				if(dist > 10) self.ex_pace = true;
					else self.ex_pace = false;

				// Sniper anti-run
				if(level.ex_antirun && !self.ex_spawnprotected)
				{
					if(self.ex_sprinting || (self.ex_stance == 0 && self.ex_moving))
					{
						if(isdefined(self.antirun_mark))
						{
							if(int(distance(self.antirun_mark, self.origin)) > level.ex_antirun_distance)
							{
								self thread extreme\_ex_punishments::antirunPunish();
								self.antirun_mark = undefined;
							}
						}
						else self.antirun_mark = mark;
					}
					else self.antirun_mark = undefined;
				}
			}
		}
	}
}

monitorStance()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	self.ex_stance = 0;

	while(1)
	{
		wait(0.1);

		// "stand"(0), "crouch"(1), "prone"(2)
		stance = self GetStance();
		switch(stance)
		{
			case "stand":
				self.ex_stance = 0;
				break;
			case "crouch":
				self.ex_stance = 1;
				break;
			case "prone":
				self.ex_stance = 2;
				break;
		}
	}
}

monitorSprint()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	self.ex_sprinting = false;
	
	while(1)
	{
		self waittill("sprint_begin");
		self.ex_sprinting = true;
		self waittill("sprint_end");
		self.ex_sprinting = false;
	}
}

monitorJump()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	self.ex_jumping = false;

	lastprone = 2;
	lastjump = 3;

	jumpcheck = false;
	jumpsensor = 0;

	while(1)
	{
		wait 0.05;

		self.ex_jumping = !self isOnGround();
		
		if(level.ex_stancemon)
		{
			doit = false;

			switch(level.ex_stancemon)
			{
				case 1:
					if(self.ex_stance == 2 && lastprone != 2) doit = true;
					break;
				case 2:
					if(self.ex_jumping && !lastjump) jumpcheck = true;
					break;
				default:
					if(self.ex_stance == 2 && lastprone != 2) doit = true;
						if(self.ex_jumping && !lastjump) jumpcheck = true;
					break;
			}

			if(jumpcheck)
			{
				jumpsensor++;
				if(jumpsensor > level.ex_stancemon_threshold)
				{
					jumpsensor = 0;
					doit = true;
				}
				jumpcheck = false;
			}
			else jumpsensor = 0;

			lastprone = self.ex_stance;
			if(jumpsensor == 0) lastjump = self.ex_jumping;

			if(doit) self thread extreme\_ex_utils::weaponPause(0.4);
		}
	}
}

//******************************************************************************
// extreme additional routines
//******************************************************************************

urlredirect()
{
	if(!level.ex_urlredirect) return;

	setDvar("sv_allowDownload", level.ex_allowDownload);
	setDvar("sv_wwwDownload", level.ex_wwwDownload);
	setDvar("sv_wwwDlDisconnected", level.ex_wwwDlDisconnected);
	setDvar("sv_wwwBaseURL", level.ex_wwwBaseURL);

	return;
}

weaponDamageMod( eVictim, eAttacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	if(level.ex_wdmodon && sWeapon != "none" && sMeansOfDeath != "MOD_MELEE")
	{
		weapondvar = "";
		if(isDefined(game["ex_wdm"][sWeapon]))
			weapondvar = game["ex_wdm"][sWeapon];
		
		if(weapondvar != "")
		{
			if(getdvar(weapondvar) != "" && getdvarfloat(weapondvar) > 0)
			{
				multiplier = getdvarfloat(weapondvar);
				iDamage = int((iDamage / 100) * multiplier);
			}
		}
	}

	return iDamage;
}

//******************************************************************************
// extreme welcome handler
//******************************************************************************
handleWelcome()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(isPlayer(self))
	{
		// Resetting the tag ex_ispunished is done in resetFlagVars()

		// Did the Name Checker already tag the player for using an unacceptable name?
		if(isDefined(self.ex_isunknown) && self.ex_isunknown)
		{
			self thread handleUnknown(false);
		}
		else
		{
			// Did the Name Checker already tag the player for using a duplicate name?
			if(isDefined(self.ex_isdupname) && self.ex_isdupname)
			{
				self thread handleDupName();
			}
			else
			{
				// If Name Checker is disabled and Unknown Soldier handling is enabled,
				// check for unacceptable names ourselves
				if(level.ex_uscheck && isUnknown(self))
				{
					self thread handleUnknown(false);
				}
				else self thread extreme\_ex_messages::welcomeMessages();
			}
		}
	}
}

//******************************************************************************
// extreme duplicate name checker
//******************************************************************************
handleDupName()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	// Tag the player to prevent the Name Checker to kick in more than once
	self.ex_isdupname = true;

	iprintlnbold(&"NAMECHECK_DNCHECK_DUPNAME1", self);
	self setClientDvar("name", "Unknown Soldier");
	self iprintlnbold(&"NAMECHECK_DNCHECK_NEWUNKNOWN");

	if(level.ex_ncskipwarning)
	{
		if(level.ex_usclanguest) self iprintlnbold(&"NAMECHECK_DNCHECK_NEXTCLANGUEST");
			else self iprintlnbold(&"NAMECHECK_DNCHECK_NEXTGUEST");
	}
	else self iprintlnbold(&"NAMECHECK_DNCHECK_NEXTUNKNOWN");

	// Wait several seconds before starting the Unknown Soldier handling code
	wait 10;
	self thread handleUnknown(level.ex_ncskipwarning);

	// Remove the tag; the player is officially an Unknown Soldier now
	self.ex_isdupname = false;
}

//******************************************************************************
// extreme Unknown Soldier handler
//******************************************************************************
handleUnknown(skipwarning)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	// Tag the player to prevent the Name Checker to kick in more than once
	self.ex_isunknown = true;

	usname = [];

	if(!skipwarning)
	{
		if(isPlayer(self))
		{
			// Warn them first
			if(level.ex_usclanguest)
			{
				iprintlnbold(&"UNKNOWNSOLDIER_MSG_UNACCEPTABLE", self);
				self iprintlnbold(&"UNKNOWNSOLDIER_MSG_CHANGEIT");
				self iprintlnbold(&"UNKNOWNSOLDIER_MSG_CLANGUEST", level.ex_uswarndelay1);
			}
			else
			{
				iprintlnbold(&"UNKNOWNSOLDIER_MSG_UNACCEPTABLE", self);
				self iprintlnbold(&"UNKNOWNSOLDIER_MSG_CHANGEIT");
				self iprintlnbold(&"UNKNOWNSOLDIER_MSG_GUEST", level.ex_uswarndelay1);
			}
		}
		// Now give them some time to change their name
		waitWhileUnknown(level.ex_uswarndelay1);
	}

	if(isPlayer(self) && isUnknown(self))
	{
		// Get a free guest number (1 to sv_maxclients)
		level.ex_usguestno = getFreeGuestSlot();

		if(level.ex_usclanguest)
		{
			usname[0] = level.ex_usclanguestname; // Clan Guest
			usname[1] = usname[0] + level.ex_usguestno;
			self setClientDvar("name", usname[1]);
			self iprintlnbold(&"UNKNOWNSOLDIER_NEWNAME_BYSERVER");
			self iprintlnbold(&"UNKNOWNSOLDIER_NEWNAME_CLANGUEST", usname[1]);

			// Clan guests are now off the hook; show welcome messages and return
			self.ex_isunknown = false;
			wait 3;
			if(isPlayer(self)) self thread extreme\_ex_messages::welcomeMessages();
			return;
		}
		else
		{
			// Only assign guest name if not already using an assigned guest name
			if(!isAssignedName(self))
			{
				usname[0] = level.ex_usguestname; // Non-clan Guest
				usname[1] = usname[0] + level.ex_usguestno;
				self setClientDvar("name", usname[1]);
				self iprintlnbold(&"UNKNOWNSOLDIER_NEWNAME_BYSERVER");
				self iprintlnbold(&"UNKNOWNSOLDIER_NEWNAME_GUEST", usname[1]);
				self iprintlnbold(&"UNKNOWNSOLDIER_NEWNAME_CHANGEIT", level.ex_uswarndelay2);

				// After name assignment, non-clan guests get a second chance to change their name
				waitWhileUnknown(level.ex_uswarndelay2);
			}
		}
	}

	if(isPlayer(self) && isUnknown(self))
	{
		// My god, don't they understand? ok, time to f*** around with them!
		count = 0;
		while(isPlayer(self) && isUnknown(self) && count < level.ex_uspunishcount)
		{
			if(!self.ex_sinbin)
			{
				while(self.ex_sinbin) wait 1;
				iprintlnbold(&"UNKNOWNSOLDIER_MSG_TEMPORARY", self);
				self iprintlnbold(&"UNKNOWNSOLDIER_MSG_CHANGEIT");
				self iprintlnbold(&"UNKNOWNSOLDIER_STILL_PUNISH");
				//self thread extreme\_ex_utils::punishment("drop", "freeze");
				//self disableWeapons;
				waitWhileUnknown(10);
				//if(isPlayer(self)) //self thread extreme\_ex_utils::punishment("enable", "release");
				waitWhileUnknown(20 + randomInt(20));
				count++;
			}
			else break;
		}

		// Now, if still using assigned name, allow them to play without punishment until they die
		if(isPlayer(self) && isAssignedName(self))
		{
			// Set punished-tag so Name Checker doesn't kick in again
			self.ex_ispunished = true;
			self iprintlnbold(&"UNKNOWNSOLDIER_STILL_RELIEF1");
			self iprintlnbold(&"UNKNOWNSOLDIER_STILL_RELIEF2");
			self iprintlnbold(&"UNKNOWNSOLDIER_MSG_CHANGEIT");
		}
	}

	// Allow the Name Checker to iterate once to catch duplicate names.
	// Keep this wait statement outside the following if-block to catch players
	// that would otherwise fall through by quickly changing their name from US
	// to a valid name and back to US again (highly unlikely, but possible with key bindings)
	wait 5;

	if(isPlayer(self) && !self.ex_ispunished && !isUnknown(self))
	{
		// Has the Name Checker tagged him because of using a duplicate name?
		if(isPlayer(self) && !self.ex_isdupname)
		{
			// No, so thank them, and show the welcome messages
			iprintlnbold(&"UNKNOWNSOLDIER_MSG_THANKS", self);
			wait 3;
			if(isPlayer(self)) self thread extreme\_ex_messages::welcomeMessages();
		}
		else self thread handleDupName();
	}

	// Remove the tag; the player is either renamed, punished or dupname-tagged
	self.ex_isunknown = false;
}

waitWhileUnknown(seconds)
{
	// Wait for x seconds as long as player has unacceptable name
	for(i = 0; i < seconds; i++)
	{
		if(isPlayer(self) && !isUnknown(self)) return;
			else wait 1;
	}
}

isUnknownSoldier(player)
{
	// Check if player is Unknown Soldier
	// Color codes are removed. Name is lowercased, so it will reject any case combination

	self endon("disconnect");
	self endon("ex_dead");

	playernorm = "";
	if(isPlayer(player)) playernorm = extreme\_ex_utils::monotone(player.name);
	//playernorm = extreme\_ex_utils::lowercase(playernorm);

	if(playernorm == "" || playernorm == "unknown soldier" || playernorm == "unknownsoldier") return true;
	return false;
}

isAssignedName(player)
{
	// Check if player has an assigned guest name
	// Do NOT check for assigned clan guest names!

	self endon("disconnect");
	self endon("ex_dead");

	chkname = [];
	maxguestno = getDvarInt("sv_maxclients");
	chkname[0] = level.ex_usguestname;

	for(i = 1; i <= maxguestno; i++)
	{
		chkname[1] = chkname[0] + i;
		if(player.name == chkname[1]) return true;
	}
	return false;
}

isUnknown(player)
{
	// Check if player has unacceptable name

	self endon("disconnect");
	self endon("ex_dead");
	
	if(isUnknownSoldier(player)) return true;
	if(isAssignedName(player)) return true;
	return false;
}

getFreeGuestSlot()
{
	// Get a free guest number.

	self endon("disconnect");
	self endon("ex_dead");

	chkname = [];
	maxguestno = getDvarInt("sv_maxclients");
	players = level.players;
	maxplayers = players.size;

	if(level.ex_usclanguest) chkname[0] = level.ex_usclanguestname;
		else chkname[0] = level.ex_usguestname;

	i = 1;
	while(i <= maxguestno)
	{
		chkname[1] = chkname[0] + i;
		found = false;
		for(j = 0; j < maxplayers; j++)
		{
			if(players[j].name == chkname[1])
			{
				found = true;
				break;
			}
		}
		if(found) i++;
			else break;
	}
	return i;
}

show_location() 
{
	while (true)
	{
		players = getentarray("player", "classname");		
		numplayers = players.size;
		for (i=0;i<numplayers;i++) 
		{
			players[i] iprintln("Current location is "+players[i].origin+", current angle is "+players[i].angles);
		}
		wait 5;
	}
}

gold_camo_unlocks()  
{
	self thread maps\mp\gametypes\_rank::unlockCamo( "uzi camo_gold" );
	self thread maps\mp\gametypes\_rank::unlockCamo( "ak47 camo_gold" );
	self thread maps\mp\gametypes\_rank::unlockCamo( "uzi camo_gold" );
	self thread maps\mp\gametypes\_rank::unlockCamo( "m60e4 camo_gold" );
	self thread maps\mp\gametypes\_rank::unlockCamo( "m1014 camo_gold" );
	self thread maps\mp\gametypes\_rank::unlockCamo( "dragunov camo_gold" );
}