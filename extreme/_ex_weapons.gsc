
isWeaponType(weapon, type)
{
	if(!isDefined(weapon)) return false;

	switch(type)
	{
		case "airsupport":
			switch(weapon)
			{
				case "ac130_105mm_mp":
				case "ac130_25mm_mp":
				case "ac130_40mm_mp":
				case "airstrike_mp":
				case "cobra_20mm_mp":
				case "cobra_ffar_mp":
				case "helicopter_mp":
				case "nuke_mp":
				case "hind_ffar_mp": return true;
				default: return false;
			}

		case "artillery":
			switch(weapon)
			{
				case "artillery_mp": return true;
				default: return false;
			}

		case "assaultrifle":
			switch(weapon)
			{
				case "ak47_acog_mp":
				case "ak47_gl_mp":
				case "ak47_mp":
				case "ak47_reflex_mp":
				case "ak47_silencer_mp":
				case "g3_acog_mp":
				case "g3_gl_mp":
				case "g3_mp":
				case "g3_reflex_mp":
				case "g3_silencer_mp":
				case "g36c_acog_mp":
				case "g36c_gl_mp":
				case "g36c_mp":
				case "g36c_reflex_mp":
				case "g36c_silencer_mp":
				case "m14_acog_mp":
				case "m14_gl_mp":
				case "m14_mp":
				case "m14_reflex_mp":
				case "m14_silencer_mp":
				case "m16_acog_mp":
				case "m16_gl_mp":
				case "m16_mp":
				case "m16_reflex_mp":
				case "m16_silencer_mp":
				case "m4_acog_mp":
				case "m4_gl_mp":
				case "m4_mp":
				case "m4_reflex_mp":
				case "m4_silencer_mp":
				case "mp44_mp": return true;
				default: return false;
			}

		case "car":
			switch(weapon)
			{
				case "destructible_car": return true;
				default: return false;
			}

		case "concgrenade":
			switch(weapon)
			{
				case "concussion_grenade_mp": return true;
				default: return false;
			}

		case "explosives":
			switch(weapon)
			{
				case "brick_blaster_mp":
				case "brick_bomb_mp":
				case "c4_mp":
				case "claymore_mp": return true;
				default: return false;
			}

		case "flashgrenade":
			switch(weapon)
			{
				case "flash_grenade_mp": return true;
				default: return false;
			}

		case "fraggrenade":
			switch(weapon)
			{
				case "frag_grenade_mp":
				case "frag_grenade_short_mp": return true;
				default: return false;
			}

		case "grenade":
			switch(weapon)
			{
				case "concussion_grenade_mp":
				case "flash_grenade_mp":
				case "frag_grenade_mp":
				case "frag_grenade_short_mp":
				case "smoke_grenade_mp": return true;
				default: return false;
			}

		case "grenadelauncher":
			switch(weapon)
			{
				case "gl_ak47_mp":
				case "gl_g36c_mp":
				case "gl_g3_mp":
				case "gl_m14_mp":
				case "gl_m16_mp":
				case "gl_m4_mp":
				case "gl_mp": return true;
				default: return false;
			}

		case "lmg":
			switch(weapon)
			{
				case "m60e4_acog_mp":
				case "m60e4_grip_mp":
				case "m60e4_mp":
				case "m60e4_reflex_mp":
				case "rpd_acog_mp":
				case "rpd_grip_mp":
				case "rpd_mp":
				case "rpd_reflex_mp":
				case "rpg_mp":
				case "saw_acog_mp":
				case "saw_grip_mp":
				case "saw_mp":
				case "saw_reflex_mp": return true;
				default: return false;
			}

		case "pistol":
			switch(weapon)
			{
				case "beretta_mp":
				case "beretta_silencer_mp":
				case "colt45_mp":
				case "colt45_silencer_mp":
				case "deserteaglegold_mp":
				case "deserteagle_mp":
				case "usp_mp":
				case "usp_silencer_mp":
				case "usp_acog_mp": return true;
				default: return false;
			}

		case "rocket":
			switch(weapon)
			{
				case "rpg_mp":
				case "at4_mp": return true;
				default: return false;
			}

		case "shotgun":
			switch(weapon)
			{
				case "m1014_grip_mp":
				case "m1014_mp":
				case "m1014_reflex_mp":
				case "winchester1200_grip_mp":
				case "winchester1200_mp":
				case "winchester1200_reflex_mp": return true;
				default: return false;
			}

		case "silenced":
			switch(weapon)
			{
				case "ak47_silencer_mp":
				case "ak74u_silencer_mp":
				case "beretta_silencer_mp":
				case "colt45_silencer_mp":
				case "g3_silencer_mp":
				case "g36c_silencer_mp":
				case "m14_silencer_mp":
				case "m16_silencer_mp":
				case "m4_silencer_mp":
				case "mp5_silencer_mp":
				case "p90_silencer_mp":
				case "skorpion_silencer_mp":
				case "usp_silencer_mp":
				case "uzi_silencer_mp": return true;
				default: return false;
			}

		case "smg":
			switch(weapon)
			{
				case "ak74u_acog_mp":
				case "ak74u_mp":
				case "ak74u_reflex_mp":
				case "ak74u_silencer_mp":
				case "mp5_acog_mp":
				case "mp5_mp":
				case "mp5_reflex_mp":
				case "mp5_silencer_mp":
				case "p90_acog_mp":
				case "p90_mp":
				case "p90_reflex_mp":
				case "p90_silencer_mp":
				case "skorpion_acog_mp":
				case "skorpion_mp":
				case "skorpion_reflex_mp":
				case "skorpion_silencer_mp":
				case "uzi_acog_mp":
				case "uzi_mp":
				case "uzi_reflex_mp":
				case "uzi_silencer_mp": return true;
				default: return false;
			}

		case "smokegrenade":
			switch(weapon)
			{
				case "smoke_grenade_mp": return true;
				default: return false;
			}

		case "sniper":
			switch(weapon)
			{
				case "aw50_acog_mp":
				case "aw50_mp":
				case "barrett_acog_mp":
				case "barrett_mp":
				case "dragunov_acog_mp":
				case "dragunov_mp":
				case "m21_acog_mp":
				case "m21_mp":
				case "m40a3_acog_mp":
				case "m40a3_mp":
				case "remington700_acog_mp":
				case "remington700_mp": return true;
				default: return false;
			}

		case "turret":
			switch(weapon)
			{
				case "humvee_50cal_mp":
				case "saw_bipod_crouch_mp":
				case "saw_bipod_prone_mp":
				case "saw_bipod_stand_mp": return true;
				default: return false;
			}

		case "marines":
			switch(weapon)
			{
				case "at4_mp":
				case "beretta_mp":
				case "beretta_silencer_mp":
				case "colt45_mp":
				case "colt45_silencer_mp":
				case "m14_acog_mp":
				case "m14_gl_mp":
				case "m14_mp":
				case "m14_reflex_mp":
				case "m14_silencer_mp":
				case "m16_acog_mp":
				case "m16_gl_mp":
				case "m16_mp":
				case "m16_reflex_mp":
				case "m16_silencer_mp":
				case "m4_acog_mp":
				case "m4_gl_mp":
				case "m4_mp":
				case "m4_reflex_mp":
				case "m4_silencer_mp":
				case "m60e4_acog_mp":
				case "m60e4_grip_mp":
				case "m60e4_mp":
				case "m60e4_reflex_mp":
				case "mp44_mp":
				case "mp5_acog_mp":
				case "mp5_mp":
				case "mp5_reflex_mp":
				case "mp5_silencer_mp":
				case "p90_acog_mp":
				case "p90_mp":
				case "p90_reflex_mp":
				case "p90_silencer_mp":
				case "saw_acog_mp":
				case "saw_grip_mp":
				case "saw_mp":
				case "saw_reflex_mp": return true;
				default: return false;
			}

		case "sas":
			switch(weapon)
			{
				case "at4_mp":
				case "g3_acog_mp":
				case "g3_gl_mp":
				case "g3_mp":
				case "g3_reflex_mp":
				case "g3_silencer_mp":
				case "g36c_acog_mp":
				case "g36c_gl_mp":
				case "g36c_mp":
				case "g36c_reflex_mp":
				case "g36c_silencer_mp":
				case "m60e4_acog_mp":
				case "m60e4_grip_mp":
				case "m60e4_mp":
				case "m60e4_reflex_mp":
				case "mp44_mp":
				case "mp5_acog_mp":
				case "mp5_mp":
				case "mp5_reflex_mp":
				case "mp5_silencer_mp":
				case "p90_acog_mp":
				case "p90_mp":
				case "p90_reflex_mp":
				case "p90_silencer_mp":
				case "saw_acog_mp":
				case "saw_grip_mp":
				case "saw_mp":
				case "saw_reflex_mp":
				case "usp_mp":
				case "usp_silencer_mp":
				case "usp_acog_mp": return true;
				default: return false;
			}

		case "arab":
		case "opfor":
		case "russian":
			switch(weapon)
			{
				case "ak47_acog_mp":
				case "ak47_gl_mp":
				case "ak47_mp":
				case "ak47_reflex_mp":
				case "ak47_silencer_mp":
				case "ak74u_acog_mp":
				case "ak74u_mp":
				case "ak74u_reflex_mp":
				case "ak74u_silencer_mp":
				case "at4_mp":
				case "deserteaglegold_mp":
				case "deserteagle_mp":
				case "dragunov_acog_mp":
				case "dragunov_mp":
				case "mp44_mp":
				case "rpd_acog_mp":
				case "rpd_grip_mp":
				case "rpd_mp":
				case "rpd_reflex_mp":
				case "rpg_mp":
				case "skorpion_acog_mp":
				case "skorpion_mp":
				case "skorpion_reflex_mp":
				case "skorpion_silencer_mp":
				case "uzi_acog_mp":
				case "uzi_mp":
				case "uzi_reflex_mp":
				case "uzi_silencer_mp": return true;
				default: return false;
			}
	}
}
