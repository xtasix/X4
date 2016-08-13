
getgtstring(gt)
{
	switch(gt)
	{
		case "dm":
			gtstring = &"MAPS_DEATHMATCH";
			break;
		case "dom":
			gtstring = &"MAPS_DOMINATION";
			break;			
		case "koth":
			gtstring = &"MAPS_KING_OF_THE_HILL";
			break;
		case "sab":
			gtstring = &"MAPS_SABOTAGE";
			break;
		case "sd":
			gtstring = &"MAPS_SEARCH_AND_DESTROY";
			break;
		case "war":
			gtstring = &"MAPS_TEAM_DEATHMATCH";
			break;
		case "ctf":
			gtstring = &"MAPS_CAPTURE_THE_FLAG";
			break;	
		case "ctfb":
			gtstring = &"MAPS_CAPTURE_THE_FLAG_BACK";
			break;
		case "htf":
			gtstring = &"MAPS_HOLD_THE_FLAG";
			break;
		default:
			gtstring = gt;
			break;
	}

	return gtstring;
}

getgtstringshort(gt)
{
	switch(gt)
	{
		case "dm":
			gtstring = &"MAPS_DM";
			break;
		case "dom":
			gtstring = &"MAPS_DOM";
			break;
		case "koth":
			gtstring = &"MAPS_KOTH";
			break;
		case "sab":
			gtstring = &"MAPS_SAB";
			break;
		case "sd":
			gtstring = &"MAPS_SD";
			break;
		case "war":
			gtstring = &"MAPS_WAR";
			break;
		case "ctf":
			gtstring = &"MAPS_CTF";
			break;
		case "ctfb":
			gtstring = &"MAPS_CTFB";
			break;
		case "htf":
			gtstring = &"MAPS_HTF";
			break;
		default:
			gtstring = gt;
			break;
	}

	return gtstring;
}

getmapstring(map)
{
	mapstring = level.ex_maps[0].loclname;

	for(i = 0; i < level.ex_maps.size; i++)
	{
		if(level.ex_maps[i].mapname == map)
		mapstring = level.ex_maps[i].loclname;
	}
	return mapstring;
}

old_getmapstring(map)
{
	level.msc = undefined;
	
	switch(map)
	{
		// Stock maps
		case "mp_backlot":	 mapstring = &"MPUI_BACKLOT"; break;
		case "mp_bloc":		mapstring = &"MPUI_BLOC"; break;
		case "mp_bog":		 mapstring = &"MPUI_BOG"; break;
		case "mp_broadcast":   mapstring = &"MAPS_BROADCAST"; break;  // Yes, in MAPS.str
		case "mp_carentan":	mapstring = &"MAPS_CARENTAN"; break;  // Yes, in MAPS.str
		case "mp_cargoship":   mapstring = &"MPUI_CARGOSHIP"; break;
		case "mp_citystreets": mapstring = &"MPUI_CITYSTREETS"; break;
		case "mp_convoy":	  mapstring = &"MPUI_CONVOY"; break;
		case "mp_countdown":   mapstring = &"MPUI_COUNTDOWN"; break;
		case "mp_crash":	   mapstring = &"MPUI_CRASH"; break;
		case "mp_crash_snow":  mapstring = &"MAPS_CRASH_SNOW"; break; // Yes, in MAPS.str
		case "mp_creek":	   mapstring = &"MAPS_CREEK"; break;  // Yes, in MAPS.str
		case "mp_crossfire":   mapstring = &"MPUI_CROSSFIRE"; break;
		case "mp_farm":		mapstring = &"MPUI_FARM"; break;
		case "mp_killhouse":   mapstring = &"MAPS_KILLHOUSE"; break;  // Yes, in MAPS.str
		case "mp_overgrown":   mapstring = &"MPUI_OVERGROWN"; break;
		case "mp_pipeline":	mapstring = &"MPUI_PIPELINE"; break;
		case "mp_shipment":	mapstring = &"MPUI_SHIPMENT"; break;
		case "mp_showdown":	mapstring = &"MPUI_SHOWDOWN"; break;
		case "mp_strike":	  mapstring = &"MPUI_STRIKE"; break;
		case "mp_vacant":	  mapstring = &"MPUI_VACANT"; break;
		default: mapstring = map; break;
	}

	return mapstring;
}

trim(s)
{
	if(s == "") return "";

	s2="";
	s3="";

	i = 0;
	while(i < s.size && s[i] == " ") i++;

	// String is just blanks?
	if(i == s.size) return "";

	for(; i < s.size; i++) s2 += s[i];

	i = s2.size - 1;
	while(s2[i] == " " && i > 0) i--;

	for(j = 0; j <= i; j++) s3 += s2[j];

	return s3;
}

displayMapRotation()
{
	level endon("ex_gameover");

	msgText = &"MAPROTATION_NORMAL";
	if(level.ex_randommaprotation) msgText = &"MAPROTATION_RANDOM";
	if(level.ex_pbrotate) msgText = &"MAPROTATION_PLAYER";
	if(level.ex_mapvote) msgText = &"MAPROTATION_VOTING";

	iprintln(level.ex_servername, msgText);

	if(level.ex_mapvote) return;

	GetMapRotation();
	sGametype = getgtstring(level.MapRotation[0]["gametype"]);
	sMapname = getmapstring(level.MapRotation[0]["map"]);

	if(level.ex_servermsg_info >= 1)
	{
		msgLabel = sMapname;
		msgText = &"MAPROTATION_NEXT_MAP";
		mapAnnounce(msgLabel, msgText, 2);
	}
	
	if(level.ex_servermsg_info >= 2)
	{
		if(IsCustomMap(level.MapRotation[0]["map"]))
			mapAnnounce(&"MAPROTATION_CUSTOM_NEXT", undefined, 2);
	
		msgLabel = &"MAPROTATION_NEXT_GT";
		msgText = sGametype;
		mapAnnounce(msgLabel, msgText, 2);
	}

	// if no map rotation display, end here!
	if(!level.ex_servermsg_rotation) return;

	mapAnnounce(&"MAPROTATION_TITLE", undefined, 2);

	for(i = 0; i < level.MapRotation.size; i++)
	{
		sMapname = getmapstring(level.MapRotation[i]["map"]);
		sGametype = getgtstringshort(level.MapRotation[i]["gametype"]);
		bCustom = IsCustomMap(level.MapRotation[i]["map"]);

		msgLabel = sMapname;
		msgText = sGametype;
		mapAnnounce(msgLabel, msgText, 1.5, bCustom);
	}
}

mapAnnounce(msgLabel, msgText, delay, custom)
{
	if(!isDefined(delay)) delay = 2;
	if(!isDefined(custom) || !custom) color = (1, 1, 1);
	  else color = (0, 1, 0);

	if(!isDefined(level.ex_mapannouncer))
	{
		level.ex_mapannouncer = newHudElem();
		level.ex_mapannouncer.alignX = "left";
		level.ex_mapannouncer.alignY = "middle";
		level.ex_mapannouncer.horzAlign = "fullscreen";
		level.ex_mapannouncer.vertAlign = "fullscreen";
		if(level.hardcoreMode)
		{
			level.ex_mapannouncer.x = 50;
			level.ex_mapannouncer.y = 472;
		}
		if(!level.hardcoreMode)
		{
			level.ex_mapannouncer.x = 5;
			level.ex_mapannouncer.y = 472;
		}
		level.ex_mapannouncer.fontscale = 1.4;
	}

	level.ex_mapannouncer.color = color;
	level.ex_mapannouncer.label = msgLabel;
	if(isDefined(msgText)) level.ex_mapannouncer setText(msgText);
	wait delay;

	if(isDefined(level.ex_mapannouncer))
	{
		level.ex_mapannouncer fadeOverTime(.5);
		level.ex_mapannouncer.alpha = 0;
		wait .5;
	}

	if(isDefined(level.ex_mapannouncer)) level.ex_mapannouncer destroy();
}

GetMapRotation()
{
	// clean up old array
	if(isDefined(level.MapRotation)) level.MapRotation = undefined;

	// get the full rotation string
	maprot = trim(getDvar("sv_maprotation"));

	// convert to array of strings
	maprotarray = strtok(maprot, " ");

	// now build a proper array out of this mess
	sGametype = getDvar("g_gametype");
	arraypos = 0;
	mapnum = 0;

	TempMapRotation = [];
	
	while(arraypos < maprotarray.size)
	{
		if(maprotarray[arraypos] == "gametype")
		{
			// found in array string "gametype type map mapname"
			sGametype = maprotarray[arraypos + 1];
			TempMapRotation[mapnum]["gametype"] = maprotarray[arraypos + 1];
			TempMapRotation[mapnum]["map"] = maprotarray[arraypos + 3];
			arraypos = arraypos + 4;
		}
		else
		{
			// no gametype so presumably just a map "map mapname"
			TempMapRotation[mapnum]["gametype"] = sGametype;
			TempMapRotation[mapnum]["map"] = maprotarray[arraypos + 1];
			arraypos = arraypos + 2;
		}

		mapnum++;
	}

	// locate the current map
	for(i = 0; i < TempMapRotation.size; i++)
	{
	  if(TempMapRotation[i]["gametype"] == level.ex_currentgt && TempMapRotation[i]["map"] == level.ex_currentmap)
		break;
	}

	// now build the final array - first next map in line to the end of array
	mapnum = 0;
	for(j = i+1; j < TempMapRotation.size; j++)
	{
	  level.MapRotation[mapnum]["gametype"] = TempMapRotation[j]["gametype"];
	  level.MapRotation[mapnum]["map"] = TempMapRotation[j]["map"];
	  mapnum++;
	}
	// ...and from start of array to and including current
	for(j = 0; j <= i; j++)
	{
	  level.MapRotation[mapnum]["gametype"] = TempMapRotation[j]["gametype"];
	  level.MapRotation[mapnum]["map"] = TempMapRotation[j]["map"];
	  mapnum++;
	}

	// clean up temp array
	TempMapRotation = undefined;

	return;
}

IsCustomMap(map)
{
	switch(map)
	{
		case "mp_backlot":
		case "mp_bloc":
		case "mp_bog":
		case "mp_broadcast":
		case "mp_carentan":
		case "mp_cargoship":
		case "mp_citystreets":
		case "mp_convoy":
		case "mp_countdown":
		case "mp_crash":
		case "mp_crash_snow":
		case "mp_creek":
		case "mp_crossfire":
		case "mp_farm":
		case "mp_killhouse":
		case "mp_overgrown":
		case "mp_pipeline":
		case "mp_shipment":
		case "mp_showdown":
		case "mp_strike":
		case "mp_vacant": return false;

		default: return true;
	}
}
