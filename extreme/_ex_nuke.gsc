#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level.nukefx = loadfx ("explosions/nuke");
	level.nukefx2 = loadfx ("explosions/nuke_explosion");
	level.nukeflash = loadfx ("explosions/nuke_flash");
	
	precacheShader("hudStopwatch");
	precacheShader( "icon_0" );
	precacheShader( "icon_1" );
	precacheShader( "icon_2" );
	precacheShader( "icon_3" );
	precacheShader( "icon_4" );
	precacheShader( "icon_5" );

	precacheShellShock( "radiation_high" );
	precacheShellShock( "flash" );

	level.nuke = false;

}
rotatingNukeIcon()
{
	self endon("death");
   
	iconNumber = 0;
   
	for (;;) {
		if ( isDefined( self ) )
			self setShader( "icon_" + iconNumber, 32, 32 );
	   
		iconNumber++;
		if ( iconNumber > 5 ) iconNumber = 0;
	   
		wait 0.08;
	}
}

main()
{
	self endon("disconnect");
	
	loc = level.mapCenter;
	self thread NukeCountdown( loc );
}

NukeCountdown( position )
{
	level notify( "nuke" );
	level endon("ex_gameover");
	self endon("disconnect");
   
	thread extreme\_ex_utils::playSoundLoc("nuke_warning",(0,0,0));
   
	nukeTimer = 10.0;
   
	team = self.pers["team"];
	otherTeam = level.otherTeam[team];
		
	maps\mp\gametypes\_globallogic::leaderDialog( "nuke_friendly", team );
	maps\mp\gametypes\_globallogic::leaderDialog( "nuke_enemy", level.otherTeam[team] );
	  
	iprintln( self.name + " called in a Tactical Nuke!");

	if(!isDefined(self.watch))
	{
		self.watch = newClientHudElem(self);
		self.watch.x = 200;
		self.watch.y = 100;
		self.watch.alignx = "center";
		self.watch.aligny = "middle";
		self.watch.horzAlign = "fullscreen";
		self.watch.vertAlign = "fullscreen";
		self.watch.alpha = .9;
		self.watch.fontScale = 2;
		self.watch.sort = 100;
		self.watch.foreground = true;
		self.watch.color = (1,0,0);
		self.watch.glowColor = (0.2, 0.3, 0.7);
		self.watch.glowAlpha = 1;
		self.watch setTenthsTimer( nukeTimer );
	}
	
	if(!isDefined(self.nuke_icon))
	{	
		self.nuke_icon = newClientHudElem(self);
		self.nuke_icon.x = 143;
		self.nuke_icon.y = 98;
		self.nuke_icon.alignx = "center";
		self.nuke_icon.aligny = "middle";
		self.nuke_icon.horzAlign = "fullscreen";
		self.nuke_icon.vertAlign = "fullscreen";
		self.nuke_icon.glowColor = (0.2, 0.3, 0.7);
		self.nuke_icon.glowAlpha = 1;
		self.nuke_icon.alpha = .9;
		self.nuke_icon.sort = 100;
		self.nuke_icon.foreground = true;
		self.nuke_icon thread rotatingNukeIcon(); 
	}
  
	wait nukeTimer;
  
	self.watch destroy();
	self.nuke_icon destroy();
	
	position = level.mapCenter;
	position2 = (250,0,0);
	position3 = (300,100,0);

	nuke = spawn( "script_origin", position );
	
	nuke playSound( "nuke_fuse" );

	wait 2;

	playFX( level.nukefx, position );

	visionSetNaked("nuke",0);
	playFX( level.nukeflash, position3 );
	nuke playSound( "nuke_explode" );

	wait 0.1;

	playFX( level.nukefx2, position2 );
	
	level.nuke = true;

	wait 0.5;

	earthquake( 1, 1.5, position, 80000);

	players = getEntarray( "player", "classname" );

	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player playSound( "nuke_aftermath" );
		player shellshock( "radiation_high", 1 );
		player ViewKick( 127, player.origin );
		player.ex_invulnerable = true;
	}
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player setClientDvar( "ui_hud_hardcore", 1 );
		player [[level.ex_clientcmd]]("gocrouch");
		player disableWeapons();
		if(isDefined(self.ex_healthbar)) self.ex_healthbar destroy();
		if(isDefined(self.ex_healthback)) self.ex_healthback destroy();
		if(isDefined(self.ex_healthcross)) self.ex_healthcross destroy();  
	}

	wait 0.8;
	wait 5.0;

	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player thread maps\mp\_flash::applyFlash(3, 0.75);
		player [[level.ex_clientcmd]]("goprone");
	}


	wait 0.8;
	
	visionSetNaked("nuke2",1);
	AmbientStop( 20 );
	
	wait 1.5;
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player [[level.ex_clientcmd]]("goprone");
		player disableWeapons();
	}
	
	thread maps\mp\gametypes\_globallogic::endGame( self.pers["team"], "Tactical Nuke" );
	
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		player [[level.ex_clientcmd]]("goprone");
		player disableWeapons();
	}
		
	level.nuke = false;
	nuke Delete();
		
	wait 20;
		
	if ( level.scr_new_colors == 0)
	{
		visionSetNaked(getDvar("mapname"),16);
	}
	else if ( level.scr_new_colors == 1)
	{
		visionSetNaked("new_colors",16);
	}
		
	level.nuke = false;
	nuke Delete();
		
	}