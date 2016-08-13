
init()
{
	if(isdefined(level.ex_modinfo_hud)) level.ex_modinfo_hud destroy();

	level.ex_modinfo_hud = newHudElem();
	level.ex_modinfo_hud.fontScale = 1.4;
  	level.ex_modinfo_hud.glowColor = ( 0.3, 0.6, 0.3 );	 //(0.2, 0.3, 0.7);
  	level.ex_modinfo_hud.glowAlpha = 1;
	if(level.hardcoreMode)
	{
		level.ex_modinfo_hud.alignX = "center";
		level.ex_modinfo_hud.alignY = "middle";
	}
	if(!level.hardcoreMode)
	{
		level.ex_modinfo_hud.alignX = "right";
		level.ex_modinfo_hud.alignY = "middle";
	}
	level.ex_modinfo_hud.horzAlign = "fullscreen";
	level.ex_modinfo_hud.vertAlign = "fullscreen";
	level.ex_modinfo_hud.alpha = 0;
	if(level.hardcoreMode)
	{
		level.ex_modinfo_hud.x = 330;
		level.ex_modinfo_hud.y = 472;
	}
	if(!level.hardcoreMode)
	{
		level.ex_modinfo_hud.x = 633;
		level.ex_modinfo_hud.y = 472;
	}

	ex_modtxt[0] = level.ex_mod_message_name; 		//&"MOD_MESSAGE_NAME";
	ex_modtxt[1] = level.ex_mod_message_by; 		//&"MOD_MESSAGE_BY";
	ex_modtxt[2] = level.ex_mod_message_website; 	//&"MOD_MESSAGE_WEBSITE";

	for(;;)
	{
		for(i = 0; i < 3; i++)
		{
			level.ex_modinfo_hud setText(ex_modtxt[i]);
			level.ex_modinfo_hud fadeOverTime(1);
			level.ex_modinfo_hud.alpha = 1;

			wait (5 * level.fps_multiplier);

			level.ex_modinfo_hud fadeOverTime(1);
			level.ex_modinfo_hud.alpha = 0;
			wait (1 * level.fps_multiplier);
		}

		wait (60 * level.fps_multiplier);
	}
}
