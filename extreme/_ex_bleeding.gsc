
playerBleed(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	wait (1 * level.fps_multiplier);

	bleedV = [];
	bleedV = getBleedData(sMeansOfDeath, sWeapon, sHitLoc);

	if(!isDefined(bleedV["bleedmsg"])) return;

	// Do not do friendly damage if friendly damage is off
	if(level.ex_teamplay && isPlayer(eAttacker) && self != eAttacker && self.pers["team"] == eAttacker.pers["team"])
	{
		if(level.friendlyfire == 0 || level.friendlyfire == 2) return;
		if(level.friendlyfire == 3) iDamage = int(iDamage * .5);
	}

	if(isPlayer(self))
	{
		if(isAlive(self) && (self.health < level.ex_startbleed))
		{
			self.ex_bleeding = true;
			bleedcount = level.ex_maxbleed;

			msg = bleedV["bleedmsg"];

			if(level.ex_bleedmsg_global) switch(level.ex_bleedmsg)
			{
				case 0: self iprintln(msg); break;
				case 1: self iprintlnbold(msg); break;
			}

			while(bleedcount > 0 && isAlive(self) && (self.health < level.ex_startbleed))
			{
				if(self.health > 1)
				{
					self.health--;
					if(level.ex_bleedshock) self thread doBleedPainShock();
					if(level.ex_bleedsound) self thread doBleedPainSound();
					//playfxontag(level.ex_effect["bleeding"], self, bleedV["bleedpos"]);
				}
				else self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

				bleedcount--;
				wait (bleedV["bleeddly"] * level.fps_multiplier);
			}

			self.ex_bleeding = false;
			self.ex_bsoundinit = false;
			self.ex_bshockinit = false;

			if(level.ex_bleedmsg_global && level.ex_bleedmsg && isAlive(self) && (self.health > level.ex_startbleed))
			{
				msg = &"BLEED_BLEEDINGSTOPPED";

				switch(level.ex_bleedmsg)
				{
					case 0: self iprintln(msg); break;
					case 1: self iprintlnbold(msg); break;
				}
			}
			else if(!level.ex_bleedmsg && level.ex_bleedmsg_global && isalive(self) && (self.health > level.ex_startbleed)) self iprintln(&"BLEED_BLEEDINGSTOPPED");
		}
	}
}

doBleedPainSound()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(self.ex_bsoundinit) return;

	self.ex_bsoundinit = true;
	sounddelay = 5.0;

	while(isAlive(self) && self.sessionstate == "playing" && self.ex_bleeding && (self.health < level.ex_startbleed))
	{
		if(self.health >= 1 && self.health <= 5) sounddelay = 1.0;
		else if(self.health >= 6 && self.health <= 10) sounddelay = 1.5;
		else if(self.health >= 11 && self.health <= 25) sounddelay = 2.0;
		else if(self.health >= 26 && self.health <= 50) sounddelay = 3.0;
		else if(self.health >= 51 && self.health <= 75) sounddelay = 4.0;
		else sounddelay = 5.0;

		self playLocalSound("breathing_hurt");
		wait(sounddelay * level.fps_multiplier);
	}
}

doBleedPainShock()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	if(self.ex_bshockinit) return;

	self.ex_bshockinit = true;
	shocktime = 1;

	while(isAlive(self) && self.sessionstate == "playing"  && self.ex_bleeding && (self.health < level.ex_startbleed))
	{
		if(self.health >= 1 && self.health <= 5) shocktime = 10;
		else if(self.health >= 6 && self.health <= 10) shocktime = 5;
		else if(self.health >= 11 && self.health <= 25) shocktime = 4;
		else if(self.health >= 26 && self.health <= 50) shocktime = 3;
		else if(self.health >= 51 && self.health <= 75) shocktime = 2;

		self shellshock("default", shocktime);
		wait(shocktime * level.fps_multiplier);
	}
}

getBleedData(sMeansOfDeath, sWeapon, sHitLoc)
{
	pmsg = undefined;
	delay = undefined;

	switch(sHitLoc)
	{
		case "neck": pmsg = &"BLEED_NECK"; delay = 0.7; break;
		case "head": pmsg = &"BLEED_HEAD"; delay = 0.4; break;
		case "helmet": pmsg = &"BLEED_HELMET"; delay = 0.9; break;
		case "torso_upper": pmsg = &"BLEED_UPPERTORS"; delay = 1.0; break;
		case "torso_lower": pmsg = &"BLEED_LOWERTORS"; delay = 1.0; break;
		case "left_leg_upper": pmsg = &"BLEED_LEFTLEGUP"; delay = 1.2; break;
		case "right_leg_upper": pmsg = &"BLEED_RIGHTLEGUP"; delay = 1.2; break;
		case "left_leg_lower": pmsg = &"BLEED_LEFTLEGLOW"; delay = 1.5; break;
		case "right_leg_lower": pmsg = &"BLEED_RIGHTLEGLOW"; delay = 1.5; break;
		case "left_foot": pmsg = &"BLEED_LEFTFOOT"; delay = 2.5; break;
		case "right_foot": pmsg = &"BLEED_RIGHTFOOT"; delay = 2.5; break;
		case "left_arm_upper": pmsg = &"BLEED_LEFTARMUP"; delay = 1.5; break;
		case "right_arm_upper": pmsg = &"BLEED_RIGHTARMUP"; delay = 1.5; break;
		case "left_arm_lower": pmsg = &"BLEED_LEFTARMLOW"; delay = 1.5; break;
		case "right_arm_lower": pmsg = &"BLEED_RIGHTARMLOW"; delay = 1.5; break;
		case "left_hand": pmsg = &"BLEED_LEFTHAND"; delay = 2.0; break;
		case "right_hand": pmsg = &"BLEED_RIGHTHAND"; delay = 2.0; break;

		case "none":
		{
			switch(sMeansOfDeath)
			{
				
				case "MOD_GRENADE": pmsg = &"BLEED_EXPLOSIVE"; break;
				case "MOD_GRENADE_SPLASH": pmsg = &"BLEED_EXPLOSIVE"; break;
				case "MOD_PROJECTILE": pmsg = &"BLEED_PROJECTILE"; break;
				case "MOD_PROJECTILE_SPLASH": pmsg = &"BLEED_PROJECTILE"; break;
				case "MOD_CRUSH": pmsg = &"BLEED_CRUSH"; break;
				case "MOD_EXPLOSIVE": pmsg = &"BLEED_EXPLOSIVE"; break;
				case "MOD_IMPACT": pmsg = &"BLEED_IMPACT"; break;
				case "MOD_FALLING": pmsg = &"BLEED_FALLING"; break;
			}
		}
					
		delay = 2.0;
		break;

		default: pmsg = &"BLEED_DEFAULT"; delay = 2.0; break;
	}

	bleedV["bleedmsg"] = pmsg;
	bleedV["bleeddly"] = delay;
	
	return bleedV;
}
