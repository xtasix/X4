

tracers()
{
	level endon("ex_gameover");

	ix = 0;
	iy = 0;
	iz = 0;

	wait randomInt(20) + 5;

	while(!level.ex_gameover)
	{
		//delay = level.ex_tracersdelaymin + randomint(level.ex_tracersdelaymax - level.ex_tracersdelaymin);
		//if(level.ex_flakison) delay = randomInt(2) + 1;
		//wait delay;
		
		delay = randomInt(level.ex_tracersdelaymax - level.ex_tracersdelaymin) + level.ex_tracersdelaymin;
		if(delay < 20) delay = 20;
		//if(level.ex_flakison) delay = randomInt(2) + 1;
		wait(delay);

		iSide = randomInt(4);
		switch (iSide)
		{
			case 0:
				ix = level.ex_mapArea_Min[0];
				iy = level.ex_mapArea_Min[1] + randomInt(int(level.ex_mapArea_Max[1] - level.ex_mapArea_Min[1]));
				break;
			case 1:
				ix = level.ex_mapArea_Max[0];
				iy = level.ex_mapArea_Min[1] + randomInt(int(level.ex_mapArea_Max[1] - level.ex_mapArea_Min[1]));
				break;
			case 2:
				ix = level.ex_mapArea_Min[0] + randomInt(int(level.ex_mapArea_Max[0] - level.ex_mapArea_Min[0]));
				iy = level.ex_mapArea_Min[1];
				break;
			case 3:
				ix = level.ex_mapArea_Min[0] + randomInt(int(level.ex_mapArea_Max[0] - level.ex_mapArea_Min[0]));
				iy = level.ex_mapArea_Max[1];
				break;
		}
			
		//set the height as the spawnpoint level - 100
		spawnpoints = getentarray("mp_dm_spawn", "classname");
		if(!spawnpoints.size) spawnpoints = getentarray("mp_tdm_spawn", "classname");
		if(!spawnpoints.size) spawnpoints = getentarray("mp_ctf_spawn_allied", "classname");
		if(!spawnpoints.size) spawnpoints = getentarray("mp_ctf_spawn_axis", "classname");
		if(!spawnpoints.size) spawnpoints = getentarray("mp_sd_spawn_attacker", "classname");
		if(!spawnpoints.size) spawnpoints = getentarray("mp_sd_spawn_defender", "classname");
		if(!spawnpoints.size) return;
		iz = spawnpoints[0].origin[2] - 100;

		pos = (ix, iy, iz);

		if(level.ex_tracers_sound)
		{
			tracer = spawn( "script_model", pos);
			wait 0.05;
			tracer playSound("elm_gunfire_50cal_dist"); 
			wait 0.5;
			playfx(level.ex_effect["tracer"], pos);
			wait 3;
			tracer delete();
		}
		else 
		{
			tracer = spawn( "script_model", pos);
			wait 0.05;
			playfx(level.ex_effect["tracer"], pos); 
			wait 5;
			tracer delete();
		}
	}
}

flakfx()
{
	level endon("ex_gameover");
	level endon("stop_flak");
	level.ex_flakison = true;

	while(level.ex_flakison)
	{
		// wait a random delay
		delay = level.ex_flakfxdelaymin + randomint(level.ex_flakfxdelaymax - level.ex_flakfxdelaymin);
		wait delay;

		if(!level.ex_flakfx)
		{
			if(!level.ex_axisapinsky && !level.ex_allieapinsky && !level.ex_paxisapinsky && !level.ex_pallieapinsky)
				level.ex_flakison = false;
		}
	
		// spawn object that is used to play sound
		flak = spawn ( "script_model", ( 0, 0, 0) );

		//get a random position
		xpos = level.ex_playArea_Min[0] + randomInt(level.ex_playArea_Width);
		ypos = level.ex_playArea_Min[1] + randomInt(level.ex_playArea_Length);
		zpos =  level.ex_mapArea_Max[2] - randomInt(100);	

		position = ( xpos, ypos, zpos);

		flak.origin = position;
		wait .05;
		
		// play effect
		flak playsound("elm_expl");

		playfx(level.ex_effect["flak_flash"], position);
		wait 0.25;
		playfx(level.ex_effect["flak_smoke"], position);
		wait 0.25;
		playfx(level.ex_effect["flak_dust"], position);
		wait 0.25;

		flak delete();
	}
}
