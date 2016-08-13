
init()
{
	level endon("ex_gameover");

	color = (1,1,0);
	deadcolor = (1,0,0);
	statalpha = 0.8;

	allies = 0;
	axis = 0;
	deadallies = 0;
	deadaxis = 0;

	switch(game["allies"])
	{
		case "sas":
			extreme["headicon_allies"] = "faction_128_sas";
			break;
		case "marines":
			extreme["headicon_allies"] = "faction_128_usmc";
			break;
		default:
			extreme["headicon_allies"] = "faction_128_usmc";
			break;
	}

	switch(game["axis"])
	{
		case "russian":
			extreme["headicon_axis"] = "faction_128_ussr";
			break;
		case "opfor":
			extreme["headicon_axis"] = "faction_128_arab";
			break;
		default:
			extreme["headicon_axis"] = "faction_128_arab";
			break;
	}
	
	precacheHeadIcon( extreme["headicon_allies"] );
	precacheHeadIcon( extreme["headicon_axis"] );

	while(!level.ex_gameover)
	{
		if(!isdefined(level.ex_alliesicon))
		{
			level.ex_alliesicon = newHudElem();
			level.ex_alliesicon.fontScale = 1.4;
			level.ex_alliesicon.alignX = "center";
			level.ex_alliesicon.alignY = "middle";
			level.ex_alliesicon.horzAlign = "fullscreen";
			level.ex_alliesicon.vertAlign = "fullscreen";
			level.ex_alliesicon.alpha = statalpha;
			level.ex_alliesicon.x = 576;
			level.ex_alliesicon.y = 20;
			level.ex_alliesicon setShader(extreme["headicon_allies"], 16, 16);
		}
		if(!isdefined(level.ex_alliesnumber))
		{
			level.ex_alliesnumber = newHudElem();
			level.ex_alliesnumber.fontScale = 1.4;
			level.ex_alliesnumber.alignX = "center";
			level.ex_alliesnumber.alignY = "middle";
			level.ex_alliesnumber.horzAlign = "fullscreen";
			level.ex_alliesnumber.vertAlign = "fullscreen";
			level.ex_alliesnumber.alpha = statalpha;
			level.ex_alliesnumber.x = 590;
			level.ex_alliesnumber.y = 20;
			level.ex_alliesnumber.color = color;
			level.ex_alliesnumber setValue(0);
		}
		else level.ex_alliesnumber setValue(allies);

		if(!isdefined(level.ex_deadalliesicon))
		{
			level.ex_deadalliesicon = newHudElem();
			level.ex_deadalliesicon.fontScale = 1.4;
			level.ex_deadalliesicon.alignX = "center";
			level.ex_deadalliesicon.alignY = "middle";
			level.ex_deadalliesicon.horzAlign = "fullscreen";
			level.ex_deadalliesicon.vertAlign = "fullscreen";
			level.ex_deadalliesicon.alpha = statalpha;
			level.ex_deadalliesicon.x = 576;
			level.ex_deadalliesicon.y = 45;
			level.ex_deadalliesicon setShader("hud_status_dead", 16, 16);
		}
		if(!isdefined(level.ex_deadalliesnumber))
		{
			level.ex_deadalliesnumber = newHudElem();
			level.ex_deadalliesnumber.fontScale = 1.4;
			level.ex_deadalliesnumber.alignX = "center";
			level.ex_deadalliesnumber.alignY = "middle";
			level.ex_deadalliesnumber.horzAlign = "fullscreen";
			level.ex_deadalliesnumber.vertAlign = "fullscreen";
			level.ex_deadalliesnumber.alpha = statalpha;
			level.ex_deadalliesnumber.x = 590;
			level.ex_deadalliesnumber.y = 45;
			level.ex_deadalliesnumber.color = deadcolor;
			level.ex_deadalliesnumber setValue(0);
		}
		else level.ex_deadalliesnumber setValue(deadallies);

		if(!isdefined(level.ex_axisicon))
		{
			level.ex_axisicon = newHudElem();
			level.ex_axisicon.fontScale = 1.4;
			level.ex_axisicon.alignX = "center";
			level.ex_axisicon.alignY = "middle";
			level.ex_axisicon.horzAlign = "fullscreen";
			level.ex_axisicon.vertAlign = "fullscreen";
			level.ex_axisicon.alpha = statalpha;
			level.ex_axisicon.x = 616;
			level.ex_axisicon.y = 20;
			level.ex_axisicon setShader(extreme["headicon_axis"], 16, 16);
		}
		if(!isdefined(level.ex_axisnumber))
		{
			level.ex_axisnumber = newHudElem();
			level.ex_axisnumber.fontScale = 1.4;
			level.ex_axisnumber.alignX = "center";
			level.ex_axisnumber.alignY = "middle";
			level.ex_axisnumber.horzAlign = "fullscreen";
			level.ex_axisnumber.vertAlign = "fullscreen";
			level.ex_axisnumber.alpha = statalpha;
			level.ex_axisnumber.x = 630;
			level.ex_axisnumber.y = 20;
			level.ex_axisnumber.color = color;
			level.ex_axisnumber setValue(0);
		}
		else level.ex_axisnumber setValue(axis);

		if(!isdefined(level.ex_deadaxisicon))
		{
			level.ex_deadaxisicon = newHudElem();
			level.ex_deadaxisicon.fontScale = 1.4;
			level.ex_deadaxisicon.alignX = "center";
			level.ex_deadaxisicon.alignY = "middle";
			level.ex_deadaxisicon.horzAlign = "fullscreen";
			level.ex_deadaxisicon.vertAlign = "fullscreen";
			level.ex_deadaxisicon.alpha = statalpha;
			level.ex_deadaxisicon.x = 616;
			level.ex_deadaxisicon.y = 45;
			level.ex_deadaxisicon setShader("hud_status_dead", 16, 16);
		}
		if(!isdefined(level.ex_deadaxisnumber))
		{
			level.ex_deadaxisnumber = newHudElem();
			level.ex_deadaxisnumber.fontScale = 1.4;
			level.ex_deadaxisnumber.alignX = "center";
			level.ex_deadaxisnumber.alignY = "middle";
			level.ex_deadaxisnumber.horzAlign = "fullscreen";
			level.ex_deadaxisnumber.vertAlign = "fullscreen";
			level.ex_deadaxisnumber.alpha = statalpha;
			level.ex_deadaxisnumber.x = 630;
			level.ex_deadaxisnumber.y = 45;
			level.ex_deadaxisnumber.color = deadcolor;
			level.ex_deadaxisnumber setValue(0);
		}
		else level.ex_deadaxisnumber setValue(deadaxis);

		allies = 0;
		axis = 0;
		deadallies = 0;
		deadaxis = 0;
		
		for(i = 0; i < level.players.size; i++)
		{
			if(isPlayer(level.players[i]))
			{
				player = level.players[i];

				if(!isDefined(player.pers["team"])) continue;
					else if(player.pers["team"] == "spectator") continue;

				if(player.sessionstate == "playing")
				{
					if(player.pers["team"] == "allies") allies++;
						else axis++;
				}
				else
				{
					if(player.pers["team"] == "allies") deadallies++;
						else deadaxis++;
				}
			}
		}

		wait 0.25;
	}
}
