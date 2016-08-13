#include extreme\_ex_utils;

start()
{
	if(isExcluded()) return;

	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(!isDefined(self.ex_laserdot))
	{
		self.ex_laserdot = newClientHudElem(self);
		self.ex_laserdot.x = 320;
		self.ex_laserdot.y = 240;
		self.ex_laserdot.alignX = "center";
		self.ex_laserdot.alignY = "middle";
		self.ex_laserdot.horzAlign = "fullscreen";
		self.ex_laserdot.vertAlign = "fullscreen";
		self.ex_laserdot.alpha = 0;
		self.ex_laserdot.color = (level.ex_laserdotred, level.ex_laserdotgreen, level.ex_laserdotblue);
		self.ex_laserdot setShader("hud_laser", level.ex_laserdotsize, level.ex_laserdotsize );
	}

	if(level.ex_laserdot == 1) self.ex_laserdot.alpha = 1;
		else self thread laserdotMonitor();
}

isExcluded()
{
	self endon("disconnect");

	count = 0;
	clan_check = "";

	if(isDefined(self.ex_clan))
	{
		playerclan = convertMUJ(self.ex_clan);

		for(;;)
		{
			clan_check = [[level.ex_dvardef]]("ex_laserdot_clan_" + count, "", "", "", "string");
			if(clan_check == "") break;
			clan_check = convertMUJ(clan_check);
			if(clan_check == playerclan) break;
				else count++;
		}
	}

	if(clan_check != "") return true;

	count = 0;
	playername = convertMUJ(self.name);

	for(;;)
	{
		name_check = [[level.ex_dvardef]]("ex_laserdot_name_" + count, "", "", "", "string");
		if(name_check == "") break;
		name_check = convertMUJ(name_check);
		if(name_check == playername) break;
			else count++;
	}

	if(name_check != "") return true;

	return false;
}

laserdotMonitor()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	while(isPlayer(self) && self.sessionstate == "playing")
	{
		if(isDefined(self.ex_laserdot))
		{
			switch(level.ex_laserdot)
			{
				case 2:
					if(self playerads()) self.ex_laserdot.alpha = 1;
						else self.ex_laserdot.alpha = 0;
					break;
				case 3:
					if(self playerads()) self.ex_laserdot.alpha = 0;
						else self.ex_laserdot.alpha = 1;
					break;
			}
		}
		wait 0.5;
	}
}

draw_cross() 
{ 
   yadd = 10; 
   xadd = 10; 

   self.cross_top = newClientHudElem(self); 
   self.cross_top.alignX = "center"; 
   self.cross_top.alignY = "middle"; 
   self.cross_top.x = 320; 
   self.cross_top.y = 240 + yadd; 
   self.cross_top.alpha = 1; 
   self.cross_top.color = (1,1,1); 
   self.cross_top setShader("white",1,10); 

   self.cross_bottom = newClientHudElem(self); 
   self.cross_bottom.alignX = "center"; 
   self.cross_bottom.alignY = "middle"; 
   self.cross_bottom.x = 320; 
   self.cross_bottom.y = 240 - yadd; 
   self.cross_bottom.alpha = 1; 
   self.cross_bottom.color = (1,1,1); 
   self.cross_bottom setShader("white",1,10); 

   self.cross_right = newClientHudElem(self); 
   self.cross_right.alignX = "center"; 
   self.cross_right.alignY = "middle"; 
   self.cross_right.x = 320 - xadd; 
   self.cross_right.y = 240; 
   self.cross_right.alpha = 1; 
   self.cross_right.color = (1,1,1); 
   self.cross_right setShader("white",10,1); 
	
   self.cross_left = newClientHudElem(self); 
   self.cross_left.alignX = "center"; 
   self.cross_left.alignY = "middle"; 
   self.cross_left.x = 320 + xadd; 
   self.cross_left.y = 240; 
   self.cross_left.alpha = 1; 
   self.cross_left.color = (1,1,1); 
   self.cross_left setShader("white",10,1); 

// Cleanup 

   self waittill("whatever you want to wait for"); 
   self.cross_top destroy(); 
   self.cross_botom destroy(); 
   self.cross_right destroy();	
   self.cross_left destroy(); 
} 