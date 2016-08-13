minefields()
{
	precacheShellShock( "radiation_high" );
	
	if(!level.ex_minefields) return;

	minefields = getentarray("minefield", "targetname");
	if(minefields.size > 0)
	{
		if(level.ex_minefields == 1) level._effect["mine_explosion"] = loadfx("explosions/grenadeExp_dirt");
			else if(level.ex_minefields == 2) level._effect["mine_explosion"] = loadfx("smoke/smoke_grenade_22sec_mp");
				else if(level.ex_minefields == 3) level._effect["mine_explosion"] = loadfx("extreme/napalm");
					else if(level.ex_minefields == 4) level._effect["mine_explosion"] = loadfx ("impacts/large_mud");
	}

	for(i = 0; i < minefields.size; i++)
	{
		minefields[i] thread minefield_think();
	}
}

minefield_think()
{
	while(1)
	{
		self waittill("trigger", other);

		if(isPlayer(other))
			other thread minefield_kill(self);
	}
}

minefield_kill(trigger)
{
	if(isDefined(self.minefield))
		return;

	self.minefield = true;
	self playsound("minefield_click");

	wait(.5);
	wait(randomFloat(.5));

	if(isdefined(self) && self istouching(trigger))
	{
		origin = self getorigin();

		range = 300;
		mindamage = 50;
		maxdamage = 2000;
		self playsound("explo_mine");

		if(level.ex_minefields == 2)
		{
			range = 200;
			mindamage = level.ex_gasmine_min;
			maxdamage = level.ex_gasmine_max;
			self playsound("smokegrenade_explode_default");
		}

		if(level.ex_minefields == 3)
		{
			range = 300;
			mindamage = level.ex_napalmmine_min;
			maxdamage = level.ex_napalmmine_max;
			self playsound("Nebelwerfer_fire");
		}
		
		if(level.ex_minefields == 4)
		{
			range = 300;
			mindamage = level.ex_radiationmine_min;
			maxdamage = level.ex_radiationmine_max;
			self shellshock("radiation_high", 5 );
		}

		playfx(level._effect["mine_explosion"], origin);
		radiusDamage(origin, range, maxdamage, mindamage);
	}

	self.minefield = undefined;
}
