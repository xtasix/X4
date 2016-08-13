

init()
{
	level endon("ex_stop_ambient_fx");

	lastapteam = 2;		// set to 2 so it won't run the first time

	while(!level.ex_gameover)
	{
		wait 1; // avoid infinite loop error on continue

		players = getentarray("player", "classname");
		if(players.size == 0) continue;

		delay = (randomInt(level.ex_planes_delay_max - level.ex_planes_delay_min) + level.ex_planes_delay_min) - 10;
		if(delay < 10) delay = 10;
		
		wait(delay / 3);

		if(level.ex_planes_flak && level.ex_flakison)
		{
			level notify("stop_flak");
			level.ex_flakison = false;
		}

		wait((delay / 3) * 1.5);

		// set up plane amount (normal)
		apcount = randomInt(level.ex_planes_max - level.ex_planes_min) + level.ex_planes_min;
		apflangle = randomInt(360);

		// pick a plane team at random		
		if(randomInt(100) < 50) apteam = 0;
			else apteam = 1;

		// keep it balanced for teamplay
		if(level.ex_teamplay)
		{
			if(lastapteam != 2)
			{
				if(lastapteam == apteam)
				{
					if(apteam == 0) apteam = 1;
						else apteam = 0;
				}
			}
		}

		// set team definition
		if(apteam == 0) level.apteam = "axis";
			else level.apteam = "allies";

		// set planes in sky values
		if(apteam == 0) level.ex_allieapinsky += apcount;
			else level.ex_axisapinsky += apcount;
				
		apstpoint = [];
		apenpoint = [];
		apposinmap = [];

		if(level.ex_air_raid_global) thread extreme\_ex_utils::playSoundLoc("air_raid",(0,0,0));
		
		if(level.ex_planes_flak && !level.ex_flakison)
		{
			for(flak = 0; flak < level.ex_flakfx; flak++)
				thread extreme\_ex_ambient_skyeffects::flakfx();

			wait 5;
		}
			
		self.airplanesGlobalDelay = 0;

		for(i = 0; i < apcount; i++)
		{
			if(randomInt(100) < 30)
			{
				x = level.ex_playArea_Max[0] + randomInt(level.ex_playArea_Width);
				y = level.ex_playArea_Max[1] + randomInt(level.ex_playArea_Length);
			}
			else
			{
				x = level.ex_playArea_Min[0] + randomInt(level.ex_playArea_Width);
				y = level.ex_playArea_Min[1] + randomInt(level.ex_playArea_Length);
			}

			z = level.ex_mapArea_Max[2] - randomint(150);
			if(level.ex_planes_altitude && (level.ex_planes_altitude <= z))
				z = level.ex_planes_altitude;

			stenpos = getPlaneStartEnd( (x,y,z), apflangle );
			stenpos2 = getPlaneStartEnd( (stenpos[1]), apflangle );
			if(stenpos2[2] == 1) stenpos[1] = stenpos2[1];

			apstpoint[i] = stenpos[0];
			apenpoint[i] = stenpos[1];
			apposinmap[i] = (x,y,z);

			// create the plane
			thread planestart(apflangle, apstpoint[i], apenpoint[i], apteam, apposinmap[i]);
		}

		for(i = 0; i < apcount; i++)
			level waittill("ambplane_finished");

		// check for teamplay to keep things even
		if(level.ex_teamplay) lastapteam = apteam;
	}
}

planestart(apflangle, apstpoint, apenpoint, apteam, apposinmap)
{
	self.airplanesGlobalDelay += randomFloatRange( 2, 5 );
	wait(self.airplanesGlobalDelay);

	apmodel = [];
	apsoundchoice = [];


	if(apteam == 0)
	{
		// plane models
		apmodel[0] = "vehicle_mig29_desert";
		apmodel[1] = "vehicle_mig29_desert";

		// plane sounds
		apsoundchoice[0] = "veh_mig29_dist_loop";
		apsoundchoice[1] = "veh_mig29_dist_loop";
	}
	else
	{

		// plane models
		apmodel[0] = "vehicle_mig29_desert"; 
		apmodel[1] = "vehicle_mig29_desert"; 

		// plane sounds
		apsoundchoice[0] = "veh_mig29_dist_loop";	
	}
	
	aprand = randomInt(apmodel.size);
	apsound = apsoundchoice[randomInt(apsoundchoice.size)];

	planetype = 0; // fighter
	if(apteam == 0 && aprand == 1) planetype = 1; // axis bomber
		else if(apteam == 1 && aprand == 2) planetype = 1; // allies bomber

	plane = spawn("script_model", apstpoint);
	plane setModel(apmodel[aprand]);
	if(apteam == 1 && aprand == 2)
	{
		plane.angles = plane.angles + (0, apflangle, 0);
		plane rotateyaw(90, .1);
	}
	else if(apteam == 0 && aprand == 0) plane.angles = plane.angles + (10, apflangle, 0);
		else plane.angles = plane.angles + (0, apflangle, 0);
			
	if(apteam == 0) plane spawnmig29bomberFx();  
	if(apteam == 1) plane spawnmig29fighterFx(); 

	plane.apdivesound = spawn("script_model", (0,0,0));
	plane.apdivesound.origin = apstpoint - (0,50,0);
	plane.apdivesound linkto(plane);

	plane.apsound = spawn("script_model", (0,0,0));
	plane.apsound.origin = apstpoint - (0,50,0);
	plane.apsound linkto(plane);
	plane.apsound playloopsound(apsound);

	// set speed
	if(planetype == 0) apspeed = 40; // fighters //!ATTN do not turn up or lower the speed on planes will effect planes they will not crash in the map and will not brop bombs in the map
		else apspeed = 30; // bombers //!ATTN do not turn up or lower the speed on planes will effect planes they will not crash in the map and will not brop bombs in the map

	// flighttime
	flighttime = calcTime(apstpoint, apenpoint, apspeed);
	plane moveto(apenpoint, flighttime);

	plane.isbombing = false;
	// 10% chance plane will crash, but
	// - only fighters, because memphis has axis mixed up (and I'm too lazy to include the other bomber)
	// - only if there weren't enough crashes already (4 max)
	planecrash = false;
	if(randomInt(100) < 10 && level.ex_planescrashed < 6 && planetype == 0) planecrash = true;

	for(i = 0; i < ((flighttime/3)*2); i += 0.1)
	{
		if(!plane.isbombing && level.ex_planes >= 2 && planetype == 1 && (distance(apposinmap, plane.origin) < 1000) )
		{
			plane thread bombsetup();
			plane.isbombing = true;
		}

		if(planecrash && !plane.isbombing && (distance(level.ex_playArea_Centre, plane.origin) < 3000) )
		{
			plane thread airplanecrash(apspeed+10, apteam);
			return;
		}
		wait(0.1);
	}

	// has survived?, victory roll for fighters and bank for bombers but not every time!
	rolltime = flighttime/3;
	if(!rolltime <= 0)
	{
		if(planetype == 0)
		{
			switch(randomInt(5))
			{
				case 0:	{ plane rotateroll(360,rolltime,rolltime/2,rolltime/2); break; }
				case 1: { plane rotateroll(-360,rolltime,rolltime/2,rolltime/2); break; }
				default: break;
			}
		}
	}
	wait rolltime;

	if(isdefined(plane.apsound))
	{
		plane.apsound stopLoopSound();
		plane.apsound delete();
	}

	if(isdefined(plane.apdivesound))
	{
		plane.apdivesound stopLoopSound();
		plane.apdivesound delete();
	}

	if(apteam == 0) level.ex_axisapinsky--;
		else level.ex_allieapinsky--;

	if(isdefined(plane)) plane delete();
	level notify("ambplane_finished");
}

spawnmig29bomberFx()
{
	self endon("ex_gameover");
	self endon("ex_stop_ambient_fx");
	
	wait .07;
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_right" );
	wait .07;
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_left" );
	wait .07;
	playfxontag( level.fx_heli_green_blink, self, "tag_left_wingtip" );
	wait .07;
	playfxontag( level.fx_heli_green_blink, self, "tag_right_wingtip" );
	
}

spawnmig29fighterFx()
{
	self endon("ex_gameover");
	self endon("ex_stop_ambient_fx");
	
	wait .07;
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_right" );
	wait .07;
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_left" );
	
}
// bomb routines
bombsetup()
{
	wait randomInt(2) + .5;

	bombcount = 0;
	bombno = randomInt(3) + 4; 

	while(bombcount < bombno)
	{
		self thread dropabomb();
		bombcount++;
		wait 0.2;
	}
}

dropabomb(generic, surfaceFx)
{
	if(!isdefined(self)) return;

	x = self.origin[0];
	y = self.origin[1];
	z = self.origin[2];

	startpoint = self.origin;
	forwardvector = anglestoforward(self.angles);
	endorigin = startpoint + ([[level.ex_vectormulti]](forwardvector,360));

	// get the impact point
	trace = bulletTrace(startpoint,(endorigin[0],endorigin[1],endorigin[2] - 2048), false, self);
	if(trace["fraction"] < 1) endorigin = trace["position"];
		else return; // if no proper position then skip the bomb

	// bomb falltime
	falltime = calcTime(startpoint, endorigin, 20);
	//if(falltime < 0.5) return; // abort

	// spawn the bomb and drop it
	bomb = spawn("script_model", startpoint);
	bomb.angles = self.angles + (50 + randomint(50),0,0);
	bomb setModel("projectile_cbu97_clusterbomb");
	bomb moveto(endorigin + (0,0, - 100), falltime);
		bomb moveto(endorigin, falltime);

	// play the incoming sound falling sound
	bombsfx[0] = "fast_artillery_round";
	bombsfx[1] = "fast_artillery_round";
	bombsfx[2] = "fast_artillery_round";
	bombsfx[3] = "fast_artillery_round";
	bombsfx[4] = "fast_artillery_round";
	bs = randomInt(bombsfx.size);
	bomb playsound(bombsfx[bs]);

	// wait for it to hit
	wait falltime;

	// do the damage
	if(level.ex_planes == 2)
		bomb thread extreme\_ex_utils::scriptedfxradiusdamage(bomb, undefined, "MOD_EXPLOSIVE", "airstrike_mp", level.ex_planebomb_radius, 0, 0, "generic", surfaceFx, true, true, true);

	if(level.ex_planes == 3)
		bomb thread extreme\_ex_utils::scriptedfxradiusdamage(bomb, undefined, "MOD_EXPLOSIVE", "airstrike_mp", level.ex_planebomb_radius, level.ex_planes_bombmax, level.ex_planes_bombmin, "generic", surfaceFx, true, true, true);

	// play the explosion sound
	bombsfx[0] = "artillery_impact";
	bombsfx[1] = "artillery_impact";
	bombsfx[2] = "artillery_impact";
	bombsfx[3] = "artillery_impact";
	bombsfx[4] = "artillery_impact";
	bs = randomInt(bombsfx.size);
	bomb playsound(bombsfx[bs]);
	
	playfx(level.ex_effect["artillery"], bomb.origin);

	bomb hide();
	wait 1;
	bomb delete();
}

getPlaneStartEnd(targetpos, angle)
{
	forwardvector = anglestoforward( (0, angle, 0) );
	backpos = targetpos + ([[level.ex_vectormulti]](forwardvector, -30000));
	frontpos = targetpos + ([[level.ex_vectormulti]](forwardvector, 30000));
	fronthit = 0;

	trace = bulletTrace(targetpos, backpos, false, undefined);
	if(trace["fraction"] != 1) start = trace["position"];
		else start = backpos;

	trace = bulletTrace(targetpos, frontpos, false, undefined);
	if(trace["fraction"] != 1)
	{
		endpoint = trace["position"];
		fronthit = 1;
	}
	else endpoint = frontpos;

	startpos = start + ([[level.ex_vectormulti]](forwardvector, -3000));
	endpoint = endpoint + ([[level.ex_vectormulti]](forwardvector, 3000));
	stenpos[0] = startpos;
	stenpos[1] = endpoint;
	stenpos[2] = fronthit;
	return stenpos;
}

calcTime(startpos, endpos, speedvalue)
{
	distunit = 1;	// Metres
	speedunit = 1; // Metres per second
	distvalue = distance(startpos, endpos);
	distvalue = int(distvalue * 0.0254); // convert to metres
	timeinsec = (distvalue * distunit) / (speedvalue * speedunit);
	if(timeinsec <= 0) timeinsec = 0.1;
	return timeinsec;
}

airplanecrash(speed, apteam, generic, surfaceFx)
{
	level.ex_planescrashed++;

	playfx(level.ex_effect["flak_flash"], self.origin - (0, 200, 0));
	self playsound("elm_expl");
	wait 0.2;
	playfx(level.ex_effect["flak_smoke"], self.origin - (0, 200, 0));
	wait 0.2;
	playfx(level.ex_effect["flak_dust"], self.origin - (0, 200, 0));
	wait 0.05;
	playfx(level.ex_effect["plane_smoke"], self.origin);
	wait 0.05;
	self.apdivesound playloopsound("plane_dive");
	playfx(level.ex_effect["plane_explosion"], self.origin);
	self playsound("elm_expl");
		wait 0.5;
	playfx(level.ex_effect["plane_explosion"], self.origin);
	self.fire = 0;
	if(randomInt(100) > 50) self.fire = 1;

	angle = self.angles;
	pitch = randomInt(25) + 25;
	yaw = randomInt(50) - 25;
	roll = 200 - randomInt(400);
	angle_start = angle + (pitch,yaw,0);
	forwardvector = anglestoforward(angle_start);

	endpoint = self.origin + ([[level.ex_vectormulti]](forwardvector,30000));
	trace=bulletTrace(self.origin,endpoint, true, undefined);
	if(trace["fraction"] < 1 && trace["position"][2] > level.ex_mapArea_Min[2] - 500) endpoint = trace["position"];
	else endpoint = self.origin + ([[level.ex_vectormulti]](forwardvector,100));

	falltime = calcTime(self.origin, endpoint, speed);
	rotdone = "notdone";

	if(falltime > 1)
	{
		start_turn = 0;

		self moveto(endpoint,falltime);

		np = (pitch/(0.5/0.05));
		ny = (yaw/(0.5/0.05));
		nr = (roll/(falltime/0.05));

		for(i=0;i<falltime;i+=0.05)
		{
			if(i <= 0.5)
			{
				self.angles += (np,0,0);
				self.angles += (0,ny,0);
				self.angles += (0,0,nr);
			}
			else if(start_turn == 0)
			{
				start_turn = 1;
				self.angles += (0,0,nr);
			}

			playfx(level.ex_effect["plane_smoke"], self.origin);

			if(self.fire == 1) playfx(level.ex_effect["plane_smoke"], self.origin);

			wait 0.05;
		}
	}

	wait 0.05;

	self stoploopsound();

	if(isdefined(self.apsound))
	{
		self.apsound stopLoopSound();
		self.apsound delete();
	}

	if(isdefined(self.apdivesound))
	{
		self.apdivesound stopLoopSound();
		self.apdivesound delete();
	}

	// explosions
	hm = randomInt(2) + 1; // how many explosions, at least 1

	for(i = 0; i < 2;i++)
	{
		for(exp=0; exp < hm; exp++)
		{
			// play the incoming falling sound
			planecrashsfx[0] = "elm_expl";
			planecrashsfx[1] = "elm_expl";
			planecrashsfx[2] = "elm_expl";
			pc = randomInt(planecrashsfx.size);
			self playsound(planecrashsfx[pc]);

			// do the damage
			if(level.ex_planes == 3)
				self thread extreme\_ex_utils::scriptedfxradiusdamage(self, undefined, "MOD_EXPLOSIVE", "planecrash_mp", level.ex_planecrash_radius, 500, 400, "generic", surfaceFx, true, true, true); 
	
			playfx(level.ex_effect["plane_smoke"], self.origin);
			playfx(level.ex_effect["artillery"],self.origin);
			self thread extreme\_ex_utils::playSoundLoc("car_explode",self.origin);
	
			if(exp != 2)
			{
				wait 0.3;
				wait randomFloat(1);
			}
			else
			{
				wait 0.3;
				wait randomFloat(2);
			}
		}
	}

	if(apteam == 0) level.ex_axisapinsky--;
		else level.ex_allieapinsky--;

	self planeCrashSmokeFX();
	self blowtheplane();
	level notify("ambplane_finished");
}

planeCrashSmokeFX()
{
	self thread extreme\_ex_utils::hotSpot(self.origin, 120, "MOD_EXPLOSIVE", "plane_mp");

	for(i = 0; i < 25; i++)
	{
		playfx(level.ex_effect["planecrash_fire"], self.origin);
		wait 0.5;
		
	}
	self notify("endhotspot");
	thread planeCrashDelayedSmokeFX(self.origin);
}

planeCrashDelayedSmokeFX(position)
{
	for(i = 0; i < 25; i++)
	{
		playfx(level.ex_effect["planecrash_smoke"], position);
		wait 0.5;
		
	}
}

blowtheplane()
{
	wait 80;
	playfx(level.ex_effect["planeblow"], self.origin); 
	self playsound("hind_helicopter_crash");
	self thread extreme\_ex_utils::scriptedfxradiusdamage(self, undefined, "MOD_EXPLOSIVE", "planecrash_mp", level.ex_planecrash_radius, 0, 0, "explosion_dirt", undefined, true, true, true);  //todo add damage next version =)
	self hide();
	self delete();
}