init()
{
	maps\mp\gametypes\_rank::registerScoreInfo( "firstaid", 10 );
}

start()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");	

	if(!level.ex_firstaid_kits) return;

	if(level.inPrematchPeriod)
		level waittill("prematch_over");

	self.ex_firstaidkits = level.ex_firstaid_kits ;

	if(!isDefined(self.ex_firstaidicon))
	{
		self.ex_firstaidicon = newClientHudElem(self);			
		self.ex_firstaidicon.alignX = "center";
		self.ex_firstaidicon.alignY = "middle";
		self.ex_firstaidicon.horzAlign = "fullscreen";
		self.ex_firstaidicon.vertAlign = "fullscreen";
		self.ex_firstaidicon.alpha = 0.5;
		if(level.hardcoreMode)
		{
			self.ex_firstaidicon.x = 616;
			self.ex_firstaidicon.y = 472;
		}
		if(!level.hardcoreMode)
		{
			self.ex_firstaidicon.x = 616;
			self.ex_firstaidicon.y = 416;
		}
		self.ex_firstaidicon.color = (0,1,0);
		self.ex_firstaidicon setShader("hint_health", 16, 16);		
	}
	
	if(!isDefined(self.ex_firstaidval))
	{
		self.ex_firstaidval = newClientHudElem(self);
		self.ex_firstaidval.fontScale = 1.4;
		self.ex_firstaidval.alignX = "center";
		self.ex_firstaidval.alignY = "middle";
		self.ex_firstaidval.horzAlign = "fullscreen";
		self.ex_firstaidval.vertAlign = "fullscreen";
		self.ex_firstaidval.alpha = 0.5;
		if(level.hardcoreMode)
		{
			self.ex_firstaidval.x = 630;
			self.ex_firstaidval.y = 472;
		}
		if(!level.hardcoreMode)
		{
			self.ex_firstaidval.x = 630;
			self.ex_firstaidval.y = 416;
		}
			
		if(self.ex_firstaidkits> 0) self.ex_firstaidval.color = (1, 1, 1);
			else self.ex_firstaidval.color = (1, 0, 0);
			
		self.ex_firstaidval setValue(self.ex_firstaidkits);
	}

	while (isAlive(self) && self.sessionstate == "playing")
	{
		wait(.5 * level.fps_multiplier);

		targetplayer = getTargetPlayer();

		// if targetplayer is self and self healing is not allowed, skip
		if(level.ex_teamplay && targetplayer == self && !level.ex_firstaid_self) continue;

		while(self useButtonPressed() && targetplayer.health < level.ex_maxhealth && self.ex_firstaidkits > 0)
		{
			// wait 2 seconds (make sure they mean it, are holding USE)
			holdtime = 0;
			while(isPlayer(self) && self useButtonPressed() && holdtime < .1)
			{
				holdtime += 0.05;
				wait (0.05 * level.fps_multiplier);
			}

			if(holdtime < .1) break;
			
			// can't heal while moving
			if(self.ex_moving) break;

			// can't heal while planting or defusing a bomb
			if(level.ex_bombplay && (self.isPlanting || self.isDefusing)) break;

			// fade counter
			if(isDefined(self.ex_firstaidval))
			{
				self.ex_firstaidval fadeOverTime(1);
				self.ex_firstaidval.alpha = 0;	
			}

			if(isDefined(self.ex_firstaidicon))
				self.ex_firstaidicon scaleOverTime(2, 32, 32);

			healTargetPlayer(targetplayer);

			if(isDefined(self.ex_firstaidicon))
				self.ex_firstaidicon scaleOverTime(2, 16, 16);

			self.ex_firstaidkits--;
			if(self.ex_firstaidkits < 0) self.ex_firstaidkits = 0; 

			wait(.5 * level.fps_multiplier);
		}

		if(isDefined(self.ex_firstaidval))
		{
			if(self.ex_firstaidkits > 0) self.ex_firstaidval.color = (1, 1, 1);
				else self.ex_firstaidval.color = (1, 0, 0);

			self.ex_firstaidval setValue(self.ex_firstaidkits);
			self.ex_firstaidicon.alpha = 0.8;
		}

		// fadein counter
		if(isDefined(self.ex_firstaidval))
		{
			self.ex_firstaidval fadeOverTime(1);
			self.ex_firstaidval.alpha = 1;
		}
	}
}

healTargetPlayer(targetplayer)
{
	self disableWeapons();
	self shellshock("frag_grenade_mp", 5.5);

	if(targetplayer == self)
		iprintln (&"FIRSTAID_ISUSING", targetplayer.name );
	else
		iprintln (&"FIRSTAID_FIXEDUP", targetplayer.name, self.name );

	targetplayer playSound("health_pickup_medium"); 

 	healamount = level.ex_firstaid_minheal + (randomInt(level.ex_firstaid_maxheal - level.ex_firstaid_minheal));
	health = level.ex_maxhealth - targetplayer.health;
	if(healamount > health) healamount = health;
	
	for(i = 0; i < healamount; i++) 
	{
		if(isDefined(targetplayer) && isAlive(targetplayer))
		{
			if(targetplayer.health < level.ex_maxhealth) targetplayer.health += 1;
				else break;
		}
		else break;
		wait(0.05 * level.fps_multiplier);
	}

	if(isDefined(targetplayer) && isAlive(targetplayer))
	{
		if(targetplayer.health >= level.ex_maxhealth)
			targetplayer iprintln(&"FIRSTAID_MAXHEALTH");
		else		
			targetplayer iprintln(&"FIRSTAID_HEALINGFINISHED");
	}

	if(isDefined(self) && self != targetplayer)
		[[level.givePlayerScore]]("firstaid", self, targetplayer);

	self enableWeapons();;
	self playLocalSound("breathing_better");
	
}

getTargetPlayer()
{
	targetplayer = self;

	if(level.ex_teamplay)
	{	
		players = getEntArray( "player", "classname" );
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(player == self) continue;
			if(player.health == level.ex_maxhealth || !isAlive(player) || player.pers["team"] != self.pers["team"]) continue;
			if(distance(player.origin, self.origin) > 31) continue;

			targetplayer = player;
			break;
		}
	}

	return targetplayer;
}

healthDrop()
{
	self endon("disconnect");
	
	if(isDefined(game["ex_healthqueue"][game["ex_healthqueuecurrent"]])) game["ex_healthqueue"][game["ex_healthqueuecurrent"]] delete();

	health_nr = RandomInt(3);

	switch(health_nr) //TODO: small, medium, large are the same now
	{
		case 1: modeltype = "com_x4_health_package1"; break;
		case 2: modeltype = "com_x4_health_package1"; break;
		default: modeltype = "com_x4_health_package1"; break;
	}

	item_health = spawn("script_model", (0,0,0));	
	item_health setModel(modeltype);
	item_health.targetname = "item_healths";
	item_health hide();	
	item_health.origin = self.origin;
	item_health.angles = (0, randomint(360), 0);
	item_health show(); 

	rotation = (randomFloat(180), randomFloat(180), randomFloat(180));
	velocity = (randomInt(4) + 4, randomInt(4) + 4, randomInt(6) + 6);

	item_health extreme\_ex_utils::bounceObject(rotation, velocity, (0,0,0), (0,0,0), 5, 0.4, undefined, undefined, "health");
	item_health thread healthThink(health_nr);

	game["ex_healthqueue"][game["ex_healthqueuecurrent"]] = item_health;
	game["ex_healthqueuecurrent"]++;

	if(game["ex_healthqueuecurrent"] >= 16) game["ex_healthqueuecurrent"] = 0;
}

healthThink(health_nr)
{
	while(isDefined(self))
	{
		wait 0.2;

		if(!isDefined(self)) return;

		players = level.players;
		for(i = 0; i < players.size; i++)
		{			 
			player = players[i];

			if(isPlayer(player) && isDefined(self) && player.sessionstate == "playing" && distance(self.origin,player.origin) < 50 &&
				(player.health < player.maxhealth || level.ex_firstaid_pickup && player.ex_firstaidkits < level.ex_firstaid_pickup))
			{
				player endon("disconnect");

				if(player.health < player.maxhealth)
				{
					player.health += health_nr * 40;

					if(player.health > player.maxhealth) player.health = player.maxhealth;

					if(isDefined(self)) self delete();
				}
				else if(level.ex_firstaid_pickup && level.ex_firstaid_self && player.ex_firstaidkits < level.ex_firstaid_pickup)
				{
					player.ex_firstaidkits++;
					player playLocalSound("health_pickup");
					player iprintln(&"FIRSTAID_PICKEDUP");
					if(isDefined(player.ex_firstaidval))
					{
						player.ex_firstaidval setValue(player.ex_firstaidkits);
						player.ex_firstaidval.color = (1, 1, 1);
					}

					if(isDefined(self)) self delete();
				}
			}
		}				
	}
}
