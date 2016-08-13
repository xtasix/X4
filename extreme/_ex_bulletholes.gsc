
bulletHole()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(!isDefined(self.ex_bulletholes)) self.ex_bulletholes = [];

	hole = self.ex_bulletholes.size;
	
	self.ex_bulletholes[hole] = newClientHudElem(self);
	self.ex_bulletholes[hole].alignX = "center";
	self.ex_bulletholes[hole].alignY = "middle";
	self.ex_bulletholes[hole].x = 48 + randomInt(544);
	self.ex_bulletholes[hole].y = 48 + randomInt(204);
	self.ex_bulletholes[hole].color = (1,1,1);
	self.ex_bulletholes[hole].alpha = 0.8 + randomFloat(0.2);

	xsize = 96 + randomInt(64);
	ysize = 96 + randomInt(64);
	self.ex_bulletholes[hole] setShader("bullethit_glass", xsize, ysize);

	self playLocalSound("glass_break");

	//if(level.ex_bulletholes != 2) return;
	if(level.ex_bulletholes == 1) return;

	if(level.ex_bulletholes == 2) self thread fadeBulletHole5(hole);
	if(level.ex_bulletholes == 3) self thread fadeBulletHole10(hole);
	if(level.ex_bulletholes == 4) self thread fadeBulletHole15(hole);
	//if(level.ex_bulletholes == 5) self thread fadeBulletHoleRespawn(hole);
}

fadeBulletHole5(hole)
{
	wait 5;

	if(isPlayer(self))
	{
		if(isDefined(self.ex_bulletholes))
		{
			if(isDefined(self.ex_bulletholes[hole]))
			{
				self.ex_bulletholes[hole] fadeOverTime(1);
				self.ex_bulletholes[hole].alpha = 0;
				wait 1;
				if(isPlayer(self) && isDefined(self.ex_bulletholes[hole])) self.ex_bulletholes[hole] destroy();
			}
		}
	}
}

fadeBulletHole10(hole)
{
	wait 10;

	if(isPlayer(self))
	{
		if(isDefined(self.ex_bulletholes))
		{
			if(isDefined(self.ex_bulletholes[hole]))
			{
				self.ex_bulletholes[hole] fadeOverTime(1);
				self.ex_bulletholes[hole].alpha = 0;
				wait 1;
				if(isPlayer(self) && isDefined(self.ex_bulletholes[hole])) self.ex_bulletholes[hole] destroy();
			}
		}
	}
}

fadeBulletHole15(hole)
{
	wait 15;

	if(isPlayer(self))
	{
		if(isDefined(self.ex_bulletholes))
		{
			if(isDefined(self.ex_bulletholes[hole]))
			{
				self.ex_bulletholes[hole] fadeOverTime(1);
				self.ex_bulletholes[hole].alpha = 0;
				wait 1;
				if(isPlayer(self) && isDefined(self.ex_bulletholes[hole])) self.ex_bulletholes[hole] destroy();
			}
		}
	}
}

