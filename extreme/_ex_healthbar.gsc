start()
{
	if(level.inPrematchPeriod)
		level waittill("prematch_over");

	if(!isDefined(self.ex_healthback))
	{
		self.ex_healthback = newClientHudElem(self);
		self.ex_healthback.fontScale = 1.4;
		self.ex_healthback.alignX = "left";
		self.ex_healthback.alignY = "middle";
		self.ex_healthback.horzAlign = "fullscreen";
		self.ex_healthback.vertAlign = "fullscreen";
		self.ex_healthback.alpha = .7;
		if(level.hardcoreMode)
		{
			self.ex_healthback.x = 6;
			self.ex_healthback.y = 472;
		}
		if(!level.hardcoreMode)
		{
			self.ex_healthback.x = 6;
			self.ex_healthback.y = 415;
		}
		self.ex_healthback setShader("progress_bar_fg", 90, 7);
	}

	if(!isDefined(self.ex_healthbar))
	{
		self.ex_healthbar = newClientHudElem(self);
		self.ex_healthbar.fontScale = 1.4;
		self.ex_healthbar.alignX = "left";
		self.ex_healthbar.alignY = "middle";
		self.ex_healthbar.horzAlign = "fullscreen";
		self.ex_healthbar.vertAlign = "fullscreen";
		self.ex_healthbar.alpha = .7;
		if(level.hardcoreMode)
		{
			self.ex_healthbar.x = 7;
			self.ex_healthbar.y = 472;
		}
		if(!level.hardcoreMode)
		{
			self.ex_healthbar.x = 7;
			self.ex_healthbar.y = 415;
		}
		self.ex_healthbar.color = ( 0, 1, 0);
		self.ex_healthbar setShader("progress_bar_fill", 88, 5);
	}

	if(!isDefined(self.ex_healthcross))
	{
		self.ex_healthcross = newClientHudElem(self);
		self.ex_healthcross.fontScale = 1.4;
		self.ex_healthcross.alignX = "left";
		self.ex_healthcross.alignY = "middle";
		self.ex_healthcross.horzAlign = "fullscreen";
		self.ex_healthcross.vertAlign = "fullscreen";
		self.ex_healthcross.alpha = .7;
		if(level.hardcoreMode)
		{
			self.ex_healthcross.x = 100;
			self.ex_healthcross.y = 472;

		}
		if(!level.hardcoreMode)
		{
			self.ex_healthcross.x = 100;
			self.ex_healthcross.y = 414;

		}
		self.ex_healthcross setShader("hint_health", 10, 10);
	}

	self thread healthUpdate();
}

healthUpdate()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	oldhealth = self.health;
	width = undefined;
	
	for(;;)
	{
		wait (0.1 * level.fps_multiplier);

		if(isPlayer(self) && isDefined(self.health) && self.health != oldhealth)
		{
			health = self.health / self.maxhealth;
		
			width = int(health * 88);
					
			if(width < 1) width = 1;

			if(isDefined(self.ex_healthbar))
			{					
				self.ex_healthbar setShader("progress_bar_fill", width, 5);
				self.ex_healthbar.color = ( 1.0 - health, health, 0);
			}
			
			oldhealth = self.health;
		}
	}
}
