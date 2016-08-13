#include maps\mp\_utility;

init()
{
	level.clientTweakables = [];
	level.tweakablesInitialized = true;

	level.rules = [];
	level.gameTweaks = [];
	level.teamTweaks = [];
	level.playerTweaks = [];
	level.classTweaks = [];
	level.weaponTweaks = [];
	level.hardpointTweaks = [];
	level.hudTweaks = [];

	// commented out tweaks have not yet been implemented
	registerTweakable( "game", "playerwaittime", "scr_game_playerwaittime", 15 );
	registerTweakable( "game", "matchstarttime", "scr_game_matchstarttime", 5 );
	registerTweakable( "game", "onlyheadshots", "scr_game_onlyheadshots", 0 );
	registerTweakable( "game", "allowkillcam", "scr_game_allowkillcam", 1 );
	registerTweakable( "game", "spectatetype", "scr_game_spectatetype", 2 );
	registerTweakable( "game", "deathpointloss", "scr_game_deathpointloss", 0 );
	registerTweakable( "game", "suicidepointloss", "scr_game_suicidepointloss", 0 );

	//registerTweakable( "team", "respawntime", "scr_team_respawntime", 0 );
	registerTweakable( "team", "fftype", "scr_team_fftype", 0 );
	registerTweakable( "team", "teamkillpointloss", "scr_team_teamkillpointloss", 0 );
	registerTweakable( "team", "teamkillspawndelay", "scr_team_teamkillspawndelay", 0 );

	//registerTweakable( "player", "respawndelay", "scr_player_respawndelay", 0 );
	registerTweakable( "player", "maxhealth", "scr_player_maxhealth", 100 );
	registerTweakable( "player", "healthregentime", "scr_player_healthregentime", 5 );
	registerTweakable( "player", "forcerespawn", "scr_player_forcerespawn", 1 );

	registerTweakable( "weapon", "allowfrag", "scr_weapon_allowfrags", 1 );
	registerTweakable( "weapon", "allowsmoke", "scr_weapon_allowsmoke", 1 );
	registerTweakable( "weapon", "allowflash", "scr_weapon_allowflash", 1 );
	registerTweakable( "weapon", "allowc4", "scr_weapon_allowc4", 1 );
	registerTweakable( "weapon", "allowclaymores", "scr_weapon_allowclaymores", 1 );
	registerTweakable( "weapon", "allowrpgs", "scr_weapon_allowrpgs", 1 );
	registerTweakable( "weapon", "allowmines", "scr_weapon_allowmines", 1 );

	registerTweakable( "hardpoint", "allowuav", "scr_hardpoint_allowuav", 1 );
	registerTweakable( "hardpoint", "allowartillery", "scr_hardpoint_allowartillery", 1 );
	registerTweakable( "hardpoint", "allowairstrike", "scr_hardpoint_allowairstrike", 1 );
	registerTweakable( "hardpoint", "allowsentrygun", "scr_hardpoint_allowsentrygun", 1 );
	registerTweakable( "hardpoint", "allowhelicopter", "scr_hardpoint_allowhelicopter", 1 );
	registerTweakable( "hardpoint", "allownapalm", "scr_hardpoint_allownapalm", 1 );
	registerTweakable( "hardpoint", "allowstealth", "scr_hardpoint_allowstealth", 1 );
	registerTweakable( "hardpoint", "allowac130", "scr_hardpoint_allowac130", 1 );
	registerTweakable( "hardpoint", "allownuke", "scr_hardpoint_allownuke", 1 );

	setClientTweakable( "hud", "compass_objicons", "ui_compass_objicons", level.ex_compass_objicons );
	setClientTweakable( "hud", "compass_helicopter", "ui_compass_helicopter", level.ex_compass_helicopter );
	setClientTweakable( "hud", "compass_planes", "ui_compass_planes", level.ex_compass_planes );
	setClientTweakable( "hud", "compass_friendlyping", "ui_compass_friendlyping", level.ex_compass_friendlyping );
	setClientTweakable( "hud", "compass_playerping", "ui_compass_playerping", level.ex_compass_playerping );
	setClientTweakable( "hud", "compass_enemyping", "ui_compass_enemyping", level.ex_compass_enemyping );
	setClientTweakable( "hud", "compass_uavenemyping", "ui_compass_uavenemyping", level.ex_compass_uavenemyping );
	setClientTweakable( "hud", "compass_tacticalenemyping", "ui_compass_tacticalenemyping", level.ex_compass_tacticalenemyping );
	setClientTweakable( "hud", "compass_fsmenemyping", "ui_compass_fsmenemyping", level.ex_compass_fsmenemyping );

	setClientTweakable( "hud", "hud_lowhealth", "ui_hud_lowhealth", level.ex_hud_lowhealth );
	setClientTweakable( "hud", "hud_mantlehint", "ui_hud_mantlehint", level.ex_hud_mantlehint );
	setClientTweakable( "hud", "hud_cursorhint", "ui_hud_cursorhint", level.ex_hud_cursorhint );
	setClientTweakable( "hud", "hud_commandhint", "ui_hud_commandhint", level.ex_hud_commandhint );
	setClientTweakable( "hud", "hud_holdbreathhint", "ui_hud_holdbreathhint", level.ex_hud_holdbreathhint);
	setClientTweakable( "hud", "hud_stance", "ui_hud_stance", level.ex_hud_stance );
	setClientTweakable( "hud", "hud_localvoice", "ui_hud_localvoice", level.ex_hud_localvoice );
	setClientTweakable( "hud", "hud_remotevoice", "ui_hud_remotevoice", level.ex_hud_remotevoice );
	setClientTweakable( "hud", "hud_obituaries", "ui_hud_obituaries", level.ex_hud_obituaries);

	level thread updateUITweakables();
}


getTweakableDVarValue( category, name )
{
	switch( category )
	{
		case "rule":
			dVar = level.rules[name].dVar;
			break;
		case "game":
			dVar = level.gameTweaks[name].dVar;
			break;
		case "team":
			dVar = level.teamTweaks[name].dVar;
			break;
		case "player":
			dVar = level.playerTweaks[name].dVar;
			break;
		case "class":
			dVar = level.classTweaks[name].dVar;
			break;
		case "weapon":
			dVar = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			dVar = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			dVar = level.hudTweaks[name].dVar;
			break;
		default:
			dVar = undefined;
			break;
	}
	
	assert( isDefined( dVar ) );
	
	value = getDvarInt( dVar );
	
	return value;
}


getTweakableDVar( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].dVar;
			break;
		case "game":
			value = level.gameTweaks[name].dVar;
			break;
		case "team":
			value = level.teamTweaks[name].dVar;
			break;
		case "player":
			value = level.playerTweaks[name].dVar;
			break;
		case "class":
			value = level.classTweaks[name].dVar;
			break;
		case "weapon":
			value = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			value = level.hudTweaks[name].dVar;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


getTweakableValue( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].value;
			break;
		case "game":
			value = level.gameTweaks[name].value;
			break;
		case "team":
			value = level.teamTweaks[name].value;
			break;
		case "player":
			value = level.playerTweaks[name].value;
			break;
		case "class":
			value = level.classTweaks[name].value;
			break;
		case "weapon":
			value = level.weaponTweaks[name].value;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].value;
			break;
		case "hud":
			value = level.hudTweaks[name].value;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


getTweakableLastValue( category, name )
{
	switch( category )
	{
		case "rule":
			value = level.rules[name].lastValue;
			break;
		case "game":
			value = level.gameTweaks[name].lastValue;
			break;
		case "team":
			value = level.teamTweaks[name].lastValue;
			break;
		case "player":
			value = level.playerTweaks[name].lastValue;
			break;
		case "class":
			value = level.classTweaks[name].lastValue;
			break;
		case "weapon":
			value = level.weaponTweaks[name].lastValue;
			break;
		case "hardpoint":
			value = level.hardpointTweaks[name].lastValue;
			break;
		case "hud":
			value = level.hudTweaks[name].lastValue;
			break;
		default:
			value = undefined;
			break;
	}
	
	assert( isDefined( value ) );
	return value;
}


setTweakableValue( category, name, value )
{
	switch( category )
	{
		case "rule":
			dVar = level.rules[name].dVar;
			break;
		case "game":
			dVar = level.gameTweaks[name].dVar;
			break;
		case "team":
			dVar = level.teamTweaks[name].dVar;
			break;
		case "player":
			dVar = level.playerTweaks[name].dVar;
			break;
		case "class":
			dVar = level.classTweaks[name].dVar;
			break;
		case "weapon":
			dVar = level.weaponTweaks[name].dVar;
			break;
		case "hardpoint":
			dVar = level.hardpointTweaks[name].dVar;
			break;
		case "hud":
			dVar = level.hudTweaks[name].dVar;
			break;
		default:
			dVar = undefined;
			break;
	}
	
	setDvar( dVar, value );
}


setTweakableLastValue( category, name, value )
{
	switch( category )
	{
		case "rule":
			level.rules[name].lastValue = value;
			break;
		case "game":
			level.gameTweaks[name].lastValue = value;
			break;
		case "team":
			level.teamTweaks[name].lastValue = value;
			break;
		case "player":
			level.playerTweaks[name].lastValue = value;
			break;
		case "class":
			level.classTweaks[name].lastValue = value;
			break;
		case "weapon":
			level.weaponTweaks[name].lastValue = value;
			break;
		case "hardpoint":
			level.hardpointTweaks[name].lastValue = value;
			break;
		case "hud":
			level.hudTweaks[name].lastValue = value;
			break;
		default:
			break;
	}
}


registerTweakable( category, name, dvar, value )
{
	if ( isString( value ) )
	{
		if( getDvar( dvar ) == "" )
			setDvar( dvar, value );
		else
			value = getDvar( dvar );
	}
	else
	{
		if( getDvar( dvar ) == "" )
			setDvar( dvar, value );
		else
			value = getDvarInt( dvar );
	}

	switch( category )
	{
		case "rule":
			if ( !isDefined( level.rules[name] ) )
				level.rules[name] = spawnStruct();				
			level.rules[name].value = value;
			level.rules[name].lastValue = value;
			level.rules[name].dVar = dvar;
			break;
		case "game":
			if ( !isDefined( level.gameTweaks[name] ) )
				level.gameTweaks[name] = spawnStruct();
			level.gameTweaks[name].value = value;
			level.gameTweaks[name].lastValue = value;			
			level.gameTweaks[name].dVar = dvar;
			break;
		case "team":
			if ( !isDefined( level.teamTweaks[name] ) )
				level.teamTweaks[name] = spawnStruct();
			level.teamTweaks[name].value = value;
			level.teamTweaks[name].lastValue = value;			
			level.teamTweaks[name].dVar = dvar;
			break;
		case "player":
			if ( !isDefined( level.playerTweaks[name] ) )
				level.playerTweaks[name] = spawnStruct();
			level.playerTweaks[name].value = value;
			level.playerTweaks[name].lastValue = value;			
			level.playerTweaks[name].dVar = dvar;
			break;
		case "class":
			if ( !isDefined( level.classTweaks[name] ) )
				level.classTweaks[name] = spawnStruct();
			level.classTweaks[name].value = value;
			level.classTweaks[name].lastValue = value;			
			level.classTweaks[name].dVar = dvar;
			break;
		case "weapon":
			if ( !isDefined( level.weaponTweaks[name] ) )
				level.weaponTweaks[name] = spawnStruct();
			level.weaponTweaks[name].value = value;
			level.weaponTweaks[name].lastValue = value;			
			level.weaponTweaks[name].dVar = dvar;
			break;
		case "hardpoint":
			if ( !isDefined( level.hardpointTweaks[name] ) )
				level.hardpointTweaks[name] = spawnStruct();
			level.hardpointTweaks[name].value = value;
			level.hardpointTweaks[name].lastValue = value;			
			level.hardpointTweaks[name].dVar = dvar;
			break;
		case "hud":
			if ( !isDefined( level.hudTweaks[name] ) )
				level.hudTweaks[name] = spawnStruct();
			level.hudTweaks[name].value = value;
			level.hudTweaks[name].lastValue = -1; //X4: To make sure it inits the client
			level.hudTweaks[name].dVar = dvar;
			break;
	}
}


setClientTweakable( category, name, dvar, value )
{
	registerTweakable( category, name, dvar, value );
	level.clientTweakables[level.clientTweakables.size] = name;
}


updateUITweakables()
{
	for ( ;; )
	{
		for ( index = 0; index < level.clientTweakables.size; index++ )
		{
			clientTweakable = level.clientTweakables[index];
			curValue = getTweakableDVarValue( "hud", clientTweakable );
			lastValue = getTweakableLastValue( "hud", clientTweakable );

			if ( curValue != lastValue )
			{
				updateServerDvar( getTweakableDvar( "hud", clientTweakable ), curValue );
				setTweakableLastValue( "hud", clientTweakable, curValue );
			}
		}
			
		wait ( 1.0 );
	}
}


updateServerDvar( dvar, value )
{
	makeDVarServerInfo( dvar, value );
}
