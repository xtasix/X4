main()
{	
	//****************************************************************************
	// X4 setup commonly used function alias
	//****************************************************************************
	level.ex_dvardef = extreme\_ex_utils::dvardef;
	level.ex_clientcmd = extreme\_ex_utils::execClientCommand;
	level.ex_clearlnb = extreme\_ex_utils::clearlnbold;
	level.ex_vectormulti = extreme\_ex_utils::vectormulti;
	level.ex_vectorscale = extreme\_ex_utils::vectorscale;

	//****************************************************************************
	// X4 linux check
	//****************************************************************************
	level.ex_linux = extreme\_ex_linux::isLinuxServer();

	//****************************************************************************
	// X4 fps modifier
	//****************************************************************************
	level thread extreme\_ex_fps::init();
	
	//****************************************************************************
	// X4 make current game type and map as level variables
	//****************************************************************************
	level.ex_currentgt = getdvar("g_gametype");
	level.ex_currentmap = getdvar("mapname");
	
	if(level.ex_currentgt != "dm" ) level.ex_teamplay = true;
		else level.ex_teamplay = false;

	if(level.ex_currentgt == "sd" || level.ex_currentgt == "sab") level.ex_bombplay = true;
		else level.ex_bombplay = false;
		
	level.ex_objectivepoints = [[level.ex_dvardef]] ("ex_objective_points", 0, 0, 1, "int");

	//****************************************************************************
	// X4 debug and proof of concept vars
	//****************************************************************************
	level.ex_forceuav = [[level.ex_dvardef]]("ex_forceuav", 0, 0, 1, "int");
	level.ex_hc_delay = [[level.ex_dvardef]]("ex_hc_delay", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Grenadecookbar
	//********************************************************************
	level.ex_grenadecookbar = [[level.ex_dvardef]]("ex_grenadecookbar", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Show Coordinates
	//****************************************************************************
	level.ex_showcoordinates = [[level.ex_dvardef]] ("ex_show_location", 0, 0, 1, "int");
	
	//****************************************************************************
	// gCOPS Dvar - On hold until web/SQL interface of gCOPS fully released
	//****************************************************************************
	
	
	//****************************************************************************
	// X4 Close Kill
	//****************************************************************************
	level.ex_closekill = [[level.ex_dvardef]] ("ex_close_kill", 0, 0, 1, "int");
	level.ex_killyards = [[level.ex_dvardef]] ("ex_kill_yards", 40, 0, 999, "int");
		
	//****************************************************************************
	// X4 Enhanced Redirect
	//****************************************************************************
	level.ex_urlredirect = [[level.ex_dvardef]] ("ex_url_redirect", 0, 0, 1, "int");
	level.ex_allowDownload = [[level.ex_dvardef]]("ex_allowDownload", 1, 0, 1, "int");
	level.ex_wwwDownload = [[level.ex_dvardef]]("ex_wwwDownload", 0, 0, 1, "int");
	level.ex_wwwDlDisconnected = [[level.ex_dvardef]]("ex_wwwDlDisconnected", 0, 0, 1, "int");
	level.ex_wwwBaseURL = [[level.ex_dvardef]]("ex_wwwBaseURL", "", "", "", "string");
	
	//****************************************************************************
	// X4 Sticky Nade
	//****************************************************************************
	level.ex_sticky_nades = [[level.ex_dvardef]] ("ex_sticky_nades", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Rank system 
	//****************************************************************************
	level.ex_gold_camo_unlock = [[level.ex_dvardef]] ("ex_gold_camo_unlock", 1, 0, 1, "int"); 
	level.ex_fullwarfare = [[level.ex_dvardef]] ("ex_fullwarfare", 1, 0, 1, "int");
	level.ex_rank_stock = [[level.ex_dvardef]] ("ex_rank_stock", 1, 0, 1, "int");

	//****************************************************************************
	// eXtreme+ ammo crates
	//****************************************************************************
	level.ex_amc_perteam = [[level.ex_dvardef]]("ex_amc_perteam", 0, 0, 8, "int");
	level.ex_amc_msg = [[level.ex_dvardef]]("ex_amc_msg", 0, 0, 3, "int");
	level.ex_amc_compass = [[level.ex_dvardef]]("ex_amc_compass", 0, 0, 2, "int");
	level.ex_amc_chutein = [[level.ex_dvardef]]("ex_amc_chutein", 0, 0, 3600, "int");
	level.ex_amc_chutein_slice = [[level.ex_dvardef]]("ex_amc_chutein_slice", 0, 0, 4, "int");
	level.ex_amc_chutein_neutral = [[level.ex_dvardef]]("ex_amc_chutein_neutral", 0, 0, 1, "int");
	level.ex_amc_chutein_lifespan = [[level.ex_dvardef]]("ex_amc_chutein_lifespan", 0, 0, 3600, "int");
	level.ex_amc_chutein_pause_slice = [[level.ex_dvardef]]("ex_amc_chutein_pause_slice", 10, 1, 3600, "int");
	level.ex_amc_chutein_pause_all = [[level.ex_dvardef]]("ex_amc_chutein_pause_all", 240, 1, 3600, "int");
	level.ex_amc_chutein_score = [[level.ex_dvardef]]("ex_amc_chutein_score", 0, 0, 3, "int");
	level.ex_amc_hardpoints = [[level.ex_dvardef]]("ex_amc_hardpoints", 0, 0, 1, "int");
	
	//if(!level.ex_amc_perteam && level.ex_amc_msg >= 2) //cant get this working yet =(
	//{
		//switch(self.index)
		//{
			//case "marines":	msg = &"AMMOCRATE_DENY_AMERICAN";	break;
			//case "sas":	msg = &"AMMOCRATE_DENY_BRITISH";		break;
			//default: msg = &"AMMOCRATE_DENY_RUSSIAN";		break;
			//else msg = &"AMMOCRATE_DENY_GERMAN";
		//}	
	//}

	//****************************************************************************
	// eXtreme+ ambient flares
	//****************************************************************************
	level.ex_flares = [[level.ex_dvardef]]("ex_flares", 0, 0, 1, "int");
	level.ex_flare_type = [[level.ex_dvardef]]("ex_flare_type", 0, 0, 1, "int");
	level.ex_flare_alert = [[level.ex_dvardef]]("ex_flare_alert", 1, 0, 1, "int");
	level.ex_flares_min = [[level.ex_dvardef]]("ex_flares_min", 5, 5, 15, "int");
	level.ex_flares_max = [[level.ex_dvardef]]("ex_flares_max", level.ex_flares_min * 2, level.ex_flares_min + 1, 30, "int");
	level.ex_flares_delay_min = [[level.ex_dvardef]]("ex_flares_delay_min", 300, 30, 720, "int");
	level.ex_flares_delay_max = [[level.ex_dvardef]]("ex_flares_delay_max", level.ex_flares_delay_min * 2, level.ex_flares_delay_min + 1, 1440, "int");

	//****************************************************************************
	// X4 Bloody Screen
	//****************************************************************************
	level.ex_bloodyscreen = [[level.ex_dvardef]]("ex_bloodyscreen", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Black Screen
	//****************************************************************************
	level.ex_blackscreen = [[level.ex_dvardef]]("ex_blackscreen", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Thermal nightvision overwrite
	//****************************************************************************
	level.ex_toggleThermal = [[level.ex_dvardef]]("ex_toggleThermal", 0, 0, 1, "int"); 
	
	//****************************************************************************
	// X4 BloodPools 
	//****************************************************************************
	level.ex_bloodpools = [[level.ex_dvardef]]("ex_bloodpools", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 conversion of LooL Hit shot enforement
	//****************************************************************************
	level.ex_hipshotenforement = [[level.ex_dvardef]] ("ex_hipshotenforement", 0, 0, 1, "int");
	level.ex_playerishipshootingmsg = [[level.ex_dvardef]] ("ex_playerishipshootingmsg", "", "", "", "string");
	level.ex_playermsg = [[level.ex_dvardef]] ("ex_playermsg", "", "", "", "string");
	level.ex_hipshotpunish = [[level.ex_dvardef]] ("ex_hipshotpunish", 0, 0, 3, "int");
	level.ex_hipshotbloodscreen = [[level.ex_dvardef]] ("ex_hipshotbloodscreen", 0, 0, 1, "int");
	level.ex_hipshotblackscreen = [[level.ex_dvardef]] ("ex_hipshotblackscreen", 0, 0, 1, "int");
	level.ex_hipshotdisableweapon = [[level.ex_dvardef]] ("ex_hipshotdisableweapon", 0, 0, 1, "int");
	level.ex_hipshotpunishtime = [[level.ex_dvardef]] ("ex_hipshotpunishtime", 0, 0, 999, "int");

	//****************************************************************************
	// X4 ambient effects control
	//****************************************************************************
	level.ex_ambient_track = [[level.ex_dvardef]]("ex_ambient_track", 1, 0, 1, "int");
	level.ex_ambient_sound = [[level.ex_dvardef]]("ex_ambient_sound", 1, 0, 1, "int");
	level.ex_ambient_fog = [[level.ex_dvardef]]("ex_ambient_fog", 1, 0, 1, "int");
	level.ex_ambient_wind = [[level.ex_dvardef]]("ex_ambient_wind", 1, 0, 1, "int");
	level.ex_ambient_smoke = [[level.ex_dvardef]]("ex_ambient_smoke", 1, 0, 1, "int");
	level.ex_ambient_dust = [[level.ex_dvardef]]("ex_ambient_dust", 1, 0, 1, "int");
	level.ex_ambient_fire = [[level.ex_dvardef]]("ex_ambient_fire", 1, 0, 1, "int");
	level.ex_ambient_tracers = [[level.ex_dvardef]]("ex_ambient_tracers", 1, 0, 1, "int");
	level.ex_ambient_snow = [[level.ex_dvardef]]("ex_ambient_snow", 1, 0, 1, "int");
	level.ex_ambient_rain = [[level.ex_dvardef]]("ex_ambient_rain", 1, 0, 1, "int");
	level.ex_ambient_fauna = [[level.ex_dvardef]]("ex_ambient_fauna", 1, 0, 1, "int");
	level.ex_ambient_neon = [[level.ex_dvardef]]("ex_ambient_neon", 1, 0, 1, "int");
	level.ex_ambient_dirt = [[level.ex_dvardef]]("ex_ambient_dirt", 1, 0, 1, "int");
	level.ex_ambient_water = [[level.ex_dvardef]]("ex_ambient_water", 1, 0, 1, "int");
	level.ex_ambient_insects = [[level.ex_dvardef]]("ex_ambient_insects", 1, 0, 1, "int");
	level.ex_ambient_leaves = [[level.ex_dvardef]]("ex_ambient_leaves", 1, 0, 1, "int");
	level.ex_ambient_cave = [[level.ex_dvardef]]("ex_ambient_cave", 1, 0, 1, "int");
	level.ex_ambient_steam = [[level.ex_dvardef]]("ex_ambient_steam", 1, 0, 1, "int");
	level.ex_ambient_drips = [[level.ex_dvardef]]("ex_ambient_drips", 1, 0, 1, "int");
	level.ex_ambient_lights = [[level.ex_dvardef]]("ex_ambient_lights", 1, 0, 1, "int");

	//****************************************************************************
	// X4 call vote control
	//****************************************************************************
	level.ex_callvote_mode = [[level.ex_dvardef]]("ex_callvote_mode", 0, 0, 3, "int");
	level.ex_callvote_delay = [[level.ex_dvardef]]("ex_callvote_delay", 60, 0, 9999, "int");
	level.ex_callvote_delay_players = [[level.ex_dvardef]]("ex_callvote_delay_players", 0, 0, 64, "int");
	level.ex_callvote_enable_time = [[level.ex_dvardef]]("ex_callvote_enable_time", 120, 30, 9999, "int");
	level.ex_callvote_disable_time = [[level.ex_dvardef]]("ex_callvote_disable_time", 300, 60, 9999, "int");
	level.ex_callvote_msg = [[level.ex_dvardef]]("ex_callvote_msg", 3, 0, 3, "int");

	//****************************************************************************
	// X4 forced clientside dvars
	//****************************************************************************
	level.ex_forcedvar_mode = [[level.ex_dvardef]]("ex_forcedvar_mode", 1, 0, 1, "int");
	level.ex_forcedvar_nadeindicator = [[level.ex_dvardef]]("ex_forcedvar_nadeind", 0, 0, 1, "int");
	level.ex_forcedvar_crosshair = [[level.ex_dvardef]]("ex_forcedvar_crosshair", 0, 0, 1, "int");
	level.ex_forcedvar_redcrosshairs = [[level.ex_dvardef]]("ex_forcedvar_redcrosshairs", 0, 0, 1, "int");
	level.ex_forcedvar_mantlehint = [[level.ex_dvardef]]("ex_forcedvar_mantlehint", 0, 0, 1, "int");
	level.ex_forcedvar_crosshairnames = [[level.ex_dvardef]]("ex_forcedvar_crosshairnames", 0, 0, 1, "int");
	level.ex_hitsound = [[level.ex_dvardef]]("ex_hitsound", 0, 0, 1, "int");

	//****************************************************************************
	// X4 misc features
	//****************************************************************************
	level.ex_moveinprematch = [[level.ex_dvardef]]("ex_moveinprematch", 0, 0, 1, "int");
	level.ex_hardcore_minimap = [[level.ex_dvardef]]("ex_hardcore_minimap", 0, 0, 1, "int");
	
	game["ex_favoriteaddress"] = getDvar("net_ip") + ":" + getDvar("net_port");
	level.ex_favorite = [[level.ex_dvardef]]("ex_favorite", 1, 0, 1, "int");	
	
	//****************************************************************************
	// X4 C4 & Claymore red laser FX
	//****************************************************************************
	level.ex_c4blink = [[level.ex_dvardef]]("ex_c4_blink_lights", 1, 0, 1, "int");
	level.ex_c4lasers = [[level.ex_dvardef]]("ex_c4_lasers", 1, 0, 1, "int");
	level.ex_claymorelasers = [[level.ex_dvardef]]("ex_claymore_lasers", 1, 0, 1, "int");
	
	//****************************************************************************
	// X4 thirdperson view
	//****************************************************************************
	level.ex_third_person = [[level.ex_dvardef]]("ex_thirdperson", 0, 0, 1, "int");

	//****************************************************************************
	// X4 compass indicators
	//****************************************************************************
	// Force stock var for enemy ping to true (affects g_compassShowEnemies). we handle it differently
	setDvar( "scr_game_forceuav", 1 );
	level.ex_compass_objicons = [[level.ex_dvardef]]("ex_compass_objicons", 1, 0, 1, "int");
	level.ex_compass_helicopter = [[level.ex_dvardef]]("ex_compass_helicopter", 1, 0, 1, "int");
	level.ex_compass_planes = [[level.ex_dvardef]]("ex_compass_planes", 1, 0, 1, "int");
	level.ex_compass_friendlyping = [[level.ex_dvardef]]("ex_compass_friendlyping", 1, 0, 1, "int");
	level.ex_compass_playerping = [[level.ex_dvardef]]("ex_compass_playerping", 1, 0, 1, "int");
	level.ex_compass_enemyping = [[level.ex_dvardef]]("ex_compass_enemyping", 0, 0, 1, "int");
	level.ex_compass_uavenemyping = [[level.ex_dvardef]]("ex_compass_uavenemyping", 1, 0, 1, "int");
	level.ex_compass_tacticalenemyping = [[level.ex_dvardef]]("ex_compass_tacticalenemyping", 0, 0, 1, "int");
	level.ex_compass_fsmenemyping = [[level.ex_dvardef]]("ex_compass_fsmenemyping", 1, 0, 1, "int");

	//****************************************************************************
	// X4 hud indicators
	//****************************************************************************
	level.ex_hud_lowhealth = [[level.ex_dvardef]]("ex_hud_lowhealth", 1, 0, 1, "int");
	level.ex_hud_mantlehint = [[level.ex_dvardef]]("ex_hud_mantlehint", 1, 0, 1, "int");
	level.ex_hud_cursorhint = [[level.ex_dvardef]]("ex_hud_cursorhint", 1, 0, 1, "int");
	level.ex_hud_commandhint = [[level.ex_dvardef]]("ex_hud_commandhint", 1, 0, 1, "int");
	level.ex_hud_holdbreathhint = [[level.ex_dvardef]]("ex_hud_holdbreathhint", 1, 0, 1, "int");
	level.ex_hud_stance = [[level.ex_dvardef]]("ex_hud_stance", 1, 0, 1, "int");
	level.ex_hud_fade_stance = [[level.ex_dvardef]] ("ex_hud_fade_stance", 1, 0, 1, "int"); 
	level.ex_hudStanceHintPrints = [[level.ex_dvardef]] ("ex_hudStanceHintPrints", 1, 0, 1, "int"); 
	level.ex_hud_localvoice = [[level.ex_dvardef]]("ex_hud_localvoice", 1, 0, 1, "int");
	level.ex_hud_remotevoice = [[level.ex_dvardef]]("ex_hud_remotevoice", 1, 0, 1, "int");
	level.ex_hud_obituaries = [[level.ex_dvardef]]("ex_hud_obituaries", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 hud statistics
	//****************************************************************************
	level.ex_hudstats = [[level.ex_dvardef]]("ex_hud_stats", 0, 0, 1, "int");
	level.ex_hudstats_xpos = [[level.ex_dvardef]]("ex_hud_stats_xpos", 632, 0, 640, "int");
	level.ex_hudstats_ypos = [[level.ex_dvardef]]("ex_hud_stats_ypos", 172, 0, 480, "int");
	level.ex_hudstatsuse = [[level.ex_dvardef]]("ex_hud_stats_use", 0, 0, 1, "int");
	level.ex_hudstatsuse_xpos = [[level.ex_dvardef]]("ex_hud_stats_use_xpos", 630, 0, 640, "int");
	level.ex_hudstatsuse_ypos = [[level.ex_dvardef]]("ex_hud_stats_use_ypos", 215, 0, 480, "int");

	//****************************************************************************
	// X4 field icons
	//****************************************************************************
	level.ex_field_objicons = [[level.ex_dvardef]]("ex_field_objicons", 1, 0, 1, "int");
	level.ex_field_deathicons = [[level.ex_dvardef]]("ex_field_deathicons", 1, 0, 1, "int");

	//****************************************************************************
	// X4 fix corrupt map rotations
	//****************************************************************************
	level.ex_fixmaprotation = [[level.ex_dvardef]]("ex_fix_maprotation", 0, 0, 1, "int");

	//****************************************************************************
	// X4 random map rotation
	//****************************************************************************
	level.ex_randommaprotation = [[level.ex_dvardef]]("ex_random_maprotation", 0, 0, 2, "int");

	//****************************************************************************
	// X4 player based rotation control
	//****************************************************************************
	level.ex_pbrotate = [[level.ex_dvardef]]("ex_pbrotate", 0, 0, 1, "int");
	level.ex_pbrsmall = [[level.ex_dvardef]]("ex_pbrsmall", 0, 0, 64, "int");
	level.ex_pbrmedium = [[level.ex_dvardef]]("ex_pbrmedium", 0, 0, 64, "int");

	//****************************************************************************
	// X4 empty server rotation control
	//****************************************************************************
	if(!isdefined(game["ex_emptytime"])) game["ex_emptytime"] = 0;
	level.ex_rotateifempty = [[level.ex_dvardef]]("ex_rotate_if_empty", 5, 0, 1440, "int");

	//****************************************************************************
	// X4 sniper spawn point management for WAR
	//****************************************************************************
	level.ex_sniper_war = [[level.ex_dvardef]]("ex_sniper_war", 0, 0, 1, "int");

	//****************************************************************************
	// X4 player bob factor
	//****************************************************************************
	level.ex_bobfactor = [[level.ex_dvardef]]("ex_player_bobfactor", 0, 0, 1, "int");

	//****************************************************************************
	// X4 forced auto-assign
	//****************************************************************************
	level.ex_autoassign = [[level.ex_dvardef]]("ex_autoassign", 0, 0, 2, "int");
	level.ex_autoassign_clanteam = toLower( [[level.ex_dvardef]]("ex_autoassign_clanteam", "", "", "", "string") );
	level.ex_autoassign_noswitch = [[level.ex_dvardef]]("ex_autoassign_noswitch", 0, 0, 2, "int");

	level.ex_autoassign_team = 0;
	if(level.ex_autoassign == 2 && (level.ex_autoassign_clanteam == "allies" || level.ex_autoassign_clanteam == "axis"))
	{
		level.ex_autoassign_team = 1;
		if(level.ex_autoassign_clanteam == "allies") level.ex_autoassign_nonclanteam = "axis";
			else level.ex_autoassign_nonclanteam = "allies";

		level.ex_autoassign_noswitch = 2;
		setDvar("scr_teambalance", "0");
	}

	//****************************************************************************
	// X4 map voting system
	//****************************************************************************
	level.ex_mapvote = [[level.ex_dvardef]]("ex_mapvote", 0, 0, 1, "int");
	level.ex_mapvote_max = [[level.ex_dvardef]]("ex_mapvote_max", 160, 10, 160, "int");
	level.ex_mapvote_mode = [[level.ex_dvardef]]("ex_mapvote_mode", 0, 0, 5, "int");
	level.ex_mapvote_time = [[level.ex_dvardef]]("ex_mapvote_time", 30, 10, 180, "int");
	level.ex_mapvote_timegt = [[level.ex_dvardef]]("ex_mapvote_time_gt", 10, 10, 180, "int");
	level.ex_mapvote_replay = [[level.ex_dvardef]]("ex_mapvote_replay", 0, 0, 1, "int");
	level.ex_mapvote_memory = [[level.ex_dvardef]]("ex_mapvote_memory", 0, 0, 1, "int");
	level.ex_mapvote_memory_max = [[level.ex_dvardef]]("ex_mapvote_memory_max", 3, 2, 160, "int");
	level.ex_mapvote_ignore_clanvoting = [[level.ex_dvardef]]("ex_mapvote_ignore_clanvoting", 0, 0, 1, "int");
	level.ex_mapvote_ignore_stock = [[level.ex_dvardef]]("ex_mapvote_ignore_stock", 0, 0, 1, "int");

	if(!level.ex_mapvote) level.ex_mapvote_mode = 0; // for map rotation messages
	if(level.ex_mapvote_memory) level.ex_mapvote_replay = 0; // no replay when memory is enabled

	level thread extreme\_ex_mapvote::init();

	//****************************************************************************
	// X4 healthbar
	//****************************************************************************
	level.ex_healthbar = [[level.ex_dvardef]]("ex_healthbar", 0, 0, 1, "int");
	level.ex_healthregen = [[level.ex_dvardef]]("ex_healthregen", 0, 0, 1, "int");
	level.ex_regenmethod = [[level.ex_dvardef]]("ex_regenmethod", 0, 0, 3, "int");

	//****************************************************************************
	// X4 spawnprotection
	//****************************************************************************
	level.ex_spawnprot = [[level.ex_dvardef]]("ex_spawnprot", 0, 0, 120, "int");
	level.ex_spawnprot_voice_enabled = [[level.ex_dvardef]]("ex_spawnprot_voiceenabled", 0, 0, 1, "int");
	level.ex_spawnprot_voice_disabled = [[level.ex_dvardef]]("ex_spawnprot_voicedisabled", 0, 0, 1, "int");
	level.ex_spawnprot_invisible = [[level.ex_dvardef]]("ex_spawnprot_invisible", 0, 0, 1, "int");
	level.ex_spawnprot_noweapon = [[level.ex_dvardef]]("ex_spawnprot_noweapon", 0, 0, 1, "int");
	level.ex_spawnprot_forcecrouch = [[level.ex_dvardef]]("ex_spawnprot_force_crouch", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Realism
	//****************************************************************************
	level.ex_droponarmhit = [[level.ex_dvardef]]("ex_droponarmhit", 0, 0, 100, "int");
	level.ex_droponhandhit = [[level.ex_dvardef]]("ex_droponhandhit", 0, 0, 100, "int");
	level.ex_triponleghit = [[level.ex_dvardef]]("ex_triponleghit", 0, 0, 100, "int");
	level.ex_triponfoothit = [[level.ex_dvardef]]("ex_triponfoothit", 0, 0, 100, "int");

	//****************************************************************************
	// X4 stance shoot delay monitor
	//****************************************************************************
	level.ex_stancemon = [[level.ex_dvardef]]("ex_stancemon", 0, 0, 3, "int");
	level.ex_stancemon_threshold = [[level.ex_dvardef]]("ex_stancemon_threshold", 5, 0, 10, "int");

	//****************************************************************************
	// X4 Antirun
	//****************************************************************************
	level.ex_antirun = [[level.ex_dvardef]]("ex_antirun", 0, 0, 1, "int");
	level.ex_antirun_distance = [[level.ex_dvardef]]("ex_antirun_distance", 500, 100, 9999, "int");

	//****************************************************************************
	// X4 Server redirection
	//****************************************************************************
	level.ex_redirect = [[level.ex_dvardef]]("ex_redirect", 0, 0, 1, "int");
	level.ex_redirect_ip = [[level.ex_dvardef]]("ex_redirect_ip", "", "", "", "string");
	level.ex_redirect_pause = [[level.ex_dvardef]]("ex_redirect_pause", 10, 5, 60, "int");
	level.ex_redirect_reason = [[level.ex_dvardef]]("ex_redirect_reason", 0, 0, 3, "int");
	level.ex_redirect_logic = [[level.ex_dvardef]]("ex_redirect_logic", 0, 0, 2, "int");
	level.ex_redirect_priority = [[level.ex_dvardef]]("ex_redirect_priority", 0, 0, 4, "int");
	level.ex_redirect_hint = [[level.ex_dvardef]]("ex_redirect_hint", 1, 0, 1, "int");

	//****************************************************************************
	// X4 announcer - time remaining, score, results, firstblood, player connect
	//****************************************************************************
	level.ex_timeannouncer = [[level.ex_dvardef]]("ex_announcer", 0, 0, 2, "int");
	level.ex_antime = [[level.ex_dvardef]]("ex_antime", 0, 0, 1, "int");
	level.ex_anscore = [[level.ex_dvardef]]("ex_anscore", 0, 0, 1, "int");
	level.ex_anresult = [[level.ex_dvardef]]("ex_anresult", 0, 0, 1, "int");
	level.ex_firstblood = [[level.ex_dvardef]]("ex_firstblood", 0, 0, 1, "int");
	level.ex_plcdsound = [[level.ex_dvardef]]("ex_plcdsound", 0, 0, 1, "int");

	//****************************************************************************
	// X4 duplicate name check
	//****************************************************************************
	level.ex_namechecker = [[level.ex_dvardef]]("ex_namechecker", 1, 0, 1, "int");
	level.ex_ncskipwarning = [[level.ex_dvardef]]("ex_ncskipwarning", 1, 0, 1, "int");

	//****************************************************************************
	// X4 unknown soldier handling system
	//****************************************************************************
	level.ex_uscheck = [[level.ex_dvardef]]("ex_uscheck", 1, 0, 1, "int");
	level.ex_usclanguest = [[level.ex_dvardef]]("ex_usclanguest", 0, 0, 1, "int");
	level.ex_usclanguestname = [[level.ex_dvardef]]("ex_usclanguestname", "Guest#", "" , "", "string");
	level.ex_usguestname = [[level.ex_dvardef]]("ex_usguestname", "UnacceptableName#", "" , "", "string");
	level.ex_uswarndelay1 = [[level.ex_dvardef]]("ex_uswarndelay1", 30, 20, 60, "int");
	level.ex_uswarndelay2 = [[level.ex_dvardef]]("ex_uswarndelay2", 30, 20, 120, "int");
	level.ex_uspunishcount = [[level.ex_dvardef]]("ex_uspunishcount", 5, 1, 999, "int");

	//****************************************************************************
	// X4 security
	//****************************************************************************
	level.ex_security = [[level.ex_dvardef]]("ex_security", 0, 0, 1, "int");

	//****************************************************************************
	// X4 clan configuration
	//****************************************************************************
	level.ex_clantag = [];
	level.ex_clanvote = [];
	level.ex_clanann = [];
	level.ex_clanmsg = [];

	level.ex_clantag[1] = [[level.ex_dvardef]]("ex_clantag1", "{clan1}", "" , "", "string");
	level.ex_clanvote[1] = [[level.ex_dvardef]]("ex_clantag1_vote", 1, 0, 1, "int");
	level.ex_clanann[1] = [[level.ex_dvardef]]("ex_clantag1_announce", 1, 0, 1, "int");
	level.ex_clanmsg[1] = [[level.ex_dvardef]]("ex_clantag1_welcomemsg", 2, 0, 5, "int");

	level.ex_clantag[2] = [[level.ex_dvardef]]("ex_clantag2", "{clan2}", "" , "", "string");
	level.ex_clanvote[2] = [[level.ex_dvardef]]("ex_clantag2_vote", 1, 0, 1, "int");
	level.ex_clanann[2] = [[level.ex_dvardef]]("ex_clantag2_announce", 1, 0, 1, "int");
	level.ex_clanmsg[2] = [[level.ex_dvardef]]("ex_clantag2_welcomemsg", 2, 0, 5, "int");

	level.ex_clantag[3] = [[level.ex_dvardef]]("ex_clantag3", "{clan3}", "" , "", "string");
	level.ex_clanvote[3] = [[level.ex_dvardef]]("ex_clantag3_vote", 1, 0, 1, "int");
	level.ex_clanann[3] = [[level.ex_dvardef]]("ex_clantag3_announce", 1, 0, 1, "int");
	level.ex_clanmsg[3] = [[level.ex_dvardef]]("ex_clantag3_welcomemsg", 2, 0, 5, "int");

	level.ex_clantag[4] = [[level.ex_dvardef]]("ex_clantag4", "{clan4}", "" , "", "string");
	level.ex_clanvote[4] = [[level.ex_dvardef]]("ex_clantag4_vote", 1, 0, 1, "int");
	level.ex_clanann[4] = [[level.ex_dvardef]]("ex_clantag4_announce", 1, 0, 1, "int");
	level.ex_clanmsg[4] = [[level.ex_dvardef]]("ex_clantag4_welcomemsg", 2, 0, 5, "int");

	// clan voting
	level.ex_clanvoting = [[level.ex_dvardef]]("ex_clanvoting", 0, 0, 1, "int");

	// server name and admin name
	level.ex_servername = [[level.ex_dvardef]]("ex_servername", "^1X^24 ^3e^1X^3treme ^2Warfare", "", "", "string");
	level.ex_adminname = [[level.ex_dvardef]]("ex_adminname", "^7", "", "", "string");

	// clan member welcome messages
	level.ex_clan_welcomemode = [[level.ex_dvardef]]("ex_clan_welcomemode", 1, 0, 1, "int");
	level.ex_clan_welcomemsg_delay = [[level.ex_dvardef]]("ex_clan_welcomemsg_delay", 1, 0, 10, "int");
	level.ex_clan_welcomemsg_1 = [[level.ex_dvardef]]("ex_clan_welcomemsg_1", "Welcome back &&1", "", "", "string");
	level.ex_clan_welcomemsg_2 = [[level.ex_dvardef]]("ex_clan_welcomemsg_2", "^7to the ^3e^1X^3treme^1 X^24^7 Server", "", "", "string");
	level.ex_clan_welcomemsg_3 = [[level.ex_dvardef]]("ex_clan_welcomemsg_3", "", "", "", "string");
	level.ex_clan_welcomemsg_4 = [[level.ex_dvardef]]("ex_clan_welcomemsg_4", "", "", "", "string");
	level.ex_clan_welcomemsg_5 = [[level.ex_dvardef]]("ex_clan_welcomemsg_5", "", "", "", "string");

	//****************************************************************************
	// X4 welcome messages
	//****************************************************************************
	level.ex_welcomemsg = [[level.ex_dvardef]]("ex_welcomemsg", 2, 0, 5, "int");
	level.ex_welcomemsg_delay = [[level.ex_dvardef]]("ex_welcomemsg_delay", 1, 0, 10, "int");
	level.ex_welcomemsg_1 = [[level.ex_dvardef]]("ex_welcomemsg_1", "Welcome &&1", "", "", "string");
	level.ex_welcomemsg_2 = [[level.ex_dvardef]]("ex_welcomemsg_2", "^7to the ^3e^1X^3treme^1 X^24^7 Server", "", "", "string");
	level.ex_welcomemsg_3 = [[level.ex_dvardef]]("ex_welcomemsg_3", "", "", "", "string");
	level.ex_welcomemsg_4 = [[level.ex_dvardef]]("ex_welcomemsg_4", "", "", "", "string");
	level.ex_welcomemsg_5 = [[level.ex_dvardef]]("ex_welcomemsg_5", "", "", "", "string");
	
	//****************************************************************************
	// X4 Team Player Name Talking on VOIP
	//****************************************************************************
	level.axistalking = [];
	level.alliestalking = [];
	
	level.ex_TeamChat_Name = [[level.ex_dvardef]]("ex_DisplayChat_Name", 0, 0, 1, "int");
	level.ex_TeamChat_AxisColor = [[level.ex_dvardef]]("ex_TeamChat_AxisColor", 1, 0, 7, "int");
	level.ex_TeamChat_AlliesColor = [[level.ex_dvardef]]("ex_TeamChat_AlliesColor", 1, 0, 7, "int");
	level.ex_TeamChat_Msg = [[level.ex_dvardef]]("ex_DisplayChat_Msg", "", "", "", "string");
	level.ex_displaychat_posx = [[level.ex_dvardef]]("ex_displaychat_posx", 5, 0, 640, "int");
	level.ex_displaychat_posy = [[level.ex_dvardef]]("ex_displaychat_posy", 150, 0, 480, "int");
	
	level.ex_TeamChat_Msg		 = " " + level.ex_TeamChat_Msg;
	
	//****************************************************************************
	// X4 server messages
	//****************************************************************************
	level.ex_servermsg = [[level.ex_dvardef]]("ex_servermsg", 0, 0, 10, "int");
	level.ex_servermsg_loop = [[level.ex_dvardef]]("ex_servermsg_loop", 1, 0, 1, "int");
	level.ex_servermsg_delay_msg = [[level.ex_dvardef]]("ex_servermsg_delay_msg", 30, 1, 60, "int");
	level.ex_servermsg_delay_main = [[level.ex_dvardef]]("ex_servermsg_delay_main", 60, 60, 900, "int");
	level.ex_servermsg_1 = [[level.ex_dvardef]]("ex_servermsg_1", "Server Message 1", "", "", "string");
	level.ex_servermsg_2 = [[level.ex_dvardef]]("ex_servermsg_2", "Server Message 2", "", "", "string");
	level.ex_servermsg_3 = [[level.ex_dvardef]]("ex_servermsg_3", "Server Message 3", "", "", "string");
	level.ex_servermsg_4 = [[level.ex_dvardef]]("ex_servermsg_4", "Server Message 4", "", "", "string");
	level.ex_servermsg_5 = [[level.ex_dvardef]]("ex_servermsg_5", "Server Message 5", "", "", "string");
	level.ex_servermsg_6 = [[level.ex_dvardef]]("ex_servermsg_6", "Server Message 6", "", "", "string");
	level.ex_servermsg_7 = [[level.ex_dvardef]]("ex_servermsg_7", "Server Message 7", "", "", "string");
	level.ex_servermsg_8 = [[level.ex_dvardef]]("ex_servermsg_8", "Server Message 8", "", "", "string");
	level.ex_servermsg_9 = [[level.ex_dvardef]]("ex_servermsg_9", "Server Message 9", "", "", "string");
	level.ex_servermsg_10 = [[level.ex_dvardef]]("ex_servermsg_10", "Server Message 10", "", "", "string");
	level.ex_servermsg_info = [[level.ex_dvardef]]("ex_servermsg_info", 0, 0, 3, "int");
	level.ex_servermsg_rotation = [[level.ex_dvardef]]("ex_servermsg_rotation", 0, 0, 1, "int");

	//****************************************************************************
	// X4 server rules
	//****************************************************************************
	level.ex_serverrules = [[level.ex_dvardef]]("ex_serverrules", "", "", "", "string");
	level.ex_serverrule_1 = [[level.ex_dvardef]]("ex_serverrule_1", "", "", "", "string");
	level.ex_serverrule_2 = [[level.ex_dvardef]]("ex_serverrule_2", "", "", "", "string");
	level.ex_serverrule_3 = [[level.ex_dvardef]]("ex_serverrule_3", "", "", "", "string");
	level.ex_serverrule_4 = [[level.ex_dvardef]]("ex_serverrule_4", "", "", "", "string");
	level.ex_serverrule_5 = [[level.ex_dvardef]]("ex_serverrule_5", "", "", "", "string");
	level.ex_serverrule_6 = [[level.ex_dvardef]]("ex_serverrule_6", "", "", "", "string");
	level.ex_serverrule_7 = [[level.ex_dvardef]]("ex_serverrule_7", "", "", "", "string");
	level.ex_serverrule_8 = [[level.ex_dvardef]]("ex_serverrule_8", "", "", "", "string");
	level.ex_serverrule_9 = [[level.ex_dvardef]]("ex_serverrule_9", "", "", "", "string");
	level.ex_serverrule_10 = [[level.ex_dvardef]]("ex_serverrule_10", "", "", "", "string");

	//****************************************************************************
	// X4 message of the day
	//****************************************************************************
	level.ex_motd_rotate = [[level.ex_dvardef]]("ex_motd_rotate", 1, 0, 1, "int");
	level.ex_motd_delay = [[level.ex_dvardef]]("ex_motd_delay", 3, 3, 60, "int");

	//****************************************************************************
	// X4 bot control
	//****************************************************************************
	level.ex_bots_randomclass = [[level.ex_dvardef]]("ex_bots_randomclass", 1, 0, 1, "int");
	level.ex_bots_endgamekick = [[level.ex_dvardef]]("ex_bots_endgamekick", 1, 0, 1, "int");

	//****************************************************************************
	// X4 logo
	//****************************************************************************
	thread extreme\_ex_logo::varcache();
	
	//****************************************************************************
	// X4 hud text and settings
	//****************************************************************************
	// Mod Info (bottom-right corner)
	//level.ex_clantext = [[level.ex_dvardef]]("ex_clan_txt",1,0,1,"int");
	level.ex_modinfo = [[level.ex_dvardef]]("ex_modinfo", 1, 0, 1, "int");
	level.ex_mod_message_name = [[level.ex_dvardef]]("ex_mod_message_1", "Powered by ^1X^24 ^3e^1X^3treme ^2Warfare", "", "", "string");
	level.ex_mod_message_by = [[level.ex_dvardef]]("ex_mod_message_2", "For more information...", "", "", "string");
	level.ex_mod_message_website = [[level.ex_dvardef]]("ex_mod_message_3", "Visit www.mycallofduty.com", "", "", "string");
	
	// Initialize player statistics
	thread extreme\_ex_statshud::init();
	
	//****************************************************************************
	// eXtreme+ statsboard
	//****************************************************************************
	level.ex_stbd = [[level.ex_dvardef]]("ex_stbd",0,0,1,"int");
	if(level.ex_stbd)
	{
		level.ex_stbd_kd = [[level.ex_dvardef]]("ex_stbd_kd", 1, 0, 1, "int");
		level.ex_stbd_se = [[level.ex_dvardef]]("ex_stbd_se", 1, 0, 1, "int");
		level.ex_stbd_tps = [[level.ex_dvardef]]("ex_stbd_tps", 0, 0, 10, "int");
		level.ex_stbd_time = [[level.ex_dvardef]]("ex_stbd_time", 20, 0, 120, "int");
		level.ex_stbd_icons = [[level.ex_dvardef]]("ex_stbd_icons", 0, 0, 1, "int");
		level.ex_stbd_movex = [[level.ex_dvardef]]("ex_stbd_movex", 0, 0, 150, "int");
		level.ex_stbd_fade = [[level.ex_dvardef]]("ex_stbd_fade", 0, 0, 1, "int");
		level.ex_stbd_log = [[level.ex_dvardef]]("ex_stbd_log", 0, 0, 1, "int");
		if(!level.ex_stbd_kd && !level.ex_stbd_se) level.ex_stbd = 0;
	}

	//****************************************************************************
	// X4 minefields
	//****************************************************************************
	level.ex_minefields = [[level.ex_dvardef]]("ex_minefields", 1, 0, 4, "int");
	level.ex_gasmine_min = [[level.ex_dvardef]]("ex_gasmine_min", 50, 1, 100, "int");
	level.ex_gasmine_max = [[level.ex_dvardef]]("ex_gasmine_max", 75, level.ex_gasmine_min, 100, "int");
	level.ex_napalmmine_min = [[level.ex_dvardef]]("ex_napalmmine_min", 50, 1, 100, "int");
	level.ex_napalmmine_max = [[level.ex_dvardef]]("ex_napalmmine_max", 75, level.ex_napalmmine_min, 100, "int");
	level.ex_radiationmine_min = [[level.ex_dvardef]]("ex_radiationmine_min", 50, 1, 100, "int");
	level.ex_radiationmine_max = [[level.ex_dvardef]]("ex_radiationmine_max", 75, level.ex_radiationmine_min, 100, "int");
	
	//****************************************************************************
	// X4 claymore control
	//****************************************************************************
	level.ex_allowclaymoredefuse = [[level.ex_dvardef]]("ex_allowclaymoredefuse", 0, 0, 1, "int");
	level.ex_claymoredefusetime = [[level.ex_dvardef]]("ex_claymoredefusetime", 2, 1, 99, "int");
	level.ex_defuseclaymorefailFriendly = [[level.ex_dvardef]]("ex_defuseclaymorefail", 10, 0, 10, "int");
	level.ex_defuseclaymorefailEnemy = [[level.ex_dvardef]]("ex_defuseclaymorefailEnemy", 10, 0, 10, "int");
	level.ex_defuseclaymorefailSelf = [[level.ex_dvardef]]("ex_defuseclaymorefailSelf", 10, 0, 10, "int");
	level.ex_defuseclaymorepointsFriendly = [[level.ex_dvardef]]("ex_defuseclaymorepointsFriendly", 0, 0, 99, "int");
	level.ex_defuseclaymorepointsEnemy	= [[level.ex_dvardef]]("ex_defuseclaymorepointsEnemy", 2, 0, 99, "int");
	level.ex_defuseclaymorepointsSelf = [[level.ex_dvardef]]("ex_defuseclaymorepointsSelf", 0, 0, 99, "int");
	level.ex_defuseclaymoreAddWeapon = [[level.ex_dvardef]]("ex_defuseclaymoreAddWeapon", 1, 0, 1, "int");
	level.ex_defuseclaymoreUseMsg = [[level.ex_dvardef]]("ex_defuseclaymoreUseMsg", "", "", "", "string");
	level.ex_defuseclaymoreSuccessMsg = [[level.ex_dvardef]]("ex_defuseclaymoreSuccessMsg", "", "", "", "string");
	level.ex_defuseclaymoreFailMsg = [[level.ex_dvardef]]("ex_defuseclaymoreFailMsg", "", "", "", "string");
	level.ex_defuseclaymoreWorkingMsg = [[level.ex_dvardef]]("ex_defuseclaymoreWorkingMsg", "", "", "", "string");

	//****************************************************************************
	// X4 laserdot & static cross
	//****************************************************************************
	level.ex_laserdot = [[level.ex_dvardef]]("ex_laserdot", 0, 0, 3, "int");
	level.ex_laserdotsize = [[level.ex_dvardef]]("ex_laserdot_size", 2, 1, 10, "int");
	level.ex_laserdotred = [[level.ex_dvardef]]("ex_laserdot_red", 1, 0, 1, "float");
	level.ex_laserdotgreen = [[level.ex_dvardef]]("ex_laserdot_green", 0, 0, 1, "float");
	level.ex_laserdotblue = [[level.ex_dvardef]]("ex_laserdot_blue", 0, 0, 1, "float");
	level.ex_staticcross = [[level.ex_dvardef]]("ex_static_cross", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 proximity C4
	//****************************************************************************
	level.ex_proximityc4 = [[level.ex_dvardef]]("ex_proximity_c4", 1, 0, 1, "int");
	level.ex_Proximityc4DetonateRadius = [[level.ex_dvardef]]("ex_Proximityc4DetonateRadius", 0, 0, 999, "int");
	level.ex_Proximityc4DetectionGracePeriod = [[level.ex_dvardef]]("ex_Proximityc4DetectionGracePeriod", 0, 0, 999, "int");

	//****************************************************************************
	// X4 rangefinder
	//****************************************************************************
	level.ex_rangefinder = [[level.ex_dvardef]]("ex_rangefinder", 0, 0, 1, "int");
	level.ex_rangefinder_units = [[level.ex_dvardef]]("ex_rangefinder_units", 1, 0, 1, "int");
	level.ex_rangefinder_scopesonly = [[level.ex_dvardef]]("ex_rangefinder_scopesonly", 1, 0, 1, "int");

	//****************************************************************************
	// X4 WMD's
	//****************************************************************************	
	level.ex_ac130grain = [[level.ex_dvardef]]("ex_ac130_static", 0, 0, 1, "int");
	level.ex_ac130_hud = [[level.ex_dvardef]]("ex_ac130_hud", 0, 0, 1, "int"); 
	level.ex_ac130_thermal = [[level.ex_dvardef]]("ex_ac130_thermal", 0, 0, 1, "int");
	level.ex_ac130_sound = [[level.ex_dvardef]]("ex_ac130_sound", 0, 0, 1, "int");  
	level.ex_ac130_shotFiredDarkScreen = [[level.ex_dvardef]]("ex_ac130_shotFiredDarkScreen", 0, 0, 1, "int");
	level.ex_ac130_timer = [[level.ex_dvardef]]("ex_ac130_time", 30, 10, 999, "int");
	level.ex_drone_flyer = [[level.ex_dvardef]]("ex_drone_flyer", 0, 0, 1, "int");//doom 
	level.ex_radarViewTime = [[level.ex_dvardef]]("ex_wmd_uav_time", 30, 5, 999, "int");
	level.ex_napalm_radius = [[level.ex_dvardef]]("ex_wmd_napalmradius", 3000, 0, 9999, "int");
	level.ex_air_raid_global = [[level.ex_dvardef]]("ex_airraid_siren_global", 0, 0, 1, "int");
	level.ex_air_raid_team = [[level.ex_dvardef]]("ex_airraid_siren_team", 0, 0, 1, "int");
	level.ex_kill_streaks = [[level.ex_dvardef]]("ex_kill_streaks", 0, 0, 1, "int");
	level.ex_helicopter_manned = [[level.ex_dvardef]]("ex_helicopter_manned", 0, 0, 1, "int");//doom
	level.ex_helicopter_unmanned = [[level.ex_dvardef]]("ex_helicopter_unmanned", 0, 0, 1, "int");//doom
	level.ex_heli_timer = [[level.ex_dvardef]]("ex_heli_timer", 30, 10, 999, "int");
	level.ex_sentry_turret_range = [[level.ex_dvardef]]("ex_sentry_turret_range", 0, 0, 999, "int");
	
	level.ex_wmd_uav = [[level.ex_dvardef]]("ex_wmd_uav", 0, 0, 999, "int");
	level.ex_wmd_uav2 = [[level.ex_dvardef]]("ex_wmd_uav2", 0, 0, 999, "int"); 
	level.ex_wmd_sentrygun = [[level.ex_dvardef]]("ex_wmd_sentrygun", 0, 0, 999, "int");
	level.ex_wmd_sentrygun2 = [[level.ex_dvardef]]("ex_wmd_sentrygun2", 0, 0, 999, "int");  
	level.ex_wmd_airstrike = [[level.ex_dvardef]]("ex_wmd_airstrike", 0, 0, 999, "int");
	level.ex_wmd_airstrike2 = [[level.ex_dvardef]]("ex_wmd_airstrike2", 0, 0, 999, "int");
	level.ex_wmd_chopper = [[level.ex_dvardef]]("ex_wmd_chopper", 0, 0, 999, "int");
	level.ex_wmd_chopper2 = [[level.ex_dvardef]]("ex_wmd_chopper2", 0, 0, 999, "int");
	level.ex_wmd_napalm = [[level.ex_dvardef]]("ex_wmd_napalm", 0, 0, 999, "int");
	level.ex_wmd_napalm2 = [[level.ex_dvardef]]("ex_wmd_napalm2", 0, 0, 999, "int");
	level.ex_wmd_stealth = [[level.ex_dvardef]]("ex_wmd_stealth", 18, 0, 999, "int");
	level.ex_wmd_stealth2 = [[level.ex_dvardef]]("ex_wmd_stealth2", 18, 0, 999, "int");
	level.ex_wmd_ac130 = [[level.ex_dvardef]]("ex_wmd_ac130", 0, 0, 999, "int");
	level.ex_wmd_ac1302 = [[level.ex_dvardef]]("ex_wmd_ac1302", 0, 0, 999, "int");
	level.ex_wmd_nuke = [[level.ex_dvardef]]("ex_wmd_nuke", 0, 0, 999, "int");
	
	//****************************************************************************
	// X4 fall damage
	//****************************************************************************
	if([[level.ex_dvardef]]("ex_falldamage_enable", 0, 0, 1,"int"))
	{
		minfalldamage = [[level.ex_dvardef]]("ex_falldamage_min", 5, 5, 9999, "int");
		maxfalldamage = [[level.ex_dvardef]]("ex_falldamage_max", 10, minfalldamage, 9999, "int");
		setDvar("bg_fallDamageMinHeight", minfalldamage * 12);
		setDvar("bg_fallDamageMaxHeight", maxfalldamage * 12);
	}

	//****************************************************************************
	// X4 weapon drop system (after death)
	//****************************************************************************
	level.ex_wepo_drop_all = [[level.ex_dvardef]]("ex_wepo_drop_all", 0, 0, 1, "int"); 
	level.ex_wepo_drop_frag = [[level.ex_dvardef]]("ex_wepo_drop_frag", 0, 0, 1, "int");
	level.ex_wepo_drop_smoke = [[level.ex_dvardef]]("ex_wepo_drop_smoke", 0, 0, 1, "int");
	level.ex_wepo_drop_flash = [[level.ex_dvardef]]("ex_wepo_drop_flash", 0, 0, 1, "int");
	level.ex_wepo_drop_concussion = [[level.ex_dvardef]]("ex_wepo_drop_concussion", 0, 0, 1, "int");
	level.ex_wepo_drop_c4 = [[level.ex_dvardef]]("ex_wepo_drop_c4", 0, 0, 1, "int");																	  
	level.ex_wepo_drop_claymore = [[level.ex_dvardef]]("ex_wepo_drop_claymore", 0, 0, 1, "int");
	level.ex_wepo_drop_rpg = [[level.ex_dvardef]]("ex_wepo_drop_rpg", 0, 0, 1, "int");

	//****************************************************************************
	// X4 sniper zoom level
	//****************************************************************************
	level.ex_zoom = [[level.ex_dvardef]]("ex_zoom", 0, 0, 1, "int");
	level.ex_zoom_min = [[level.ex_dvardef]]("ex_zoom_min", 1, 1, 10, "int");
	level.ex_zoom_max = [[level.ex_dvardef]]("ex_zoom_max", 10, level.ex_zoom_min, 10, "int");
	level.ex_zoom_default = [[level.ex_dvardef]]("ex_zoom_default", 7, level.ex_zoom_min, level.ex_zoom_max, "int");
	level.ex_zoom_switchreset = [[level.ex_dvardef]]("ex_zoom_switchreset", 0, 0, 1, "int");
	level.ex_zoom_adsreset = [[level.ex_dvardef]]("ex_zoom_adsreset", 0, 0, 1, "int");
	level.ex_zoom_gradual = [[level.ex_dvardef]]("ex_zoom_gradual", 1, 0, 1, "int");

	//****************************************************************************
	// X4 jump height
	//****************************************************************************
	if([[level.ex_dvardef]]("ex_jumpheight", 0, 0, 1,"int"))
	{
		maxjumpheight = [[level.ex_dvardef]]("ex_jumpheight_max", 2, 1, 10, "int");
		setDvar("jump_height", maxjumpheight * 12);
	}

	//****************************************************************************
	// X4 body sink on death
	//****************************************************************************
	level.ex_bodysink = [[level.ex_dvardef]]("ex_bodysink", 0, 0, 1, "int");	
	level.ex_bodysink_time = [[level.ex_dvardef]]("ex_bodysink_time", 15, 5, 99, "int");
	
	//****************************************************************************
	// X4 livestats
	//****************************************************************************
	level.ex_livestats = [[level.ex_dvardef]]("ex_livestats", 0, 0, 1, "int");
	
	//****************************************************************************
	// x4 sky fx
	//****************************************************************************
	// tracer fx
	level.ex_tracers = [[level.ex_dvardef]]("ex_tracers", 0, 0, 10, "int");

	if(level.ex_tracers)
	{
		level.ex_tracersdelaymin = [[level.ex_dvardef]]("ex_tracers_delay_min", 10, 5, 720, "int");
		level.ex_tracersdelaymax = [[level.ex_dvardef]]("ex_tracers_delay_max", level.ex_tracersdelaymin + 1, level.ex_tracersdelaymin + 1, 1440, "int");
		level.ex_tracers_sound = [[level.ex_dvardef]]("ex_tracers_sound", 0, 0, 1, "int");
	}

	// flak fx
	level.ex_flakfx = [[level.ex_dvardef]]("ex_flakfx", 0, 0, 10, "int");

	if(level.ex_flakfx)
	{
		level.ex_flakfxdelaymin = [[level.ex_dvardef]]("ex_flakfx_delay_min", 5, 5, 720, "int");
		level.ex_flakfxdelaymax = [[level.ex_dvardef]]("ex_flakfx_delay_max", level.ex_flakfxdelaymin + 1, level.ex_flakfxdelaymin + 1, 1440, "int");
	}
	//****************************************************************************
	// X4 ambient artillery
	//****************************************************************************
	level.ex_artillery = [[level.ex_dvardef]]("ex_artillery", 1, 0, 2, "int");
	level.ex_artillery_alert = [[level.ex_dvardef]]("ex_artillery_alert", 1, 0, 1, "int");
	level.ex_artillery_shells_min = [[level.ex_dvardef]]("ex_artillery_shells_min", 5, 5, 15, "int");
	level.ex_artillery_shells_max = [[level.ex_dvardef]]("ex_artillery_shells_max", level.ex_artillery_shells_min * 2, level.ex_artillery_shells_min + 1, 30, "int");
	level.ex_artillery_delay_min = [[level.ex_dvardef]]("ex_artillery_delay_min", 300, 30, 720, "int");
	level.ex_artillery_delay_max = [[level.ex_dvardef]]("ex_artillery_delay_max", level.ex_artillery_delay_min * 2, level.ex_artillery_delay_min + 1, 1440, "int");
	level.ex_artillery_max = [[level.ex_dvardef]]("ex_artillery_max", 50, 0, 999, "int");
	level.ex_artillery_min = [[level.ex_dvardef]]("ex_artillery_min", 30, 0, 999, "int");
	
	//****************************************************************************
	// x4 ambient planes
	//****************************************************************************
	level.ex_planes = [[level.ex_dvardef]]("ex_planes", 0, 0, 3, "int");
	level.ex_planes_min = [[level.ex_dvardef]]("ex_planes_min", 1, 1, 19, "int");
	level.ex_planes_max = [[level.ex_dvardef]]("ex_planes_max", level.ex_planes_min + 1, level.ex_planes_min + 1, 20, "int");
	level.ex_planes_delay_min = [[level.ex_dvardef]]("ex_planes_delay_min", 60, 30, 720, "int");
	level.ex_planes_delay_max = [[level.ex_dvardef]]("ex_planes_delay_max", level.ex_planes_delay_min + 1, level.ex_planes_delay_min + 1, 1440, "int");
	level.ex_planes_flak = [[level.ex_dvardef]]("ex_planes_flak", 0, 0, 1, "int");
	level.ex_planes_altitude = [[level.ex_dvardef]]("ex_planes_altitude", 6000, 0, 6000, "int");
	level.ex_planes_bombmax = [[level.ex_dvardef]]("ex_planes_bombmax", 50, 0, 999, "int");
	level.ex_planes_bombmin = [[level.ex_dvardef]]("ex_planes_bombmin", 30, 0, 999, "int");
	
	// flak settings if plane flak enabled
	if(level.ex_planes_flak)
	{
		if(level.ex_flakfx < 10) level.ex_flak = 10;
		level.ex_flakfxdelaymin = 5;
		level.ex_flakfxdelaymax = 15;
	}	
	//*
	// X4 explosion control
	//*
	// radius control
	// radius control
	level.ex_planecrash_radius = 12 * [[level.ex_dvardef]]("ex_planecrash_radius",36, 0, 999, "int");
	level.ex_planebomb_radius = 12 * [[level.ex_dvardef]]("ex_planebomb_radius",36, 0, 999, "int");
	level.ex_artillery_radius = 12 * [[level.ex_dvardef]]("ex_artillery_radius", 36, 5, 500, "int");
	//****************************************************************************
	// X4 killing spree and obituary system
	//****************************************************************************
	level.ex_obituary = [[level.ex_dvardef]]("ex_obituary", 4, 0, 8, "int");
	level.ex_obrange = [[level.ex_dvardef]]("ex_obitunit", 1, 0, 1, "int");
	
	//****************************************************************************
	// X4 Knife/Headshot/Grenade Counter
	//****************************************************************************
	level.ex_showbashcount = [[level.ex_dvardef]] ("ex_show_bash_count", 0, 0, 1, "int");
	level.ex_showbashbold = [[level.ex_dvardef]] ("ex_show_bash_bold", 0, 0, 1, "int");
	level.ex_showheadcount = [[level.ex_dvardef]] ("ex_show_head_count", 0, 0, 1, "int");
	level.ex_showheadbold = [[level.ex_dvardef]] ("ex_show_head_bold", 0, 0, 1, "int");
	level.ex_shownadecount = [[level.ex_dvardef]] ("ex_show_nade_count", 0, 0, 1, "int");
	level.ex_shownadebold = [[level.ex_dvardef]] ("ex_show_nade_bold", 0, 0, 1, "int");
	
	//****************************************************************************
	// X4 Knife/Headshot/chopper Reward System
	//****************************************************************************
	level.ex_headshotreward = [[level.ex_dvardef]] ("ex_headshot_reward", 0, 0, 1, "int");
	level.ex_headshotpoints = [[level.ex_dvardef]] ("ex_headshot_points", 0, 0, 99, "int");
	level.ex_meleereward = [[level.ex_dvardef]] ("ex_melee_reward", 0, 0, 1, "int");
	level.ex_meleepoints = [[level.ex_dvardef]] ("ex_melee_points", 0, 0, 99, "int");
	level.ex_destroyedhelireward = [[level.ex_dvardef]] ("ex_destroyedhelireward", 0, 0, 1, "int");
	level.ex_helidestroyedpoints = [[level.ex_dvardef]] ("ex_helidestroyedpoints", 0, 0, 99, "int"); 
	
	//****************************************************************************
	// X4 scoring overrides //doom
	//****************************************************************************
	level.ex_score_kill		 = [[level.ex_dvardef]]("ex_score_kill", 0, 0, 9999, "int");
	level.ex_score_assist		 = [[level.ex_dvardef]]("ex_score_assist", 0, 0, 9999, "int");
	level.ex_score_suicide		 = [[level.ex_dvardef]]("ex_score_suicide", 0, 0, 9999, "int");
	level.ex_score_teamkill	 = [[level.ex_dvardef]]("ex_score_teamkill", 0, 0, 9999, "int");
	level.ex_score_win		 = [[level.ex_dvardef]]("ex_score_win", 0, 0, 9999, "int");
	level.ex_score_loss		 = [[level.ex_dvardef]]("ex_score_loss", 0, 0, 9999, "int");
	level.ex_score_tie		 = [[level.ex_dvardef]]("ex_score_tie", 0, 0, 9999, "int");
	level.ex_score_capture		 = [[level.ex_dvardef]]("ex_score_capture", 0, 0, 9999, "int");
	level.ex_score_defend		 = [[level.ex_dvardef]]("ex_score_defend", 0, 0, 9999, "int");
	level.ex_score_defend_assist	= [[level.ex_dvardef]]("ex_score_defend_assist", 0, 0, 9999, "int");
	level.ex_score_assault		= [[level.ex_dvardef]]("ex_score_assault", 0, 0, 9999, "int");
	level.ex_assault_assist		= [[level.ex_dvardef]]("ex_score_assault_assist", 0, 0, 9999, "int");
	level.ex_score_challenge	= [[level.ex_dvardef]]("ex_score_challenge", 0, 0, 9999, "int");
	level.ex_score_capture_team_complete		 = [[level.ex_dvardef]]("ex_score_capture_team_complete", 0, 0, 9999, "int");
	level.ex_score_plant		= [[level.ex_dvardef]]("ex_score_plant", 0, 0, 9999, "int");
	level.ex_score_defuse		= [[level.ex_dvardef]]("ex_score_defuse", 0, 0, 9999, "int");
	level.ex_score_return		= [[level.ex_dvardef]]("ex_score_return", 0, 0, 9999, "int");
	level.ex_score_hardpoint		= [[level.ex_dvardef]]("ex_score_hardpoint", 0, 0, 9999, "int");	  

	//****************************************************************************
	// X4 weapon damage mod
	//****************************************************************************
	level.ex_wdmodon = [[level.ex_dvardef]]("ex_wdmodon", 0, 0, 1, "int");
	if(level.ex_wdmodon) thread Weapon_Damage_Mod();
	
	level.headshot_fulldamage = [[level.ex_dvardef]] ("ex_headshot_full_damage", 0, 0, 1, "int");

	//****************************************************************************
	// X4 first aid
	//****************************************************************************
	level.ex_maxhealth = getDvarint("scr_player_maxhealth");
	level.ex_firstaid_kits = [[level.ex_dvardef]]("ex_firstaid_kits", 2, 0, 9, "int");
	level.ex_firstaid_self = [[level.ex_dvardef]]("ex_firstaid_self", 1, 0, 1, "int");
	level.ex_firstaid_minheal = [[level.ex_dvardef]]("ex_firstaid_minheal", 50, 1, 99, "int");	
	level.ex_firstaid_maxheal = [[level.ex_dvardef]]("ex_firstaid_maxheal", 100, level.ex_firstaid_minheal, 100, "int");
	level.ex_firstaid_pickup = [[level.ex_dvardef]]("ex_firstaid_pickup", 0, 0, 9, "int");	
	level.ex_firstaid_drop = [[level.ex_dvardef]]("ex_firstaid_drop", 0, 0, 1, "int");

	//****************************************************************************
	// X4 bullet holes
	//****************************************************************************
	level.ex_bulletholes = [[level.ex_dvardef]]("ex_bulletholes", 0, 0, 5, "int");

	//****************************************************************************
	// X4 bleeding
	//****************************************************************************
	level.ex_bleeding = [[level.ex_dvardef]]("ex_bleeding", 0, 0, 1, "int");
	level.ex_bleedmsg_global = [[level.ex_dvardef]]("ex_bleedmsg_global", 1, 0, 1, "int");
	level.ex_startbleed = [[level.ex_dvardef]]("ex_startbleed", 50, 1, 99, "int");
	level.ex_maxbleed = [[level.ex_dvardef]]("ex_maxbleed", 50, 0, 100, "int");
	level.ex_bleedmsg = [[level.ex_dvardef]]("ex_bleedmsg", 0, 0, 1, "int");
	level.ex_bleedsound = [[level.ex_dvardef]]("ex_bleedsound", 1, 0, 1, "int");
	level.ex_bleedshock = [[level.ex_dvardef]]("ex_bleedshock", 0, 0, 1, "int");

	//****************************************************************************
	// X4 hit, pain and death sounds
	//****************************************************************************
	level.ex_painsound = [[level.ex_dvardef]]("ex_painsound", 1, 0, 1, "int");
	level.ex_painsound_chance = [[level.ex_dvardef]]("ex_painsound_chance", 90, 0, 100, "int");
	level.ex_deathsound = [[level.ex_dvardef]]("ex_deathsound", 1, 0, 1, "int");
	level.ex_deathsound_chance = [[level.ex_dvardef]]("ex_deathsound_chance", 90, 0, 100, "int");

	//****************************************************************************
	// X4 battlechatter control
	//****************************************************************************
	level.ex_battlechatter = [[level.ex_dvardef]]("ex_battlechatter", 1, 0, 1, "int");
	level.ex_battlechatter_reload = [[level.ex_dvardef]]("ex_battlechatter_reload", 1, 0, 1, "int");
	level.ex_battlechatter_fragout = [[level.ex_dvardef]]("ex_battlechatter_fragout", 1, 0, 1, "int");
	level.ex_battlechatter_flashout = [[level.ex_dvardef]]("ex_battlechatter_flashout", 1, 0, 1, "int");
	level.ex_battlechatter_smokeout = [[level.ex_dvardef]]("ex_battlechatter_smokeout", 1, 0, 1, "int");
	level.ex_battlechatter_concout = [[level.ex_dvardef]]("ex_battlechatter_concout", 1, 0, 1, "int");
	level.ex_battlechatter_c4 = [[level.ex_dvardef]]("ex_battlechatter_c4", 1, 0, 1, "int");
	level.ex_battlechatter_claymore = [[level.ex_dvardef]]("ex_battlechatter_claymore", 1, 0, 1, "int");
	level.ex_battlechatter_kill = [[level.ex_dvardef]]("ex_battlechatter_kill", 1, 0, 1, "int");
	level.ex_battlechatter_casualty = [[level.ex_dvardef]]("ex_battlechatter_casualty", 1, 0, 1, "int");
	level.ex_battlechatter_self = [[level.ex_dvardef]]("ex_battlechatter_self", 0, 0, 1, "int");

	//****************************************************************************
	// X4 anti-camper system
	//****************************************************************************
	level.ex_campwarntime = [[level.ex_dvardef]]("ex_campwarntime", 0, 0, 300, "int");
	level.ex_campobjtime = [[level.ex_dvardef]]("ex_campobjtime", level.ex_campwarntime+10, level.ex_campwarntime+5, 600, "int");
	level.ex_camptimer = [[level.ex_dvardef]]("ex_camptimer", 20, 0, 300, "int");
	level.ex_campsniper_warntime = [[level.ex_dvardef]]("ex_campsniper_warntime", 0, 0, 600, "int");
	level.ex_campsniper_objtime = [[level.ex_dvardef]]("ex_campsniper_objtime", level.ex_campsniper_warntime+10, level.ex_campsniper_warntime+5, 1200, "int");
	level.ex_camppunish = [[level.ex_dvardef]]("ex_camp_punish", 0, 0, 5, "int");

	//****************************************************************************
	// X4 command monitor
	//****************************************************************************
	level.ex_cmd_monitor = [[level.ex_dvardef]]("ex_cmd_monitor", 0, 0, 1, "int");
	level.ex_cmdmonitor_models = [[level.ex_dvardef]]("ex_cmdmonitor_models", 0, 0, 1, "int");

	//****************************************************************************
	// X4 active server rules
	//****************************************************************************
	level.ex_svrrules = [[level.ex_dvardef]]("ex_svrrules", "", "" , "", "string");

	//****************************************************************************
	// X4 turret control and overheating
	//****************************************************************************
	level.ex_turrets = [[level.ex_dvardef]]("ex_turrets", 1, 0, 1, "int");
	level.ex_turretoverheat = [[level.ex_dvardef]]("ex_turretoverheat", 1, 0, 1, "int");
	level.ex_turretoverheat_heatrate = [[level.ex_dvardef]]("ex_turretoverheat_heatrate", 2, 1, 4, "int");
	level.ex_turretoverheat_coolrate = [[level.ex_dvardef]]("ex_turretoverheat_coolrate", 2, 1, 4, "int");

	//****************************************************************************
	// X4 misc
	//****************************************************************************
	level.ex_showteambalance_msg = [[level.ex_dvardef]]("ex_show_teambalancemsg", 1, 0, 1, "int");
	
	//****************************************************************************
	// X4 Body Search (port from UO)
	//****************************************************************************
	level.ex_bodysearch = [[level.ex_dvardef]] ("ex_bodysearch", 0, 0, 1, "int");
	level.ex_show_searchicon = [[level.ex_dvardef]] ("ex_show_searchicon", 1, 0, 1, "int");
	level.ex_searchtime = [[level.ex_dvardef]] ("ex_search_time", 3, 1, 10, "int");
	level.ex_bodysearchsound = [[level.ex_dvardef]] ("ex_bodysearchsound", 1, 0, 1, "int");
	level.aBodies = [];
	level.iBodies = 0;
	level.oClone = [];
	level.ex_search1 = [[level.ex_dvardef]] ("ex_searchmsg1", "", "", "", "string");
	level.ex_search2 = [[level.ex_dvardef]] ("ex_searchmsg2", "", "", "", "string");
	level.ex_search3 = [[level.ex_dvardef]] ("ex_searchmsg3", "", "", "", "string");
	level.ex_search4 = [[level.ex_dvardef]] ("ex_searchmsg4", "", "", "", "string");
	level.ex_search5 = [[level.ex_dvardef]] ("ex_searchmsg5", "", "", "", "string");
	level.ex_search6 = [[level.ex_dvardef]] ("ex_searchmsg6", "", "", "", "string");
	level.ex_search7 = [[level.ex_dvardef]] ("ex_searchmsg7", "", "", "", "string");
	level.ex_search8 = [[level.ex_dvardef]] ("ex_searchmsg8", "", "", "", "string");
	level.ex_search9 = [[level.ex_dvardef]] ("ex_searchmsg9", "", "", "", "string");
	level.ex_search10 = [[level.ex_dvardef]] ("ex_searchmsg10", "", "", "", "string");
	level.ex_search11 = [[level.ex_dvardef]] ("ex_searchmsg11", "", "", "", "string");
	level.ex_search12 = [[level.ex_dvardef]] ("ex_searchmsg12", "", "", "", "string");
	level.ex_search13 = [[level.ex_dvardef]] ("ex_searchmsg13", "", "", "", "string");
	level.ex_search14 = [[level.ex_dvardef]] ("ex_searchmsg14", "", "", "", "string");
	level.ex_search15 = [[level.ex_dvardef]] ("ex_searchmsg15", "", "", "", "string");
	level.ex_search16 = [[level.ex_dvardef]] ("ex_searchmsg16", "", "", "", "string");
	level.ex_search17 = [[level.ex_dvardef]] ("ex_searchmsg17", "", "", "", "string");
	level.ex_search18 = [[level.ex_dvardef]] ("ex_searchmsg18", "", "", "", "string");
	level.ex_search19 = [[level.ex_dvardef]] ("ex_searchmsg19", "", "", "", "string");
	level.ex_search20 = [[level.ex_dvardef]] ("ex_searchmsg20", "", "", "", "string");

	//****************************************************************************
	// X4 define level variables
	//****************************************************************************
	// set plane variables
	level.ex_axisapinsky = 0;
	level.ex_allieapinsky = 0;
	level.ex_paxisapinsky = 0;
	level.ex_pallieapinsky = 0;
	level.ex_planescrashed = 0;
	
	level.ex_fbannounce = true;

	// set up drophealth arrays
	if(level.ex_firstaid_drop)
	{
		game["ex_healthqueue"] = [];
		game["ex_healthqueuecurrent"] = 0;

		// Set up object queues
		level.ex_objectQ["health"] = [];
		level.ex_objectQcurrent["health"] = 0;
		level.ex_objectQsize["health"] = 4;
	}

	// Set up number of voices
	level.ex_voices["american"] = [];
	level.ex_voices["american"]["death"] = 8;
	level.ex_voices["american"]["pain"] = 8;
	level.ex_voices["american"]["meleecharge"] = 8;
	level.ex_voices["american"]["meleeattack"] = 8;
	level.ex_voices["american"]["flashbang"] = 8;
	level.ex_voices["british"] = [];
	level.ex_voices["british"]["death"] = 8;
	level.ex_voices["british"]["pain"] = 8;
	level.ex_voices["british"]["meleecharge"] = 8;
	level.ex_voices["british"]["meleeattack"] = 8;
	level.ex_voices["british"]["flashbang"] = 8;
	level.ex_voices["russian"] = [];
	level.ex_voices["russian"]["death"] = 8;
	level.ex_voices["russian"]["pain"] = 8;
	level.ex_voices["russian"]["meleecharge"] = 8;
	level.ex_voices["russian"]["meleecharge"] = 8;
	level.ex_voices["russian"]["flashbang"] = 8;
	level.ex_voices["arab"] = [];
	level.ex_voices["arab"]["death"] = 8;
	level.ex_voices["arab"]["pain"] = 8;
	level.ex_voices["arab"]["meleecharge"] = 8;
	level.ex_voices["arab"]["meleeattack"] = 8;
	level.ex_voices["arab"]["flashbang"] = 8;

	//****************************************************************************
	// X4 post-map loadfx, precache strings, shaders, models, headicons
	//****************************************************************************

	// precache shaders
	thread precacheShaders();
	
	// precache models
	thread precacheModels();

	// precache effects
	thread loadEffects();
}

Weapon_Damage_Mod()
{
	game["ex_wdm"] = [];
	game["ex_wdm"]["ac130_105mm_mp"] = "ex_wdm_ac130";
	game["ex_wdm"]["ac130_25mm_mp"] = "ex_wdm_ac130";
	game["ex_wdm"]["ac130_40mm_mp"] = "ex_wdm_ac130";
	game["ex_wdm"]["airstrike_mp"] = "ex_wdm_airstrike";
	game["ex_wdm"]["ak47_acog_mp"] = "ex_wdm_ak47";
	game["ex_wdm"]["ak47_gl_mp"] = "ex_wdm_ak47";
	game["ex_wdm"]["ak47_mp"] = "ex_wdm_ak47";
	game["ex_wdm"]["ak47_reflex_mp"] = "ex_wdm_ak47";
	game["ex_wdm"]["ak47_silencer_mp"] = "ex_wdm_ak47";
	game["ex_wdm"]["ak74u_acog_mp"] = "ex_wdm_ak74u";
	game["ex_wdm"]["ak74u_mp"] = "ex_wdm_ak74u";
	game["ex_wdm"]["ak74u_reflex_mp"] = "ex_wdm_ak74u";
	game["ex_wdm"]["ak74u_silencer_mp"] = "ex_wdm_ak74u";
	game["ex_wdm"]["artillery_mp"] = "ex_wdm_artillery";
	game["ex_wdm"]["at4_mp"] = "ex_wdm_at4";
	game["ex_wdm"]["aw50_acog_mp"] = "ex_wdm_aw50";
	game["ex_wdm"]["aw50_mp"] = "ex_wdm_aw50";
	game["ex_wdm"]["barrett_acog_mp"] = "ex_wdm_barrett";
	game["ex_wdm"]["barrett_mp"] = "ex_wdm_barrett";
	game["ex_wdm"]["beretta_mp"] = "ex_wdm_beretta";
	game["ex_wdm"]["beretta_silencer_mp"] = "ex_wdm_beretta";
	game["ex_wdm"]["brick_blaster_mp"] = "ex_wdm_brick_bomb";
	game["ex_wdm"]["brick_bomb_mp"] = "ex_wdm_brick_bomb";
	game["ex_wdm"]["c4_mp"] = "ex_wdm_c4";
	game["ex_wdm"]["claymore_mp"] = "ex_wdm_claymore";
	game["ex_wdm"]["cobra_20mm_mp"] = "ex_wdm_cobra";
	game["ex_wdm"]["cobra_ffar_mp"] = "ex_wdm_cobra";
	game["ex_wdm"]["colt45_mp"] = "ex_wdm_colt45";
	game["ex_wdm"]["colt45_silencer_mp"] = "ex_wdm_colt45";
	game["ex_wdm"]["concussion_grenade_mp"] = "ex_wdm_concussion_grenade";
	game["ex_wdm"]["deserteaglegold_mp"] = "ex_wdm_deserteaglegold";
	game["ex_wdm"]["deserteagle_mp"] = "ex_wdm_deserteagle";
	game["ex_wdm"]["destructible_car"] = "ex_wdm_destructible_car";
	game["ex_wdm"]["dragunov_acog_mp"] = "ex_wdm_dragunov";
	game["ex_wdm"]["dragunov_mp"] = "ex_wdm_dragunov";
	game["ex_wdm"]["flash_grenade_mp"] = "ex_wdm_flash_grenade";
	game["ex_wdm"]["frag_grenade_mp"] = "ex_wdm_frag_grenade";
	game["ex_wdm"]["frag_grenade_short_mp"] = "ex_wdm_frag_grenade";
	game["ex_wdm"]["g36c_acog_mp"] = "ex_wdm_g36c";
	game["ex_wdm"]["g36c_gl_mp"] = "ex_wdm_g36c";
	game["ex_wdm"]["g36c_mp"] = "ex_wdm_g36c";
	game["ex_wdm"]["g36c_reflex_mp"] = "ex_wdm_g36c";
	game["ex_wdm"]["g36c_silencer_mp"] = "ex_wdm_g36c";
	game["ex_wdm"]["g3_acog_mp"] = "ex_wdm_g3";
	game["ex_wdm"]["g3_gl_mp"] = "ex_wdm_g3";
	game["ex_wdm"]["g3_mp"] = "ex_wdm_g3";
	game["ex_wdm"]["g3_reflex_mp"] = "ex_wdm_g3";
	game["ex_wdm"]["g3_silencer_mp"] = "ex_wdm_g3";
	game["ex_wdm"]["gl_ak47_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["gl_g36c_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["gl_g3_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["gl_m14_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["gl_m16_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["gl_m4_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["gl_mp"] = "ex_wdm_grenade_launcher";
	game["ex_wdm"]["helicopter_mp"] = "ex_wdm_helicopter";
	game["ex_wdm"]["hind_ffar_mp"] = "ex_wdm_hind_ffar";
	game["ex_wdm"]["humvee_50cal_mp"] = "ex_wdm_humvee_50cal";
	game["ex_wdm"]["m1014_grip_mp"] = "ex_wdm_m1014";
	game["ex_wdm"]["m1014_mp"] = "ex_wdm_m1014";
	game["ex_wdm"]["m1014_reflex_mp"] = "ex_wdm_m1014";
	game["ex_wdm"]["m14_acog_mp"] = "ex_wdm_m14";
	game["ex_wdm"]["m14_gl_mp"] = "ex_wdm_m14";
	game["ex_wdm"]["m14_mp"] = "ex_wdm_m14";
	game["ex_wdm"]["m14_reflex_mp"] = "ex_wdm_m14";
	game["ex_wdm"]["m14_silencer_mp"] = "ex_wdm_m14";
	game["ex_wdm"]["m16_acog_mp"] = "ex_wdm_m16";
	game["ex_wdm"]["m16_gl_mp"] = "ex_wdm_m16";
	game["ex_wdm"]["m16_mp"] = "ex_wdm_m16";
	game["ex_wdm"]["m16_reflex_mp"] = "ex_wdm_m16";
	game["ex_wdm"]["m16_silencer_mp"] = "ex_wdm_m16";
	game["ex_wdm"]["m21_acog_mp"] = "ex_wdm_m21";
	game["ex_wdm"]["m21_mp"] = "ex_wdm_m21";
	game["ex_wdm"]["m40a3_acog_mp"] = "ex_wdm_m40a3";
	game["ex_wdm"]["m40a3_mp"] = "ex_wdm_m40a3";
	game["ex_wdm"]["m4_acog_mp"] = "ex_wdm_m4";
	game["ex_wdm"]["m4_gl_mp"] = "ex_wdm_m4";
	game["ex_wdm"]["m4_mp"] = "ex_wdm_m4";
	game["ex_wdm"]["m4_reflex_mp"] = "ex_wdm_m4";
	game["ex_wdm"]["m4_silencer_mp"] = "ex_wdm_m4";
	game["ex_wdm"]["m60e4_acog_mp"] = "ex_wdm_m60e4";
	game["ex_wdm"]["m60e4_grip_mp"] = "ex_wdm_m60e4";
	game["ex_wdm"]["m60e4_mp"] = "ex_wdm_m60e4";
	game["ex_wdm"]["m60e4_reflex_mp"] = "ex_wdm_m60e4";
	game["ex_wdm"]["mp44_mp"] = "ex_wdm_mp44";
	game["ex_wdm"]["mp5_acog_mp"] = "ex_wdm_mp5";
	game["ex_wdm"]["mp5_mp"] = "ex_wdm_mp5";
	game["ex_wdm"]["mp5_reflex_mp"] = "ex_wdm_mp5";
	game["ex_wdm"]["mp5_silencer_mp"] = "ex_wdm_mp5";
	game["ex_wdm"]["p90_acog_mp"] = "ex_wdm_p90";
	game["ex_wdm"]["p90_mp"] = "ex_wdm_p90";
	game["ex_wdm"]["p90_reflex_mp"] = "ex_wdm_p90";
	game["ex_wdm"]["p90_silencer_mp"] = "ex_wdm_p90";
	game["ex_wdm"]["remington700_acog_mp"] = "ex_wdm_remington";
	game["ex_wdm"]["remington700_mp"] = "ex_wdm_remington";
	game["ex_wdm"]["rpd_acog_mp"] = "ex_wdm_rpd";
	game["ex_wdm"]["rpd_grip_mp"] = "ex_wdm_rpd";
	game["ex_wdm"]["rpd_mp"] = "ex_wdm_rpd";
	game["ex_wdm"]["rpd_reflex_mp"] = "ex_wdm_rpd";
	game["ex_wdm"]["rpg_mp"] = "ex_wdm_rpg";
	game["ex_wdm"]["saw_acog_mp"] = "ex_wdm_saw";
	game["ex_wdm"]["saw_bipod_crouch_mp"] = "ex_wdm_turret";
	game["ex_wdm"]["saw_bipod_prone_mp"] = "ex_wdm_turret";
	game["ex_wdm"]["saw_bipod_stand_mp"] = "ex_wdm_turret";
	game["ex_wdm"]["saw_grip_mp"] = "ex_wdm_saw";
	game["ex_wdm"]["saw_mp"] = "ex_wdm_saw";
	game["ex_wdm"]["saw_reflex_mp"] = "ex_wdm_saw";
	game["ex_wdm"]["skorpion_acog_mp"] = "ex_wdm_skorpion";
	game["ex_wdm"]["skorpion_mp"] = "ex_wdm_skorpion";
	game["ex_wdm"]["skorpion_reflex_mp"] = "ex_wdm_skorpion";
	game["ex_wdm"]["skorpion_silencer_mp"] = "ex_wdm_skorpion";
	game["ex_wdm"]["smoke_grenade_mp"] = "ex_wdm_smoke_grenade";
	game["ex_wdm"]["usp_mp"] = "ex_wdm_usp";
	game["ex_wdm"]["usp_silencer_mp"] = "ex_wdm_usp";
	game["ex_wdm"]["usp_acog_mp"] = "ex_wdm_usp";
	game["ex_wdm"]["uzi_acog_mp"] = "ex_wdm_uzi";
	game["ex_wdm"]["uzi_mp"] = "ex_wdm_uzi";
	game["ex_wdm"]["uzi_reflex_mp"] = "ex_wdm_uzi";
	game["ex_wdm"]["uzi_silencer_mp"] = "ex_wdm_uzi";
	game["ex_wdm"]["winchester1200_grip_mp"] = "ex_wdm_winchester";
	game["ex_wdm"]["winchester1200_mp"] = "ex_wdm_winchester";
	game["ex_wdm"]["winchester1200_reflex_mp"] = "ex_wdm_winchester";
}

precacheShaders()
{
	 // healthbar
	if(level.ex_healthbar)
	{
		precacheShader("progress_bar_fg");
		precacheShader("progress_bar_fill");
		precacheShader("hint_health");
	}
	
	// bullet holes
	if(level.ex_bulletholes)
		precacheShader("bullethit_glass");

	// firstaid or spawn protection
	if(level.ex_firstaid_self || level.ex_spawnprot)
		precacheShader("hint_health");

	// turret overheating
	if(level.ex_turretoverheat)
		precacheShader("hud_temperature_gauge");

	if(level.ex_campwarntime >= 1)
	{
		precacheShader("objpoint_radio");
		precacheShader("field_radio");
	}

	if(level.ex_livestats)
		precacheShader("hud_status_dead");
	
	if(level.ex_bodysearch)
		precacheShader( "hint_usable" );
		
	if(level.ex_bloodyscreen)
	{
		precacheShader("overlay_flesh_hit2");
		precacheShader("overlay_fleshitgib");
	}
	
	precacheShader( "compass_waypoint_target");
	precacheShader( "compassping_enemyfiring");
	precacheShader( "faction_128_sas" ); 
	precacheShader( "faction_128_usmc" ); 
	precacheShader( "faction_128_ussr" ); 
	precacheShader( "faction_128_arab" ); 
	precacheShader( "hud_ac130" );
	precacheShader( "compass_objpoint_ammo" );
	precacheShader( "hud_laser" );
	precacheShader( "white" );
	precacheShader( "hud_icon_minigun" );
	precacheShader( "red" );
	
	if(level.ex_planes)
	{
		precacheShader("black");
		precacheShader("black_glassv2");
		precacheShader("blackv3");
		precacheShader("brayas");
		precacheShader("brayboo");
		precacheShader("silver");
		precacheShader("blue_b");
		precacheShader("criss");
		precacheShader("fusder");
		precacheShader("fusizq");
		precacheShader("left");
		precacheShader("leftn");
		precacheShader("leftnc");
		precacheShader("migmorro");
		precacheShader("top2p");
		precacheShader("yellow_b");
	}
}

precacheModels()
{
	if(level.ex_firstaid_drop)
		PrecacheModel("com_x4_health_package1");

	PrecacheModel("shaneys_chute_i");
	PrecacheModel("projectile_slamraam_missile");
	PrecacheModel("weapon_ac130_projectile");
	PrecacheModel("projectile_rpg7");
	PrecacheModel("vehicle_mig29_desert");
	PrecacheModel("jokers_stealth");
	
	//PrecacheModel("vehicle_av8b_harrier_jet");
	
	PrecacheModel("vehicle_cobra_helicopter_fly");
	PrecacheModel("vehicle_mi24p_hind_desert");
	PrecacheModel("com_plasticcase_green_big");
	PrecacheModel("com_plasticcase_black_big");
	
	if(level.ex_planes) 
		PrecacheModel("mig");
		
	if(level.ex_artillery) 
		PrecacheModel("weapon_ac130_projectile");
	
	if(level.ex_planes)
	{
		PrecacheModel("vehicle_ac130_low");
		PrecacheModel("weapon_ac130_projectile");
	}
}

loadEffects()
{
	// fart
	level.ex_fartbomb = loadfx("extreme/fart_smoke");
	
	// blood pools
	level.ex_effect["bloodpool"] = loadfx("impacts/deathfx_bloodpool_ambush");
	
	//misc heli fx and plane fx
	level.fx_heli_afterburner = loadfx ("fire/jet_afterburner");
   	level.fx_heli_red_blink = loadfx ("misc/aircraft_light_red_blink");
	level.fx_heli_green_blink = loadfx ("misc/aircraft_light_green_blink");
	
	//napalm
	level.ex_effect["napalm_bomb"] = loadfx ("extreme/napalm");
	level.ex_effect["bodygroundfire"] = loadfx("fire/ground_fire_med_nosmoke");
	
	// ION
	level.ioncannonfx = loadfx ("ic/charge");
	level.ionlightningfx = loadfx ("ic/beam");
	
	// command monitor
	level.ex_blowthefag = loadfx("explosions/wall_explosion_pm_a");
	level.ex_effect["barrel"] = loadfx("props/barrelExp");
	level.ex_effect["bodyfire"] = loadfx("extreme/body_fire_oneshot");
	level.ex_effect["turretoverheat"] = loadfx("extreme/turret_overheat");
	
	if(level.ex_flares >= 1)
	{
		switch(level.ex_flare_type)
		{
			case 0:
				level.ex_effect["flare_ambient"] = loadfx("misc/flare_gun");  
				break;
			case 1:
				level.ex_effect["flare_ambient"] = loadfx("misc/flare_arialdrop_runner");
				
			break;
		}
	}
		
	// Atry
	if(level.ex_artillery)
	{
		// generic explosion effects
		level.ex_effect["explosion_beach"] = loadfx("explosions/grenadeExp_cliffblast"); //ok
		level.ex_effect["explosion_concrete"] = loadfx("explosions/grenadeExp_concrete"); //ok
		level.ex_effect["explosion_dirt"] = loadfx("explosions/grenadeExp_dirt"); //ok
		level.ex_effect["explosion_mud"] = loadfx("explosions/grenadeExp_mud"); //ok
		level.ex_effect["explosion_water"] = loadfx("explosions/grenadeExp_water"); //ok
		level.ex_effect["explosion_wood"] = loadfx("explosions/grenadeExp_wood"); //ok
		level.ex_effect["explosion_snow"] = loadfx("explosions/grenadeExp_snow"); //
		level.ex_effect["explosion_smoke"] = loadfx("smoke/flare_smoke"); //ok
		level.ex_effect["artillery"] = loadfx("explosions/grenadeExp_default"); //ok
		level.ex_effect["artillery"] = loadfx("explosions/artilleryExp_dirt_brown"); //ok
	}
	
	// flak
	if(level.ex_flakfx >=1 || level.ex_planes_flak)
	{
		// flak fx
		level.ex_effect["flak_smoke"] = loadfx("distortion/distortion_tank_muzzleflash"); //ok
		level.ex_effect["flak_flash"] = loadfx("explosions/default_explosion"); //ok
		level.ex_effect["flak_dust"] = loadfx("explosions/aa_explosion"); //ok
	}

	// tracers
	if(level.ex_tracers >= 1) level.ex_effect["tracer"] = loadfx("misc/antiair_runner"); //ok 
	
	// planes
	if(level.ex_planes)
	{
		level.ex_effect["plane_smoke"]			= loadfx("smoke/flare_smoke");
		level.ex_effect["plane_explosion"]		= loadfx("explosions/default_explosion");
		level.ex_effect["planecrash_fire"]		= loadfx("fire/ground_fire_med_nosmoke");
		level.ex_effect["planecrash_smoke"]		= loadfx("props/american_smoke_grenade_mp");
		level.ex_effect["planecrash_ball"]		= loadfx("fire/firelp_med_pm_nodistort");
		level.ex_effect["planecrash"]		= loadfx("explosions/default_explosion");
		level.ex_effect["planeblow"] = loadfx("explosions/helicopter_explosion_cobra");
	}
}