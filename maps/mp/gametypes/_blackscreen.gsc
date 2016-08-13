init() 
{ 
	precacheShader("overlay_low_health"); 
	level.healthOverlayCutoff = 0.35; 
	level.playerHealth_RegularRegenDelay = 5000; 
	level thread onPlayerConnect(); 
} 
onPlayerConnect() 
{ 
	for(;;) 
	{ 
	level waittill("connecting", player); 
	player thread onPlayerKilled(); 
	} 
} 

onPlayerKilled() 
{ 
	self endon("disconnect"); 

	for(;;) 
	{ 
		self waittill("killed_player"); 
		if(self.sessionteam == "spectator") 
			onPlayerKilled(); 
		else 
		self.blackscreentext = newClientHudElem(self); 
		self.blackscreentext.sort = -1; 
		self.blackscreentext.archived = false; 
		self.blackscreentext.alignX = "center"; 
		self.blackscreentext.alignY = "middle"; 
		self.blackscreentext.fontscale = 2.5; 
		self.blackscreentext.x = 320; 
		self.blackscreentext.y = 220; 
		self.blackscreentext.alpha = 0; 
		
		self.blackscreen = newClientHudElem(self); 
		self.blackscreen.sort = -2; 
		self.blackscreen.archived = false; 
		self.blackscreen.alignX = "center"; 
		self.blackscreen.alignY = "middle";
		self.blackscreen.horzAlign = "center_safearea";
		self.blackscreen.vertAlign = "center_safearea"; 
		self.blackscreen.x = 0; 
		self.blackscreen.y = 0; 
		self.blackscreen.alpha = 0; 
		self.blackscreen setShader("black", 900, 900); 
		self.blackscreen fadeOverTime(0.1); 
		self.blackscreen.alpha = 1; 
		
		saytext = "player.name was killed"; 
		self waittill("spawned_player");
		self.blackscreen destroy(); 
		self.blackscreentext destroy(); 
		//self.ac130_overlay destroy();
		//self.ac130_grain destroy();
	} 
} 

