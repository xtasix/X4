/**/
init()
{
	precacheShader("overlay_flesh_hit2");
	precacheShader("overlay_fleshitgib");
}

CleanupSpawned()
{

	// Remove bloody screen
	if (isDefined(self.ex_bloodyscreen)) self.ex_bloodyscreen destroy();
	if (isDefined(self.ex_bloodyscreen1)) self.ex_bloodyscreen1 destroy();
	if (isDefined(self.ex_bloodyscreen2)) self.ex_bloodyscreen2 destroy();
	if (isDefined(self.ex_bloodyscreen3)) self.ex_bloodyscreen3 destroy();
}

Splatter_View()
{
	self endon("kill_threads");

	if(!level.ex_bloodyscreen) return;

	if(!isDefined(self.ex_bloodyscreen))
	{
		self.ex_bloodyscreen = newClientHudElem(self);
		self.ex_bloodyscreen1 = newClientHudElem(self);
		self.ex_bloodyscreen2 = newClientHudElem(self);
		self.ex_bloodyscreen3 = newClientHudElem(self);

		self.ex_bloodyscreen.alignX = "left";
		self.ex_bloodyscreen.alignY = "top";
	
		self.ex_bloodyscreen1.alignX = "left";
		self.ex_bloodyscreen1.alignY = "top";

		self.ex_bloodyscreen2.alignX = "left";
		self.ex_bloodyscreen2.alignY = "top";
		
		self.ex_bloodyscreen3.alignX = "left";
		self.ex_bloodyscreen3.alignY = "top";
		
		bs1 = (randomint(496));
		bs2 = (randomint(336));
		bs1a = (randomint(496));
		bs2a = (randomint(336));
		bs1b = (randomint(496));
		bs2b = (randomint(336));
		bs1c = (randomint(496));
		bs2c = (randomint(336));

		self.ex_bloodyscreen.x = bs1;
		self.ex_bloodyscreen.y = bs2;

		self.ex_bloodyscreen1.x = bs1a;
		self.ex_bloodyscreen1.y = bs2a;

		self.ex_bloodyscreen2.x = bs1b;
		self.ex_bloodyscreen2.y = bs2b;

		self.ex_bloodyscreen3.x = bs1c;
		self.ex_bloodyscreen3.y = bs2c;

		bs3 = randomint(48);
		bs3a = randomint(48);
		bs3b = randomint(48);
		bs3c = randomint(48);
		self.ex_bloodyscreen.color = (1,1,1);
		self.ex_bloodyscreen1.color = (1,1,1);
		self.ex_bloodyscreen2.color = (1,1,1);
		self.ex_bloodyscreen3.color = (1,1,1);
		self.ex_bloodyscreen.alpha = 1;
		self.ex_bloodyscreen1.alpha = 1;
		self.ex_bloodyscreen2.alpha = 1;
		self.ex_bloodyscreen3.alpha = 1;

		self.ex_bloodyscreen SetShader("overlay_flesh_hit2",96 + bs3 , 96 + bs3);
		self.ex_bloodyscreen1 SetShader("overlay_fleshitgib",96 + bs3a , 96 + bs3a);
		self.ex_bloodyscreen2 SetShader("overlay_flesh_hit2",96 + bs3b , 96 + bs3b);
		self.ex_bloodyscreen3 SetShader("overlay_fleshitgib",96 + bs3c , 96 + bs3c);

		wait (4);

		if(!isdefined(self.ex_bloodyscreen))
			return;
		self.ex_bloodyscreen fadeOverTime (2);
		self.ex_bloodyscreen moveOverTime(3.25);
		self.ex_bloodyscreen.y = self.ex_bloodyscreen.y + 550; 
		self.ex_bloodyscreen.alpha = 0;
		self.ex_bloodyscreen1 fadeOverTime (2);
		self.ex_bloodyscreen1 moveOverTime(3.25);
		self.ex_bloodyscreen1.y = self.ex_bloodyscreen1.y + 550; 
		self.ex_bloodyscreen1.alpha = 0;
		self.ex_bloodyscreen2 fadeOverTime (2);
		self.ex_bloodyscreen2 moveOverTime(3.25);
		self.ex_bloodyscreen2.y = self.ex_bloodyscreen2.y + 550;
		self.ex_bloodyscreen2.alpha = 0;
		self.ex_bloodyscreen3 fadeOverTime (2);
		self.ex_bloodyscreen3 moveOverTime(3.25);
		self.ex_bloodyscreen3.y = self.ex_bloodyscreen3.y + 550;
		self.ex_bloodyscreen3.alpha = 0;
		wait(2);
		
		// Remove bloody screen
		if (isDefined(self.ex_bloodyscreen))	self.ex_bloodyscreen destroy();
		if (isDefined(self.ex_bloodyscreen1))	self.ex_bloodyscreen1 destroy();
		if (isDefined(self.ex_bloodyscreen2))	self.ex_bloodyscreen2 destroy();
		if (isDefined(self.ex_bloodyscreen3))	self.ex_bloodyscreen3 destroy();
	}
}
