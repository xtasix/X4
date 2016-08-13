#include extreme\_ex_weapons;

main(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	// death sound
	if(level.ex_deathsound && (randomInt(100) < level.ex_deathsound_chance))
		self thread extreme\_ex_utils::playSoundLoc("generic_death", self.origin, "death");

	// obituary debug log -- 0 = disable, 1 = enable (do not remove!)
	level.obitlog = 0;

	// do not report command monitor deaths
	if(isDefined(self.ex_cmdmondeath) && self.ex_cmdmondeath)
	{
		self.ex_cmdmondeath = undefined;
		return;
	}

	// do not report forced suicides
	if(isDefined(self.ex_forcedsuicide) && self.ex_forcedsuicide)
	{
		self.ex_forcedsuicide = undefined;
		return;
	}

	// do not report forced suicide for camping
	if(isDefined(self.ex_iscamper) && self.ex_iscamper) return;
	
	// do not report forced suicide for team switch
	if(isDefined(self.switching_teams) && self.switching_teams) return;

	self.ex_obmonamsg = false;
	self.ex_obmonpmsg = false;
	self.ex_obmonpsound = false;

	// 0 = no obituary	   - with stats (---)
	// 1 = stock obituary	- with stats (---)
	// 2 = stock obituary	- with stats and personal sounds (--S)
	// 3 = stock obituary	- with stats and personal messages (-M-)
	// 4 = stock obituary	- with stats, personal messages and personal sounds (-MS)
	// 5 = eXtreme+ obituary - with stats (X--)
	// 6 = eXtreme+ obituary - with stats and personal sounds (X-S)
	// 7 = eXtreme+ obituary - with stats and personal message (XM-)
	// 8 = eXtreme+ obituary - with stats, personal messages and personal sounds (XMS)
	if(level.ex_obituary >= 5) self.ex_obmonamsg = true;
	if(level.ex_obituary == 3 || level.ex_obituary == 4 || level.ex_obituary == 7 || level.ex_obituary == 8) self.ex_obmonpmsg = true;
	if(level.ex_obituary == 2 || level.ex_obituary == 4 || level.ex_obituary == 6 || level.ex_obituary == 8) self.ex_obmonpsound = true;

	if(level.ex_obituary >= 1 && level.ex_obituary <= 4)
	{
		if(level.ex_teamplay && isDefined(attacker.pers) && self.team == attacker.team && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0)
			obituary(self, self, sWeapon, sMeansOfDeath);
		else
			obituary(self, attacker, sWeapon, sMeansOfDeath);
	}	
	thread extremeobituary(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
}

extremeobituary(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	// sMeansOfDeath conversions
	
	if(sMeansOfDeath == "MOD_EXPLOSIVE" && sWeapon == "artillery_mp") sMeansOfDeath = "MOD_NONE"; //ambit stuff
	
	if(sMeansOfDeath == "MOD_EXPLOSIVE" && sWeapon == "airstrike_mp") sMeansOfDeath = "MOD_NONE"; //ambit stuff
	
	if(sMeansOfDeath == "MOD_EXPLOSIVE" && sWeapon == "planecrash_mp") sMeansOfDeath = "MOD_NONE"; //ambit stuff
	
	if(sMeansOfDeath == "MOD_EXPLOSIVE" && sWeapon == "destructible_car") sMeansOfDeath = "MOD_CAR";
	
	if(sMeansOfDeath == "MOD_EXPLOSIVE" && sWeapon == "nuke_mp") sMeansOfDeath = "MOD_NUKE"; 
	
	if(sMeansOfDeath == "MOD_GRENADE_SPLASH" && sWeapon == "c4_mp") sMeansOfDeath = "MOD_C4";

	if(sMeansOfDeath == "MOD_RIFLE_BULLET" && sWeapon == "saw_bipod_crouch_mp" || sWeapon == "saw_bipod_prone_mp" || sWeapon == "saw_bipod_stand_mp") sMeansOfDeath = "MOD_SAW"; 

	if(sMeansOfDeath == "MOD_GRENADE_SPLASH" && sWeapon == "gl_mp" || sWeapon == "gl_g3_mp" || sWeapon == "gl_g36c_mp"  || sWeapon == "gl_m4_mp" || sWeapon == "gl_m16_mp" || sWeapon == "gl_m14_mp") sMeansOfDeath = "MOD_M203"; 
	
	if(sMeansOfDeath == "MOD_GRENADE_SPLASH" && sWeapon == "claymore_mp") sMeansOfDeath = "MOD_CLAYMORE";

	if(sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_IMPACT")
	{
		switch(sWeapon)
		{
			case "airstrike_mp": sMeansOfDeath = "MOD_AIRSTRIKE"; break;
			case "artillery_mp": sMeansOfDeath = "MOD_ARTILLERY"; break;
			case "helicopter_mp": sMeansOfDeath = "MOD_HELICOPTER"; break;
			case "c4_mp": sMeansOfDeath = "MOD_C4"; break;
			case "claymore_mp": sMeansOfDeath = "MOD_CLAYMORE"; break;
			case "destructible_car": sMeansOfDeath = "MOD_CAR"; break;
			case "napalm_mp": sMeansOfDeath = "MOD_NAPALM"; break;
			case "gl_mp": sMeansOfDeath = "MOD_M203"; break;
			case "gl_m4_mp": sMeansOfDeath = "MOD_M203"; break;
			case "gl_m16_mp": sMeansOfDeath = "MOD_M203"; break;
			case "gl_m14_mp": sMeansOfDeath = "MOD_M203"; break;
			case "gl_g36c_mp": sMeansOfDeath = "MOD_M203"; break;
			case "gl_g3_mp": sMeansOfDeath = "MOD_M203"; break;
			case "ac130_25mm_mp": sMeansOfDeath = "MOD_AC130"; break;
			case "ac130_40mm_mp": sMeansOfDeath = "MOD_AC130"; break;
			case "ac130_105mm_mp": sMeansOfDeath = "MOD_AC130"; break;
			case "saw_bipod_crouch_mp": sMeansOfDeath = "MOD_SAW"; break;
			case "saw_bipod_prone_mp": sMeansOfDeath = "MOD_SAW"; break;
			case "saw_bipod_stand_mp": sMeansOfDeath = "MOD_SAW"; break;
			case "rpg_mp": sMeansOfDeath = "MOD_RPG"; break;
			case "nuke_mp": sMeansOfDeath = "MOD_NUKE"; break;
			/*
			case "m40a3_mp": 
			sMeansOfDeath = "MOD_RIFLE_BULLET"; 
			if(sHitLoc == "head")sMeansOfDeath = "MOD_HEAD_SHOT"; 
			break; 
			  
			case "m21_mp": 
			sMeansOfDeath = "MOD_RIFLE_BULLET"; 
			if(sHitLoc == "head")sMeansOfDeath = "MOD_HEAD_SHOT"; 
			break; 
		   
			case "dragunov_mp": 
			sMeansOfDeath = "MOD_RIFLE_BULLET";			  
			if(sHitLoc == "head")sMeansOfDeath = "MOD_HEAD_SHOT"; 
			break; 
			  
			case "remington700_mp": 
			sMeansOfDeath = "MOD_RIFLE_BULLET"; 
			if(sHitLoc == "head")sMeansOfDeath = "MOD_HEAD_SHOT"; 
			break; 
				 
			case "barrett_mp": 
			sMeansOfDeath = "MOD_RIFLE_BULLET"; 
			if(sHitLoc == "head")sMeansOfDeath = "MOD_HEAD_SHOT"; 
			break;
			*/
		}
	}

	if(level.obitlog) logprint("OBITUARY LOG: " + sMeansOfDeath + ", Weapon: " + sWeapon + ", Hitloc: " + sHitLoc + "\n");

	if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
	{
		self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"OBITUARY_FATALITY" );
		self playlocalSound("fatality");
	}
	
	if(sMeansOfDeath == "MOD_EXPLOSIVE")
	{
		self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"OBITUARY_ROADKILL" );
		self playlocalSound("roadkill");		
	}

	if(sMeansOfDeath == "MOD_TRIGGER_HURT") // unknown death
	{
		obitnad("", "unknown", false);
	}
	else if(sMeansOfDeath == "MOD_FALLING")	// falling
	{
		obitnad("fallingdeath", "falling", true);
	}
	else if(isDefined(attacker) && !isPlayer(attacker)) // ambient fx deaths
	{
		switch(sMeansOfDeath)
		{
			case "MOD_EXPLOSIVE":
			{
				switch(sWeapon)
				{
					case "plane_mp":
					obitnad("planedeath", "plane", false);
					break;
					
					case "planebomb_mp":
					obitnad("airstrikedeath", "plane_bomb", false);
					break;

					default:
					obitnad("minefielddeath", "minefield", true);
					break;
				}
			}
		}
	}
	else if(isDefined(attacker) && isPlayer(attacker)) // real player kills/deaths
	{
		if(attacker == self) // killed themself
		{
			switch(sMeansOfDeath)
			{
				case "MOD_AIRSTRIKE":
				obitnad("airstrikedeath", "selfairstrike", false);
				break;

				case "MOD_ARTILLERY":
				obitnad("artillerydeath", "selfartillery", false);
				break;

				case "MOD_CAR":
				obitnad("cardeath", "selfcar", false);
				break;

				case "MOD_SAW":
				obitnad("sawdeath", "selfsaw", false);
				break;

				case "MOD_CLAYMORE":
				obitnad("claymoredeath", "selfclaymore", false);
				break;

				case "MOD_M203":
				obitnad("m203death", "selfm203", false);
				break;

				case "MOD_GRENADE_SPLASH":
				obitnad("grenadedeath", "selfnade", false);
				break;

				case "MOD_HELICOPTER":
				obitnad("helostrikedeath", "selfhelostrike", false);
				break;

				case "MOD_C4":
				obitnad("c4death", "selfc4", false);
				break;

				case "MOD_NAPALM":
				obitnad("napalmdeath", "selfnapalm", false);
				break;
				
				case "MOD_NUKE":
				obitnad("nukedeath", "selfnuke", false);
				break;

				case "MOD_RPG":
				obitnad("rpgdeath", "selfrpg", false);
				break;

				case "MOD_SUICIDE":
				obitnad("grenadedeath", "selfnades", true);
				break;
			}
		}
		else if(level.ex_teamplay && attacker.pers["team"] != self.pers["team"] || !level.ex_teamplay) // did not kill themself
		{
			if(isSpecialMOD(sMeansOfDeath)) // special MOD
			{
				switch(sMeansOfDeath)
				{
					case "MOD_AC130":
					obitspec(attacker, "ac130kill", "ac130death", "explosive", &"OBITUARY_WITH_AC130");
					break;

					case "MOD_AIRSTRIKE":
					obitspec(attacker, "airstrikekill", "airstrikedeath", "explosive", &"OBITUARY_WITH_AIRSTRIKE");
					break;

					case "MOD_ARTILLERY":
					obitspec(attacker, "artillerykill", "artillerydeath", "explosive", &"OBITUARY_WITH_ARTILLERY");
					break;

					case "MOD_CAR":
					obitspec(attacker, "carkill", "cardeath", "explosive", &"OBITUARY_WITH_CAR");
					break;

					case "MOD_SAW":
					obitspec(attacker, "sawkill", "sawdeath", "psaw", &"OBITUARY_WITH_SAW");
					break;

					case "MOD_M203":
					obitspec(attacker, "m203kill", "m203death", "explosive", &"OBITUARY_WITH_M203");
					break;

					case "MOD_CLAYMORE":
					obitspec(attacker, "claymorekill", "claymoredeath", "explosive", &"OBITUARY_WITH_CLAYMORE");
					break;

					case "MOD_C4":
					obitspec(attacker, "c4kill", "c4death", "explosive", &"OBITUARY_WITH_C4");
					break;

					case "MOD_GRENADE_SPLASH":
					obitspec(attacker, "grenadekill", "grenadedeath", "explosive", &"OBITUARY_WITH_A_GRENADE");
					break;

					case "MOD_HELICOPTER":
					obitspec(attacker, "helostrikekill", "helostrikedeath", "explosive", &"OBITUARY_WITH_HELOSTRIKE");
					break;

					case "MOD_NAPALM":
					obitspec(attacker, "napalmkill", "napalmdeath", "pnapalm", &"OBITUARY_WITH_NAPALM");
					break;
					
					case "MOD_RPG":
					obitspec(attacker, "rpgkill", "rpgdeath", "prpg", &"OBITUARY_WITH_RPG");
					break;

					case "MOD_NUKE":
					obitspec(attacker, "nukekill", "nukedeath", "pnuke", &"OBITUARY_WITH_NUKE");
					break;

					case "MOD_HEAD_SHOT":
					{
					  obitad(attacker, "headshotkill", "headshotdeath", "", sMeansOfDeath, sWeapon);
					  if(isWeaponType(sWeapon, "sniper")) obitstat(attacker, "sniperkill", "sniperdeath");
					  obitmain(attacker, sWeapon, sHitLoc, false);
					  if(self.ex_obmonpmsg) attacker thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"OBITUARY_HEADSHOT" );
					  if(self.ex_obmonpsound) attacker playlocalSound("headshot");
					  if(level.ex_headshotreward)
						{
						 attacker.pers["score"] = attacker.pers["score"] + level.ex_headshotpoints;
						 attacker.score = attacker.score + 5;
						 if(self.ex_obmonpmsg) attacker iprintlnbold("Headshot bonus: ^2+ " + level.ex_headshotpoints + " ^7pts");
						}
					  break;
					}

					case "MOD_MELEE":
					{
					  obitad(attacker, "knifekill", "knifedeath", "knifewhip", sMeansOfDeath, sWeapon);
					  if(self.ex_obmonpmsg) self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"OBITUARY_HUMILIATION" );
					  if(self.ex_obmonpsound) self playlocalSound("humiliation");
					  if(level.ex_meleereward)
						{
						 attacker.pers["score"] = attacker.pers["score"] + level.ex_meleepoints;
						 attacker.score = attacker.score + 5;
						 if(self.ex_obmonpmsg) attacker iprintlnbold("Knife bonus: ^2+ " + level.ex_meleepoints + " ^7pts");
						}
					  break;
					} 
				}
			}
			else // not special MOD
			{
				// sniper kills
				if(isWeaponType(sWeapon, "sniper"))
				{
					obitad(attacker, "sniperkill", "sniperdeath", "", sMeansOfDeath, sWeapon);
					obitmain(attacker, sWeapon, sHitLoc, false);
					sMeansOfDeath = "MOD_IGNORE";
				}
			}
		}
		else if(attacker.pers["team"] == self.pers["team"] && level.ex_teamplay) // team kills
		{
			if(isSpecialMOD(sMeansOfDeath)) // special MOD
			{
				switch(sMeansOfDeath)
				{
					case "MOD_NAPALM":
					obitteam(attacker, "napalmtk", sMeansOfDeath, sWeapon);
					break;
					
					case "MOD_NUKE":
					obitteam(attacker, "nuketk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_SAW":
					obitteam(attacker, "sawtk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_CAR":
					obitteam(attacker, "cartk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_M203":
					obitteam(attacker, "m203tk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_C4":
					obitteam(attacker, "c4tk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_CLAYMORE":
					obitteam(attacker, "claymoretk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_RPG":
					obitteam(attacker, "rpgtk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_HEAD_SHOT":
					obitteam(attacker, "headshottk", sMeansOfDeath, sWeapon);
					break;

					case "MOD_MELEE":
					obitteam(attacker, "knifewhiptk", sMeansOfDeath, sWeapon);
					break;

					default:
					obitteam(attacker, "explosivetk", sMeansOfDeath, sWeapon);
					break;
				}
			}
			else // not special sMOD
			{
				if(isWeaponType(sWeapon, "sniper"))
				{
					obitteam(attacker, "snipertk", sMeansOfDeath, sWeapon);
					sMeansOfDeath = "MOD_IGNORE";
				}
			}
		}
	}

	// standard deaths
	if(sHitLoc != "none" && !isSpecialWeapon(sWeapon) && !isSpecialMOD(sMeansOfDeath) && isPlayer(attacker))
	{
		if(attacker.pers["team"] != self.pers["team"] && level.ex_teamplay || !level.ex_teamplay) obitmain(attacker, sWeapon, sHitLoc, true);
			else if(attacker.pers["team"] == self.pers["team"] && attacker != self && level.ex_teamplay) obitteam(attacker, "teamkill", sMeansOfDeath, sWeapon);
	}
	
	self thread killspree(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
	if(!isWeaponType(sWeapon, "smg")) self thread weaponstreak(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
	if(isWeaponType(sWeapon, "smg") || isWeaponType(sWeapon, "assaultrifle")) self thread noobstreak(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);
	self thread consecdeath(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc);

	if(level.ex_fbannounce && level.ex_firstblood)
	{
		if(isDefined(attacker) && isPlayer(attacker))
		{
			players = level.players;
			for(i = 0; i < players.size; i++)
			{
				if(players[i] != self)
				{
					if(level.ex_linux)
					{
						players[i] thread maps\mp\gametypes\_hud_message::oldNotifyMessage(&"FIRSTBLOOD_REPORT_ALL", attacker.name);
						//players[i] iprintlnbold(&"FIRSTBLOOD_REPORT_ALL", attacker.name);
						if(attacker.pers["team"] != self.pers["team"] || !level.ex_teamplay) players[i] iprintlnbold(&"FIRSTBLOOD_VICTIM", self.name);
							else if(attacker.pers["team"] == self.pers["team"] && level.ex_teamplay && attacker != self) players[i] iprintlnbold(&"FIRSTBLOOD_VICTIM_TEAM_MATE", self.name);
								else if(attacker == self) players[i] iprintlnbold(&"FIRSTBLOOD_VICTIM_SELF");
					}
					else
					{
						players[i] thread maps\mp\gametypes\_hud_message::oldNotifyMessage(&"FIRSTBLOOD_REPORT_ALL", attacker);
						//players[i] iprintlnbold(&"FIRSTBLOOD_REPORT_ALL", attacker);
						if(attacker.pers["team"] != self.pers["team"] || !level.ex_teamplay) players[i] iprintlnbold(&"FIRSTBLOOD_VICTIM", self);
							else if(attacker.pers["team"] == self.pers["team"] && level.ex_teamplay && attacker != self) players[i] iprintlnbold(&"FIRSTBLOOD_VICTIM_TEAM_MATE", self);
								else if(attacker == self) players[i] iprintlnbold(&"FIRSTBLOOD_VICTIM_SELF");
					}

					players[i] playLocalSound("firstblood");
				}
			}

			self thread maps\mp\gametypes\_hud_message::oldNotifyMessage(&"FIRSTBLOOD_REPORT_SELF");
			//self iprintlnbold(&"FIRSTBLOOD_REPORT_SELF");
			self playlocalsound("whyami");
		}
		level.ex_fbannounce = false;
	}
}

isSpecialWeapon(sWeapon)
{
	switch(sWeapon)
	{
		case "airstrike_mp":
		case "artillery_mp":
		case "helicopter_mp":
		case "nuke_mp":
		case "napalm_mp": return true;
	}

	return false;
}

isSpecialMOD(sMeansOfDeath)
{
	switch(sMeansOfDeath)
	{
		case "MOD_AC130":
		case "MOD_AIRSTRIKE":
		case "MOD_ARTILLERY":
		case "MOD_CAR":
		case "MOD_EXPLOSIVE":
		case "MOD_FALLING":
		case "MOD_RPG":
		case "MOD_C4":
		case "MOD_SAW":
		case "MOD_M203":
		case "MOD_CLAYMORE":
		case "MOD_GRENADE":
		case "MOD_GRENADE_SPLASH":
		case "MOD_HEAD_SHOT":
		case "MOD_HELICOPTER":
		case "MOD_MELEE":
		case "MOD_NAPALM":
		case "MOD_NUKE":
		case "MOD_PROJECTILE":
		case "MOD_SUICIDE":
		case "MOD_IGNORE": return true;
	}

	return false;
}

// special detection - no attacker defined
obitnad(vartype, amsg, issuicide)
{
	self endon("disconnect");

	self.pers["death"]++;
	if(vartype != "") self.pers[vartype]++;
	if(issuicide)
	{
		self.pers["kill"]--;
		self.pers["suicide"]++;
	}

	if(level.obitlog) logprint("OBITNAD: self skd(" + self.score + ":" + self.pers["kill"] + ":" + self.pers["death"] + ")\n");

	if(amsg != "")
	{
		if(self.ex_obmonpmsg) self showpmsgs(amsg);
		if(self.ex_obmonamsg)
		{
			if(level.ex_linux) iprintln(getmessage(amsg), self.name);
				else iprintln(getmessage(amsg), self);
		}
	}
}

// special detection - attacker defined
obitad(attacker, atvt, vivt, amsg, sMeansOfDeath, sWeapon)
{
	self endon("disconnect");
	
	attacker.pers["kill"]++;
	self.pers["death"]++;
	if(atvt != "") attacker.pers[atvt]++;
	if(vivt != "") self.pers[vivt]++;

	if(level.obitlog) logprint("OBITAD: attacker " + attacker.name + " skd(" + (attacker.score+1) + ":" + attacker.pers["kill"] + ":" + attacker.pers["death"] + "), self " + self.name + " skd(" + self.score + ":" + self.pers["kill"] + ":" + self.pers["death"] + ")\n");

	if(amsg != "")
	{
		weapon = getweaponstringname(sWeapon);
		
		if(sMeansOfDeath == "MOD_MELEE")
		{
			if(self.ex_obmonpmsg) self showpmsgs(amsg);
			if(self.ex_obmonamsg)
			{
				if(level.ex_linux)
				{
					iprintln(getmessage(amsg), self.name);
					iprintln(&"OBITUARY_WITH_KNIFE", attacker.name);
				}
				else
				{
					iprintln(getmessage(amsg), self);
					iprintln(&"OBITUARY_WITH_KNIFE", attacker);
				}
			}
		}
		else
		{
			if(self.ex_obmonpmsg) self showpmsgs(amsg);
			if(self.ex_obmonamsg)
			{
				if(level.ex_linux)
				{
					iprintln(getmessage(amsg), self.name);
					iprintln(&"OBITUARY_USING", attacker.name, weapon);
				}
				else
				{
					iprintln(getmessage(amsg), self);
					iprintln(&"OBITUARY_USING", attacker, weapon);
				}
			}
		}
	}
}

// killed by teammate
obitteam(attacker, amsg, sMeansOfDeath, sWeapon)
{
	self endon("disconnect");

	if(!level.ex_sinbin) attacker.pers["teamkill"]++; // If enabled, sinbin in _ex_main::exPlayerKilled will handle it
	attacker.pers["kill"]--;

	if(level.obitlog) logprint("OBITTEAM: attacker " + attacker.name + " skd(" + (attacker.score-1) + ":" + attacker.pers["kill"] + ":" + attacker.pers["death"] + "), self " + self.name + " skd(" + self.score + ":" + self.pers["kill"] + ":" + self.pers["death"] + ")\n");

	if(amsg != "")
	{
		weapon = getweaponstringname(sWeapon);

		if(sMeansOfDeath == "MOD_MELEE")
		{
			if(self.ex_obmonpmsg) self showpmsgs(amsg);
			if(self.ex_obmonamsg)
			{
				if(level.ex_linux)
				{
					iprintln(getmessage(amsg), self.name);
					iprintln(&"OBITUARY_WITH_KNIFE", attacker.name);
				}
				else
				{
					iprintln(getmessage(amsg), self);
					iprintln(&"OBITUARY_WITH_KNIFE", attacker);
				}
			}
		}
		else
		{
			if(self.ex_obmonpmsg) self showpmsgs(amsg);
			if(self.ex_obmonamsg)
			{
				if(level.ex_linux)
				{
					iprintln(getmessage(amsg), self.name);
					iprintln(&"OBITUARY_USING", attacker.name, weapon);
				}
				else
				{
					iprintln(getmessage(amsg), self);
					iprintln(&"OBITUARY_USING", attacker, weapon);
				}
			}
		}
	}
}

// handles weapon_gramatic of mass destruction deaths
obitspec(attacker, atvt, vivt, amsg, wmd)
{
	self endon("disconnect");
	
	attacker.pers["kill"]++;
	self.pers["death"]++;
	if(atvt != "") attacker.pers[atvt]++;
	if(vivt != "") self.pers[vivt]++;

	if(level.obitlog) logprint("OBITSPEC: attacker " + attacker.name + " skd(" + (attacker.score+1) + ":" + attacker.pers["kill"] + ":" + attacker.pers["death"] + "), self " + self.name + " skd(" + self.score + ":" + self.pers["kill"] + ":" + self.pers["death"] + ")\n");

	if(amsg != "")
	{
		if(self.ex_obmonpmsg) self showpmsgs(amsg);
		if(self.ex_obmonamsg)
		{
			if(level.ex_linux)
			{
				iprintln(getmessage(amsg), self.name);
				iprintln(wmd, attacker.name);
			}
			else
			{
				iprintln(getmessage(amsg), self);
				iprintln(wmd, attacker);
			}
		}
	}
}

// standard weapons
obitmain(attacker, sWeapon, sHitLoc, updstat)
{
	self endon("disconnect");

	if(updstat)
	{
		attacker.pers["kill"]++;
		self.pers["death"]++;
	}

	if(level.obitlog) logprint("OBITMAIN: attacker " + attacker.name + " skd(" + (attacker.score+1) + ":" + attacker.pers["kill"] + ":" + attacker.pers["death"] + "), self " + self.name + " skd(" + self.score + ":" + self.pers["kill"] + ":" + self.pers["death"] + ")\n");

	if(!self.ex_obmonamsg) return;

	inyards = false;
	calcdist = undefined;
	showdist = false;

	range = int(distance(attacker.origin, self.origin));
	if(isDefined(range))
	{
		if(level.ex_obrange == 1)
		{
			inyards = true;
			calcdist = int(range * 0.02778); // Range in Yards
			if(calcdist > 9) showdist = true;
		}
		else
		{
			calcdist = int(range * 0.0254); // Range in Metres
			if(calcdist > 3) showdist = true;
		}

		attacker thread obitlongstat("longdist", calcdist);
		if(sHitloc == "head") attacker thread obitlongstat("longhead", calcdist);
	}

	weapon = getweaponstringname(sWeapon);
	hitloc = gethitlocstringname(sHitLoc);

	if(level.ex_linux)
	{
		iprintln(&"OBITUARY_KILLED_HITLOC", self.name, hitloc);

		if(showdist)
		{
			iprintln(&"OBITUARY_ATTACKER_WEAPON", attacker.name, weapon);
			if(inyards) iprintln(&"OBITUARY_YARDS", calcdist);
				else iprintln(&"OBITUARY_METRES", calcdist);
		}
		else
		{
			iprintln(&"OBITUARY_CLOSE_RANGE", attacker.name);
			iprintln(&"OBITUARY_USING_WEAPON", weapon);
		}
	}
	else
	{
		iprintln(&"OBITUARY_KILLED_HITLOC", self, hitloc);

		if(showdist)
		{
			iprintln(&"OBITUARY_ATTACKER_WEAPON", attacker, weapon);
			if(inyards) iprintln(&"OBITUARY_YARDS", calcdist);
				else iprintln(&"OBITUARY_METRES", calcdist);
		}
		else
		{
			iprintln(&"OBITUARY_CLOSE_RANGE", attacker);
			iprintln(&"OBITUARY_USING_WEAPON", weapon);
		}
	}
}

// special stat update
obitstat(attacker, atvt, vivt)
{
	self endon("disconnect");

	if(atvt != "") attacker.pers[atvt]++;
	if(vivt != "") self.pers[vivt]++;
}

obitlongstat(stat, value)
{
	if(value > self.pers[stat])
	  self.pers[stat] = value;
}

killspree(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	if(!isPlayer(attacker)) return;
	if(level.ex_teamplay && attacker.pers["team"] == self.pers["team"])
	{
		attacker.pers["conseckill"]--;
		return;
	}

	if(attacker != self)
	{
		// check for end of a players killing spree	
		if(self.pers["conseckill"] >= 5)
		{
			if(self.ex_obmonamsg)
			{
				amsg1 = undefined;
				amsg2 = undefined;

				if(self.pers["conseckill"] >= 30)
				{
					amsg1 = &"KILLSPREE_HAS_SAVED_ALL_OUR_ASSES_FROM";
					amsg2 = &"KILLSPREE_ANAL_RAPE";
				}
				else if(self.pers["conseckill"] >= 25)
				{
					amsg1 = &"KILLSPREE_HAS_SAVED_US_ALL_FROM";
					amsg2 = &"KILLSPREE_UNHOLY";
				}
				else if(self.pers["conseckill"] >= 20)
				{
					amsg1 = &"KILLSPREE_HAS_STOPPED_THE_UNSTOPPABLE";
					amsg2 = &"KILLSPREE_CRUSADE";
				}
				else if(self.pers["conseckill"] >= 15)
				{
					amsg1 = &"KILLSPREE_HAS_STOPPED_THE_UNSTOPPABLE";
					amsg2 = &"KILLSPREE_UNREAL";
				}
				else if(self.pers["conseckill"] >= 10)
				{
					amsg1 = &"KILLSPREE_HAS_STOPPED";
					amsg2 = &"KILLSPREE_FLUKISH";
				}
				else if(self.pers["conseckill"] >= 5)
				{
					amsg1 = &"KILLSPREE_HAS_STOPPED";
					amsg2 = &"KILLSPREE_PLURAL";
				}

				if(isDefined(amsg1))
				{
					if(level.ex_linux) iprintln(amsg1, attacker.name);
						else iprintln(amsg1, attacker);
				}
				if(isDefined(amsg2))
				{
					if(level.ex_linux) iprintln(amsg2, self.name);
						else iprintln(amsg2, self);
				}
			}

			self.pers["conseckill"] = 0;

			if(self.ex_obmonpsound)
			{
				attacker playLocalSound("nailedhim");
				if(self.ex_obmonpsound) attacker playlocalSound("mp_last_stand");
				if(self.ex_obmonpmsg) attacker iprintlnbold("^1B U Z Z K I L L");

				players = level.players;
				for(i = 0; i < players.size; i++) if(players[i] != self) players[i] playlocalsound("hallelujah");
				//self playlocalsound("hallelujah");
				//self.ex_deathmusic = false;
			}
		}

		// check for a players killing spree
		if(attacker.pers["conseckill"] < 0) attacker.pers["conseckill"] = 0;

		attacker.pers["conseckill"]++;
		attacker thread obitlongstat("longspree", attacker.pers["conseckill"]);

		pmsg = undefined;
		amsg = undefined;
		psnd = undefined;

		if(attacker.pers["conseckill"] >= 5)
		{
			if(attacker.pers["conseckill"] == 5)
			{
				amsg = &"KILLSPREE_MSG_5";
				pmsg = &"KILLSPREE_KILLSPREE_PMSG";
				psnd = "killingspree";
			}
			else if(attacker.pers["conseckill"] == 10)
			{
				amsg = &"KILLSPREE_MSG_10";
				pmsg = &"KILLSPREE_DOMINATING_PMSG";
				psnd = "dominating";
			}
			else if(attacker.pers["conseckill"] == 15)
			{
				amsg = &"KILLSPREE_MSG_15";
				pmsg = &"KILLSPREE_RAMPAGE_PMSG";
				psnd = "rampage";
			}
			else if(attacker.pers["conseckill"] == 20)
			{
				amsg = &"KILLSPREE_MSG_20";
				pmsg = &"KILLSPREE_UNSTOPPABLE_PMSG";
				psnd = "unstoppable";
			}
			else if(attacker.pers["conseckill"] == 25)
			{
				amsg = &"KILLSPREE_MSG_25";
				pmsg = &"KILLSPREE_MONSTER_KILL_PMSG";
				psnd = "monsterkill";
			}
			else if(attacker.pers["conseckill"] >= 30)
			{
				amsg = &"KILLSPREE_MSG_30";
				ps = randomInt(100);
				if(ps <= 25) { psnd = "ultrakill"; pmsg = &"KILLSPREE_ULTRA_KILL_PMSG"; }
				else if(ps > 25 && ps <= 50) { psnd = "godlike"; pmsg = &"KILLSPREE_GODLIKE_PMSG"; }
				else if(ps > 50 && ps <= 75) { psnd = "killingmachine"; pmsg = &"KILLSPREE_KILLINGMACHINE_PMSG"; }
				else if(ps > 75) { psnd = "juggernaut"; pmsg = &"KILLSPREE_JUGGERNAUT_PMSG"; }
			}

			if(self.ex_obmonamsg && isDefined(amsg))
			{
				if(level.ex_linux) iprintln(amsg, attacker.name);
					else iprintln(amsg, attacker);
			}
			if(self.ex_obmonpmsg && isDefined(pmsg)) attacker iprintlnbold(pmsg);		   
			if(self.ex_obmonpsound && isDefined(psnd)) attacker playLocalSound(psnd);
		}
	}
}

weaponstreak(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	if(!isPlayer(attacker)) return;
	if(attacker.pers["team"] == self.pers["team"] && level.ex_teamplay) return;

	if(isDefined(attacker.pers["weaponname"]) && sWeapon == attacker.pers["weaponname"]) attacker.pers["weaponstreak"]++;
	else
	{
		attacker.pers["weaponstreak"] = 1;
		attacker.pers["weaponname"] = sWeapon;
	}

	attacker_weapon = getweaponstringname(attacker.pers["weaponname"]);

	if(attacker.pers["weaponstreak"] >= 5 && self.ex_obmonamsg)
	{
		amsg1 = undefined;
		amsg2 = undefined;

		if(attacker.pers["weaponstreak"] == 5) amsg1 = &"WEAPONSTREAK_MSG_5";
		else if(attacker.pers["weaponstreak"] == 10) amsg1 = &"WEAPONSTREAK_MSG_10";
		else if(attacker.pers["weaponstreak"] == 15) amsg1 = &"WEAPONSTREAK_MSG_15";
		else if(attacker.pers["weaponstreak"] == 20) amsg1 = &"WEAPONSTREAK_MSG_20";
		else if(attacker.pers["weaponstreak"] == 25) amsg1 = &"WEAPONSTREAK_MSG_25";
		else if(attacker.pers["weaponstreak"] == 30) amsg1 = &"WEAPONSTREAK_MSG_30";
		else if(attacker.pers["weaponstreak"] >= 35)
		{
			amsg1 = &"WEAPONSTREAK_MSG_35A";
			amsg2 = &"WEAPONSTREAK_MSG_35B";
		}

		if(isDefined(amsg1))
		{
				if(level.ex_linux) iprintln(amsg1, attacker.name, attacker_weapon);
					else iprintln(amsg1, attacker, attacker_weapon);
		}
		if(isDefined(amsg2)) iprintln(amsg2, attacker.pers["weaponstreak"]);
	}
}

noobstreak(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	if(!isPlayer(attacker)) return;
	if(attacker.pers["team"] == self.pers["team"] && level.ex_teamplay) return;

	if(isDefined(attacker.pers["weaponname"]) && sWeapon == attacker.pers["weaponname"]) attacker.pers["noobstreak"]++;
	else
	{
		attacker.pers["noobstreak"] = 1;
		attacker.pers["weaponname"] = sWeapon;
	}

	attacker_weapon = getweaponstringname(attacker.pers["weaponname"]);
	if(attacker.pers["noobstreak"]%5==0) attacker.pers["spamkill"]++;

	if(attacker.pers["noobstreak"] >= 5 && self.ex_obmonamsg)
	{
		amsg1 = undefined;
		amsg2 = undefined;

		if(attacker.pers["noobstreak"] == 5) amsg1 = &"NOOBSTREAK_MSG_5";
		else if(attacker.pers["noobstreak"] == 10) amsg1 = &"NOOBSTREAK_MSG_10";
		else if(attacker.pers["noobstreak"] == 15) amsg1 = &"NOOBSTREAK_MSG_15";
		else if(attacker.pers["noobstreak"] == 20) amsg1 = &"NOOBSTREAK_MSG_20";
		else if(attacker.pers["noobstreak"] == 25) amsg1 = &"NOOBSTREAK_MSG_25";
		else if(attacker.pers["noobstreak"] == 30) amsg1 = &"NOOBSTREAK_MSG_30";
		else if(attacker.pers["noobstreak"] >= 35)
		{
			amsg1 = &"NOOBSTREAK_MSG_35A";
			amsg2 = &"NOOBSTREAK_MSG_35B";
		}

		if(isDefined(amsg1))
		{
				if(level.ex_linux) iprintln(amsg1, attacker.name, attacker_weapon);
					else iprintln(amsg1, attacker, attacker_weapon);
		}
		if(isDefined(amsg2)) iprintln(amsg2, attacker.pers["noobstreak"]);
	}
}

consecdeath(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("disconnect");

	if(!isPlayer(attacker)) return;
	if(attacker.pers["team"] == self.pers["team"] && level.ex_teamplay) return;

	if(self.pers["conseckill"] > 0) self.pers["conseckill"] = 0;
	self.pers["conseckill"]--;

	if(self.pers["conseckill"] <= -5 && self.ex_obmonamsg)
	{
		amsg = undefined;

		if(self.pers["conseckill"] == -5) amsg = &"CONSECDEATHS_MSG_5";
		else if(self.pers["conseckill"] == -8) amsg = &"CONSECDEATHS_MSG_8";
		else if(self.pers["conseckill"] == -10) amsg = &"CONSECDEATHS_MSG_10";
		else if(self.pers["conseckill"] == -13) amsg = &"CONSECDEATHS_MSG_13";
		else if(self.pers["conseckill"] <= -16) amsg = &"CONSECDEATHS_MSG_16";

		if(isDefined(amsg))
		{
			if(level.ex_linux) iprintln(amsg, self.name);
				else iprintln(amsg, self);
		}
	}
}

getmessage(var)
{
	self endon("disconnect");

	if(!isDefined(var)) return undefined;

	msg = [];

	switch(var)
	{
		case "unknown":
			msg[0] = &"OBITUARY_UNKNOWN_MSG_0";
			msg[1] = &"OBITUARY_UNKNOWN_MSG_1";
			msg[2] = &"OBITUARY_UNKNOWN_MSG_2";
			break;

		case "falling":
			msg[0] = &"OBITUARY_FALLING_MSG_0";
			msg[1] = &"OBITUARY_FALLING_MSG_1";
			msg[2] = &"OBITUARY_FALLING_MSG_2";
			break;

		// exploding car
		case "selfcar":
			msg[0] = &"OBITUARY_CARSELF_MSG_0";
			break;

		case "cartk":
			msg[0] = &"OBITUARY_CAR_TK_MSG_0";
			break;

		// c4
		case "selfc4":
			msg[0] = &"OBITUARY_C4SELF_MSG_0";
			break;

		case "c4tk":
			msg[0] = &"OBITUARY_C4_TK_MSG_0";
			break;

		// saw
		case "selfsaw":
			msg[0] = &"OBITUARY_SAWSELF_MSG_0";
			break;

		case "sawtk":
			msg[0] = &"OBITUARY_SAW_TK_MSG_0";
			break;

		// claymore
		case "selfclaymore":
			msg[0] = &"OBITUARY_CLAYMORESELF_MSG_0";
			break;

		case "claymoretk":
			msg[0] = &"OBITUARY_CLAYMORE_TK_MSG_0";
			break;

		// m203
		case "selfm203":
			msg[0] = &"OBITUARY_M203SELF_MSG_0";
			break;

		case "m203tk":
			msg[0] = &"OBITUARY_M203_TK_MSG_0";
			break;

		// rpg
		case "selfrpg":
			msg[0] = &"OBITUARY_RPGSELF_MSG_0";
			break;

		case "rpgtk":
			msg[0] = &"OBITUARY_RPG_TK_MSG_0";
			break;

		// knife
		case "knifewhip":
			msg[0] = &"OBITUARY_KNIFE_WHIP";
			break;

		case "knifewhiptk":
			msg[0] = &"OBITUARY_KNIFE_WHIP_TK";
			break;

		// plane
		case "plane":
			msg[0] = &"OBITUARY_PLANE_MSG_0";
			msg[1] = &"OBITUARY_PLANE_MSG_1";
			break;

		case "plane_bomb":
			msg[0] = &"OBITUARY_PLANE_BOMB_MSG_0";
			msg[1] = &"OBITUARY_PLANE_BOMB_MSG_1";
			break;

		// artillery
		case "selfartillery":
			msg[0] = &"OBITUARY_ARTILLERYSELF_MSG_0";
			break;

		// airstrike
		case "selfairstrike":
			msg[0] = &"OBITUARY_AIRSTRIKESELF_MSG_0";
			break;

		// helicopter
		case "selfhelostrike":
			msg[0] = &"OBITUARY_HELOSTRIKESELF_MSG_0";
			break;

		// napalm
		case "pnapalm":
			msg[0] = &"OBITUARY_PNAPALM_MSG_0";
			msg[1] = &"OBITUARY_PNAPALM_MSG_1";
			break;

		case "napalmtk":
			msg[0] = &"OBITUARY_NAPALMTK_MSG_0";
			msg[1] = &"OBITUARY_NAPALMTK_MSG_1";
			break;

		case "selfnapalm":
			msg[0] = &"OBITUARY_NAPALMSELF_MSG_0";
			break;
			
		// nuke
		case "pnuke":
			msg[0] = &"OBITUARY_PNUKE_MSG_0";
			msg[1] = &"OBITUARY_PNUKE_MSG_1";
			break;
		
		case "nuketk":
			msg[0] = &"OBITUARY_NUKETK_MSG_0";
			msg[1] = &"OBITUARY_NUKETK_MSG_1";
			break;
			
		case "selfnuke":
			msg[0] = &"OBITUARY_NUKESELF_MSG_0";
			break;

		// explosive
		case "explosive":
			msg[0] = &"OBITUARY_EXPLOSIVE_MSG_0";
			msg[1] = &"OBITUARY_EXPLOSIVE_MSG_1";
			break;

		case "explosivetk":
			msg[0] = &"OBITUARY_EXPLOSIVETK_MSG_0";
			msg[1] = &"OBITUARY_EXPLOSIVETK_MSG_1";
			break;

		// mine
		case "minefield":
			msg[0] = &"OBITUARY_MINEFIELD_MSG_0";
			msg[1] = &"OBITUARY_MINEFIELD_MSG_1";
			msg[2] = &"OBITUARY_MINEFIELD_MSG_2";
			break;

		// grenade
		case "selfnade":
			msg[0] = &"OBITUARY_SELFNADE_MSG_0";
			msg[1] = &"OBITUARY_SELFNADE_MSG_1";
			break;

		case "selfnades":
			msg[0] = &"OBITUARY_SELFNADES_MSG_0";
			msg[1] = &"OBITUARY_SELFNADES_MSG_1";
			break;
			
		case "selfkamikaze":
			msg[0] = &"OBITUARY_SELFKAMIKAZE_MSG_0";
			msg[1] = &"OBITUARY_SELFKAMIKAZE_MSG_1";
			break;

		// specials
		case "headshottk":
			msg[0] = &"OBITUARY_HEADSHOT_TK_MSG_0";
			msg[1] = &"OBITUARY_HEADSHOT_TK_MSG_1";
			break;

		case "sniper":
			msg[0] = &"OBITUARY_SNIPER_MSG_0";
			msg[1] = &"OBITUARY_SNIPER_MSG_1";
			break;

		case "snipertk":
			msg[0] = &"OBITUARY_SNIPER_TK_MSG_0";
			msg[1] = &"OBITUARY_SNIPER_TK_MSG_1";
			break;

		// general teamkill
		case "teamkill":
			msg[0] = &"OBITUARY_TEAMKILL_MSG";
			break;

		default:
			msg[0] = &"OBITUARY_WAS_KILLED_BY";
			break;
	}
	
	wm = randomInt(msg.size);
	return msg[wm];
}

// show personal message
showpmsgs(message)
{
	self endon("disconnect");

	if(!isDefined(message)) return undefined;
	
	pmsg = undefined;
	switch(message)
	{
		case "unknown":
			pmsg = &"OBITUARY_UNKNOWN_PMSG";
			break;

		case "falling":
			pmsg = &"OBITUARY_FALLING_PMSG";
			break;

		// exploding car
		case "selfcar":
			pmsg = &"OBITUARY_CARSELF_PMSG";
			break;

		case "cartk":
			pmsg = &"OBITUARY_CAR_TK_PMSG";
			break;			
								   //rpg
		case "rpgtk":
			pmsg = &"OBITUARY_RPG_TK_PMSG";
			break;

		case "selfrpg":
			pmsg = &"OBITUARY_RPGSELF_PMSG";
			break;

								   //m203
		case "m203tk":
			pmsg = &"OBITUARY_M203_TK_PMSG";
			break;

		case "selfm203":
			pmsg = &"OBITUARY_M203SELF_PMSG";
			break;

								   //claymore
		case "claymoretk":
			pmsg = &"OBITUARY_CLAYMORE_TK_PMSG";
			break;

		case "selfclaymore":
			pmsg = &"OBITUARY_CLAYMORESELF_PMSG";
			break;

								   //saw
		case "sawtk":
			pmsg = &"OBITUARY_SAW_TK_PMSG";
			break;

		case "selfsaw":
			pmsg = &"OBITUARY_SAW_PMSG";
			break;
			
  		//c4
   		case "c4tk":
			pmsg = &"OBITUARY_C4_TK_PMSG";
			break;

		case "selfc4":
			pmsg = &"OBITUARY_C4SELF_PMSG";
			break;

		// knife
		case "knifewhip":
			pmsg = &"OBITUARY_KNIFE_WHIP_PMSG";
			break;

		case "knifewhiptk":
			pmsg = &"OBITUARY_KNIFE_WHIP_TK_PMSG";
			break;

		// plane bomb
		case "plane":
			pmsg = &"OBITUARY_PLANE_PMSG";
			break;

		case "plane_bomb":
			pmsg = &"OBITUARY_PLANE_BOMB_PMSG";
			break;

		// artillery
		case "artillery":
			pmsg = &"OBITUARY_ARTILLERY_PMSG";
			break;

		case "artillerytk":
			pmsg = &"OBITUARY_ARTILLERYTK_PMSG";
			break;

		case "selfartillery":
			pmsg = &"OBITUARY_ARTILLERYSELF_PMSG";
			break;

		// airstrike
		case "pairstrike":
			pmsg = &"OBITUARY_AIRSTRIKE_PMSG";
			break;

		case "airstriketk":
			pmsg = &"OBITUARY_AIRSTRIKETK_PMSG";
			break;

		case "selfairstrike":
			pmsg = &"OBITUARY_AIRSTRIKESELF_PMSG";
			break;

		// napalm
		case "pnapalm":
			pmsg = &"OBITUARY_NAPALM_PMSG";
			break;

		case "napalmtk":
			pmsg = &"OBITUARY_NAPALMTK_PMSG";
			break;

		case "selfnapalm":
			pmsg = &"OBITUARY_NAPALMSELF_PMSG";
			break;
		
		// nuke
		case "pnuke":
			pmsg = &"OBITUARY_NUKE_PMSG";
			break;

		case "nuketk":
			pmsg = &"OBITUARY_NUKETK_PMSG";
			break;

		case "selfnuke":
			pmsg = &"OBITUARY_NUKESELF_PMSG";
			break;

		// explosive
		case "explosive":
			pmsg = &"OBITUARY_EXPLOSIVE_PMSG";
			break;
			
		case "explosivetk":
			pmsg = &"OBITUARY_EXPLOSIVETK_PMSG";
			break;

		// mine
		case "minefield":
			pmsg = &"OBITUARY_MINEFIELD_PMSG";
			break;
		
		// grenade
		case "selfnade":
			pmsg = &"OBITUARY_SELFNADE_PMSG";
			break;
			
		case "selfnades":
			pmsg = &"OBITUARY_SELFNADES_PMSG";
			break;

		case "selfkamikaze":
			pmsg = &"OBITUARY_SELFKAMIKAZE_PMSG";
			break;

		// specials
		case "headshottk":
			pmsg = &"OBITUARY_HEADSHOT_TK_PMSG";
			break;

		case "sniper":
			pmsg = &"OBITUARY_SNIPER_PMSG";
			break;

		case "snipertk":
			pmsg = &"OBITUARY_SNIPER_TK_PMSG";
			break;

		// general teamkill
		case "teamkill":
			pmsg = &"OBITUARY_TEAMKILL_PMSG";
			break;

		default:
			return;
	}

	self iprintlnbold(pmsg);
}

gethitlocstringname(location)
{
	switch(location)
	{
		case "right_hand":	  return &"HITLOC_RIGHT_HAND";
		case "left_hand":	   return &"HITLOC_LEFT_HAND";
		case "right_arm_upper": return &"HITLOC_RIGHT_UPPER_ARM";
		case "right_arm_lower": return &"HITLOC_RIGHT_FOREARM";
		case "left_arm_upper":  return &"HITLOC_LEFT_UPPER_ARM";
		case "left_arm_lower":  return &"HITLOC_LEFT_FOREARM";
		case "head":			return &"HITLOC_HEAD";
		case "neck":			return &"HITLOC_NECK";
		case "right_foot":	  return &"HITLOC_RIGHT_FOOT";
		case "left_foot":	   return &"HITLOC_LEFT_FOOT";
		case "right_leg_lower": return &"HITLOC_RIGHT_LOWER_LEG";
		case "left_leg_lower":  return &"HITLOC_LEFT_LOWER_LEG";
		case "right_leg_upper": return &"HITLOC_RIGHT_UPPER_LEG";
		case "left_leg_upper":  return &"HITLOC_LEFT_UPPER_LEG";
		case "torso_upper":	 return &"HITLOC_UPPER_TORSO";
		case "torso_lower":	 return &"HITLOC_LOWER_TORSO";
		case "none":			return &"HITLOC_UNKNOWN";
		default:				return location;
	}
}

getweaponstringname(weapon)
{
	switch(weapon)
	{
		// Winchester 1200
		case "winchester1200_mp":
		case "winchester1200_grip_mp":
		case "winchester1200_reflex_mp":
			return &"GWEAPON_WINCHESTER1200";

		// Uzi
		case "uzi_mp":
		case "uzi_acog_mp":
		case "uzi_reflex_mp":
		case "uzi_silencer_mp":
			return &"GWEAPON_UZI";

		// Usp
		case "usp_mp":	
		case "usp_silencer_mp":
			return &"GWEAPON_USP";

		// Skorpion
		case "skorpion_mp":
		case "skorpion_acog_mp":
		case "skorpion_reflex_mp":
		case "skorpion_silencer_mp":
			return &"GWEAPON_SKORPION";

		// Saw
		case "saw_mp":
		case "saw_acog_mp":
		case "saw_bipod_crouch_mp":
		case "saw_bipod_prone_mp":
		case "saw_bispod_stand_mp":
		case "saw_grip_mp":
		case "saw_reflex_mp":
			return &"GWEAPON_SAW";

		// RPG
		case "rpg_mp":
			return &"GWEAPON_RPG";

		// RPD
		case "rpd_mp":
		case "rpd_acog_mp":
		case "rpd_grip_mp":
		case "rpd_reflex_mp":
			return &"GWEAPON_RPD";

		// Remington 700
		case "remington700_mp":
		case "remington700_acog_mp":
			return &"GWEAPON_REMINGTON700";

		// P90
		case "p90_mp":
		case "p90_acog_mp":
		case "p90_reflex_mp":
		case "p90_silencer_mp":
			return &"GWEAPON_P90";

		// MP5
		case "mp5_mp":
		case "mp5_acog_mp":
		case "mp5_reflex_mp":
		case "mp5_silencer_mp":
			return &"GWEAPON_MP5";

		// MP44
		case "mp44_mp":
			return &"GWEAPON_MP44";

		// M60E4
		case "m60e4_mp":
		case "m60e4_acog_mp":
		case "m60e4_grip_mp":
		case "m60e4_reflex_mp":
			return &"GWEAPON_M60E4";

		// M40A3
		case "m40a3_mp":
		case "m40a3_acog_mp":
			return &"GWEAPON_M40A3";
		
		// M4
		case "m4_gl_mp":
			return &"GWEAPON_M4M203";
		case "m4_reflex_mp":
			return &"GWEAPON_M4AIMPOINT";
		case "m4_mp":
		case "m4_acog_mp":		
		case "m4_silencer_mp":
			return &"GWEAPON_M4";

		// M21
		case "m21_mp":
			return &"GWEAPON_M21_SILENCER";
		case "m21_acog_mp":
			return &"GWEAPON_M21";

		// M16
		case "m16_mp":
		case "m16_acog_mp":
		case "m16_gl_mp":
		case "m16_reflex_mp":
		case "m16_silencer_mp":
			return &"GWEAPON_M16";

		// M14
		case "m14_mp":
		case "m14_acog_mp":
		case "m14_gl_mp":
		case "m14_reflex_mp":
		case "m14_silencer_mp":
			return &"GWEAPON_M14";

		// M1014
		case "m1014_mp":
		case "m1014_grip_mp":
		case "m1014_reflex_mp":
			return &"GWEAPON_BENELLI";

		// GL
		case "gl_mp":
		case "gl_m4_mp":
		case "gl_m16_mp":
		case "gl_m14_mp":
		case "gl_g36c_mp":
		case "gl_g3_mp":
			return &"GWEAPON_M203";

		case "gl_ak47_mp":
			return &"GWEAPON_AK47_GP25";

		// G36C
		case "g36c_gl_mp":
			return &"GWEAPON_M4M203_SILENCER";
		case "g36c_mp":
		case "g36c_acog_mp":		
		case "g36c_reflex_mp":
		case "g36c_silencer_mp":
			return &"GWEAPON_G36C";

		// G3
		case "g3_mp":
		case "g3_acog_mp":
		case "g3_gl_mp":
		case "g3_reflex_mp":
		case "g3_silencer_mp":
			return &"GWEAPON_G3";

		// Dragnov
		case "dragnov_mp":
		case "dragnov_acog_mp":
			return &"GWEAPON_DRAGNOV";

		// Desert Eagle
		case "deserteagle_mp":
			return &"GWEAPON_DESERTEAGLE";

		// Desert Eagle Gold
		case "deserteaglegold_mp":
			return &"GWEAPON_DESERTEAGLEGOLD";

		// Colt 45
		case "colt45_mp": 
		case "colt45_silencer_mp":
			return &"GWEAPON_COLT45";

		// Beretta
		case "beretta_mp":
		case "beretta_silencer_mp":
			return &"GWEAPON_BERETTA";

		// Barrett 50cal
		case "barrett_mp":
		case "barrett_acog_mp":
			return &"GWEAPON_BARRETT";

		// AW50
		case "aw50_mp":   
		case "aw50_acog_mp":
			return &"GWEAPON_AW50";

		// AT4
		case "at4_mp":
			return &"GWEAPON_AT4";

		// AK74U
		case "ak74u_mp":
		case "ak74u_acog_mp":
		case "ak74u_reflex_mp":
		case "ak74u_silencer_mp":
			return &"GWEAPON_AK74U";

		// AK47
		case "ak47_mp":
		case "ak47_acog_mp":
		case "ak47_gl_mp":
		case "ak47_reflex_mp":
		case "ak47_silencer_mp":
			return &"GWEAPON_AK47";

		// frag grenades
		case "frag_grenade_mp":
		case "frag_grenade_short_mp":
			return &"GWEAPON_M2FRAGGRENADE";

		// Claymore
		case "claymore_mp":
			return &"GWEAPON_CLAYMORE";

		// C4
		case "c4_mp":
			return &"GWEAPON_C4";

		default: return &"GWEAPON_UNKNOWN";
	}
}
