
start()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	forcedDvar = [];
	forcedDvarValue = []; 

	if(!level.ex_forcedvar_nadeindicator)
	{
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconMaxRangeFrag";
		forcedDvarValue[forcedDvarValue.size] = 0;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconHeight";
		forcedDvarValue[forcedDvarValue.size] = 0;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconWidth";
		forcedDvarValue[forcedDvarValue.size] = 0;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconOffset";
		forcedDvarValue[forcedDvarValue.size] = 0;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadePointerHeight";
		forcedDvarValue[forcedDvarValue.size] = 0;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadePointerWidth";
		forcedDvarValue[forcedDvarValue.size] = 0;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadePointerPivot";
		forcedDvarValue[forcedDvarValue.size] = 0;
	}
	else
	{
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconMaxRangeFrag";
		forcedDvarValue[forcedDvarValue.size] = 250;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconHeight";
		forcedDvarValue[forcedDvarValue.size] = 25;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconWidth";
		forcedDvarValue[forcedDvarValue.size] = 25;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadeIconOffset";
		forcedDvarValue[forcedDvarValue.size] = 50;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadePointerHeight";
		forcedDvarValue[forcedDvarValue.size] = 12;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadePointerWidth";
		forcedDvarValue[forcedDvarValue.size] = 25;
		forcedDvar[forcedDvar.size] = "cg_hudGrenadePointerPivot";
		forcedDvarValue[forcedDvarValue.size] = "12 27";
	}

	forcedDvar[forcedDvar.size] = "cg_drawcrosshair";
	forcedDvarValue[forcedDvarValue.size] = level.ex_forcedvar_crosshair;
	
	forcedDvar[forcedDvar.size] = "cg_crosshairEnemyColor";
	forcedDvarValue[forcedDvarValue.size] = level.ex_forcedvar_redcrosshairs;

	forcedDvar[forcedDvar.size] = "cg_drawCrosshairNames";
	forcedDvarValue[forcedDvarValue.size] = level.ex_forcedvar_crosshairnames;

	forcedDvar[forcedDvar.size] = "cg_drawmantlehint";
	forcedDvarValue[forcedDvarValue.size] = level.ex_forcedvar_mantlehint;
	
	forcedDvar[forcedDvar.size] = "cg_hudStanceHintPrints";
	forcedDvarValue[forcedDvarValue.size] = level.ex_hudStanceHintPrints;
	
	forcedDvar[forcedDvar.size] = "hud_fade_stance";
	forcedDvarValue[forcedDvarValue.size] = level.ex_hud_fade_stance;
	
	forcedDvar[forcedDvar.size] = "cg_thirdperson";
	forcedDvarValue[forcedDvarValue.size] = level.ex_third_person;
	
	forcedDvar[forcedDvar.size] = "cg_thirdpersonrange";
	forcedDvarValue[forcedDvarValue.size] = 100;
	
	forcedDvar[forcedDvar.size] = "cg_thirdpersonangle";
	forcedDvarValue[forcedDvarValue.size] = 0;	

	while(isPlayer(self) && self.sessionstate == "playing")
	{
		for(j = 0; j < forcedDvar.size; j++)
		{
			self setClientDvar(forcedDvar[j], forcedDvarValue[j]);
			wait (0.1 * level.fps_multiplier);
		}

		if(level.ex_forcedvar_mode == 1) return;

		wait (5 * level.fps_multiplier);
	}
}
