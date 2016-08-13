
GetPlainMapRotation(number)
{
	return GetMapRotation(false, false, number);
}

GetRandomMapRotation()
{
	return GetMapRotation(true, false, undefined);
}

GetCurrentMapRotation(number)
{
	return GetMapRotation(false, true, number);
}

GetPlayerBasedMapRotation()
{
	return GetMapRotation(false, false, undefined);
}

GetRandomPlayerBasedMapRotation()
{
	return GetMapRotation(true, false, undefined);
}

GetMapRotation(random, current, number)
{
	if(!isdefined(number))
		number = 0;

	maprot = "";
	if(current)
		maprot = strip(getdvar("sv_maprotationcurrent"));

	if(maprot == "")
	{
		if(level.ex_pbrotate)
		{
			small_rot_size = level.ex_pbrsmall;
			med_rot_size = level.ex_pbrmedium;

			players = level.players;

			if (players.size > med_rot_size) maprot = strip(getdvar("scr_large_rotation"));
				else if (players.size > small_rot_size) maprot = strip(getdvar("scr_med_rotation"));
					else maprot = strip(getdvar("scr_small_rotation"));
		}
		else maprot = strip(getdvar("sv_maprotation"));
	}

	if(maprot == "") return undefined;
	
	j=0;
	temparr2[j] = "";	
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else temparr2[j] += maprot[i];
	}

	temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = strip(temparr2[i]);

		if(element != "") temparr[temparr.size] = element;
	}

	x = spawn("script_origin",(0,0,0));
	x.maps = [];
	lastexec = undefined;
	lastgt = getdvar("g_gametype");
	for(i=0;i<temparr.size;)
	{
		switch(temparr[i])
		{
			case "exec":
				if(isdefined(temparr[i+1]))
					lastexec = temparr[i+1];
				i += 2;
				break;

			case "gametype":
				if(isdefined(temparr[i+1]))
					lastgt = temparr[i+1];
				i += 2;
				break;

			case "map":
				if(isdefined(temparr[i+1]))
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i+1];
				}

				if(!random)
				{
					lastexec = undefined;
					lastgt = undefined;
				}

				i += 2;
				break;

			default:
				if(!level.ex_mapvote) iprintln(&"MAPROTATION_ERROR");

				if(isGametype(temparr[i])) lastgt = temparr[i];
				else if(isConfig(temparr[i])) lastexec = temparr[i];
				else
				{
					x.maps[x.maps.size]["exec"] = lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i];
	
					if(!random)
					{
						lastexec = undefined;
						lastgt = undefined;
					}
				}

				i += 1;
				break;
		}

		if(number && x.maps.size >= number) break;
	}

	if(random)
	{
		for(k = 0; k < 20; k++)
		{
			for(i = 0; i < x.maps.size; i++)
			{
				j = randomInt(x.maps.size);
				element = x.maps[i];
				x.maps[i] = x.maps[j];
				x.maps[j] = element;
			}
		}
	}
	return x;
}

pbrotation()
{
	if(!level.ex_pbrotate) return;

	rot = Get_Next_Map();

	if(rot == "") return;

	cur_rot = getDvar("sv_maprotationcurrent");
	new_rot = rot + cur_rot;
	setDvar("sv_maprotationcurrent", new_rot);
}

Get_Next_Map()
{
	mapstring = undefined;
	execstring = undefined;
	gtstring = undefined;

	players = level.players;

	if(players.size >= 1)
	{
		setDvar("ex_playerslg", players.size);
		psize = players.size;
	}
	else psize = getDvarInt("ex_playerslg"); 

	small_rot_size = level.ex_pbrsmall;
	med_rot_size = level.ex_pbrmedium;

	if ( psize > med_rot_size)
	{
		map_rot_cur = "scr_large_rotation_current";
		map_rot = "scr_large_rotation";
	}
	else if ( psize > small_rot_size)
	{
		map_rot_cur = "scr_med_rotation_current";
		map_rot = "scr_med_rotation";
	}
	else
	{
		map_rot_cur = "scr_small_rotation_current";
		map_rot = "scr_small_rotation";
	}

	cur_map_rot = getDvar(map_rot_cur);
	if (cur_map_rot == "" || cur_map_rot == " ")
	{
		setdvar(map_rot_cur, getdvar(map_rot) );
		cur_map_rot = getdvar(map_rot);
	}

	//Parce Map Rotation
	maprotation = splitArray(cur_map_rot, " ", "", true);
	for (i=0; i < maprotation.size; i++ )
	{
		if (!isdefined(maprotation[i]) )
			continue;

		if (maprotation[i] == "exec")
		{
			execstring = "exec " + maprotation[i+1] + " ";
			i++;
			continue;
		}
		else if (maprotation[i] == "gametype")
		{
			gtstring = "gametype " + maprotation[i+1] + " ";
			i++;
			continue;
		}
		else if (maprotation[i] == "map")
		{
			mapstring = "map " + maprotation[i+1] + " ";

			newcurrentstring = " ";
			for (a=i+2; a<maprotation.size ; a++)
			{
				newcurrentstring = newcurrentstring + maprotation[a];
				newcurrentstring = newcurrentstring + " ";
			}

			if(newcurrentstring == " " || newcurrentstring == "  ") setdvar(map_rot_cur, getdvar(map_rot) );
			else setdvar(map_rot_cur, newcurrentstring);
			break;
		}

		//Whatever it is, it isn't one of the above so ignore it
		continue;
	}

	// Rebuild Map Rotation Current Return Value
	rebuild = "";
	if(!isdefined(mapstring)) return rebuild;
	if(isdefined(execstring)) rebuild = execstring;
	if(isdefined(gtstring)) rebuild = rebuild + gtstring;

	rebuild = rebuild + mapstring;
	return rebuild;
}

splitArray( str, sep, quote, skipEmpty )
{
	if(!isdefined(str) || str == "") return ( [] );

	if(!isdefined(sep) || sep == "") sep = ";";	// Default separator

	if(!isdefined(quote)) quote = "";

	skipEmpty = isdefined( skipEmpty );

	a = _splitRecur( 0, str, sep, quote, skipEmpty );

	return ( a );
}

_splitRecur( iter, str, sep, quote, skipEmpty )
{
	s = sep[ iter ];

	_a = [];
	_s = "";
	doQuote = false;
	for(i = 0; i < str.size; i++)
	{
		ch = str[i];
		if(ch == quote)
		{
			doQuote = !doQuote;

			if(iter + 1 < sep.size) _s += ch;
		}
		else
		if(ch == s && !doQuote )
		{
			if( _s != "" || !skipEmpty)
			{
				_l = _a.size;

				if(iter + 1 < sep.size)
				{
					_x = _splitRecur( iter + 1, _s,	sep, quote, skipEmpty );

					if(_x.size > 0 || !skipEmpty)
					{
						_a[ _l ][ "str" ] = _s;
						_a[ _l ][ "fields" ] = _x;
					}
				}
				else _a[ _l ] = _s;
			}

			_s = "";
		}
		else _s += ch;
	}

	if( _s != "")
	{
		_l = _a.size;

		if(iter + 1 < sep.size)
		{
			_x = _splitRecur( iter + 1, _s, sep, quote, skipEmpty);
			if(_x.size > 0 )
			{
				_a[ _l ][ "str" ] = _s;
				_a[ _l ][ "fields" ] = _x;
			}
		}
		else _a[ _l ] = _s;
	}

	return ( _a );
}

findStr( find, str, pos )
{
	if ( !isdefined( find ) || ( find == "" ) || !isdefined( str ) || !isdefined( pos ) || ( find.size > str.size ) )
		return ( -1 );

	fsize = find.size;
	ssize = str.size;

	switch ( pos )
	{
		case "start": place = 0 ; break;
		case "end":	place = ssize - fsize; break;
		default:	place = 0 ; break;
	}

	for ( i = place; i < ssize; i++ )
	{
		if ( i + fsize > ssize )
			break;			// Too late to compare

		// Compare now ...
		for ( j = 0; j < fsize; j++ )
			if ( str[ i + j ] != find[ j ] )
				break;		// No match

		if ( j >= fsize )
			return ( i );		// Found it!

		if ( pos == "start" )
			break;			// Didn't find at start
	}

	return ( -1 );
}

fixMapRotation()
{
	maps = undefined;

	x = GetPlainMapRotation();
	if(isdefined(x))
	{
		if(isdefined(x.maps))
			maps = x.maps;
		x delete();
	}

	if(!isdefined(maps) || !maps.size)
		return;

	newmaprotation = "";
	newmaprotationcurrent = "";
	for(i = 0; i < maps.size; i++)
	{
		if(!isdefined(maps[i]["exec"])) exec = "";
		else exec = " exec " + maps[i]["exec"];

		if(!isdefined(maps[i]["gametype"])) gametype = "";
		else gametype = " gametype " + maps[i]["gametype"];

		newmaprotation += exec + gametype + " map " + maps[i]["map"];

		if(i>0) newmaprotationcurrent += exec + gametype + " map " + maps[i]["map"];
	}

	setdvar("sv_maprotation", strip(newmaprotation));
	setdvar("sv_maprotationcurrent", newmaprotationcurrent);
	setdvar("ex_fix_maprotation", "0");
}
	
randomMapRotation()
{
	level endon("ex_gameover");
	maps = undefined;

	if(!level.ex_randommaprotation)
		return;

	if( strip(getdvar("sv_maprotationcurrent")) == "" || level.ex_randommaprotation == 1)
	{
		x = GetRandomMapRotation();
		if(isdefined(x))
		{
			if(isdefined(x.maps))
				maps = x.maps;
			x delete();
		}

		if(!isdefined(maps) || !maps.size)
			return;

		lastexec = "";
		lastgt = "";

		newmaprotation = "";
		for(i = 0; i < maps.size; i++)
		{
			if(!isdefined(maps[i]["exec"]) || lastexec == maps[i]["exec"]) exec = "";
			else
			{
				lastexec = maps[i]["exec"];
				exec = " exec " + maps[i]["exec"];
			}

			if(!isdefined(maps[i]["gametype"]) || lastgt == maps[i]["gametype"]) gametype = "";
			else
			{
				lastgt = maps[i]["gametype"];
				gametype = " gametype " + maps[i]["gametype"];	
			}

			newmaprotation += exec + gametype + " map " + maps[i]["map"];
		}

		setdvar("sv_maprotationcurrent", newmaprotation);
		setdvar("ex_random_maprotation", "2");
	}
}

strip(s)
{
	if(s=="") return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	// String is just blanks?
	if(i==s.size) return "";
	
	for(;i<s.size;i++)
		s2 += s[i];

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
		s3 += s2[j];
		
	return s3;
}

isGametype(gt)
{
	switch(gt)
	{
		case "dm":
		case "dom":
		case "koth":
		case "sab":
		case "sd":
		case "war":
		case "ctf":
		case "ctfb":
		case "htf":
			return true;

		default:
			return false;
	}
}

isConfig(cfg)
{
	temparr = explode(cfg,".");
	if(temparr.size == 2 && temparr[1] == "cfg") return true;
	else return false;
}

explode(s,delimiter)
{
	j=0;
	temparr[j] = "";	

	for(i=0;i<s.size;i++)
	{
		if(s[i]==delimiter)
		{
			j++;
			temparr[j] = "";
		}
		else temparr[j] += s[i];
	}

	return temparr;
}
