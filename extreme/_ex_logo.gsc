
varcache()
{
	level.ex_logo = [[level.ex_dvardef]]("ex_logo", 1, 0, 1, "int");
	level.ex_logo_posx = [[level.ex_dvardef]]("ex_logo_posx", 600, 0, 640, "int");
	level.ex_logo_posy = [[level.ex_dvardef]]("ex_logo_posy", 120, 0, 480, "int");
	level.ex_logo_sizex = [[level.ex_dvardef]]("ex_logo_sizex", 80, 0, 512, "int");
	level.ex_logo_sizey = [[level.ex_dvardef]]("ex_logo_sizey", 80, 0, 512, "int");
	level.ex_logo_transp = [[level.ex_dvardef]]("ex_logo_transp", 0, 0, 9, "int");
	level.ex_logo_looptime = [[level.ex_dvardef]]("ex_logo_looptime", 120, 0, 3600, "int");
	level.ex_logo_fadewait = [[level.ex_dvardef]]("ex_logo_fadewait", 10, 0, 3600, "int");

	if(level.ex_logo) precacheShader("clanlogo");
}

init()
{
	if(level.ex_logo)
	{
		level.ex_logo_active = true;
		level thread logoMonitor();
		level thread logoShow();
	}
}

logoMonitor()
{
	level waittill("ex_gameover");
	level.ex_logo_active = false;
}

logoShow()
{
	if(!isDefined(level.logo_img))
	{
		level.logo_img = newHudElem();
		level.logo_img.alignX = "center";
		level.logo_img.alignY = "middle";
		level.logo_img.horzAlign = "fullscreen";
		level.logo_img.vertAlign = "fullscreen";
		level.logo_img.x = level.ex_logo_posx;
		level.logo_img.y = level.ex_logo_posy;
		level.logo_img.archived = false;
		level.logo_img.sort = 3;
		level.logo_img.alpha = 0;
		level.logo_img setShader("clanlogo", level.ex_logo_sizex, level.ex_logo_sizey);
	}

	// Initial fixed pause
	logoWait(20);

	if(!level.ex_logo_looptime)
	{
		if(isDefined(level.logo_img))
			level.logo_img.alpha = 1 - (level.ex_logo_transp / 10);
	}

	// Loop until the LogoMonitor signals it to end (regardless of fading effects)
	while(level.ex_logo_active)
	{
		wait(1 * level.fps_multiplier);
		
		if(level.ex_logo_looptime)
		{
			// Fade in
			if(isdefined(level.logo_img))
			{
				level.logo_img fadeOverTime(2);
				level.logo_img.alpha = 1 - (level.ex_logo_transp / 10);
			}

			// Wait before fading out again
			logoWait(level.ex_logo_fadewait);

			// Fade out
			if(isdefined(level.logo_img))
			{
				level.logo_img fadeOverTime(2);
				level.logo_img.alpha = 0;
			}

			// Wait (before fading in again)
			logoWait(level.ex_logo_looptime);
		}
	}

	if(isDefined(level.logo_img)) level.logo_img destroy();
}

logoWait(seconds)
{
	for(i = 0; i < seconds; i++)
	{
		if(level.ex_logo_active) wait(1 * level.fps_multiplier);
			else break;
	}
}
