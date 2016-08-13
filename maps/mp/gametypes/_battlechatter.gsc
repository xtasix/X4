#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precachemenu( "walrus" );
	if ( game["allies"] == "sas" )
		level.teamPrefix["allies"] = "UK_1";
	else
		level.teamPrefix["allies"] = "US_1";

	if ( game["axis"] == "russian" )
		level.teamPrefix["axis"] = "RU_1";
	else
		level.teamPrefix["axis"] = "AB_1";
	
	level.isTeamSpeaking["allies"] = false;
	level.isTeamSpeaking["axis"] = false;
	
	level.speakers["allies"] = [];
	level.speakers["axis"] = [];
	
	level.bcSounds = [];
	level.bcSounds["reload"] = "inform_reloading_generic";
	level.bcSounds["frag_out"] = "inform_attack_grenade";
	level.bcSounds["flash_out"] = "inform_attack_flashbang";
	level.bcSounds["smoke_out"] = "inform_attack_smoke";
	level.bcSounds["conc_out"] = "inform_attack_stun";
	level.bcSounds["c4_plant"] = "inform_attack_thwc4";
	level.bcSounds["claymore_plant"] = "inform_plant_claymore";
	level.bcSounds["kill"] = "inform_killfirm_infantry";
	level.bcSounds["casualty"] = "inform_casualty_generic";

	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	if((getDvar("music_radio") == "") || (getDvar("music_radio") != "0") && (getDvar("music_radio") != "1"))
		setDvar("music_radio", "0");
	level.radio = getDvarint("music_radio");
	if(level.radio == 1)
		level.radio = true;
	else
		level.radio = false;
	if(level.radio)
		thread radio();
	dvar1 = getDvar("music1");
	dvar2 = getDvar("music2");
	dvar3 = getDvar("music3");
	dvar4 = getDvar("music4");
	dvar5 = getDvar("music5");
	dvar6 = getDvar("music6");
	dvar7 = getDvar("music7");
	dvar8 = getDvar("music8");
	dvar9 = getDvar("music9");
	dvar10 = getDvar("music10");
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		if(!level.radio)
			player thread music();
		player setclientdvar("music1", dvar1 );
		player setclientdvar("music2", dvar2 );
		player setclientdvar("music3", dvar3 );
		player setclientdvar("music4", dvar4 );
		player setclientdvar("music5", dvar5 );
		player setclientdvar("music6", dvar6 );
		player setclientdvar("music7", dvar7 );
		player setclientdvar("music8", dvar8 );
		player setclientdvar("music9", dvar9 );
		player setclientdvar("music10", dvar10 );
		player.songplaying = "1337h4x";
	}
}


onJoinedTeam()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_team" );
	}
}


onJoinedSpectators()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_spectators" );
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
		
		// help players be stealthy in splitscreen by not announcing their intentions
		if ( level.splitscreen )
			continue;
		
		self thread claymoreTracking();
		self thread reloadTracking();
		self thread grenadeTracking();
	}
}


claymoreTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	while(1)
	{
		self waittill( "begin_firing" );
		weaponName = self getCurrentWeapon();
		if ( weaponName == "claymore_mp" )
			level thread sayLocalSound( self, "claymore_plant" );
	}
}


reloadTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	for( ;; )
	{
		self waittill ( "reload_start" );
		level thread sayLocalSound( self, "reload" );
	}
}


grenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	for( ;; )
	{
		self waittill ( "grenade_fire", grenade, weaponName );
		
		if ( weaponName == "frag_grenade_mp" )
			level thread sayLocalSound( self, "frag_out" );
		else if ( weaponName == "flash_grenade_mp" )
			level thread sayLocalSound( self, "flash_out" );
		else if ( weaponName == "concussion_grenade_mp" )
			level thread sayLocalSound( self, "conc_out" );
		else if ( weaponName == "smoke_grenade_mp" )
			level thread sayLocalSound( self, "smoke_out" );
		else if ( weaponName == "c4_mp" )
			level thread sayLocalSound( self, "c4_plant" );
	}
}


sayLocalSoundDelayed( player, soundType, delay )
{
	player endon ( "death" );
	player endon ( "disconnect" );
	
	wait ( delay );
	
	sayLocalSound( player, soundType );
}


sayLocalSound( player, soundType )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	if ( isSpeakerInRange( player ) )
		return;
		
	if( player.pers["team"] != "spectator" )
	{
		soundAlias = level.teamPrefix[player.pers["team"]] + "_" + level.bcSounds[soundType];
		player thread doSound( soundAlias );
	}
}


doSound( soundAlias )
{
	team = self.pers["team"];
	level addSpeaker( self, team );
	self playsoundToTeam( soundAlias, team, self );
	self thread timeHack( soundAlias ); // workaround because soundalias notify isn't happening
	self waittill_any( soundAlias, "death", "disconnect" );
	level removeSpeaker( self, team );
}


timeHack( soundAlias )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	wait ( 2.0 );
	self notify ( soundAlias );
}


isSpeakerInRange( player )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	distSq = 1000 * 1000;

	// to prevent player switch to spectator after throwing a granade causing damage to someone and result in attacker.pers["team"] = "spectator"
	if( isdefined( player ) && isdefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
	{
		for ( index = 0; index < level.speakers[player.pers["team"]].size; index++ )
		{
			teammate = level.speakers[player.pers["team"]][index];
			if ( teammate == player )
				return true;
				
			if ( distancesquared( teammate.origin, player.origin ) < distSq )
				return true;
		}
	}

	return false;
}


addSpeaker( player, team )
{
	level.speakers[team][level.speakers[team].size] = player;
}


// this is lazy... fix up later by tracking ID's and doing array slot swapping
removeSpeaker( player, team )
{
	newSpeakers = [];
	for ( index = 0; index < level.speakers[team].size; index++ )
	{
		if ( level.speakers[team][index] == player )
			continue;
			
		newSpeakers[newSpeakers.size] = level.speakers[team][index]; 
	}
	
	level.speakers[team] = newSpeakers;
}
meleeftl()
{
	while(1)
	{
		self waittill("meleebuttonpressed");
//		waittillframeend;
		self PlayLocalSound( self.songplaying );
	}
}
nade1ftl()
{
	while(1)
	{
		self waittill("fragbuttonpressed");
//		waittillframeend;
		self PlayLocalSound( self.songplaying );
	}
}
nade2ftl()
{
	while(1)
	{
		self waittill("specbuttonpressed");
//		waittillframeend;
		self PlayLocalSound( self.songplaying );
	}
}
music()
{
	self endon( "disconnect" );
	while(1)
	{
		self waittill( "menuresponse", menu, response);
		response = response + getDvar("music_volume");
		if( menu == "walrus" )
		{
			announcement("tis music");
			if(response != self.songplaying )
			{
				self StopLocalSound( self.songplaying );
				self iprintlnbold("stopping sound" );
			}
			if( SoundExists( response ) && ( response != self.songplaying ))
			{
//					response = response + getDvar("music_volume");
					allclientsprint(response);
				self PlayLocalSound( response );
			}
				else
					allclientsprint(response + " did not exist");
			self.songplaying = response;
		}
	}
}
cheese()
{
	self endon("disconnect");
	while(1)
	{
		if(self usebuttonpressed() )
		{
//			self notify("usebuttonpressed");
			self thread checkhold();
		}
		else
			self notify("usebuttonnotpressed");
		wait 0.05;
	}
}
mylinkto( ent )
{
	while(1)
	{
		lulz = anglestoforward( ent.angles );
		lulz = lulz * 10;
		self.origin = ent geteye() + lulz;
		self.angles = ent.angles;
		wait 0.000001;
		//sound,musicmod,,all_mp
	}
}
checkhold()
{
	self endon("usebuttonnotpressed");
	for(j=0;j<30;j++)
		wait 0.05;
	self notify("usebuttonpressedhold");
}
radio()//IMPORTANT!!! CHANGE THE TIMES OF THE SONGS IF U CHANGE THE SONGS HERE!
{//CUT 1 TENTHS OF A SECOND OFF THE TIMING 0.1 so thers no potental infinite loop gay error
	level endon("game_ended");
//	wait 15;
	elephant = spawn("script_origin", (0,0,50));
	while(1)
	{		
		AmbientPlay( "advert" );
		waitminute( 0.2 );
		l = randomint( getdvarint( "music_songs" ));
		volume = getdvarint( "music_volume" );
		j = tostring( volume );
		l = tostring( l );
		music = "zmusic" + l;
		music2 = "zmusic" + l + j;
		switch( music )
		{
			case "zmusic1":
				AmbientPlay( music2 );
				waitminute( getdvarint("music1_time") );
				break;
			case "zmusic2":
				AmbientPlay( music2 );
				waitminute( getdvarint("music2_time") );
				break;
			case "zmusic3":
				AmbientPlay( music2 );
				waitminute( getdvarint("music3_time") );
				break;
			case "zmusic4":
				AmbientPlay( music2 );
				waitminute( getdvarint("music4_time") );
				break;
			case "zmusic5":
				AmbientPlay( music2 );
				waitminute( getdvarint("music5_time") );
				break;
			case "zmusic6":
				AmbientPlay( music2 );
				waitminute( getdvarint("music6_time") );
				break;
			case "zmusic7":
				AmbientPlay( music2 );
				waitminute( getdvarint("music7_time") );
				break;
			case "zmusic8":
				AmbientPlay( music2 );
				waitminute( getdvarint("music8_time") );
				break;
			case "zmusic9":
				AmbientPlay( music2 );
				waitminute( getdvarint("music9_time") );
				break;
			case "zmusic10":
				AmbientPlay( music2 );
				waitminute( getdvarint("music1_time") );
				break;
		}
	}
}
waitminute( time )
{
	wait time * 60;
}
tostring( var )
{
	setdvar("temp", var );
	string = getDvar("temp");
	return string;
}