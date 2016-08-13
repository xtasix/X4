
cookbar(weapon)		// originally from AWE:UO
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");
	self endon("death");

	if (!level.ex_grenadecookbar || weapon != "frag_grenade_mp")
		return;

	self destroyCookbar();

	// Size of progressbar
	barsize = 250;
	
	// Time for progressbar	
	bartime = 4 - 0.15;

	// background
	self.ex_grenadecookbar[0] = newClientHudElem(self);				
	self.ex_grenadecookbar[0].horzAlign = "fullscreen";
	self.ex_grenadecookbar[0].vertAlign = "fullscreen";
	self.ex_grenadecookbar[0].alignX = "center";
	self.ex_grenadecookbar[0].alignY = "middle";
	self.ex_grenadecookbar[0].x = 320;
	self.ex_grenadecookbar[0].y = 385;
	self.ex_grenadecookbar[0].archived = false;
	self.ex_grenadecookbar[0].alpha = 0.5;
	self.ex_grenadecookbar[0].color = (0,0,0);
	self.ex_grenadecookbar[0].sort = 9997;
	self.ex_grenadecookbar[0] setShader("white", (barsize + 4), 12);			

	// foreground
	self.ex_grenadecookbar[1] = newClientHudElem(self);				
	self.ex_grenadecookbar[1].horzAlign = "fullscreen";
	self.ex_grenadecookbar[1].vertAlign = "fullscreen";
	self.ex_grenadecookbar[1].alignX = "left";
	self.ex_grenadecookbar[1].alignY = "middle";
	self.ex_grenadecookbar[1].x = (320 - (barsize / 2.0));
	self.ex_grenadecookbar[1].y = 385;
	self.ex_grenadecookbar[1].archived = false;
	self.ex_grenadecookbar[1].color = (1,1,1);
	self.ex_grenadecookbar[1].alpha = 0.7;
	self.ex_grenadecookbar[1].sort = 9998;
	self.ex_grenadecookbar[1] setShader("white", 0, 8);
	self.ex_grenadecookbar[1] scaleOverTime(bartime , barsize, 8);

	// text
	self.ex_grenadecookbar[2] = newClientHudElem(self);
	self.ex_grenadecookbar[2].horzAlign = "fullscreen";
	self.ex_grenadecookbar[2].vertAlign = "fullscreen";
	self.ex_grenadecookbar[2].alignX = "center";
	self.ex_grenadecookbar[2].alignY = "middle";
	self.ex_grenadecookbar[2].x = 320;
	self.ex_grenadecookbar[2].y = 384;
	self.ex_grenadecookbar[2].archived = false;
	self.ex_grenadecookbar[2].fontscale = 1.4;
	self.ex_grenadecookbar[2].color = (.5,.5,.5);
	self.ex_grenadecookbar[2].sort = 9999;
	self.ex_grenadecookbar[2].label = &"Grenade Cook Timer";

	// Cooktime is fusetime * 20 - 2 (Usually 79)
	cooktime = 4 * 20 - 2;

	// Cook
	for (i=0; i<cooktime; i++)
	{
		color = i/cooktime;
		self.ex_grenadecookbar[1].color = (1,1-color,1-color);

		if (!self fragButtonPressed())
			break;
		else
		{
			wait .05;
		}
		if (!isAlive(self) || self.sessionstate != "playing")
			break;
		if (!isDefined(self.throwingGrenade) || !self.throwingGrenade)
			break;
	}

	self destroyCookbar();
}

destroyCookbar()
{
	if (isDefined(self.ex_grenadecookbar))
		for (i = 0; i < 3; i++)
			if (isDefined(self.ex_grenadecookbar[i]))
				self.ex_grenadecookbar[i] destroy();
}

CleanupSpawned()
{
	if (isDefined(self.ex_grenadecookbar))
		for (i = 0; i < 3; i++)
			if (isDefined(self.ex_grenadecookbar[i]))
				self.ex_grenadecookbar[i] destroy();
}