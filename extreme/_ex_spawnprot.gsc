start()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	self.ex_spawnprotected = true;

	if(level.inPrematchPeriod)
		level waittill("prematch_over");

	self.protectiontime = level.ex_spawnprot;

	if(level.ex_spawnprot_forcecrouch) self [[level.ex_clientcmd]]("gocrouch");
	if(level.ex_spawnprot_noweapon) self disableWeapons();
	if(level.ex_spawnprot_invisible) 
	{
		self hide();
		self iprintlnbold("^4Invisible ^7Spawn Protection ^1Enabled");
	}
	if(level.ex_spawnprot_voice_enabled) self playlocalSound("spenabled");
	//self thread Head_Icon();

	if(!isDefined(self.spawnprot_icon))
	{
		self.spawnprot_icon = newClientHudElem(self);
		if(level.hardcoreMode)
		{
			self.spawnprot_icon.x = 135;
			self.spawnprot_icon.y = 452;
		}
		if(!level.hardcoreMode)
		{
			self.spawnprot_icon.x = 135;
			self.spawnprot_icon.y = 401;
		}
		self.spawnprot_icon.alignX = "right";
		self.spawnprot_icon.alignY = "top";
		self.spawnprot_icon.alpha = .9;
		self.spawnprot_icon.archived = false;
		self.spawnprot_icon setShader("hint_health", 24, 24);
	}

	if(!isDefined(self.spawnprot_text))
	{
		self.spawnprot_text = newClientHudElem(self);
		self.spawnprot_text.x = 0;
		self.spawnprot_text.y = 180;
		self.spawnprot_text.alignX = "center";
		self.spawnprot_text.alignY = "middle";
		self.spawnprot_text.horzAlign = "center_safearea";
		self.spawnprot_text.vertAlign = "center_safearea";
		self.spawnprot_text.alpha = 1;
		self.spawnprot_text.archived = false;
		self.spawnprot_text.font = "default";
		self.spawnprot_text.fontscale = 1.4;
		self.spawnprot_text.color = (0.980,0.996,0.388);
		self.spawnprot_text.label = &"MISC_SPAWNPRO";
	}

	if(!isDefined(self.spawnprot_cntr))
	{
		self.spawnprot_cntr = newClientHudElem(self);
		self.spawnprot_cntr.x = 0;
		self.spawnprot_cntr.y = 160;
		self.spawnprot_cntr.alignX = "center";
		self.spawnprot_cntr.alignY = "middle";
		self.spawnprot_cntr.horzAlign = "center_safearea";
		self.spawnprot_cntr.vertAlign = "center_safearea";
		self.spawnprot_cntr.alpha = 1;
		self.spawnprot_cntr.fontScale = 2.4;
		self.spawnprot_cntr.color = (.99, .00, .00);			
	}

	self thread monitorAttackKey();

	timer = 0;
	while (self.protectiontime)
	{
		if(!self.ex_spawnprotected) break;
		if(isDefined(self.spawnprot_cntr)) self.spawnprot_cntr setvalue(self.protectiontime);
		wait (.1 * level.fps_multiplier);
		timer++;

		if(timer == 10)
		{
			self.protectiontime--;
			timer = 0;
		}
	}

	if(level.ex_spawnprot_invisible) 
	{
		self show();
		self iprintlnbold("^4Invisible ^7Spawn Protection ^1Disabled");
	}
	if(level.ex_spawnprot_noweapon) self enableWeapons();
	if(level.ex_spawnprot_voice_disabled) self playlocalSound("spdisabled");
	self.ex_spawnprotected = false;

	if(isDefined(self.spawnprot_cntr)) self.spawnprot_cntr destroy(); 
	if(isDefined(self.spawnprot_text)) self.spawnprot_text destroy();
	if(isDefined(self.spawnprot_icon)) self.spawnprot_icon destroy();
}

monitorAttackKey()
{
	self endon("disconnect");

	while(self.ex_spawnprotected)
	{
		wait (0.1 * level.fps_multiplier);

		if(self attackButtonPressed() || self meleeButtonPressed())
			self.ex_spawnprotected = false;
	}
}
