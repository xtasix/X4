
cleanLevelHud()
{
	// remove all level based HUD elements
	if(isDefined(level.ex_alliesicon)) level.ex_alliesicon destroy();
	if(isDefined(level.ex_alliesnumber)) level.ex_alliesnumber destroy();
	if(isDefined(level.ex_axisicon)) level.ex_axisicon destroy();
	if(isDefined(level.ex_axisnumber)) level.ex_axisnumber destroy();
	if(isDefined(level.ex_deadalliesicon)) level.ex_deadalliesicon destroy();
	if(isDefined(level.ex_deadalliesnumber)) level.ex_deadalliesnumber destroy();
	if(isDefined(level.ex_deadaxisicon)) level.ex_deadaxisicon destroy();
	if(isDefined(level.ex_deadaxisnumber)) level.ex_deadaxisnumber destroy();
	if(isDefined(level.ex_mapannouncer)) level.ex_mapannouncer destroy();
	if(isDefined(level.logo_img)) level.logo_img destroy();

	// fade out modinfo, move to centre and fade in
	if(isDefined(level.ex_modinfo_hud))
	{
		level.ex_modinfo_hud fadeOverTime(1);
		level.ex_modinfo_hud.alpha = 0;
		wait (1 * level.fps_multiplier);
		level.ex_modinfo_hud.x = 320;
		level.ex_modinfo_hud.alignX = "center";
		level.ex_modinfo_hud fadeOverTime(1);
		level.ex_modinfo_hud.alpha = 0.8;
		wait (1 * level.fps_multiplier);
	}
}

cleanPlayerHud()
{
	// undo link and attach
	if(isdefined(self.ex_anchor))
	{
		self unlink();
		self.ex_anchor delete();
	}

	// remove camper objective
	self thread extreme\_ex_camper::removeCamper();

	// remove bullet holes
	if(isDefined(self.ex_bulletholes))
		for(i = 0; i < self.ex_bulletholes.size; i++)
			if(isDefined(self.ex_bulletholes[i])) self.ex_bulletholes[i] destroy();

	// remove all player based HUD elements
	if(isDefined(self.ex_laserdot)) self.ex_laserdot destroy();
	if(isDefined(self.spawnprot_cntr)) self.spawnprot_cntr destroy(); 
	if(isDefined(self.spawnprot_text)) self.spawnprot_text destroy();
	if(isDefined(self.spawnprot_icon)) self.spawnprot_icon destroy();
	if(isDefined(self.ex_healthbar)) self.ex_healthbar destroy();
	if(isDefined(self.ex_healthback)) self.ex_healthback destroy();
	if(isDefined(self.ex_healthcross)) self.ex_healthcross destroy();
	if(isDefined(self.ex_givehealth)) self.ex_givehealth destroy();
	if(isDefined(self.ex_firstaidval)) self.ex_firstaidval destroy();
	if(isDefined(self.ex_firstaidicon)) self.ex_firstaidicon destroy();
	if(isDefined(self.ex_rangehud)) self.ex_rangehud destroy();
	if(isDefined(self.overheat_bg)) self.overheat_bg destroy();
	if(isDefined(self.overheat_status)) self.overheat_status destroy();
	if(isDefined(self.teamchathud)) self.teamchathud destroy();
	if(isDefined(self.ac130_overlay)) self.ac130_overlay destroy();
	if(isDefined(self.ac130_grain)) self.ac130_grain destroy();
	if(isDefined(self.hud_statsscore)) self.hud_statsscore destroy(); 
	if(isDefined(self.hud_statshead)) self.hud_statshead destroy();
	if(isDefined(self.hud_statsknife)) self.hud_statsknife destroy();
	if(isDefined(self.hud_statsnade)) self.hud_statsnade destroy(); 
	if(isDefined(self.hud_statskill)) self.hud_statskill destroy(); 
	if(isDefined(self.hud_statsdeath)) self.hud_statsdeath destroy();
	if(isDefined(self.hud_statskd)) self.hud_statskd destroy(); 
	if(isdefined(self.ex_searchicon)) self.ex_searchicon destroy();
	if(isdefined(self.ex_plantbarbackground)) self.ex_plantbarbackground destroy();
	if(isdefined(self.ex_plantbar)) self.ex_plantbar destroy();
	if(isdefined(self.claymoredefallow)) self.claymoredefallow destroy();
	if(isDefined(self.claymoredefuse)) self.claymoredefuse destroy(); 
	if(isDefined(self.claymoredefusetimer)) self.claymoredefusetimer destroy(); 
	if(isDefined(self.ex_watch)) self.ex_watch destroy();
	if(isDefined(self.ac130_grain)) self.ac130_grain destroy();
	if(isDefined(self.ac130_weptext)) self.ac130_weptext destroy();
	if(isDefined(self.ac130_overlay)) self.ac130_overlay destroy();
	if(isDefined(self.darkScreenOverlay)) self.darkScreenOverlay destroy();
	if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy();
	if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy();
	if(isDefined(self.ex_UAVtimer)) self.ex_UAVtimer destroy();
	if(isDefined(self.ex_heliwatch)) self.ex_heliwatch destroy();

	if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy();
  
	
	/*if(isdefined(player.ex_plantbarbackground)) player.ex_plantbarbackground destroy();
	if(isdefined(player.ex_plantbar)) player.ex_plantbar destroy();
	if(isdefined(player.claymoredefallow)) player.claymoredefallow destroy();
	if(isDefined(player.claymoredefuse)) player.claymoredefuse destroy(); 
	if(isDefined(player.claymoredefusetimer)) player.claymoredefusetimer destroy(); */
}
