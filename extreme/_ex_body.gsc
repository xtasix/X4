
BodySearch(body,playerclone)
{
	self endon("death");
	self endon("disconnect");

	if (!level.ex_bodysearch)
		return;

	weaponslist = body getweaponslist();

	level.iBodies ++;
	level.oClone[level.iBodies] = playerclone;
	level.aBodies[level.iBodies]["Number"] = body.name;
	level.aBodies[level.iBodies]["Healthpacks"] = body.ex_firstaidkits;
	for( a = 0; a < weaponslist.size; a++ )
	{
		weapon = weaponslist[a];
		
		if(maps\mp\gametypes\_weapons::isPrimaryWeapon(weapon))
		{
			if(!isDefined(level.aBodies[level.iBodies]["Weapon_Load"]))
			{
				level.aBodies[level.iBodies]["Weapon_Load"]= weapon;
				level.aBodies[level.iBodies]["Weapon_Load_Ammo"] = body GetWeaponAmmoClip(weapon);
			}
		}

		if(maps\mp\gametypes\_weapons::isPistol(weapon))
		{
			if(!isDefined(level.aBodies[level.iBodies]["Pistol"]))
				level.aBodies[level.iBodies]["Pistol"] = weapon;
		}
		
		if(maps\mp\gametypes\_weapons::isGrenade(weapon))
		{	
			if(!isDefined(level.aBodies[level.iBodies]["Grenade"]))
			{
				level.aBodies[level.iBodies]["Grenade"] = weapon;
				level.aBodies[level.iBodies]["Grenade_ammount"] = body GetWeaponAmmoClip(weapon);
			}
		}

		if(maps\mp\gametypes\_weapons::isGrenade(weapon) && weapon !=level.aBodies[level.iBodies]["Grenade"])
		{
			if(!isDefined(level.aBodies[level.iBodies]["Grenade1"]))
			{
				level.aBodies[level.iBodies]["Grenade1"] = weapon;
				level.aBodies[level.iBodies]["Grenade1_ammount"] = body GetWeaponAmmoClip(weapon);
			}	
		}
	}
}

SearchBody()
{
	self endon("death");
	self endon("disconnect");
	
	if(self.issearching)
		return;
	
	for(i = 1; i <= level.iBodies; i++)
	{
		if(isDefined(level.oClone[i]) && distance(level.oClone[i].origin, self.origin)<20)
		{	
			self.issearching = true;
			
			if(level.ex_show_searchicon && (self getStance() == "crouch" || self getStance() == "prone"))
			{	
				if(!isdefined(self.ex_searchicon))
				{
					self.ex_searchicon = newClientHudElem(self);	
					self.ex_searchicon.x = 320;
					self.ex_searchicon.y = 375;
					self.ex_searchicon.alignX = "center";
					self.ex_searchicon.alignY = "middle";
					self.ex_searchicon.horzAlign = "fullscreen";
					self.ex_searchicon.vertAlign = "fullscreen";
					self.ex_searchicon.hideWhenInMenu = true;
					self.ex_searchicon.alpha = 0.8;
					self.ex_searchicon setShader("hint_usable",32,32);
				}
			}
				self Searching(i);
		}		
	}	
	
	if(isdefined(self.ex_searchicon)) self.ex_searchicon destroy();
	self.issearching = false;
}

Searching(body)
{
	range = 30;
	origin = self.origin;

	for(;;)
	{
		if(self getStance() == "crouch" || self getStance() == "prone") 
		if(isAlive(self) && self.sessionstate == "playing" && self meleeButtonPressed() && !isdefined(self.claymoredefallow))
		{
			// Ok to plant, show progress bar
			origin = self.origin;
			angles = self.angles;
	
			planttime = level.ex_searchtime + randomFloat(1);
	
			self disableWeapons();
				
			if(!isdefined(self.ex_plantbar))
			{
				barsize = 288;

				// Time for progressbar 
				bartime = planttime;

				// Background
				self.ex_plantbarbackground = newClientHudElem(self);				
				self.ex_plantbarbackground.alignX = "center";
				self.ex_plantbarbackground.alignY = "middle";
				self.ex_plantbarbackground.x = 320;
				self.ex_plantbarbackground.y = 405;
				self.ex_plantbarbackground.horzAlign = "fullscreen";
				self.ex_plantbarbackground.vertAlign = "fullscreen";
				self.ex_plantbarbackground.hideWhenInMenu = true;
				self.ex_plantbarbackground.alpha = 0.5;
				self.ex_plantbarbackground.color = (0,0,0);
				self.ex_plantbarbackground setShader("white", (barsize + 4), 3);
			
				// Progress bar
				self.ex_plantbar = newClientHudElem(self); 			
				self.ex_plantbar.alignX = "left";
				self.ex_plantbar.alignY = "middle";
				self.ex_plantbar.horzAlign = "fullscreen";
				self.ex_plantbar.vertAlign = "fullscreen";
				self.ex_plantbar.hideWhenInMenu = true;
				self.ex_plantbar.x = (320 - (barsize / 2.0));
				self.ex_plantbar.y = 405;
				self.ex_plantbar setShader("white", 0, 2);
				self.ex_plantbar scaleOverTime(bartime , barsize, 2);

				// Play plant sound
				if(level.ex_bodysearchsound)
					self playsound("mp_bomb_plant");
			}
				color = 1;
				for(i=0;i<planttime*20;i++)
				{
					if(!(self meleeButtonPressed() && origin == self.origin && isAlive(self) && self.sessionstate == "playing" && !isdefined(self.claymoredefallow)))
						break;
	
					// Make sure player is in prone or crouch (do after 0.5 second to avoid unwanted crouching while trying to bash someone)
					if(i>10)
					{
						stance = self GetStance();
						if(!(stance == "crouch" || stance == "stand")) self setClientDvar("cl_stance","1");
					}
	
					self.ex_plantbar.color = (color,color,1);
					color -= 0.05 / planttime;
	
					wait (0.05 * level.fps_multiplier);
				}
				// Remove hud elements
				if(isdefined(self.ex_plantbarbackground)) self.ex_plantbarbackground 	destroy();
				if(isdefined(self.ex_plantbar))		 self.ex_plantbar destroy();
				
				if(i<planttime*20 )
				{
					self enableWeapons();
					return;
				}
							msg = true;;

				if(isDefined(level.aBodies[body]["Weapon_Load"]) && int(level.aBodies[body]["Weapon_Load_Ammo"])>0)
				{
					if(level.aBodies[body]["Weapon_Load"] == "m16_mp" || level.aBodies[body]["Weapon_Load"] == "m16_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "m16_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "m16_silencer_mp")
					self iprintlnbold(&"BODY_M16A4");
					else if(level.aBodies[body]["Weapon_Load"] == "ak47_mp" || level.aBodies[body]["Weapon_Load"] == "ak47_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "ak47_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "ak47_silencer_mp")
					self iprintlnbold(&"BODY_AK47");
					else if(level.aBodies[body]["Weapon_Load"] == "m4_mp" || level.aBodies[body]["Weapon_Load"] == "m4_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "m4_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "m4_silencer_mp")
					self iprintlnbold(&"BODY_M4A1");
					else if(level.aBodies[body]["Weapon_Load"] == "g3_mp" || level.aBodies[body]["Weapon_Load"] == "g3_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "g3_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "g3_silencer_mp")
					self iprintlnbold(&"BODY_G3");
					else if(level.aBodies[body]["Weapon_Load"] == "g36c_mp" || level.aBodies[body]["Weapon_Load"] == "g36c_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "g36c_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "g36c_silencer_mp")
					self iprintlnbold(&"BODY_G36C");
					else if(level.aBodies[body]["Weapon_Load"] == "m14_mp" || level.aBodies[body]["Weapon_Load"] == "m14_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "m14_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "m14_silencer_mp")
					self iprintlnbold(&"BODY_M14");
					else if(level.aBodies[body]["Weapon_Load"] == "mp44_mp")
					self iprintlnbold(&"BODY_MP44");
					else if(level.aBodies[body]["Weapon_Load"] == "m16_gl_mp")
					self iprintlnbold(&"BODY_M16A4_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "ak47_gl_mp")
					self iprintlnbold(&"BODY_AK47_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "m4_gl_mp")
					self iprintlnbold(&"BODY_M4A1_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "g3_gl_mp")
					self iprintlnbold(&"BODY_G3_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "g36c_gl_mp")
					self iprintlnbold(&"BODY_G36C_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "m14_gl_mp")
					self iprintlnbold(&"BODY_M14_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "mp5_mp" || level.aBodies[body]["Weapon_Load"] == "mp5_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "mp5_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "mp5_silencer_mp")
					self iprintlnbold(&"BODY_MP5");
					else if(level.aBodies[body]["Weapon_Load"] == "skorpion_mp" || level.aBodies[body]["Weapon_Load"] == "skorpion_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "skorpion_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "skorpion_silencer_mp")
					self iprintlnbold(&"BODY_SKORPION");
					else if(level.aBodies[body]["Weapon_Load"] == "uzi_mp" || level.aBodies[body]["Weapon_Load"] == "uzi_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "uzi_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "uzi_silencer_mp")
					self iprintlnbold(&"BODY_MINIUZI");
					else if(level.aBodies[body]["Weapon_Load"] == "ak74u_mp" || level.aBodies[body]["Weapon_Load"] == "ak74u_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "ak74u_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "ak74u_silencer_mp")
					self iprintlnbold(&"BODY_AK47U");
					else if(level.aBodies[body]["Weapon_Load"] == "p90_mp" || level.aBodies[body]["Weapon_Load"] == "p90_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "p90_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "p90_silencer_mp")
					self iprintlnbold(&"BODY_P90");
					else if(level.aBodies[body]["Weapon_Load"] == "saw_mp" || level.aBodies[body]["Weapon_Load"] == "saw_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "saw_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "saw_grip_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "saw_bipod_crouch_mp" || level.aBodies[body]["Weapon_Load"] == "saw_bipod_prone_mp" || level.aBodies[body]["Weapon_Load"] == "saw_bipod_stand_mp")
					self iprintlnbold(&"BODY_M249_SAW");
					else if(level.aBodies[body]["Weapon_Load"] == "rpd_mp" || level.aBodies[body]["Weapon_Load"] == "rpd_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "rpd_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "rpd_grip_mp")
					self iprintlnbold(&"BODY_RPG");
					else if(level.aBodies[body]["Weapon_Load"] == "m60e4_mp" || level.aBodies[body]["Weapon_Load"] == "m60e4_acog_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "m60e4_reflex_mp" || level.aBodies[body]["Weapon_Load"] == "m60e4_grip_mp")
					self iprintlnbold(&"BODY_M60E4");
					else if(level.aBodies[body]["Weapon_Load"] == "m1014_mp" || level.aBodies[body]["Weapon_Load"] == "m1014_grip_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "m1014_reflex_mp")
					self iprintlnbold(&"BODY_M1014");
					else if(level.aBodies[body]["Weapon_Load"] == "winchester1200_mp" || level.aBodies[body]["Weapon_Load"] == "winchester1200_grip_mp" 
					|| level.aBodies[body]["Weapon_Load"] == "winchester1200_reflex_mp")
					self iprintlnbold(&"BODY_W1200");
					else if(level.aBodies[body]["Weapon_Load"] == "dragunov_mp" || level.aBodies[body]["Weapon_Load"] == "dragunov_acog_mp")
					self iprintlnbold(&"BODY_DRAGUNOV");
					else if(level.aBodies[body]["Weapon_Load"] == "m40a3_mp" || level.aBodies[body]["Weapon_Load"] == "m40a3_acog_mp")
					self iprintlnbold(&"BODY_M40A3");
					else if(level.aBodies[body]["Weapon_Load"] == "barrett_mp" || level.aBodies[body]["Weapon_Load"] == "barrett_acog_mp")
					self iprintlnbold(&"BODY_BARRETT");
					else if(level.aBodies[body]["Weapon_Load"] == "remington700_mp" || level.aBodies[body]["Weapon_Load"] == "remington700_acog_mp")
					self iprintlnbold(&"BODY_R700");
					else if(level.aBodies[body]["Weapon_Load"] == "m21_mp" || level.aBodies[body]["Weapon_Load"] == "m21_acog_mp")
					self iprintlnbold(&"BODY_M21");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_ak47_mp")
					self iprintlnbold(&"BODY_AK47_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_g36c_mp")
					self iprintlnbold(&"BODY_G36C_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_g3_mp")
					self iprintlnbold(&"BODY_G3_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_m14_mp")
					self iprintlnbold(&"BODY_M14_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_m16_mp")
					self iprintlnbold(&"BODY_M16A4_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_m4_mp")
					self iprintlnbold(&"BODY_M4A1_GL");
					else if(level.aBodies[body]["Weapon_Load"] == "gl_mp")
					self iprintlnbold(&"BODY_GRENADELAUNCH");
					self giveWeapon(level.aBodies[body]["Weapon_Load"]);
					self setWeaponAmmoClip(level.aBodies[body]["Weapon_Load"],int(level.aBodies[body]["Weapon_Load_Ammo"]));
					level.aBodies[body]["Weapon_Load"] = undefined;
					msg = false;
					break;
				}
				else
				if(isDefined(level.aBodies[body]["Pistol"]))
				{
					self FindPistols();
					if(level.aBodies[body]["Pistol"] == "beretta_mp" || level.aBodies[body]["Pistol"] == "beretta_silencer_mp")
					self iprintlnbold(&"BODY_BERETTA");
					else if(level.aBodies[body]["Pistol"] == "colt45_mp" || level.aBodies[body]["Pistol"] == "colt45_silencer_mp")
					self iprintlnbold(&"BODY_COLT45");
					else if(level.aBodies[body]["Pistol"] == "usp_mp" || level.aBodies[body]["Pistol"] == "usp_silencer_mp"|| level.aBodies[body]["Pistol"] == "usp_acog_mp")
					self iprintlnbold(&"BODY_USP");
					else if(level.aBodies[body]["Pistol"] == "deserteaglegold_mp" || level.aBodies[body]["Pistol"] == "deserteagle_mp")
					self iprintlnbold(&"BODY_EAGLE");
					self giveWeapon(level.aBodies[body]["Pistol"]);
					self switchToOffhand(level.aBodies[body]["Pistol"]);
					level.aBodies[body]["Pistol"] = undefined;	
					msg = false;
					break;
				}
				else
				if(isDefined(level.aBodies[body]["Grenade"]) && int(level.aBodies[body]["Grenade_ammount"])>0)
				{
					if(level.aBodies[body]["Grenade"] == "frag_grenade_mp" || level.aBodies[body]["Grenade"] == "frag_grenade_short_mp")
					self iprintlnbold(&"BODY_FRAG");
					total_grenades = self GetWeaponAmmoClip( level.aBodies[body]["Grenade"]);
					self giveWeapon(level.aBodies[body]["Grenade"]);
					self setWeaponAmmoClip(level.aBodies[body]["Grenade"],total_grenades+int(level.aBodies[body]["Grenade_ammount"]));
					level.aBodies[body]["Grenade"] = undefined;
					msg = false;
					break;
				}
				else
				if(isDefined(level.aBodies[body]["Grenade1"]) && int(level.aBodies[body]["Grenade1_ammount"])>0)
				{
					if(level.aBodies[body]["Grenade1"] == "concussion_grenade_mp")
					self iprintlnbold(&"BODY_CONCUSS");
					else if(level.aBodies[body]["Grenade1"] == "flash_grenade_mp")
					self iprintlnbold(&"BODY_FLASH");
					else if(level.aBodies[body]["Grenade1"] == "smoke_grenade_mp")
					self iprintlnbold(&"BODY_SMOKE");
					total_grenades1 = self GetWeaponAmmoClip( level.aBodies[body]["Grenade1"]);
					self giveWeapon(level.aBodies[body]["Grenade1"]);
					self setWeaponAmmoClip(level.aBodies[body]["Grenade1"],total_grenades1+int(level.aBodies[body]["Grenade1_ammount"]));
					level.aBodies[body]["Grenade1"] = undefined;
					msg = false;
					break;
				}
				/*
				else
				if(isDefined(level.aBodies[body]["Healthpacks"]) && level.ex_firstaid && level.ex_firstaidpickup && self.ex_firstaidkits < level.ex_firstaidpickup)
				{
					self iprintlnbold(&"BODY_HEALTH");
					self.ex_firstaidkits ++;
					self.ex_ishealing = true;
					if(isDefined(self.ex_firstaidval))
					{
						self.ex_firstaidval setValue(self.ex_firstaidkits);
						self.ex_firstaidval.color = (1, 1, 1);
					}
					//if we exceed the maxamount ...reset 
					if(self.ex_firstaidkits > level.ex_firstaidpickup)
					self.ex_firstaidkits = level.ex_firstaidpickup;	
					level.aBodies[body]["Healthpacks"] = undefined;
					msg = false;
					break;
				}
				*/
				else msg = true;

				if(msg)
				{
					nothing = [];
					nothing[nothing.size] = level.ex_search1;
					nothing[nothing.size] = level.ex_search2;
					nothing[nothing.size] = level.ex_search3;
					nothing[nothing.size] = level.ex_search4;
					nothing[nothing.size] = level.ex_search5;
					nothing[nothing.size] = level.ex_search6;
					nothing[nothing.size] = level.ex_search7;
					nothing[nothing.size] = level.ex_search8;
					nothing[nothing.size] = level.ex_search9;
					nothing[nothing.size] = level.ex_search10;
					nothing[nothing.size] = level.ex_search11;
					nothing[nothing.size] = level.ex_search12;
					nothing[nothing.size] = level.ex_search13;
					nothing[nothing.size] = level.ex_search14;
					nothing[nothing.size] = level.ex_search15;
					nothing[nothing.size] = level.ex_search16;
					nothing[nothing.size] = level.ex_search17;
					nothing[nothing.size] = level.ex_search18;
					nothing[nothing.size] = level.ex_search19;
					nothing[nothing.size] = level.ex_search20;

					self iprintlnbold(nothing[randomInt(nothing.size)]);
				}
			break;
		}
			wait (.05 * level.fps_multiplier);
	
			// Check distance
			distance = distance(origin, self.origin);
			if(distance >= range) break;
	}

	self enableWeapons();
	// Clean up
	if(isdefined(self.ex_plantbarbackground)) self.ex_plantbarbackground 	destroy();
	if(isdefined(self.ex_plantbar))		 self.ex_plantbar destroy();
	
	while(self meleeButtonPressed() && isAlive(self) && self.sessionstate == "playing")
		wait (.05 * level.fps_multiplier);
		
}

FindPistols()
{
	weaponslist  = self getweaponslist();

	for( a = 0; a < weaponslist.size; a++ )
	{
		weapon = weaponslist[a];
		if(maps\mp\gametypes\_weapons::isPistol(weapon))
			self dropItem(weapon);
	}
}
