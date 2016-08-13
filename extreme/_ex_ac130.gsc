#include maps\mp\_utility;

init()
{
	precacheModel("c130_zoomrig");
	precacheModel("vehicle_ac130_low");
	precacheShader("ac130_overlay_25mm");
	precacheShader("ac130_overlay_40mm");
	precacheShader("ac130_overlay_105mm");
	precacheShader("ac130_overlay_grain");
	precacheShader("hudStopwatch"); 
	precacheShader( "black" );
	precacheItem("ac130_25mm_mp");
	precacheItem("ac130_40mm_mp");
	precacheItem("ac130_105mm_mp");

	level.physicsSphereRadius["ac130_25mm_mp"] = 200;
	level.physicsSphereRadius["ac130_40mm_mp"] = 600;
	level.physicsSphereRadius["ac130_105mm_mp"] = 1000;
	level.physicsSphereForce["ac130_25mm_mp"] = 0.5;
	level.physicsSphereForce["ac130_40mm_mp"] = 3.0;
	level.physicsSphereForce["ac130_105mm_mp"] = 6.0;
	level.ac130_rotationSpeed = 40;
}

main()
{
	ac130Origin = level.ex_playArea_Centre;
	ac130Origin = getAboveBuildingsLocation(ac130Origin);   

	level.ac130 = spawn("script_model", ac130Origin);
	level.ac130 setModel("c130_zoomrig");
	level.ac130.angles = (0,75,0);
	level.ac130 hide();
   
	level.ac130model = spawn("script_model", ac130Origin);
	level.ac130model setModel("vehicle_ac130_low");
	level.ac130.angles = (0,75,0);
	level.ac130model linkTo(level.ac130, "tag_player", (000,0,0), (0,0,0));
	level.ac130model hide();   
   
	thread rotatePlane(true);
}

getAboveBuildingsLocation(location)
{
	trace = bullettrace(location + (0,0,10000), location, false, undefined);
	startorigin = trace["position"] + (0,0,-514);
   
	zpos = 0;
   
	maxxpos = 13; maxypos = 13;
	for (xpos = 0; xpos < maxxpos; xpos++)
	{
		for (ypos = 0; ypos < maxypos; ypos++)
		{
			thisstartorigin = startorigin + ((xpos/(maxxpos-1) - .5) * 1024, (ypos/(maxypos-1) - .5) * 1024, 0);
			thisorigin = bullettrace(thisstartorigin, thisstartorigin + (0,0,-10000), false, undefined);
			zpos += thisorigin["position"][2];
		}
	}

	zpos = zpos / (maxxpos*maxypos);
	zpos = zpos + 1000;
   
	return (location[0], location[1], zpos);
}

rotatePlane(toggle)
{
	level notify("stop_rotatePlane_thread");
	level endon("stop_rotatePlane_thread");
   
	if(toggle)
	{
		for(;;)
		{
			level.ac130 rotateyaw( 360, level.ac130_rotationSpeed );
			wait level.ac130_rotationSpeed;
		}
	}
	else level.ac130 rotateyaw( level.ac130.angles[2], 0.05 );
}

ac130_attachPlayer()
{
	self endon("end_respawn");
	self endon("spawn");
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("death");
   
	if(level.inPrematchPeriod) return;
	if(isDefined(level.ac130Player)) return;
   
	self hide();
	level.ac130model show();
   
	level.ac130Player = self;
	level.ac130Player.ac130 = true;
	level.ac130Player hide();
	level.ac130Player.ex_invulnerable = true;
   
	self [[level.ex_clientcmd]]("gocrouch");
	level.ac130Player linkTo(level.ac130, "tag_player", (4000,0,0), (0,0,0));
	
	thread changeWeapons();
}

ac130_attachPlayer_go()
{
	self endon("end_respawn");
	self endon("spawn");
	level endon("ex_gameover");
	level endon("disconnect");
	self endon("disconnect");
	self endon("death");
	self endon("ex_dead");
	self endon("joined_spectators");
	
	if(level.inPrematchPeriod) return;
	if(isDefined(level.ac130Player)) return;
   
   	level.ac130Player = self;
	level.ac130Player.ac130 = true;
	level.ac130Player hide();

	level.ac130Player setClientDvar( "ui_hud_hardcore", 1 ); 

	//Record weapons and ammo before we take them away.
	ammoClipList = [];
	ammoStockList = [];
	weaponsList = self GetWeaponsList();
	  
	for (i = 0; i < weaponsList.size; i++)
	{
	ammoClipList[ammoClipList.size] = self GetWeaponAmmoClip( weaponsList[i] );
	ammoStockList[ammoStockList.size] = self GetWeaponAmmoStock( weaponsList[i] );
	}
   
	originalHealth = self.health;
   
	level.ac130model show(); 

 	self SetActionSlot( 3, "" ); 
   
	self thread CleanUp_AC130();

	level.ac130Player.health = 999999;

		team = self.pers["team"];
		otherTeam = level.otherTeam[team];

		maps\mp\gametypes\_globallogic::leaderDialog( "ac130_friendly", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "ac130_enemy", level.otherTeam[team] );	
	   
	self [[level.ex_clientcmd]]("gocrouch");
	level.ac130Player linkTo(level.ac130, "tag_player", (4000,0,0), (0,0,0));
	self hide();
   
	if(level.ex_ac130_hud) level.ac130Player thread ac130_hud();  

	thread changeWeapons();
   
	if(level.ex_air_raid_global) thread extreme\_ex_utils::playSoundLoc("air_raid",(0,0,0));
	if(level.ex_air_raid_team) thread extreme\_ex_utils::playSoundOnPlayers("air_raid",(0,0,0));
   
	self iprintlnbold("You have " + level.ex_ac130_timer + " Seconds");
	iprintln("^3AC130 GUNSHIP INBOUND ^1TAKE COVER!");

	if(level.ex_ac130_sound) self thread playac130Sound();
 
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(players[i] != self)
			players[i] thread maps\mp\gametypes\_hud_message::oldnotifyMessage( self.name + " ^2 IS IN THE\n AC130 GUNSHIP!!");
	} 
	  
	if(!isDefined(self.ex_watch))
	{
		self.ex_watch = newClientHudElem(self);
		self.ex_watch.x = -190;   
		self.ex_watch.y = -5; 
		self.ex_watch.alignx = "right"; 
		self.ex_watch.aligny = "bottom";
		self.ex_watch.horzAlign = "right"; 
		self.ex_watch.vertAlign = "bottom";
		self.ex_watch.alpha = .9; 
		self.ex_watch.fontScale = 2; 
		self.ex_watch.sort = 100; 
		self.ex_watch.foreground = true; 
		self.ex_watch setClock( level.ex_ac130_timer, 60, "hudStopwatch", 60, 60);
	}

  	wait level.ex_ac130_timer;

  	if(isDefined(self.ex_watch)) self.ex_watch destroy();

	level.ac130Player unlink();
	level.ac130model hide();   

	thread ac130_detachPlayer();
   
	self resetWeapons(weaponsList, ammoClipList, ammoStockList);
	self.health = originalHealth;

  	self thread maps\mp\gametypes\_hardpoints::hardpointItemWaiter();
 	self thread maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem(); 

	self show();
}

ac130_detachPlayer()
{
	self endon("end_respawn");
	self endon("spawn");
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("death");
	self endon("ex_dead");
	self endon("joined_spectators"); 
	self endon( "darkScreenOverlay" );

	if(!isDefined(level.ac130Player)) return;
	
	level.ac130Player notify("ac130_detached");
	
	self thread CleanupSpawned();

	level.ac130Player setClientDvar( "cg_fov", 65 );
  	level.ac130Player setClientDvar( "ui_hud_hardcore", 0 );
	level.ac130Player setClientDvar( "cg_fovscale", 1.0 );


	if(level.ex_ac130_sound) 
	{
		self thread stopac130Sound(); 
	}
	if(level.ex_ac130_hud) 
	{
		level.ac130Player thread ac130_hudOff();
	}
	
	self show();

  	level.ac130Player setClientDvar( "ui_hud_hardcore", 0 );
	level.ac130Player setClientDvar( "cg_fov", 65 );
	level.ac130Player setClientDvar( "cg_fovscale", 1.0 );
	

	level.ac130Player unlink();
	level.ac130model hide();   
	[[level.onSpawnPlayer]]();
	
	if(level.hardcoreMode)
	{
		self setClientDvar( "ui_hud_hardcore", 1 );	
	}
	
	if(level.ex_hudstats) self thread extreme\_ex_hudstats::main(); 
	if(level.ex_healthbar) self thread extreme\_ex_healthbar::start(); 
	self thread extreme\_ex_firstaid::start(); 
	if(level.ex_logo) self thread extreme\_ex_logo::init(); 
	if(level.ex_laserdot) self thread extreme\_ex_laserdot::start();

	level.ac130Player.ex_invulnerable = false; 
		
	level.ac130Player.ac130 = undefined;
	level.ac130Player = undefined;
	
	self show();
}

changeWeapons()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("death");
	self endon("ac130_detached");

	weapon = [];
   
	weapon[0] = spawnstruct();
	weapon[0].weapon = "ac130_25mm_mp"; 
	weapon[0].fov = "65";
	weapon[0].fovscale = "0.7";
	weapon[0].settext = "25mm";
	weapon[0].overlay = "ac130_overlay_25mm";

	weapon[1] = spawnstruct();
	weapon[1].weapon = "ac130_40mm_mp";
	weapon[1].fov = "70";
	weapon[1].fovscale = "0.75";
	weapon[1].settext = "40mm"; 
	weapon[1].overlay = "ac130_overlay_40mm";
	  
	weapon[2] = spawnstruct();
	weapon[2].weapon = "ac130_105mm_mp";
	weapon[2].fov = "80";
	weapon[2].fovscale = "0.8";
	weapon[2].settext = "105mm";
	weapon[2].overlay = "ac130_overlay_105mm";
   
	currentWeapon = -1;

	for(;;)
	{
		if(currentWeapon != -1)
				while(!level.ac130Player useButtonPressed()) wait 0.05;
	   
		currentWeapon++;
		if (currentWeapon >= weapon.size) currentWeapon = 0;
		level.currentWeapon = setWepText(weapon[currentWeapon].settext);
   
		level.ac130Player takeAllWeapons();
		level.ac130Player giveWeapon( weapon[currentWeapon].weapon );	  
		level.ac130Player setClientDvar( "cg_fov", weapon[currentWeapon].fov );
		level.ac130Player setClientDvar( "cg_fovscale", weapon[currentWeapon].fovscale );
		level.ac130Player switchToWeapon( weapon[currentWeapon].weapon );
		level.ac130Player SetWeaponAmmoClip( weapon[currentWeapon].weapon, 999 ); 
		self thread setOverlay(weapon[currentWeapon].overlay);
		level.ac130Player thread screenshakeblackscreen();

		level.ac130Player PlayLocalSound( "weap_rpg_twist_plr" );   
		while(level.ac130Player useButtonPressed()) wait 0.05;
	}
}

setOverlay(overlay)
{
	level endon("ex_gameover");
	self endon("end_respawn");
	self endon("spawn");
	self endon("disconnect");
	self endon("death");
	self endon("ac130_detached");
   
	if(!isDefined(self.ac130_overlay))
	{
		self.ac130_overlay = newClientHudElem( self );
		self.ac130_overlay.x = 0;
		self.ac130_overlay.y = 0;
		self.ac130_overlay.alignX = "center";
		self.ac130_overlay.alignY = "middle";
		self.ac130_overlay.horzAlign = "center";
		self.ac130_overlay.vertAlign = "middle";
		self.ac130_overlay.foreground = true;
	}
	self.ac130_overlay setshader(overlay, 640, 480);

	if(level.ex_ac130grain)
	{
		if(!isDefined(self.ac130_grain))
		{
			self.ac130_grain = newClientHudElem( self );
			self.ac130_grain.x = 0;
			self.ac130_grain.y = 0;
			self.ac130_grain.alignX = "left";
			self.ac130_grain.alignY = "top";
			self.ac130_grain.horzAlign = "fullscreen";
			self.ac130_grain.vertAlign = "fullscreen";
			self.ac130_grain.foreground = true;
			self.ac130_grain.alpha = 0.5;
		}
		self.ac130_grain setshader("ac130_overlay_grain", 640, 480);
	}
	self waittill("useButtonPressed"); 

	self.ac130_overlay destroy();
	self.ac130_grain destroy();
}

setWepText(settext)
{
	level endon("ex_gameover");
	self endon("end_respawn");
	self endon("spawn");
	self endon("disconnect");
	self endon("death");
	self endon("ac130_detached");
   
	if(!isDefined(self.ac130_weptext)) 
	{
		self.ac130_weptext = newClientHudElem( self );
		self.ac130_weptext.x = 0;
		self.ac130_weptext.y = 0;
		self.ac130_weptext.alignX = "left";
		self.ac130_weptext.alignY = "bottom";
		self.ac130_weptext.horzAlign = "left";
		self.ac130_weptext.vertAlign = "bottom";
		self.ac130_weptext.foreground = true;
		self.ac130_weptext.glowColor = (0.2, 0.3, 0.7);
		self.ac130_weptext.glowAlpha = 1;
	}
	self.ac130_weptext settext(settext, 256, 256);
}

screenshakeblackscreen()
{
   level endon("ex_gameover");
   self endon("disconnect");
   self endon("death");
   self endon("ac130_detached");

   for(;;)
   {
	  level.ac130Player waittill("projectile_impact", weapon, position, radius);

	  thread shotFiredScreenShake( weapon );
	  thread shotFiredPhysicsSphere(position, weapon);
	  wait 0.05;
   }
}

shotFiredScreenShake(weapon)
{
   level endon("ex_gameover");
   self endon("disconnect");
   self endon("death");
   self endon("ac130_detached");

   switch(weapon)
   {
	  case "ac130_105mm_mp":
		 duration = 0.2;
		 break;
	  case "ac130_40mm_mp":
		 duration = 0.1;
		 break;
	  default:
		 duration = 0;
		 break;
	}
	if(duration) earthquake(duration, 1, level.ac130Player.origin, 1000);

	if(level.ex_ac130_shotFiredDarkScreen) 
	{
   	if(duration) level.ac130Player thread shotFiredDarkScreenOverlay();
	}
}

shotFiredPhysicsSphere(center, weapon)
{
	wait 0.1;
	physicsExplosionSphere(center, level.physicsSphereRadius[weapon], level.physicsSphereRadius[weapon] / 2, level.physicsSphereForce[weapon]);
}

CleanupSpawned()
{
	if (isDefined(self.ac130_overlay)) self.ac130_overlay destroy();
	if (isDefined(self.ac130_weptext)) self.ac130_weptext destroy();
	if (isDefined(self.ac130_grain)) self.ac130_grain destroy();
}

CleanUp_AC130()
{
	if(isDefined(level.ex_mapannouncer)) level.ex_mapannouncer destroy();
	if(isDefined(self.hud_statsscore)) self.hud_statsscore destroy(); 
	if(isDefined(self.hud_statshead)) self.hud_statshead destroy();
	if(isDefined(self.hud_statsknife)) self.hud_statsknife destroy();
	if(isDefined(self.hud_statsnade)) self.hud_statsnade destroy(); 
	if(isDefined(self.hud_statskill)) self.hud_statskill destroy(); 
	if(isDefined(self.hud_statsdeath)) self.hud_statsdeath destroy();
	if(isDefined(self.hud_statskd)) self.hud_statskd destroy(); 
	if(isDefined(self.ex_healthbar)) self.ex_healthbar destroy();
	if(isDefined(self.ex_healthback)) self.ex_healthback destroy();
	if(isDefined(self.ex_healthcross)) self.ex_healthcross destroy();  
	if(isDefined(self.ex_firstaidicon)) self.ex_firstaidicon destroy(); 
	if(isDefined(self.ex_firstaidval)) self.ex_firstaidval destroy();
	if(isDefined(level.logo_img)) level.logo_img destroy();
	if(isDefined(level.ex_alliesicon)) level.ex_alliesicon destroy();
	if(isDefined(level.ex_alliesnumber)) level.ex_alliesnumber destroy();
	if(isDefined(level.ex_axisicon)) level.ex_axisicon destroy();
	if(isDefined(level.ex_axisnumber)) level.ex_axisnumber destroy();
	if(isDefined(level.ex_deadalliesicon)) level.ex_deadalliesicon destroy();
	if(isDefined(level.ex_deadalliesnumber)) level.ex_deadalliesnumber destroy();
	if(isDefined(level.ex_deadaxisicon)) level.ex_deadaxisicon destroy();
	if(isDefined(level.ex_deadaxisnumber)) level.ex_deadaxisnumber destroy();
	if(isDefined(self .ex_hudstats)) self.hud_stats destroy();
	if(isDefined(self.ex_laserdot)) self.ex_laserdot destroy();
	if(isDefined(self.ex_hudstats)) self.ex_hudstats destroy(); 
}

resetWeapons(weaponsList, ammoClipList, ammoStockList) 
{
	useAltMode = true;
	
	self AC130spawnclass();
	
	if ( getDvarInt( "scr_enable_nightvision" ) )
		self setActionSlot( 1, "nightvision" );
	  
	for( i = 0; i < weaponsList.size; i++ )
	{
		if(!AC130Weapons(weaponsList[i]))
		{
			self giveWeapon( weaponsList[i] );
		}
	  
		if( isPrimaryWeapon (weaponsList[i]) && WeaponType( weaponsList[i] ) == "bullet" )
		{
			self setSpawnWeapon( weaponsList[i] );
		}
	  
		switch ( weaponsList[i]) 
		{
			case "frag_grenade_mp":
			self switchToOffhand( "frag_grenade_mp" );
			break;
			case "flash_grenade_mp":
			self setOffhandSecondaryClass("flash");
			break;
			case "smoke_grenade_mp":
			case "concussion_grenade_mp":
			self setOffhandSecondaryClass("smoke");
			break;
		}
	  
		switch ( weaponsList[i] ) 
		{
			case "claymore_mp":
			case "rpg_mp":
			case "c4_mp":
			self maps\mp\gametypes\_class::setWeaponAmmoOverall( weaponsList[i], ammoClipList[i] );
			self setActionSlot( 3, "weapon", weaponsList[i] );
			self setActionSlot( 4, "" );
			useAltMode = false;
			break;
			default:
			self setWeaponAmmoClip( weaponsList[i], ammoClipList[i] );
			self setWeaponAmmoStock( weaponsList[i], ammoStockList[i] );
			break;
		}
	}
	
	if ( useAltMode ) 
	{
		self setActionSlot( 3, "altMode" );
		self setActionSlot( 4, "" );
	}

}

AC130spawnclass(team, class)
{
	self thread maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] ); 
	self thread maps\mp\gametypes\_class::cac_selector();
}

AC130Weapons(weapon)
{
	switch(weapon)
	{
		case "ac130_25mm_mp":
		case "ac130_40mm_mp":
		case "ac130_105mm_mp":
		return true;
		default:
		return false;
	}
}

isPrimaryWeapon( weaponname )
{
	return isdefined( level.primary_weapon_array[weaponname] );
} 

ac130_hud() 
{
	level endon("ex_gameover");
	self endon("end_respawn");
	self endon("spawn");
	self endon("disconnect");
	self endon("death");
	self endon("ac130_detached");
	
	self.HUDItem[ "hud_text_top" ] = newClientHudElem( self );
 	self.HUDItem[ "hud_text_top" ].x = 0;
 	self.HUDItem[ "hud_text_top" ].y = 0;
 	self.HUDItem[ "hud_text_top" ].alignX = "left";
 	self.HUDItem[ "hud_text_top" ].alignY = "top";
 	self.HUDItem[ "hud_text_top" ].horzAlign = "left";
 	self.HUDItem[ "hud_text_top" ].vertAlign = "top";
 	self.HUDItem[ "hud_text_top" ].fontScale = 2.5;
 	self.HUDItem[ "hud_text_top" ].label = &"AC130_HUD_TOP_BAR";
  	self.HUDItem[ "hud_text_top" ].glowColor = (0.2, 0.3, 0.7);
  	self.HUDItem[ "hud_text_top" ].glowAlpha = 1;
 	self.HUDItem[ "hud_text_top" ].alpha = 1.0;
		
 	self.HUDItem[ "hud_text_left" ] = newClientHudElem( self );
 	self.HUDItem[ "hud_text_left" ].x = 0;
 	self.HUDItem[ "hud_text_left" ].y = 60;
 	self.HUDItem[ "hud_text_left" ].alignX = "left";
 	self.HUDItem[ "hud_text_left" ].alignY = "top";
 	self.HUDItem[ "hud_text_left" ].horzAlign = "left";
 	self.HUDItem[ "hud_text_left" ].vertAlign = "top";
 	self.HUDItem[ "hud_text_left" ].fontScale = 2.5;
 	self.HUDItem[ "hud_text_left" ].label = &"AC130_HUD_LEFT_BLOCK";
  	self.HUDItem[ "hud_text_left" ].glowColor = (0.2, 0.3, 0.7);
  	self.HUDItem[ "hud_text_left" ].glowAlpha = 1;
 	self.HUDItem[ "hud_text_left" ].alpha = 1.0;
		
 	self.HUDItem[ "hud_text_right" ] = newClientHudElem( self );
 	self.HUDItem[ "hud_text_right" ].x = 0;
 	self.HUDItem[ "hud_text_right" ].y = 50;
 	self.HUDItem[ "hud_text_right" ].alignX = "right";
 	self.HUDItem[ "hud_text_right" ].alignY = "top";
 	self.HUDItem[ "hud_text_right" ].horzAlign = "right";
 	self.HUDItem[ "hud_text_right" ].vertAlign = "top";
 	self.HUDItem[ "hud_text_right" ].fontScale = 2.5;
 	self.HUDItem[ "hud_text_right" ].label = &"AC130_HUD_RIGHT_BLOCK";
  	self.HUDItem[ "hud_text_right" ].glowColor = (0.2, 0.3, 0.7);
  	self.HUDItem[ "hud_text_right" ].glowAlpha = 1;
 	self.HUDItem[ "hud_text_right" ].alpha = 1.0;
		
 	self.HUDItem[ "hud_text_bottom" ] = newClientHudElem( self );
 	self.HUDItem[ "hud_text_bottom" ].x = 0;
 	self.HUDItem[ "hud_text_bottom" ].y = 0;
 	self.HUDItem[ "hud_text_bottom" ].alignX = "center";
 	self.HUDItem[ "hud_text_bottom" ].alignY = "bottom";
 	self.HUDItem[ "hud_text_bottom" ].horzAlign = "center";
 	self.HUDItem[ "hud_text_bottom" ].vertAlign = "bottom";
 	self.HUDItem[ "hud_text_bottom" ].fontScale = 2.5;
	self.HUDItem[ "hud_text_bottom" ].label = &"AC130_HUD_BOTTOM_BLOCK";
  	self.HUDItem[ "hud_text_bottom" ].glowColor = (0.2, 0.3, 0.7);
  	self.HUDItem[ "hud_text_bottom" ].glowAlpha = 1;
 	self.HUDItem[ "hud_text_bottom" ].alpha = 1.0;

	self.HUDItem[ "keypress" ] = newClientHudElem( self );
	self.HUDItem[ "keypress" ].x = 0;
	self.HUDItem[ "keypress" ].y = -60;
	self.HUDItem[ "keypress" ].alignX = "left";
	self.HUDItem[ "keypress" ].alignY = "bottom";
	self.HUDItem[ "keypress" ].horzAlign = "left";
	self.HUDItem[ "keypress" ].vertAlign = "bottom";
	self.HUDItem[ "keypress" ].fontScale = 1.5;
	self.HUDItem[ "keypress" ].label = &"AC130_HINT_CYCLE_WEAPONS";
	self.HUDItem[ "keypress" ].alpha = 1.0;
	self.HUDItem[ "keypress" ] fadeOverTime( 18 );
	self.HUDItem[ "keypress" ].alpha = 0;

	self.HUDItem[ "keypressthermal" ] = newClientHudElem( self );
	self.HUDItem[ "keypressthermal" ].x = 0;
	self.HUDItem[ "keypressthermal" ].y = -40;
	self.HUDItem[ "keypressthermal" ].alignX = "left";
	self.HUDItem[ "keypressthermal" ].alignY = "bottom";
	self.HUDItem[ "keypressthermal" ].horzAlign = "left";
	self.HUDItem[ "keypressthermal" ].vertAlign = "bottom";
	self.HUDItem[ "keypressthermal" ].fontScale = 1.5;
	self.HUDItem[ "keypressthermal" ].label = &"AC130_HINT_TOGGLE_THERMAL";
	self.HUDItem[ "keypressthermal" ].alpha = 1.0;
	self.HUDItem[ "keypressthermal" ] fadeOverTime( 18 );
	self.HUDItem[ "keypressthermal" ].alpha = 0; 
}

ac130_hudOff()  
{
	hud_items = [];
	hud_items[ hud_items.size ] = "hud_text_top";
	hud_items[ hud_items.size ] = "hud_text_left";
	hud_items[ hud_items.size ] = "hud_text_right";
	hud_items[ hud_items.size ] = "hud_text_bottom";
  	hud_items[ hud_items.size ] = "keypressthermal";
 	hud_items[ hud_items.size ] = "keypress";
	
	for ( i = 0 ; i < hud_items.size ; i++ )
	{
		if ( isdefined( self.HUDItem[ hud_items[ i ] ] ) )
			self.HUDItem[ hud_items[ i ] ] destroy();
	}
}

playac130Sound()
{
  self endon("stop_ac130sound");

	for(;;)  
	{
		self PlayLocalSound( "ambient_ac130_x4" );
		wait level.ex_ac130_timer;
	}
}

stopac130Sound()
{
	self notify("stop_ac130sound"); 
	self StopLocalSound( "ambient_ac130_x4" );
}

shotFiredDarkScreenOverlay() 
{
	self notify( "darkScreenOverlay" );
	self endon( "darkScreenOverlay" );
	
	if ( !isdefined( self.darkScreenOverlay ) )
	{
		self.darkScreenOverlay = newClientHudElem( self );
		self.darkScreenOverlay.x = 0;
		self.darkScreenOverlay.y = 0;
		self.darkScreenOverlay.alignX = "left";
		self.darkScreenOverlay.alignY = "top";
		self.darkScreenOverlay.horzAlign = "fullscreen";
		self.darkScreenOverlay.vertAlign = "fullscreen";
		self.darkScreenOverlay setshader ( "black", 640, 480 );
		self.darkScreenOverlay.sort = -10;
		self.darkScreenOverlay.alpha = 0.0;
	}
	self.darkScreenOverlay.alpha = 0.0;
	self.darkScreenOverlay fadeOverTime( 0.2 );
	self.darkScreenOverlay.alpha = 0.6;
	wait 0.4;
	self.darkScreenOverlay fadeOverTime( 0.8 );
	self.darkScreenOverlay.alpha = 0.0;
}