
dvardef(varname, vardefault, min, max, type)
{
	basename = varname;

	mapname = getdvar("mapname");
	gametype = getdvar("g_gametype");
	multigtmap = gametype + "_" + mapname;

	// check against gametype
	tempvar = basename + "_" + gametype;
	if(getdvar(tempvar) != "") varname = tempvar;

	// check against the map name
	tempvar = basename + "_" + mapname;
	if(getdvar(tempvar) != "") varname = tempvar;

	// check against the game type and the map name
	tempvar = basename + "_" + multigtmap;
	if(getdvar(tempvar) != "") varname = tempvar;

	// get the variable's definition
	switch(type)
	{
		case "int":
		if(getdvar(varname) == "") definition = vardefault;
			else definition = getdvarint(varname);
		break;

		case "float":
		if(getdvar(varname) == "") definition = vardefault;
			else definition = getdvarfloat(varname);
		break;

		case "string":
		default:
		if(getdvar(varname) == "") definition = vardefault;
			else definition = getdvar(varname);
		break;
	}

	// check to see if the value is within the min & max parameters
	if(type != "string")
	{
		if(min != 0 && definition < min) definition = min;
			else if(max != 0 && definition > max) definition = max;
	}

	return definition;
}

setDvarDefault(dvarName, setVal, minVal, maxVal, type )
{
	// no value set
	if(getDvar( dvarName ) != "")
	{
		if(isString(setVal))
			setVal = getDvar(dvarName);
		else
		{
			if(isDefined(type) && type == "float")
				setVal = getDvarFloat(dvarName);
			else
				setVal = getDvarInt(dvarName);
		}
	}
		
	if(isDefined(minVal) && !isString(setVal))
		setVal = max(setVal, minVal);

	if (isDefined(maxVal) && !isString(setVal))
		setVal = min(setVal, maxVal);

	setDvar(dvarName, setVal);
	return setVal;
}

GetMapDim()
{
	xMax = -30000;
	xMin = 30000;

	yMax = -30000;
	yMin = 30000;

	zMax = -30000;
	zMin = 30000;

	xMin_e[0] = xMax;
	yMin_e[1] = yMax;
	zMin_e[2] = zMax;

	xMax_e[0] = xMin;
	yMax_e[1] = yMin;
	zMax_e[2] = zMin;	   

	entitytypes = getentarray();

	for(i = 1; i < entitytypes.size; i++)
	{
		if(isDefined(entitytypes[i].origin))
		{
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin - (30000,0,0), false, undefined);
			if(trace["fraction"] != 1) xMin_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin + (30000,0,0), false, undefined);
			if(trace["fraction"] != 1) xMax_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin - (0,30000,0), false, undefined);
			if(trace["fraction"] != 1) yMin_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin + (0,30000,0), false, undefined);
			if(trace["fraction"] != 1) yMax_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin - (0,0,30000), false, undefined);
			if(trace["fraction"] != 1) zMin_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin + (0,0,30000), false, undefined);
			if(trace["fraction"] != 1) zMax_e = trace["position"];

			if(xMin_e[0] < xMin) xMin = xMin_e[0];
			if(yMin_e[1] < yMin) yMin = yMin_e[1];
			if(zMin_e[2] < zMin) zMin = zMin_e[2];
	
			if(xMax_e[0] > xMax) xMax = xMax_e[0];
			if(yMax_e[1] > yMax) yMax = yMax_e[1];
			if(zMax_e[2] > zMax) zMax = zMax_e[2];	   
		}
		wait 0.05;
	}

	level.ex_playArea_Centre = (int(xMax + xMin)/2, int(yMax + yMin)/2, int(zMax + zMin)/2);
	level.ex_mapArea_Max = (xMax, yMax, zMax);
	level.ex_mapArea_Min = (xMin, yMin, zMin);
	level.ex_mapArea_Width = int(distance((xMin,yMin,zMax),(xMax,yMin,zMax)));
	level.ex_mapArea_Length = int(distance((xMin,yMin,zMax),(xMin,yMax,zMax)));

	entitytypes = [];
	entitytypes = undefined;
}

GetFieldDim()
{
	spawnpoints = [];
	spawnpoints = addToArray(spawnpoints, "mp_dm_spawn");
	spawnpoints = addToArray(spawnpoints, "mp_tdm_spawn");
	spawnpoints = addToArray(spawnpoints, "mp_dom_spawn");
	spawnpoints = addToArray(spawnpoints, "mp_sab_spawn_allies");
	spawnpoints = addToArray(spawnpoints, "mp_sab_spawn_axis");
	spawnpoints = addToArray(spawnpoints, "mp_sd_spawn_attacker");
	spawnpoints = addToArray(spawnpoints, "mp_sd_spawn_defender");

	xMax = spawnpoints[0].origin[0];
	xMin = spawnpoints[0].origin[0];

	yMax = spawnpoints[0].origin[1];
	yMin = spawnpoints[0].origin[1];

	zMax = spawnpoints[0].origin[2];
	zMin = spawnpoints[0].origin[2];

	for(i = 1; i < spawnpoints.size; i++)
	{
		if (spawnpoints[i].origin[0] > xMax) xMax = spawnpoints[i].origin[0];
		if (spawnpoints[i].origin[1] > yMax) yMax = spawnpoints[i].origin[1];
		if (spawnpoints[i].origin[2] > zMax) zMax = spawnpoints[i].origin[2];
		if (spawnpoints[i].origin[0] < xMin) xMin = spawnpoints[i].origin[0];
		if (spawnpoints[i].origin[1] < yMin) yMin = spawnpoints[i].origin[1];
		if (spawnpoints[i].origin[2] < zMin) zMin = spawnpoints[i].origin[2];
	}

	level.ex_playArea_Centre = (int(xMax + xMin)/2, int(yMax + yMin)/2, int(zMax + zMin)/2);
	level.ex_playArea_Min = (xMin, yMin, zMin);
	level.ex_playArea_Max = (xMax, yMax, zMax);
	level.ex_playArea_Width = int(distance((xMin, yMin, 800),(xMax, yMin, 800)));
	level.ex_playArea_Length = int(distance((xMin, yMin, 800),(xMin, yMax, 800)));
}

addToArray(array, entname)
{
	if(!isDefined(array)) array = [];
	
	if(!isDefined(entname)) return array;

	entarray = getEntArray(entname, "classname");
	for(i = 0; i < entarray.size; i++)
		array[array.size] = entarray[i];

	return array;
}

monotone(str)
{
	if(!isDefined(str) || (str == "")) return ("");

	_s = "";

	_colorCheck = false;
	for(i = 0; i < str.size; i++)
	{
		ch = str[i];
		if ( _colorCheck )
		{
			_colorCheck = false;

			switch(ch)
			{
			  case "0":	// black
			  case "1":	// red
			  case "2":	// green
			  case "3":	// yellow
			  case "4":	// blue
			  case "5":	// cyan
			  case "6":	// pink
			  case "7":	// white
			  case "8":	// Olive
			  case "9":	// Grey
			  	break;
			  default:
			  	_s += ("^" + ch);
			  	break;
			}
		}
		else if(ch == "^")
			_colorCheck = true;
		else
			_s += ch;
	}
	return ( _s );
}

lowercase(str)
{
	return(convertChar(str, "U-L" ));
}

uppercase(str)
{
	return(convertChar(str, "L-U" ));
}

convertChar(str, conv)
{
	if(!isDefined(str) || str == "") return "";

	switch ( conv )
	{
		case "U-L":	case "U-l":	case "u-L":	case "u-l":
		from = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		to   = "abcdefghijklmnopqrstuvwxyz";
		break;

		case "L-U":	case "L-u":	case "l-U":	case "l-u":
		from = "abcdefghijklmnopqrstuvwxyz";
		to   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		break;

		default:
		return str;
	}

	string = "";

	for(i = 0; i < str.size; i++)
	{
		chr = str[i];

		for(j = 0; j < from.size; j++)
		{
			if(chr == from[j])
			{
				chr = to[j];
				break;
			}
		}

		string += chr;
	}

	return string;
}

justalphabet(str)
{
	if(!isDefined(str) || str == "") return "";

	uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	lowercase = "abcdefghijklmnopqrstuvwxyz";

	string = "";
	
	for(i = 0; i < str.size; i++)
	{
		chr = str[i];

		for(j = 0; j < uppercase.size; j++)
		{
			if(chr == uppercase[j]) string += uppercase[j];
			else if(chr == lowercase[j]) string += lowercase[j];
		}
	}

	return string;
}

convertMUJ(string)
{
	//string = monotone(string);
	string = uppercase(string);
	string = justalphabet(string);
	return string;
}

convertMLJ(string)
{
	//string = monotone(string);
	string = lowercase(string);
	string = justalphabet(string);
	return string;
}

bounceObject(vRotation, vVelocity, vOffset, angles, radius, falloff, bouncesound, bouncefx, objecttype)
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_bounceobject");

	if(!isDefined(objecttype)) return;

	self thread putinQ(objecttype);

	// Hide until everthing is setup
	self hide();

	// Setup default values
	if(!isDefined(vRotation))	vRotation = (0,0,0);
	pitch = vRotation[0]*0.05;	// Pitch/frame
	yaw = vRotation[1]*0.05;	// Yaw/frame
	roll = vRotation[2]*0.05;		// Roll/frame

	if(!isDefined(vVelocity))	vVelocity = (0,0,0);
	if(!isDefined(vOffset)) vOffset = (0,0,0);
	if(!isDefined(falloff)) falloff = 0.5;

	// Spawn anchor (the object that we will rotate)
	self.bounce_anchor = spawn("script_origin", self.origin );
	self.bounce_anchor.angles = self.angles;

	// Link to anchor
	self linkto( self.bounce_anchor, "", vOffset, angles );
	self show();

	wait .05;	// Let it happen

	if(isDefined(level.ex_gravity)) gravity = level.ex_gravity;
	else gravity = 100;

	// Set gravity
	vGravity = (0,0,-0.02 * gravity);

	stopme = 0;
	notrace = 5;	// Avoid bullettrace for the first number of frames

	// Drop with gravity
	for(;;)
	{
		// Let gravity do, what gravity do best
		vVelocity +=vGravity;

		if(!isDefined(self.bounce_anchor)) return;

		// Get destination origin
		neworigin = self.bounce_anchor.origin + vVelocity;

		// Check for impact, check for entities but not myself.
		if(!notrace)
		{
			trace=bulletTrace(self.bounce_anchor.origin,neworigin,false,undefined); 
			if(trace["fraction"] != 1)	// Hit something
			{
				// Place object at impact point - radius
				distance = distance(self.bounce_anchor.origin,trace["position"]);
				if(distance)
				{
					fraction = (distance - radius) / distance;
					delta = trace["position"] - self.bounce_anchor.origin;
					delta2 = common_scripts\utility::vectorScale(delta,fraction);
					neworigin = self.bounce_anchor.origin + delta2;
				}
				else neworigin = self.bounce_anchor.origin;

				// Play sound if defined
				if(isDefined(bouncesound)) self.bounce_anchor playSound(bouncesound + trace["surfacetype"]);	

				// Test if we are hitting ground and if it's time to stop bouncing
				if(vVelocity[2] <= 0 && vVelocity[2] > -10) stopme++;
				if(stopme==5)
				{
					stopme=0;
					// Set origin to impactpoint	
					self.bounce_anchor.origin = neworigin;
					wait .05;
					// Delete anchor to save gamestate size
					self unlink();
					self.bounce_anchor delete();
					return;
				}
				// Play effect if defined and it's a hard hit
				if(isDefined(bouncefx) && length(vVelocity) > 20) playfx(bouncefx,trace["position"]);

				// Decrease speed for each bounce.
				vSpeed = length(vVelocity) * falloff;

				// Calculate new direction (Thanks to Hellspawn this is finally done correctly)
				vNormal = trace["normal"];
				vDir = common_scripts\utility::vectorScale(vectorNormalize( vVelocity ),-1);
				vNewDir = ( common_scripts\utility::vectorScale(common_scripts\utility::vectorScale(vNormal,2),vectorDot( vDir, vNormal )) ) - vDir;

				// Scale vector
				vVelocity = common_scripts\utility::vectorScale(vNewDir, vSpeed);
	
				// Add a small random distortion
				vVelocity += (randomFloat(1)-0.5,randomFloat(1)-0.5,randomFloat(1)-0.5);
			}
		}
		else notrace--;

		if(!isDefined(self.bounce_anchor)) return;

		self.bounce_anchor.origin = neworigin;

		// Rotate pitch
		a0 = self.bounce_anchor.angles[0] + pitch;
		while(a0<0) a0 += 360;
		while(a0>359) a0 -=360;

		// Rotate yaw
		a1 = self.bounce_anchor.angles[1] + yaw;
		while(a1<0) a1 += 360;
		while(a1>359) a1 -=360;

		// Rotate roll
		a2 = self.bounce_anchor.angles[2] + roll;
		while(a2<0) a2 += 360;
		while(a2>359) a2 -=360;
		self.bounce_anchor.angles = (a0,a1,a2);
		
		// Wait one frame
		wait .05;
	}
}

putinQ(type)
{
	if(!isDefined(type)) self notify("ex_bounceobject");
	else
	{
		index = level.ex_objectQcurrent[type];
	
		level.ex_objectQcurrent[type]++;
	
		if(level.ex_objectQcurrent[type] >= level.ex_objectQsize[type]) level.ex_objectQcurrent[type] = 0;
	
		if(isDefined(level.ex_objectQ[type][index]))
		{
			level.ex_objectQ[type][index] notify("ex_bounceobject");
			wait .05; //Let thread die
	
			if(isDefined(level.ex_objectQ[type][index].anchor))
			{
				level.ex_objectQ[type][index] unlink();
				level.ex_objectQ[type][index].anchor delete();
			}
	
			if(isDefined(level.ex_objectQ[type][index])) level.ex_objectQ[type][index] delete();
		}
		
		level.ex_objectQ[type][index] = self;
	}
}

// The objectives array is shared between camper and ammocrates code!
getObjective()
{
	if(!isDefined(level.ex_objectives)) createObjectivesArray();

	objnum = 0;
	// Check slots 15 - 4
	for(i = 15; i >= 4; i--)
	{
		if(level.ex_objectives[i] == 0)
		{
			level.ex_objectives[i] = 1;
			objnum = i;
			break;
		}
	}
	return objnum;
}

deleteObjective(objnum)
{
	if(!isDefined(level.ex_objectives)) createObjectivesArray();

	if(level.ex_objectives[objnum] == 1)
	{
		objective_delete(objnum);
		level.ex_objectives[objnum] = 0;
	}
}

createObjectivesArray()
{
	if(!isDefined(level.ex_objectives)) level.ex_objectives = [];

	for(i = 0; i <= 15; i++)
	{
		if(i < 4) level.ex_objectives[i] = 1; // First 4 objectives are reserved
		  else level.ex_objectives[i] = 0;
	}
}

getAllies()
{
	switch(game["allies"])
	{
		case "marines": return "american";
		case "sas": return "british";
		default: return "american";
	}
}

getAxis()
{
	switch(game["axis"])
	{
		case "arab": return "arab";
		case "opfor": return "russian";
		default: return "russian";
	}
}

playSoundLoc(sound, position, special)
{
	if(!isDefined(position))
		position = level.ex_playArea_Centre;
	
	soundloc = spawn("script_model", position);
	wait 0.05;

	if(!isDefined(special)) soundloc playSound(sound);
	else
	{
		teamallies = getAllies();
		teamaxis = getAxis();
		if(self.pers["team"] == "allies") soundloc playsound(sound+"_" + teamallies + "_" + (randomInt(level.ex_voices[teamallies][special]) +1) );
			else soundloc playsound(sound+"_" + teamaxis + "_" + (randomInt(level.ex_voices[teamaxis][special]) + 1) );
	}

	wait 5;
	soundloc delete();
}

playSoundOnPlayer(sound, special)
{
	self notify("ex_soplayer");
	self endon("ex_soplayer");
	self endon("ex_spawned");
	self endon("ex_dead");

	if(!isDefined(special)) self playSound(sound);
	else
	{
		teamallies = getAllies();
		teamaxis = getAxis();
		if(self.pers["team"] == "allies") self playsound(sound+"_" + teamallies + "_" + (randomInt(level.ex_voices[teamallies][special]) + 1) );
			else self playsound(sound+"_" + teamaxis + "_" + (randomInt(level.ex_voices[teamaxis][special]) + 1) );
	}
}

playSoundOnPlayers(sound, team, spectators)
{
	if(!isDefined(spectators)) spectators = true;

	players = level.players;

	if(isDefined(team))
	{
		for(i = 0; i < players.size; i++)
		{
			wait 0.01;

			if(isPlayer(players[i]) && isDefined(players[i].pers) && isDefined(players[i].pers["team"]) && players[i].pers["team"] == team)
			{
				if(spectators && isPlayer(players[i])) players[i] playLocalSound(sound);
					else if(isPlayer(players[i]) && isDefined(players[i].sessionstate) && players[i].sessionstate != "spectator") players[i] playLocalSound(sound);
			}
		}
	}
	else
	{
		for(i = 0; i < players.size; i++)
		{
			wait 0.01;

			if(spectators && isPlayer(players[i])) players[i] playLocalSound(sound);
				else if(isPlayer(players[i]) && isDefined(players[i].sessionstate) && players[i].sessionstate != "spectator") players[i] playLocalSound(sound);
		}
	}
}

weaponPause(time)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(self.ex_weaponpause) return;
	self.ex_weaponpause = true;

	self disableWeapons();
	wait time;
	if(isPlayer(self))
	{
		self enableWeapons();
		self.ex_weaponpause = false;
	}	
}

clearlnbold(state, lines)
{
	for(count = 0; count < lines; count++)
	{
		if(state == "all") iprintlnbold(&"MISC_BLANK_LINE_TXT");
			else if(state == "self") self iprintlnbold(&"MISC_BLANK_LINE_TXT");
	}
}

scriptedfxradiusdamage(eAttacker, vOffset, sMeansOfDeath, sWeapon, iRange, iMaxDamage, iMinDamage, effect, surfacetype, quake, entignore, zignore, special)
{
	level endon("ex_gameover");

	if(!isDefined(vOffset)) vOffset = (0,0,0);
	if(!isDefined(entignore)) entignore = true; // ignore giving damage to non player entities
	if(!isDefined(zignore)) zignore = false;
	if(!isDefined(special)) special = "false";
	
	iDFlags = 1;

	// set default to dirt or snow on winter maps
	//if(level.ex_wintermap) surfacefx = "snow";
		//else surfacefx = "dirt";
 
	surfacefx = "dirt";

	if(isDefined(effect) && effect != "none")
	{
		if(isDefined(surfacetype))
		{
			switch(surfacetype)
			{
				case "beach":
				case "sand":
				surfacefx = "beach";
				break;
		
				case "asphalt":
				case "metal":
				case "rock":
				case "gravel":
				case "plaster":
				case "default":
				surfacefx = "concrete";
				break;
		
				case "mud":
				surfacefx = "mud";
				break;

				case "dirt":
				case "grass":
				surfacefx = "dirt";
				break;
		
				case "snow":
				case "ice":
				surfacefx = "snow";
				break;
		
				case "wood":
				case "bark":
				surfacefx = "wood";
				break;
		
				case "water":
				surfacefx = "water";
				break;
			}
		}

		// play the fx
		if(effect == "generic") playfx(level.ex_effect["explosion_" + surfacefx], self.origin);
			//else if(special == "false") playfx(level.ex_effect[effect], self.origin);

		// napalm fx
		//if(special == "napalm" && sWeapon == "planebomb_mp")
		//{
			//playfx(level.ex_effect["napalm_bomb"], self.origin);
			//playfx(level.ex_effect["bodygroundfire"], self.origin);
		//}

		//if(level.ex_wintermap && sWeapon == "planebomb_mp") thread sciptedfxdelay("explosion_snow", 1.5, self.origin);
	}
	
	if(quake)
	{
		// * Earthquake *
		peqs = randomInt(100);
		strength = 0.5 + 0.5 * peqs /100;
		length = 1 + 3*peqs/100;;
		range = iRange + iRange * peqs/100;
		earthquake(strength, length, self.origin, range);		
	}
	
	if(iMaxDamage == 0 && iMinDamage == 0) return;
	
	// Loop through players and cause damage
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		if(isPlayer(players[i]))
		{			
			// Check that player is in range
			distance = distance((self.origin + vOffset), players[i].origin);
			zdistance = distance((0,0, self.origin[2]), (0,0, players[i].origin[2]));
				
			if(distance >= iRange || players[i].sessionstate != "playing" || !isAlive(players[i])) continue;


			// ignore if above 5' height
			if(zignore && distance < iRange && zdistance > 60) continue;
			
			// if player is inside, no damage
			if(!extreme\_ex_utils::isOutside(players[i].origin)) continue;

			if(players[i] == self)
			{
				//logprint("RADIUS DAMAGE DEBUG: player " + players[i].name + " damage before range check: " + iMaxDamage + "\n");

				percent = (iRange - distance) / iRange;
				iDamage = (iMinDamage + (iMaxDamage - iMinDamage)) * percent;
	
				//logprint("RADIUS DAMAGE DEBUG: player " + players[i].name + " distance " + distance + " within range " + iRange + " is " + percent + "%\n");
				//logprint("RADIUS DAMAGE DEBUG: player " + players[i].name + " damage before trace: " + iDamage + "\n");

				offset = 0;
				stance = players[i] [[level.ex_getStance]](false);
				switch(stance)
				{
					case 2:	offset = (0,0,5);	break;
					case 1:	offset = (0,0,35);	break;
					case 0:	offset = (0,0,55);	break;
				}

				traceorigin = players[i].origin + offset;
				vDir = vectorNormalize(traceorigin - (self.origin + vOffset));

				if(special != "nuke")
				{
					if(isPlayer(self)) trace = bullettrace(self.origin + vOffset, traceorigin, true, self);
						else trace = bullettrace(self.origin + vOffset, traceorigin, true, eAttacker);

					if(trace["fraction"] != 1 && isDefined(trace["entity"]))
					{
						if(isPlayer(trace["entity"]) && trace["entity"] != players[i] && trace["entity"] != eAttacker)
						{
							iDamage = iDamage * .5;	// Damage blocked by other player, remove 50%
							//logprint("RADIUS DAMAGE DEBUG: player " + players[i].name + " damage after trace: " + iDamage + " (obstructed by player " + trace["entity"].name + ")\n");
						}
					}
					else
					{
						trace = bulletTrace(self.origin + vOffset, traceorigin, false, undefined);
						if(trace["fraction"] != 1 && trace["surfacetype"] != "default")
						{
							iDamage = iDamage * .2;	// Damage blocked by other entities, remove 80%
							//logprint("RADIUS DAMAGE DEBUG: player " + players[i].name + " damage after trace: " + iDamage + " (obstructed by entity)\n");
						}
					}
				}
			}
			else
			{
				iDamage = iMaxDamage;
				vDir = (0,0,1);
			}

			if(special == "napalm") players[i] thread napalmDamage(eAttacker);
			else
			{
				if(isPlayer(eAttacker) && eAttacker != players[i] && special == "kamikaze" && iDamage >= players[i].health)
				{
					if(!isDefined(eAttacker.kamikaze_victims)) eAttacker.kamikaze_victims = 0;
					eAttacker.kamikaze_victims++;
				}
				//logprint("RADIUS DAMAGE DEBUG: player " + eAttacker.name + " causing " + iDamage + " damage to player " + players[i].name + "\n");
				players[i] thread [[level.callbackPlayerDamage]](self, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, undefined, vDir, "none", 0);
			}
		}
	}

	if(entignore) return;

	// Loop through entities except players and cause damage
	entities = getentarray();
	for(i=0;i<entities.size;i++)
	{
		// Is it defined and not a player?
		if(isDefined(entities[i]) && !isPlayer(entities[i]))
		{
			// Check that entity is in range
			distance = distance((self.origin + vOffset), entities[i].origin);

			if(distance <= iRange)
			{	
				// Calculate damage
				if(entities[i] != self)
				{
					// bullet trace
					traceorigin = entities[i].origin;
					trace = bullettrace(self.origin + vOffset, traceorigin, true, self);
						
					// Nothing blocked the damage
					if(isDefined(trace["entity"]) && trace["entity"] == entities[i])
					{
						// get new distance and new damage position if we hit the entity directly
						pos = trace["position"];
			
						distance = distance((self.origin + vOffset), pos);
							
						// Calculate damage falloff
						percent = (iRange-distance)/iRange;
						iDamage = iMinDamage + (iMaxDamage - iMinDamage)*percent;
			
						// Cause a small radiusdamage
						if(iDamage > 0)
						{
							// Do radius damage at traced point
							if(isDefined(entities[i].health)) oldhealth = entities[i].health;
							radiusDamage(pos, 5, iDamage, iDamage, eAttacker, self);
						}
					}
					else  // Something blocked the damage
					{
						distance = distance((self.origin + vOffset), entities[i].origin);
			
						// Calculate damage falloff
						percent = (iRange-distance)/iRange;
						iDamage = iMinDamage + (iMaxDamage - iMinDamage)*percent;
			
						if(isDefined(trace["entity"])) iDamage = iDamage * .6; // Damage blocked by entity, remove 40%
							else iDamage = iDamage * .2; // Damage blocked by other stuff(walls etc...), remove 80%
			
						// Cause a small radiusdamage
						if(iDamage > 0) radiusDamage(entities[i].origin, 5, iDamage, iDamage, eAttacker, self);
					}
				}
			}
		}
	}
}

sciptedfxdelay(effect, delay, pos)
{
	wait( [[level.ex_fpstime]](delay) );
	playfx(level.ex_effect[effect], pos);
}

isOutside(origin)
{
	if(!isDefined(origin)) return false;

	trace = bulletTrace(origin, origin+ (0,0,6000), false, false);

	if(distance(origin, trace["position"]) >= 1000) return true;
	else return false;
}

execClientCommand(cmd)
{
	self setClientDvar("ui_ex_clientcmd", cmd);
	self openMenuNoMouse(game["menu_clientcmd"]);
	//self closeMenu(game["menu_clientcmd"]);
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

vectorScale (vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

vectorMulti(vec, size)
{
	x = vec[0] * size;
	y = vec[1] * size;
	z = vec[2] * size;
	vec = (x,y,z);
	return vec;
}

createBarGraphic(barsize,bartime)
{
	level endon("ex_gameover");
	self endon("disconnect");

	cleanBarGraphic();
	
	// Background
	self.ex_pbbgrd = newClientHudElem(self);
	self.ex_pbbgrd.alignX = "center";
	self.ex_pbbgrd.alignY = "middle";
	self.ex_pbbgrd.x = 320;
	self.ex_pbbgrd.y = 410;
	self.ex_pbbgrd.alpha = 0.5;
	self.ex_pbbgrd.color = (0,0,0);
	self.ex_pbbgrd setShader("white", (barsize + 4), 12);

	self.ex_pb = newClientHudElem(self);				
	self.ex_pb.alignX = "left";
	self.ex_pb.alignY = "middle";
	self.ex_pb.x = (320 - (barsize / 2.0));
	self.ex_pb.y = 410;
	self.ex_pb setShader("white", 0, 8);
	self.ex_pb scaleOverTime(bartime , barsize, 8);
}

cleanBarGraphic()
{
	if(isDefined(self.ex_pbbgrd)) self.ex_pbbgrd destroy();
	if(isDefined(self.ex_pb)) self.ex_pb destroy();
}

//ex_hud_announce(message, predelay)
//{
	//self endon("kill_ex_hud_announce");
	//self endon("disconnect");

	//if(!isDefined(message)) return;

	//if(!isDefined(self.ex_hud_announce))
	//{
		//self.ex_hud_announce = [];
		//self.ex_hudwait = 1;
	//}

	//if(self.ex_hudwait < 1) self.ex_hudwait = 1;

	//self.ex_hudwait++;
	
	//wait self.ex_hudwait;

	//for(i = 0; i < self.ex_hud_announce.size; i++)
	//{
		//if(isDefined(self.ex_hud_announce[i]))
		//{
			//self.ex_hud_announce[i] moveOverTime(0.25);
			//self.ex_hud_announce[i].y = self.ex_hud_announce[i].y - 20;
		//}
	//}

	//i = 0;
	//while(isDefined(self.ex_hud_announce[i])) i++;

	//self.ex_hud_announce[i] = newClientHudElem(self);
	//self.ex_hud_announce[i].alignX = "center";
	//self.ex_hud_announce[i].alignY = "middle";
	//self.ex_hud_announce[i].x = 320;
	//self.ex_hud_announce[i].y = 50;
	//self.ex_hud_announce[i].alpha = 0;
	//self.ex_hud_announce[i].fontscale = 1.5;
	//wait 0.25;

	//self.ex_hud_announce[i] settext(message);
	//self.ex_hud_announce[i] fadeOverTime(0.5);
	//self.ex_hud_announce[i].alpha = 1;
	//wait 2.5;
	//self.ex_hud_announce[i] fadeOverTime(0.5);
	//self.ex_hud_announce[i].alpha = 0;
	//wait 0.25;

	//self.ex_hud_announce[i] destroy();
	//self.ex_hudwait--;
//}

hotSpot(position, radius, sMeansOfDeath, sWeapon)
{
	self endon("endhotspot");

	if(!isDefined(radius)) radius = 60; // 5ft

	for(;;)
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if(isPlayer(players[i])) player = players[i];
			else continue;

			if(distance(position, player.origin) > radius) continue;
			else player thread [[level.callbackPlayerDamage]](self, self, 5, 1, sMeansOfDeath, sWeapon, undefined, (0,0,0), "none",0);
		}

		wait 0.5;
	}
}

ex_hud_announce(message)
{
	self endon("kill_hud_announce");
	self endon("disconnect");
	self endon("ex_dead");

	if(!isDefined(message)) return;
	if(!isDefined(self.ex_hud_announce)) self.ex_hud_announce = [];
	if(!isDefined(self.ex_hud_allocating)) self.ex_hud_allocating = false;

	while(self.ex_hud_allocating) wait(0.1);
	self.ex_hud_allocating = true;

	free_hud = ex_hud_getfree();
	while(free_hud == -1)
	{
		wait(1);
		free_hud = ex_hud_getfree();
	}

	for(i = 0; i < self.ex_hud_announce.size; i++)
	{
		if(isDefined(self.ex_hud_announce[i].hudelem))
		{
			self.ex_hud_announce[i].hudelem moveOverTime(0.2);
			self.ex_hud_announce[i].hudelem.y = self.ex_hud_announce[i].hudelem.y - 15;
		}
	}

	wait(0.1);
	self.ex_hud_allocating = false;
	self.ex_hud_announce[free_hud].message = message;
	self.ex_hud_announce[free_hud].status = 1; // on screen

	self.ex_hud_announce[free_hud].hudelem = newClientHudElem(self);
	self.ex_hud_announce[free_hud].hudelem.archived = false;
	self.ex_hud_announce[free_hud].hudelem.horzAlign = "fullscreen";
	self.ex_hud_announce[free_hud].hudelem.vertAlign = "fullscreen";
	self.ex_hud_announce[free_hud].hudelem.alignX = "center";
	self.ex_hud_announce[free_hud].hudelem.alignY = "middle";
	self.ex_hud_announce[free_hud].hudelem.x = 320;
	self.ex_hud_announce[free_hud].hudelem.y = 80;
	self.ex_hud_announce[free_hud].hudelem.alpha = 0;
	self.ex_hud_announce[free_hud].hudelem.fontscale = 1.1;
	self.ex_hud_announce[free_hud].hudelem settext(self.ex_hud_announce[free_hud].message);
	self.ex_hud_announce[free_hud].hudelem fadeOverTime(0.5);
	self.ex_hud_announce[free_hud].hudelem.alpha = 1;
	wait 7;
	if(isDefined(self.ex_hud_announce[free_hud].hudelem))
	{
		self.ex_hud_announce[free_hud].hudelem fadeOverTime(0.5);
		self.ex_hud_announce[free_hud].hudelem.alpha = 0;
		wait 0.5;
	}
	if(isDefined(self.ex_hud_announce[free_hud].hudelem))
		self.ex_hud_announce[free_hud].hudelem destroy();

	self.ex_hud_announce[free_hud].status = 0; // free slot
	self.ex_hud_announce[free_hud].message = undefined;
}

ex_hud_getfree()
{
	self endon("kill_hud_announce");
	self endon("disconnect");
	self endon("ex_dead");

	for(i = 0; i < 3; i++)
	{
		if(isDefined(self.ex_hud_announce[i]))
		{
			if(self.ex_hud_announce[i].status == 0) return i; // free slot
		}
		else
		{
			self.ex_hud_announce[i] = spawnstruct();
			return i; // unallocated slot
		}
	}
	return -1; // all slots in use
}

napalmDamage(eAttacker)
{
	level endon("ex_gameover");
	self endon("ex_dead");

	// Respect friendly fire settings 0 (off) and 2 (reflect; it doesn't damage the attacker though)
	friendly = false;
	if(level.friendlyfire == 2)
		if(isPlayer(eAttacker) && eAttacker.pers["team"] == self.pers["team"]) friendly = true;	
		
	// burn them c/w damage
	if(isPlayer(self) && !friendly) self extreme\_ex_punishments::doTorch(true, eAttacker);
	
	// play flame on dead body & make sure they die!
	if(isPlayer(self))
	{
		if(!friendly) playfx(level.ex_effect["bodygroundfire"], self.origin);
		self thread [[level.callbackPlayerDamage]](eAttacker, eAttacker, 1000, 1, "MOD_PROJECTILE", "napalm_mp", undefined, (0,0,1), "none", 0);
	}
}