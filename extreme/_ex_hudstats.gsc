main()
{	
 	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	self endon("joined_spectators");
	  
	while(isAlive(self))
	{
		wait (3 * level.fps_multiplier);
				
			if(!isdefined(self.hud_stats))
			{
				self.hud_stats = newClientHudElem(self);
				self.hud_stats.x = level.ex_hudstats_xpos;
				self.hud_stats.y = level.ex_hudstats_ypos;
				self.hud_stats.alignx = "right";
				self.hud_stats.aligny = "top";
				self.hud_stats.horzAlign = "fullscreen";
				self.hud_stats.vertAlign = "fullscreen";
				self.hud_stats.alpha =0;
				self.hud_stats.fontScale = 1.4;
			}
				
			self.hud_stats.label = &"HUD_SCORE";
			self.hud_stats setvalue(self.pers["score"]);
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;	

			wait (3); 
			
			self.hud_stats.label = &"HUD_HEADSHOTS";
			self.hud_stats setvalue(self.pers["headshots"]);
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;	

			wait (3); 
			
			self.hud_stats.label = &"HUD_KNIFE";
			self.hud_stats setvalue(self.pers["knifekill"]);
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;
			
			wait (3); 
			
			self.hud_stats.label = &"HUD_NADE";
			self.hud_stats setvalue(self.pers["grenadekill"]);
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;

			wait (3); 

			self.hud_stats.label = &"HUD_KILLS";
			self.hud_stats setvalue(self.pers["kills"]);
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;	

			wait (3); 
			
			self.hud_stats.label = &"HUD_DEATHS";
			self.hud_stats setvalue(self.pers["deaths"]);
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;
			
			wait (3); 

			if (((self.pers["deaths"] + self.pers["suicides"]) <= 0) && self.pers["kills"] >0)
			{
				self.hud_stats.label = &"HUD_KD";
				self.hud_stats setText(&"HUD_EGG");
			}
			else 
			{
				if ((self.pers["deaths"] + self.pers["suicides"]) <= 0)
				{
					self.hud_stats.label = &"HUD_KD";
					ex_zero = 0;
					self.hud_stats setValue(ex_zero);
				}	
				else
				{
					self.pers["effiency"] = (int(100 * self.pers["kills"] / (self.pers["deaths"] + self.pers["suicides"])) / 100);
					self.hud_stats.label = &"HUD_KD";
					self.hud_stats setvalue(self.pers["effiency"]);
				}	
			}
		
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0.9;
			
			wait (5); 
			
			self.hud_stats fadeOverTime(2);
			self.hud_stats.alpha =0;
			wait (3); 
	}		
}

statsonuse()
{
	self endon("disconnect");
	self endon("death");
	self endon( "game_ended" );
	self endon("joined_spectators");
	  
	while(isAlive(self))
	{
		wait (1 * level.fps_multiplier);
		
		if(self playerADS())  //add this feature if you only want the stats on button press or use ADS logic if only for scoped up
		{
		
			if(!isdefined(self.hud_statsscore))
			{
				self.hud_statsscore = newClientHudElem(self);
				self.hud_statsscore.x = level.ex_hudstatsuse_xpos;
				self.hud_statsscore.y = level.ex_hudstatsuse_ypos;
				self.hud_statsscore.alignx = "right";
				self.hud_statsscore.aligny = "middle";
				self.hud_statsscore.horzAlign = "fullscreen";
				self.hud_statsscore.vertAlign = "fullscreen";
				self.hud_statsscore.alpha =0.8;
				self.hud_statsscore.fontScale = 1.4;
			}
			self.hud_statsscore.label = &"HUD_SCORE";
			self.hud_statsscore setvalue(self.pers["score"]);
			
			if(!isdefined(self.hud_statshead))
			{
				self.hud_statshead = newClientHudElem(self);
				self.hud_statshead.x = level.ex_hudstatsuse_xpos;
				self.hud_statshead.y = level.ex_hudstatsuse_ypos + 16;
				self.hud_statshead.alignx = "right";
				self.hud_statshead.aligny = "middle";
				self.hud_statshead.horzAlign = "fullscreen";
				self.hud_statshead.vertAlign = "fullscreen";
				self.hud_statshead.alpha =0.8;
				self.hud_statshead.fontScale = 1.4;
				self.hud_statshead.color = (1, 0, 0);
			}
		
			self.hud_statshead.label = &"HUD_HEADSHOTS";
			self.hud_statshead setvalue(self.pers["headshots"]);
			
			//
			if(!isdefined(self.hud_statsknife))
			{
				self.hud_statsknife = newClientHudElem(self);
				self.hud_statsknife.x = level.ex_hudstatsuse_xpos;
				self.hud_statsknife.y = level.ex_hudstatsuse_ypos + 32;
				self.hud_statsknife.alignx = "right";
				self.hud_statsknife.aligny = "middle";
				self.hud_statsknife.horzAlign = "fullscreen";
				self.hud_statsknife.vertAlign = "fullscreen";
				self.hud_statsknife.alpha =0.8;
				self.hud_statsknife.fontScale = 1.4;
				self.hud_statsknife.color = (1, 0, 0);
			}
		
			self.hud_statsknife.label = &"HUD_KNIFE";
			self.hud_statsknife setvalue(self.pers["knifekill"]);
			
			if(!isdefined(self.hud_statsnade))
			{
				self.hud_statsnade = newClientHudElem(self);
				self.hud_statsnade.x = level.ex_hudstatsuse_xpos;
				self.hud_statsnade.y = level.ex_hudstatsuse_ypos + 48;
				self.hud_statsnade.alignx = "right";
				self.hud_statsnade.aligny = "middle";
				self.hud_statsnade.horzAlign = "fullscreen";
				self.hud_statsnade.vertAlign = "fullscreen";
				self.hud_statsnade.alpha =0.8;
				self.hud_statsnade.fontScale = 1.4;
				self.hud_statsnade.color = (1, 0, 0);
			}
		
			self.hud_statsnade.label = &"HUD_NADE";
			self.hud_statsnade setvalue(self.pers["grenadekill"]);
			//
			
			if(!isdefined(self.hud_statskill))
			{
				self.hud_statskill = newClientHudElem(self);
				self.hud_statskill.x = level.ex_hudstatsuse_xpos;
				self.hud_statskill.y = level.ex_hudstatsuse_ypos + 64;
				self.hud_statskill.alignx = "right";
				self.hud_statskill.aligny = "middle";
				self.hud_statskill.horzAlign = "fullscreen";
				self.hud_statskill.vertAlign = "fullscreen";
				self.hud_statskill.alpha =0.8;
				self.hud_statskill.fontScale = 1.4;
			}
			self.hud_statskill.label = &"HUD_KILLS";
			self.hud_statskill setvalue(self.pers["kills"]);
			
			if(!isdefined(self.hud_statsdeath))
			{
				self.hud_statsdeath = newClientHudElem(self);
				self.hud_statsdeath.x = level.ex_hudstatsuse_xpos;
				self.hud_statsdeath.y = level.ex_hudstatsuse_ypos + 80;
				self.hud_statsdeath.alignx = "right";
				self.hud_statsdeath.aligny = "middle";
				self.hud_statsdeath.horzAlign = "fullscreen";
				self.hud_statsdeath.vertAlign = "fullscreen";
				self.hud_statsdeath.alpha =0.8;
				self.hud_statsdeath.fontScale = 1.4;
			}
			self.hud_statsdeath.label = &"HUD_DEATHS";
			self.hud_statsdeath setvalue(self.pers["deaths"]);	

			if(!isdefined(self.hud_statskd))
			{
				self.hud_statskd = newClientHudElem(self);
				self.hud_statskd.x = level.ex_hudstatsuse_xpos;
				self.hud_statskd.y = level.ex_hudstatsuse_ypos + 96;
				self.hud_statskd.alignx = "right";
				self.hud_statskd.aligny = "middle";
				self.hud_statskd.horzAlign = "fullscreen";
				self.hud_statskd.vertAlign = "fullscreen";
				self.hud_statskd.alpha =0.8;
				self.hud_statskd.fontScale = 1.4;
			}
			if (((self.pers["deaths"] + self.pers["suicides"]) <= 0) && self.pers["kills"] >0)
			{
				self.hud_statskd.label = &"HUD_KD";
				self.hud_statskd setText(&"HUD_EGG");
			}
			else 
			{
				if ((self.pers["deaths"] + self.pers["suicides"]) <= 0)
				{
					self.hud_statskd.label = &"HUD_KD";
					ex_zero = 0;
					self.hud_statskd setValue(ex_zero);
				}	
				else
				{
					self.pers["effiency"] = (int(100 * self.pers["kills"] / (self.pers["deaths"] + self.pers["suicides"])) / 100);
					self.hud_statskd.label = &"HUD_KD";
					self.hud_statskd setvalue(self.pers["effiency"]);
				}	
			}
		}
		else
		{
			if(isDefined(self.hud_statsscore)) self.hud_statsscore destroy(); 
			if(isDefined(self.hud_statshead)) self.hud_statshead destroy();
			if(isDefined(self.hud_statskill)) self.hud_statskill destroy(); 
			if(isDefined(self.hud_statsknife)) self.hud_statsknife destroy();
			if(isDefined(self.hud_statsnade)) self.hud_statsnade destroy(); 
			if(isDefined(self.hud_statsdeath)) self.hud_statsdeath destroy();
			if(isDefined(self.hud_statskd)) self.hud_statskd destroy();  
		}
	}
}