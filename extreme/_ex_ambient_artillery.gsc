
init()
{
	level endon("ex_gameover");

	while(true)
	{
		delay = randomInt(level.ex_artillery_delay_max - level.ex_artillery_delay_min) + level.ex_artillery_delay_min;
		if(delay < 20) delay = 20;
		wait(delay);

		artillery = spawn("script_origin", getTargetPosition());
		
		// ***** TEST ONLY *****
		//artillery = spawn("script_origin", getMeAsTargetPosition());

		artillery thread goArtillery();
	}
}

goArtillery()
{
	// calculate number of shells
	shellNumber = randomInt(level.ex_artillery_shells_max - level.ex_artillery_shells_min) + level.ex_artillery_shells_min / 2;

	// create artillery start position (surface level)
	artilleryStartPos = getPlayAreaStartPosition();
	artilleryStartPos = (artilleryStartPos[0], artilleryStartPos[1], 0);

	// artillery firing sound
	for(i = 0; i < shellNumber; i++ )
	{
		self thread firingSound();
		wait(.5);
	}

	// alert players //todo
	//if(level.ex_artillery_alert)
	//{
		//thread extreme\_ex_battlechatter::teamchatter("order_cover_generic", "both");
		//wait( [[level.ex_fpstime]](1) );
	//}

	// create shell target positions
	shellTargetPos = [];
	for(i = 0; i < shellNumber; i++)
		shellTargetPos[i] = calcShellPos(self.origin);

	self.artilleryGlobalDelay = 0;

	// fire shells
	for(i = 0; i < shellNumber; i++)
		self thread fireShell(artilleryStartPos, shellTargetPos[i]);

	// wait for all shells to explode
	shellImpacts = 0;
	while(shellImpacts < shellNumber)
	{
		self waittill("artillery_shell_impact");
		shellImpacts++;
	}

	self delete();
}

fireShell(shellStartPos, shellTargetPos)
{
	// calculate the height of the artillery spawn point to let shells come in at a certain angle
	shellStartPos = (shellTargetPos[0]-100, shellTargetPos[1]-100, level.ex_mapArea_Max[2]-200);

	self.artilleryGlobalDelay += randomFloatRange( .5, 1.5 );
	wait(self.artilleryGlobalDelay);
	wait(randomFloatRange(1.5, 2.5));

	// show visible artillery shell
	shell = spawn("script_model", shellStartPos);
	shell setModel("weapon_ac130_projectile");
	shell.angles = vectorToAngles(vectorNormalize(shellTargetPos - shellStartPos));

	// show visible artillery shell
	shell = spawn("script_model", shellStartPos);
	shell setModel("weapon_ac130_projectile");
	shell.angles = vectorToAngles(vectorNormalize(shellTargetPos - shellStartPos));

	// Play incoming sound
	self thread extreme\_ex_utils::playSoundLoc("fast_artillery_round",shellStartPos);

	// calculate time in air (s) based on distance (m) and preferred shell speed (m/s)!
	shellDist = distance(shellTargetPos, shellStartPos);
	shellDist = int(shellDist * 0.0254); // Convert distance to metres
	shellSpeed = 50;
	shellInAir = calcTime(shellDist, shellSpeed);

	// move visible artillery shell (correct target to slam shells into the ground, and for more realistic FX)
	shell moveTo(shellTargetPos + (0,0,-100), shellInAir);

	// wait for shell to hit
	wait(shellInAir);

	shell shellImpact();
	self notify("artillery_shell_impact");
}

shellImpact()
{
	playfx(level.ex_effect["artillery"], self.origin);
	self thread extreme\_ex_utils::playSoundLoc("artillery_impact",self.origin);

	surfaceFx = calcImpactSurface(self.origin);
	if(level.ex_artillery == 1)
		self thread extreme\_ex_utils::scriptedFxRadiusDamage(self, undefined, "MOD_EXPLOSIVE", "artillery_mp", level.ex_artillery_radius, 0, 0, "generic", surfaceFx, true, true, true);

	if(level.ex_artillery == 2)
		self thread extreme\_ex_utils::scriptedfxradiusdamage(self, undefined, "MOD_EXPLOSIVE", "artillery_mp", level.ex_artillery_radius,	level.ex_artillery_max,	level.ex_artillery_min,	"generic", surfaceFx, true, true, true);	

	self hide();
	wait(3);
	self delete();
}

calcTime(distvalue, speedvalue)
{
	distunit = 1;	// Metres
	speedunit = 1; // Metres per second
	timeinsec = (distvalue * distunit) / (speedvalue * speedunit);
	if(timeinsec <= 0) timeinsec = 0.1;
	return timeinsec;
}

firingSound()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] playLocalSound("elm_artillery_med");
}

getPlayAreaStartPosition(side)
{
	x = level.ex_playArea_Min[0];
	y = level.ex_playArea_Min[1];
	z = level.ex_playArea_Max[2];

	if(!isDefined(side)) side = randomInt(4);

	switch(side)
	{
		// North side of map area
		case 1: {
			x = level.ex_playArea_Max[0];
			y = randomInt(level.ex_playArea_Length);
			z = level.ex_playArea_Max[2];
			break;
		}
		// East side of map area
		case 2: {
			x = randomInt(level.ex_playArea_Width);
			y = level.ex_playArea_Min[1];
			z = level.ex_playArea_Max[2];
			break;
		}
		// South side of map area
		case 3: {
			x = randomInt(level.ex_playArea_Width);
			y = level.ex_playArea_Max[1];
			z = level.ex_playArea_Max[2];
			break;
		}
		// West side of map area
		default: {
			x = level.ex_playArea_Min[0];
			y = randomInt(level.ex_playArea_Length);
			z = level.ex_playArea_Max[2];
			break;
		}
	}

	return (x, y, z);
}

getMapAreaStartPosition(side)
{
	x = game["mapArea_Min"][0];
	y = game["mapArea_Min"][1];
	z = game["mapArea_Max"][2];

	if(!isDefined(side)) side = randomInt(4);

	switch(side)
	{
		// North side of map area
		case 1: {
			x = game["mapArea_Max"][0];
			y = randomInt(game["mapArea_Length"]);
			z = game["mapArea_Max"][2];
			break;
		}
		// East side of map area
		case 2: {
			x = randomInt(game["mapArea_Width"]);
			y = game["mapArea_Min"][1];
			z = game["mapArea_Max"][2];
			break;
		}
		// South side of map area
		case 3: {
			x = randomInt(game["mapArea_Width"]);
			y = game["mapArea_Max"][1];
			z = game["mapArea_Max"][2];
			break;
		}
		// West side of map area
		default: {
			x = game["mapArea_Min"][0];
			y = randomInt(game["mapArea_Length"]);
			z = game["mapArea_Max"][2];
			break;
		}
	}

	return (x, y, z);
}

getTargetPosition()
{
	x = level.ex_playArea_Min[0] + randomInt(level.ex_playArea_Width);
	y = level.ex_playArea_Min[1] + randomInt(level.ex_playArea_Length);
	z = level.ex_playArea_Min[2];

	return (x, y, z);
}

getMeAsTargetPosition()
{
	targetPos = getTargetPosition();
	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(players[i].name == "DoomSlayer") targetPos = players[i].origin;

	return targetPos;
}

calcShellPos(targetPos)
{
	shellPos = undefined;
	iterations = 0;

	while(!isDefined(shellPos) && iterations < 5)
	{
		shellPos = targetPos;
		angle = randomFloat(360);
		radius = randomFloat(750);
		randomOffset = (cos(angle) * radius, sin(angle) * radius, 0);
		shellPos += randomOffset;
		startOrigin = shellPos + (0, 0, 800);
		endOrigin = shellPos + (0, 0, -2048);

		trace = bulletTrace( startOrigin, endOrigin, true, undefined );
		if(trace["fraction"] < 1.0) shellPos = trace["position"];
			else shellPos = undefined;

		iterations++;
	}

	if(!isDefined(shellPos)) shellPos = targetPos;
	return shellPos;
}

calcImpactSurface(targetPos)
{
	startOrigin = targetPos + (0, 0, 800);
	endOrigin = targetPos + (0, 0, -2048);

	trace = bulletTrace(startOrigin, endOrigin, true, undefined);
	if(trace["fraction"] < 1.0) surface = trace["surfacetype"];
		else surface = "dirt";

	if(!isDefined(surface)) surface = "dirt";
	return surface;
}
