init()
{
	level endon("ex_gameover");

	while(true)
	{
		delay = randomInt(level.ex_flares_delay_max - level.ex_flares_delay_min) + level.ex_flares_delay_min;
		if(delay < 20) delay = 20;
		wait(delay);

		flares = spawn("script_origin", getTargetPosition());
		
		flares thread goFlares(); 
	}
}

goFlares()
{
	// calculate number of flares
	flaresNumber = randomInt(level.ex_flares_max - level.ex_flares_min) + level.ex_flares_min / 2;

	// alert players
	//if(level.ex_flare_alert)
	//{
		//thread extreme\_ex_battlechatter::teamchatter("order_cover_generic", "both");
		//wait(1);
	//}

	// fire flares
	self.flaresGlobalDelay = 0;
	for(i = 0; i < flaresNumber; i++)
		self thread fireFlare(calcFlaresPos(self.origin));

	// wait for all flares to finish
	flaresFinished = 0;
	while(flaresFinished < flaresNumber)
	{
		self waittill("flare_end");
		flaresFinished++;
	}

	self delete();
}

fireFlare(flareTargetPos)
{
	self.flaresGlobalDelay += randomFloatRange( .5, 1.5 );
	wait(self.flaresGlobalDelay);
	wait(randomFloatRange(1.5, 2.5));

	// spawn entity for sound positioning
	flare = spawn("script_model", flareTargetPos);
	flare playSound("flare_fire");
	playfx(level.ex_effect["flare_ambient"], flareTargetPos);
	wait(1);
	flare playSound("flare_burn");

	if(!level.ex_flare_type) wait(30); // delay for normal flares
		else wait(40); // bright flares last longer

	flare delete();
	self notify("flare_end");
}

getTargetPosition()
{
	x = level.ex_playArea_Min[0] + randomInt(level.ex_playArea_Width);
	y = level.ex_playArea_Min[1] + randomInt(level.ex_playArea_Length);
	z = level.ex_playArea_Min[2];

	return (x, y, z);
}

calcFlaresPos(targetPos)
{
	flaresPos = undefined;
	iterations = 0;

	while(!isDefined(flaresPos) && iterations < 5)
	{
		flaresPos = targetPos;
		angle = randomFloat(360);
		radius = randomFloat(2250);
		randomOffset = (cos(angle) * radius, sin(angle) * radius, 0);
		flaresPos += randomOffset;
		startOrigin = flaresPos + (0, 0, 800);
		endOrigin = flaresPos + (0, 0, -2048);

		trace = bulletTrace( startOrigin, endOrigin, true, undefined );
		if(trace["fraction"] < 1.0) flaresPos = trace["position"];
			else flaresPos = undefined;

		iterations++;
	}

	if(!isDefined(flaresPos)) flaresPos = targetPos;
	return flaresPos;
}
