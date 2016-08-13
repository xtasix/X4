#include maps\mp\_utility;

init()
{

	level.sentryTurretTags = [];
	level.sentryTurretTags[level.sentryTurretTags.size] = "tag_base";
	level.sentryTurretTags[level.sentryTurretTags.size] = "tag_swivel";
	level.sentryTurretTags[level.sentryTurretTags.size] = "tag_gun";
	level.sentryTurretTags[level.sentryTurretTags.size] = "tag_barrel";
	
	game["sentrygun_pickup_hint"] = &"MP_SENTRYGUN_HINT";
	precacheString( game["sentrygun_pickup_hint"] );
	precacheShader( "hint_usable" );
	
	level.fx_sentryTurretExplode = loadfx("explosions/grenadeExp_metal");
	level.fx_sentryTurretFlash = loadfx("muzzleflashes/saw_flash_wv");
	
	level.fx_sentryTurretShellEject = loadfx("misc/mw2_sentry_turret_shellEject");
	level.fx_sentryTurretTracer = loadfx("misc/mw2_sentry_turret_tracer");
	
	level.sentryTurretClipSize = 100;
	level.sentryTurretHealth = 1500;
	
	precacheModel( "mw2_sentry_turret" );
	
	level thread onPlayerConnect();

}

onPlayerConnect()
{
	level endon( "game_ended" );
	
	for( ;; )
	{
		level waittill("connecting", player);
		level waittill("spawned_player", player);
		
		player thread onPlayerJoinedTeam();
		
	}
}

onPlayerJoinedTeam()
{
	self endon("disconnect");

	for( ;; )
	{
		self waittill( "joined_spectators" );
		
		if( isDefined( self.sentryTurret ) )
			self thread sentry_remove( false );
	}
}

main()
{
	if(isDefined(self.sentryTurret))
	{
		self iprintlnbold("You already have a sentry turret spawned");
		return;
	}
	
	wait ( 0.45 );
	
	self.sentryTurret = [];
	self.sentryTurret[self.sentryTurret.size] = spawn( "script_model", self.origin + vector_scale(anglesToForward(self.angles), 50) ); // Base
	self.sentryTurret[0] setModel("mw2_sentry_turret");
	self.sentryTurret[0].angles = self.angles;
	self.sentryTurret[0].owner = self;
	self.sentryTurret[0].team = self.pers["team"];
	self.sentryTurret[0].targetname = "sentryTurret";
	self.sentryTurret[0] playSound( "minigun_plant" );
	self.sentryTurret[0] thread manual_move();
	self.sentryTurret[0] thread sentry_damage();
	self.sentryTurret[0] maps\mp\_entityheadicons::setEntityHeadIcon( self.sentryTurret[0].team, (0,0,70) );

	for(x = 0; x < level.sentryTurretTags.size; x++)
		if(level.sentryTurretTags[x] != "tag_base")
			self.sentryTurret[0] hidePart(level.sentryTurretTags[x]);

	wait .05;
	self.sentryTurret[self.sentryTurret.size] = spawn("script_model", self.sentryTurret[0] getTagOrigin("j_pivot")); // Swivel
	self.sentryTurret[self.sentryTurret.size] = spawn("script_model", self.sentryTurret[0] getTagOrigin("j_hinge")); // Gun
	self.sentryTurret[self.sentryTurret.size] = spawn("script_model", self.sentryTurret[0] getTagOrigin("j_barrel")); // Barrel

	for(i = 1; i < self.sentryTurret.size; i++)
	{
		self.sentryTurret[i] setModel("mw2_sentry_turret");
		self.sentryTurret[i].angles = self.angles;
		self.sentryTurret[i].owner = self;
		self.sentryTurret[i].team = self.pers["team"];
		self.sentryTurret[i].targetname = "sentryTurret";
		self.sentryTurret[i] thread manual_move();
		self.sentryTurret[i] thread sentry_damage();
		
		if(i == 1)
		{
			for(x = 0; x < level.sentryTurretTags.size; x++)
				if(level.sentryTurretTags[x] != "tag_swivel")
					self.sentryTurret[i] hidePart(level.sentryTurretTags[x]);
		}
		if(i == 2)
		{
			for(x = 0; x < level.sentryTurretTags.size; x++)
				if(level.sentryTurretTags[x] != "tag_gun")
					self.sentryTurret[i] hidePart(level.sentryTurretTags[x]);
		}
		if(i == 3)
		{
			for(x = 0; x < level.sentryTurretTags.size; x++)
				if(level.sentryTurretTags[x] != "tag_barrel")
					self.sentryTurret[i] hidePart(level.sentryTurretTags[x]);
		}
	}

	self.sentryTurretDamageTaken = 0;
	self.sentryTurretIsIdling = true;
	self.sentryTurretIsTargeting = false;
	self.sentryTurretIsFiring = false;
	self.sentryTurretTarget = undefined;

	self thread sentry_idle();
	self thread sentry_targeting();
}

sentry_idle()
{
	self endon("disconnect");
	self endon("end_sentry_turret");

	wait .5;
	while(1)
	{
		if(self.sentryTurretIsTargeting)
		{
			while(self.sentryTurretIsTargeting)
				wait .5;
		}
		self.sentryTurretIsIdling = true;
		randomYaw = randomIntRange(-360, 360);
		self.sentryTurret[1] playSound("minigun_wind_down");

		for(i = 1; i < self.sentryTurret.size; i++)
			self.sentryTurret[i] rotateYaw(randomYaw, 5, .5, .5);
		wait 5;
		self.sentryTurretIsIdling = false;
		wait randomFloatRange(1.0, 2.5);
	}
}

sentry_targeting()
{
	self endon("disconnect");
	self endon("end_sentry_turret");

	// Scan for enemies in range
	//if(level.ex_sentry_turret_range)
	
	self.sentryTurretTrig = spawn("trigger_radius", self.sentryTurret[0].origin, 0, level.ex_sentry_turret_range, level.ex_sentry_turret_range / 5);
	self.sentryTurretTrig.origin = (self.sentryTurret[0].origin - (0, 0, level.ex_sentry_turret_range / 10));
	
	while( true )
	{
		wait .05;
			
		if( !isdefined( self.sentryTurretTrig ) || !isdefined( self.sentryTurret ) )
			break;
	
		if(self.sentryTurretIsTargeting || self.sentryTurretIsFiring)
			continue;

		eligibleTargets = [];
		p = getentarray("player", "classname");
		for(i = 0; i < p.size; i++)
		{
			if(p[i].model == "")
				continue;

			if(p[i].sessionstate != "playing")
				continue;

			if(p[i].health < 1)
				continue;

			if(self.sentryTurret[0].owner == p[i] )
				continue;

			if(level.teamBased && p[i].pers["team"] == self.pers["team"])
				continue;

			if(p[i] isTouching(self.sentryTurretTrig) && SightTracePassed(self.sentryTurret[0] getTagOrigin("j_barrel"), p[i] getTagOrigin("j_spine4"), false, self.sentryTurret))
				eligibleTargets[eligibleTargets.size] = p[i];
		}
		if(!eligibleTargets.size)
			continue;

		random = randomInt(eligibleTargets.size);
		target = eligibleTargets[random];
		self.sentryTurretTarget = target;
		self thread sentry_target();

		eligibleTargets = undefined;
	}
}

sentry_target()
{
	self endon("disconnect");
	self endon("end_sentry_turret");

	if( self.sentryTurretIsFiring )
	{
		while(self.sentryTurretIsFiring)
			wait .5;
	}
	if( !isDefined(self.sentryTurretTarget) || (isDefined(self.sentryTurretTarget) && self.sentryTurretTarget.health < 1) )
	{
		self.sentryTurretTarget = undefined;
		self.sentryTurretIsTargeting = false;
		return;
	}
	self.sentryTurretIsTargeting = true;
	self playSound("minigun_wind_up");

	// aim toward target
	targetVec = vectorToAngles(self.sentryTurretTarget getTagOrigin("j_spine4")  - self.sentryTurret[3].origin);
	self.sentryTurretHinge = spawn("script_origin", self.sentryTurret[0] getTagOrigin("j_hinge"));
	self.sentryTurretHinge.angles = self.sentryTurret[2].angles;

	for(i = 2; i < self.sentryTurret.size; i++)
		self.sentryTurret[i] linkTo(self.sentryTurretHinge);
	wait .05;
	self.sentryTurretHinge rotateTo((targetVec[0], targetVec[1], self.sentryTurret[2].angles[2]), .5);
	self.sentryTurret[1] rotateTo((self.sentryTurret[1].angles[0], targetVec[1], self.sentryTurret[1].angles[2]), .5);
	wait .6;

	for(i = 2; i < self.sentryTurret.size; i++)
		self.sentryTurret[i] unlink(); // Unlink after aimed correctly - Rest of positioning is taken care of in sentry_fire()
	wait .05;
	self thread sentry_fire();
	wait .05;
	if(self.sentryTurretIsFiring)
	{
		while(self.sentryTurretIsFiring)
			wait .5;
	}
	for(i = 2; i < self.sentryTurret.size; i++)
		self.sentryTurret[i] linkTo(self.sentryTurretHinge);
	wait .05;
	self.sentryTurretHinge rotateTo((0, self.sentryTurret[2].angles[1], self.sentryTurret[2].angles[2]), .25);
	wait .3;

	for(i = 2; i < self.sentryTurret.size; i++)
		self.sentryTurret[i] unlink();

	if(isDefined(self.sentryTurretHinge))
		self.sentryTurretHinge delete();

	self thread anchor_barrel();
	self.sentryTurretIsTargeting = false;
}

sentry_fire()
{
	self endon("disconnect");
	self endon("end_sentry_turret");

	self.sentryTurretIsFiring = true;
	for(i = 0; i < level.sentryTurretClipSize; i++)
	{
		wait .05;
		if((!isDefined(self.sentryTurretTarget)) || (isDefined(self.sentryTurretTarget) && self.sentryTurretTarget.health < 1) || (isDefined(self.sentryTurretTarget) && !sightTracePassed(self.sentryTurret[2] getTagOrigin("j_barrel_anchor"), self.sentryTurretTarget getTagOrigin("j_spine4"), false, self.sentryTurret)))
			break;

		targetVec = vectorToAngles(self.sentryTurretTarget getTagOrigin("j_spine4")  - self.sentryTurret[3].origin);
		start = self.sentryTurret[3] getTagOrigin("tag_flash");
		end = self.sentryTurret[3] getTagOrigin("tag_flash") + vector_scale(anglesToForward(self.sentryTurret[3] getTagAngles("tag_flash")), 10000);
		ent = bulletTrace(start, end, true, self)["entity"];

		if(!isDefined(ent) && isDefined(self.sentryTurretTarget))
		{
			self.sentryTurret[1] rotateTo((self.sentryTurret[1].angles[0], targetVec[1], self.sentryTurret[1].angles[2]), .25);
			self.sentryTurret[2] rotateTo((targetVec[0], targetVec[1], self.sentryTurret[2].angles[2]), .25);
		}
		self thread anchor_barrel();
		self.sentryTurret[3] rotateRoll(72, .05, 0, 0);

		self.sentryTurretHinge.origin = self.sentryTurret[2] getTagOrigin("tag_origin");
		self.sentryTurretHinge.angles = self.sentryTurret[2] getTagAngles("tag_origin");

		self.sentryTurret[3] playSound("weap_m249saw_turret_fire_npc");
		
		playFXOnTag(level.fx_sentryTurretFlash, self.sentryTurret[3], "tag_flash");
		playFXOnTag(level.fx_sentryTurretTracer, self.sentryTurret[3], "tag_flash");
		playFXOnTag(level.fx_sentryTurretShellEject, self.sentryTurret[2], "tag_brass");
		self.sentryTurret[3] thread sentry_bullet();
	}
	wait .25;
	self thread anchor_barrel();
	self.sentryTurretHinge.origin = self.sentryTurret[2] getTagOrigin("tag_origin");
	self.sentryTurretHinge.angles = self.sentryTurret[2] getTagAngles("tag_origin");
	wait .25;
	self.sentryTurretTarget = undefined;
	self.sentryTurretIsFiring = false;
}

anchor_barrel() // Position barrel correctly according to gun body
{
	self.sentryTurret[3].origin = self.sentryTurret[2] getTagOrigin("j_barrel_anchor");
	self.sentryTurret[3].angles = (self.sentryTurret[2] getTagAngles("j_barrel_anchor")[0], self.sentryTurret[2] getTagAngles("j_barrel_anchor")[1], self.sentryTurret[3].angles[2]);
}

sentry_bullet()
{
	self endon("death");
	self endon("end_sentry_turret");

	wait .05;
	if(!isDefined(self))
		return;

	start = self getTagOrigin("tag_flash");
	end = self getTagOrigin("tag_flash") + vector_scale(anglesToForward(self getTagAngles("tag_flash")), 10000);
	ent = bulletTrace(start, end, true, self)["entity"];

	if(isDefined(ent) && isPlayer(ent) && isAlive(ent))
	{
	 	if(!level.teamBased || (isDefined(ent.pers["team"]) && ent.pers["team"] != self.team))
		{
			ent thread [[level.callbackPlayerDamage]]
			(
				self,			// eInflictor	-The entity that causes the damage.(e.g. a turret)
				self.owner,			// eAttacker	-The entity that is attacking.
				20,			// iDamage	-Integer specifying the amount of damage done
				0,			// iDFlags		-Integer specifying flags that are to be applied to the damage
				"MOD_RIFLE_BULLET",	// sMeansOfDeath	-Integer specifying the method of death
				"sentrygun_mp",	// sWeapon	-The weapon number of the weapon used to inflict the damage
				ent.origin,		// vPoint		-The point the damage is from?
				(0,0,0),			// vDir		-The direction of the damage
				"none",			// sHitLoc	-The location of the hit
				0			// psOffsetTime	-The time offset for the damage
			);
		}
	}

	if(isDefined(ent) && !isPlayer(ent))
	{
		ent notify("damage", 20, self.owner, (0,0,0), (0,0,0), "MOD_RIFLE_BULLET", "", "" );
	}
}

sentry_damage()
{
	self endon("death");
	self endon("end_sentry_turret");

	self setCanDamage(true);
	self.maxhealth = 999999;
	self.health = self.maxhealth;
	attacker = undefined;

	while(1)
	{
		self waittill("damage", dmg, attacker);
		
		if(dmg < 5)
			continue;

		if(!maps\mp\gametypes\_weapons::friendlyFireCheck(self.owner, attacker))
			continue;

		self.owner.sentryTurretDamageTaken += dmg;
		
		attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback(false);

		if(self.owner.sentryTurretDamageTaken >= level.sentryTurretHealth)
			break;
	}
	
	if(!isDefined(self))
		return;

	self.owner thread sentry_explode();
}

manual_move() // Watch for owner manually moving his turret
{
	self endon( "death" );
	self endon( "end_sentry_turret" );

	while(1)
	{
		wait .05;
		if( !isDefined( self ) )
			return;
			
		if( isdefined( self.owner ) && isdefined( self ) )
		{
			if( ( distance( self.origin, self.owner.origin ) <= 60 ) && self.owner IsLookingAt( self ) )
			{
				self.owner CreatePickupMessage();
				
				if( self.owner useButtonPressed() )
					self.owner thread sentry_remove( true );
			}
			else
				self.owner DeletePickupMessage();
				
		}
	}
}

CreatePickupMessage()
{
	self createHudElement( "sentrygun_pickup", 0, 30, "center", "middle", "center_safearea", "center_safearea", false, "hint_usable", 30, 30, 1, 0.8, 1, 1, 1 );
	self createHudTextElement( "sentrygun_pickup_hint", 0, 0, "center", "middle", "center_safearea", "center_safearea", false, 1, .7, 1, 1, 1, 1.4, game["sentrygun_pickup_hint"] );
}

DeletePickupMessage()
{
	self deleteHudTextElementbyName( "sentrygun_pickup_hint" );
	self deleteHudElementbyName( "sentrygun_pickup" );
}

sentry_remove( play )
{
	self notify("end_sentry_turret");
	
	if( play )
		self PlaySoundToPlayer( "minigun_plant", self );
	
	self DeletePickupMessage();

	for(i = 0; i < self.sentryTurret.size; i++)
	{
		if( isDefined( self.sentryTurret[i] ) )
		{
			self.sentryTurret[i] notify("end_sentry_turret");
			self.sentryTurret[i] delete();
		}
	}

	if( isdefined( self.entityHeadIcons ) ) 
		self maps\mp\_entityheadicons::setEntityHeadIcon( "none" );
	
	if( isDefined( self.sentryTurretTrig ) )
		self.sentryTurretTrig delete();

	if(isDefined(self.sentryTurretHinge))
		self.sentryTurretHinge delete();

	wait .05;
	self.sentryTurret = undefined;
	self.owner = undefined;
	
	self giveWeapon( "sentrygun_mp" );
	self giveMaxAmmo( "sentrygun_mp" );
	self setActionSlot( 4, "weapon", "sentrygun_mp" );
	self.pers["hardPointItem"] = "sentrygun_mp";	
}

sentry_explode(attacker)
{
	self notify("end_sentry_turret");
	self.sentryTurret[0] playSound("grenade_explode_default");

	team = self.pers["team"];
	game["dialog"]["sentry_destroyed"] = "sentry_destroyed";
	maps\mp\gametypes\_globallogic::leaderDialog( "sentry_destroyed", team );
	iprintln( &"EXTREME_SENTRYGUN_GONE", self.name );
	playFX(level.fx_sentryTurretExplode, self.sentryTurret[0] getTagOrigin("j_hinge"));
	for(i = 0; i < self.sentryTurret.size; i++)
	{
		if( isDefined( self.sentryTurret[i] ) )
		{
			self.sentryTurret[i] notify("end_sentry_turret");
			self.sentryTurret[i] delete();
			self DeletePickupMessage();
		}
	}

	if( isdefined( self.entityHeadIcons ) ) 
		self maps\mp\_entityheadicons::setEntityHeadIcon( "none" );
	
	if(isDefined(self.sentryTurretTrig))
		self.sentryTurretTrig delete();

	if(isDefined(self.sentryTurretHinge))
		self.sentryTurretHinge delete();

	wait .05;
	self.sentryTurret = undefined;
}

IsLookingAt( gameEntity )
{
	entityPos = gameEntity.origin;
	playerPos = self getEye();

	entityPosAngles = vectorToAngles( entityPos - playerPos );
	entityPosForward = anglesToForward( entityPosAngles );

	playerPosAngles = self getPlayerAngles();
	playerPosForward = anglesToForward( playerPosAngles );

	newDot = vectorDot( entityPosForward, playerPosForward );

	if( newDot < 0.72 ) 
		return false;
	else 
		return true;
}

createHudTextElement( hud_text_name, x, y, xAlign, yAlign, horzAlign, vertAlign, foreground, sort, alpha, color_r, color_g, color_b, size, text ) 
{
	if( !isDefined( self.txt_hud ) ) self.txt_hud = [];

	if( checkHudTextElementbyName( hud_text_name ) )
		return;

	count = self.txt_hud.size;

	self.txt_hud[count] = newClientHudElem( self );
	self.txt_hud[count].name = hud_text_name;
	self.txt_hud[count].x = x;
	self.txt_hud[count].y = y;
	self.txt_hud[count].alignX = xAlign;
	self.txt_hud[count].alignY = yAlign;
	self.txt_hud[count].horzAlign = horzAlign;
	self.txt_hud[count].vertAlign = vertAlign;
	self.txt_hud[count].foreground = foreground;	
	self.txt_hud[count].sort = sort;
	self.txt_hud[count].color = ( color_r, color_g, color_b );
	self.txt_hud[count].hideWhenInMenu = true;
	self.txt_hud[count].alpha = alpha;
	self.txt_hud[count].fontScale = size;
	self.txt_hud[count].font = "objective";
	self.txt_hud[count] setText( text );
}

checkHudTextElementbyName( hud_text_name )
{
	result = false;

	if( isDefined( self.txt_hud ) && self.txt_hud.size > 0 )
	{
		for(i=0; i<self.txt_hud.size; i++ )
		{
			if( isDefined( self.txt_hud[i].name ) && self.txt_hud[i].name == hud_text_name )
				result = true;
		}
	}

	return(result);
}

deleteHudTextElementbyName( hud_text_name )
{
	if( isDefined( self.txt_hud ) && self.txt_hud.size > 0 ) 
	{
		for(i=0; i<self.txt_hud.size; i++ ) 
		{
			if( isDefined( self.txt_hud[i].name ) && self.txt_hud[i].name == hud_text_name ) 
			{
				self.txt_hud[i] destroy();
				self.txt_hud[i].name = undefined;
			}
		}	
	}
}

createHudElement( hud_element_name, x, y, xAlign, yAlign, horzAlign, vertAlign, foreground, shader, shader_width, shader_height, sort, alpha, color_r, color_g, color_b ) 
{
	if( !isDefined( self.hud ) ) self.hud = [];

	if( checkHudElementbyName( hud_element_name ) )
		return;

	count = self.hud.size;

	self.hud[count] = newClientHudElem( self );
	self.hud[count].name = hud_element_name;
	self.hud[count].x = x;
	self.hud[count].y = y;
	self.hud[count].alignX = xAlign;
	self.hud[count].alignY = yAlign;
	self.hud[count].horzAlign = horzAlign;
	self.hud[count].vertAlign = vertAlign;
	self.hud[count].foreground = foreground;
	self.hud[count] setShader(shader, shader_width, shader_height);	
	self.hud[count].sort = sort;
	self.hud[count].alpha = alpha;
	self.hud[count].color = (color_r,color_g,color_b);
	self.hud[count].hideWhenInMenu = true;
	self.hud[count].shader_name = shader;
	self.hud[count].shader_width = shader_width;
	self.hud[count].shader_height = shader_height;
}

checkHudElementbyName( hud_element_name )
{
	result = false;

	if( isDefined( self.hud ) && self.hud.size > 0 )
	{
		for(i=0; i<self.hud.size; i++ )
		{
			if( isDefined( self.hud[i].name ) && self.hud[i].name == hud_element_name )
				result = true;
		}
	}

	return(result);
}

deleteHudElementbyName( hud_element_name )
{
	if( isDefined( self.hud ) && self.hud.size > 0 ) 
	{
		for(i=0; i<self.hud.size; i++ ) 
		{
			if( isDefined( self.hud[i].name ) && self.hud[i].name == hud_element_name ) 
			{
				self.hud[i] destroy();
				self.hud[i].name = undefined;
			}
		}	
	}
}