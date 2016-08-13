// SV_FPS FIX CODE BY BULLETWORM

init()
{
	setMultiplier();
	// level thread testFrames();
}


monitorFPS()
{
	old_fps = getDvarInt("sv_fps");

	while (1)
	{
		wait 5;

		fps = getDvarInt("sv_fps");

		if (fps != old_fps)
		{
			if (fps == 20 || fps == 25 || fps == 30)
			{
				setMultiplier();
				old_fps = fps;
				thread updateClientSnaps(fps);
			}
			else setDvar("sv_fps", old_fps);
		}
	}
}

updateClientSnaps(snaps)
{
	players = level.players;
	for(i = 0; i < players.size; i++)
		players[i] setClientDvar("snaps", snaps );
}

setMultiplier(fps)
{
	if(!isDefined(fps)) fps = getDvarInt("sv_fps");

	if (fps == 30)
	{
		level.fps_multiplier = 1.51382;
		level.frame = .033;
	}
	else if (fps == 25)
	{
		level.fps_multiplier = 1.26110;
		level.frame = .039;
	}
	else
	{
		fps = 20;
		level.fps_multiplier = 1.0;
		level.frame = .05;
		setDvar("sv_fps", fps);
	}
}

/*
testFrames()
{
	level.running = 0;
	count = 0;
	timer = 0;
	active = 1;

	while (!level.running)
		wait .01;

	while (active)
	{
		if (level.running)
		{
			count = count + 1;
			timer = timer + 1;
		}

		if (timer == 100)
		{
			iprintln("Current Count: " + count);
			timer = 0;
		}

		if (!level.running)
		{
			iprintln("Total Count: " + count);
			active = 0;
		}

		wait .01;
	}
}
*/
