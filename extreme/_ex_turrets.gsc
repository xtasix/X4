
monitorTurrets()
{
	if(!level.ex_turretoverheat) return;

	// get all the turrets on map and monitor them
	turrets = getentarray("misc_turret", "classname");
	for(i = 0; i < turrets.size; i++)
	{
		if(isDefined(turrets[i]))
			turrets[i] thread turretThink();
	}

	turrets = getentarray("misc_mg42", "classname");
	for(i = 0; i < turrets.size; i++)
	{
		if(isDefined(turrets[i]))
			turrets[i] thread turretThink();
	}
}

turretThink()
{
	level endon("ex_gameover");

	self.heat_rate = level.ex_turretoverheat_heatrate / 2;
	self.heat_status = 1;
	self.heat_danger = 80;
	self.heat_max = 114;
	self.cool_rate = level.ex_turretoverheat_coolrate;
	self thread turretOverheatDrain();

	while(1)
	{
		// wait for player to use turret
		self waittill ("trigger", player);
		if(isPlayer(player))
		{
			player.ex_onturret = true;
			player thread playerOverheatShowHUD(self);

			while(player useButtonPressed()) wait 0.05;

			for(;;)
			{
				wait 0.05;

				// turret overheating
				if(isDefined(player) && isDefined(player.ex_onturret) && player attackButtonPressed())
				{
					if(self.heat_status < self.heat_max)
					{
						self.heat_status = self.heat_status + self.heat_rate;
						if(self.heat_status > self.heat_max) self.heat_status = self.heat_max;
					}

					if(self.heat_status == self.heat_max)
					{
						self playsound("smokegrenade_explode_default");
						// release the fire button to stop firing, and press the use button to get off the turret
						player thread [[level.ex_clientcmd]]("-attack; +activate; wait 10; -activate");
					}
				}

				// player getting off turret
				if(isDefined(player) && player useButtonPressed())
				{
					player.ex_onturret = undefined;
					player thread playerOverheatRemoveHUD();
					break;
				}

				if(isDefined(player) && isDefined(player.ex_onturret))
					player thread playerOverheatUpdateHUD(self);
			}
		}
	}
}

playerOverheatUpdateHUD(turret)
{
	self endon("disconnect");
	self endon("ex_dead");

	if(isDefined(self.overheat_status) && turret.heat_status > 1)
	{
		self.overheat_status scaleovertime( 0.1, 10, int(turret.heat_status));
		self.overheat_status.color = playerOverheatSetColor(turret);
		wait 0.1;
	}
}

playerOverheatSetColor(turret)
{
	self endon("disconnect");
	self endon("ex_dead");

	// define what colors to use
	color_cold = [];
	color_cold[0] = 1.0;
	color_cold[1] = 1.0;
	color_cold[2] = 0.0;
	color_warm = [];
	color_warm[0] = 1.0;
	color_warm[1] = 0.5;
	color_warm[2] = 0.0;
	color_hot = [];
	color_hot[0] = 1.0;
	color_hot[1] = 0.0;
	color_hot[2] = 0.0;

	// default color
	SetValue = [];
	SetValue[0] = color_cold[0];
	SetValue[1] = color_cold[1];
	SetValue[2] = color_cold[2];

	// define where the non blend points are
	cold = 0;
	warm = (turret.heat_max / 2);
	hot = turret.heat_max;
	value = turret.heat_status;

	iPercentage = undefined;
	difference = undefined;
	increment = undefined;

	if( (value > cold) && (value <= warm) )
	{
		iPercentage = int(value * (100 / warm));
		for( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_warm[colorIndex] - color_cold[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_cold[colorIndex] + (increment * iPercentage);
		}
	}
	else if( (value > warm) && (value <= hot) )
	{
		iPercentage = int( (value - warm) * (100 / (hot - warm) ) );
		for( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_hot[colorIndex] - color_warm[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_warm[colorIndex] + (increment * iPercentage);
		}
	}

	return (SetValue[0], SetValue[1], SetValue[2]);
}

turretOverheatDrain()
{
	level endon("ex_gameover");
	self endon("stop_overheat_drain");

	frames = getDvarInt("sv_fps");

	for(;;)
	{
		wait 0.05;

		if(self.heat_status > 1)
		{
			difference = self.heat_status - (self.heat_status - self.cool_rate);
			frame_difference = (difference / frames);

			if(self.heat_status >= self.heat_danger) thread turretOverheatOneShotFX();

			for(i = 0; i < frames; i++)
			{
				self.heat_status -= frame_difference;
				if(self.heat_status < 1)
				{
					self.heat_status = 1;
					break;
				}
				wait 0.05;
			}
		}
	}
}

turretOverheatOneShotFX()
{
	playfxOnTag(level.ex_effect["turretoverheat"], self, "tag_flash");
}


playerOverheatShowHUD(turret)
{
	self endon("disconnect");
	self endon("ex_dead");

	if(!isDefined(self.overheat_bg))
	{
		self.overheat_bg = newclienthudelem(self);
		self.overheat_bg.alignX = "right";
		self.overheat_bg.alignY = "bottom";
		self.overheat_bg.horzAlign = "right";
		self.overheat_bg.vertAlign = "bottom";
		self.overheat_bg.x = -13;
		self.overheat_bg.y = -140;
		self.overheat_bg setShader("hud_temperature_gauge", 35, 150);
		self.overheat_bg.sort = 2;
	}

	// status bar
	if(!isDefined(self.overheat_status))
	{
		self.overheat_status = newclienthudelem(self);
		self.overheat_status.alignX = "right";
		self.overheat_status.alignY = "bottom";
		self.overheat_status.horzAlign = "right";
		self.overheat_status.vertAlign = "bottom";
		self.overheat_status.x = -25;
		self.overheat_status.y = -172;
		self.overheat_status setShader("white", 10, int(turret.heat_status));
		self.overheat_status.color = playerOverheatSetColor(turret);
		self.overheat_status.alpha = 1;
		self.overheat_status.sort = 1;
	}
}

playerOverheatRemoveHUD()
{
	self endon("disconnect");

	if(isDefined(self.overheat_bg)) self.overheat_bg destroy();
	if(isDefined(self.overheat_status)) self.overheat_status destroy();
}

RemoveTurrets()
{
	deletePlacedEntity("misc_turret");
	deletePlacedEntity("misc_mg42");
}

deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
		entities[i] delete();
}
