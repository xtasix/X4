#include extreme\_ex_main;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

precachehelicopter(model,type)
{
	if(!isdefined(type))
		type = "blackhawk";

	deathfx = loadfx ("explosions/tanker_explosion");
	
	level.fx_heli_afterburner = loadfx ("fire/jet_afterburner");
   	level.fx_heli_red_blink = loadfx ("misc/aircraft_light_red_blink");
	level.fx_heli_green_blink = loadfx ("misc/aircraft_light_green_blink");
	
	precacheModel( model );
	level.vehicle_deathmodel[model] = model;
	
	precacheitem( "cobra_FFAR_mp" );
	precacheitem( "hind_FFAR_mp" );
	precacheitem( "cobra_20mm_mp" );
	precacheShader("hudStopwatch");
	
	level.cobra_missile_models = [];
	level.cobra_missile_models["cobra_Hellfire"] = "projectile_hellfire_missile";

	precachemodel( level.cobra_missile_models["cobra_Hellfire"] );
	
	// helicopter sounds:
	level.heli_sound["allies"]["hit"] = "cobra_helicopter_hit";
	level.heli_sound["allies"]["hitsecondary"] = "cobra_helicopter_secondary_exp";
	level.heli_sound["allies"]["damaged"] = "cobra_helicopter_damaged";
	level.heli_sound["allies"]["spinloop"] = "cobra_helicopter_dying_loop";
	level.heli_sound["allies"]["spinstart"] = "cobra_helicopter_dying_layer";
	level.heli_sound["allies"]["crash"] = "cobra_helicopter_crash";
	level.heli_sound["allies"]["missilefire"] = "weap_cobra_missile_fire";
	level.heli_sound["axis"]["hit"] = "hind_helicopter_hit";
	level.heli_sound["axis"]["hitsecondary"] = "hind_helicopter_secondary_exp";
	level.heli_sound["axis"]["damaged"] = "hind_helicopter_damaged";
	level.heli_sound["axis"]["spinloop"] = "hind_helicopter_dying_loop";
	level.heli_sound["axis"]["spinstart"] = "hind_helicopter_dying_layer";
	level.heli_sound["axis"]["crash"] = "hind_helicopter_crash";
	level.heli_sound["axis"]["missilefire"] = "weap_hind_missile_fire";
}

// generate path graph from script_origins
heli_path_graph()
{	
	// collecting all start nodes in the map to generate path arrays
	path_start = getentarray( "heli_start", "targetname" ); 		// start pointers, point to the actual start node on path
	path_dest = getentarray( "heli_dest", "targetname" ); 			// dest pointers, point to the actual dest node on path
	loop_start = getentarray( "heli_loop_start", "targetname" ); 	// start pointers for loop path in the map
	leave_nodes = getentarray( "heli_leave", "targetname" ); 		// points where the helicopter leaves to
	crash_start = getentarray( "heli_crash_start", "targetname" );	// start pointers, point to the actual start node on crash path
	
	assertex( ( isdefined( path_start ) && isdefined( path_dest ) ), "Missing path_start or path_dest" );
		
	// for each destination, loop through all start nodes in level to populate array of start nodes that leads to this destination
	for (i=0; i<path_dest.size; i++)
	{
		startnode_array = [];
		
		// destnode is the final destination from multiple start nodes
		destnode_pointer = path_dest[i];
		destnode = getent( destnode_pointer.target, "targetname" );
		
		// for each start node, traverse to its dest., if same dest. then append to startnode_array
		for ( j=0; j<path_start.size; j++ )
		{
			toDest = false;
			currentnode = path_start[j];
			// traverse through path to dest.
			while( isdefined( currentnode.target ) )
			{
				nextnode = getent( currentnode.target, "targetname" );
				if ( nextnode.origin == destnode.origin )
				{
					toDest = true;
					break;
				}
				
				// debug ==============================================================
				debug_print3d_simple( "+", currentnode, ( 0, 0, -10 ) );
				if( isdefined( nextnode.target ) )
					debug_line( nextnode.origin, getent(nextnode.target, "targetname" ).origin, ( 0.25, 0.5, 0.25 ) );
				if( isdefined( currentnode.script_delay ) )
					debug_print3d_simple( "Wait: " + currentnode.script_delay , currentnode, ( 0, 0, 10 ) );
					
				currentnode = nextnode;
			}
			if ( toDest )
				startnode_array[startnode_array.size] = getent( path_start[j].target, "targetname" ); // the actual start node on path, not start pointer
		}
		assertex( ( isdefined( startnode_array ) && startnode_array.size > 0 ), "No path(s) to destination" );
		
		// load the array of start nodes that lead to this destination node into level.heli_paths array as an element
		level.heli_paths[level.heli_paths.size] = startnode_array;
	}	
	
	// loop paths array
	for (i=0; i<loop_start.size; i++)
	{
		startnode = getent( loop_start[i].target, "targetname" );
		level.heli_loop_paths[level.heli_loop_paths.size] = startnode;
	}
	assertex( isdefined( level.heli_loop_paths[0] ), "No helicopter loop paths found in map" );
	
	// leave nodes
	for (i=0; i<leave_nodes.size; i++)
		level.heli_leavenodes[level.heli_leavenodes.size] = leave_nodes[i];
	assertex( isdefined( level.heli_leavenodes[0] ), "No helicopter leave nodes found in map" );
	
	// crash paths
	for (i=0; i<crash_start.size; i++)
	{
		crash_start_node = getent( crash_start[i].target, "targetname" );
		level.heli_crash_paths[level.heli_crash_paths.size] = crash_start_node;
	}
	assertex( isdefined( level.heli_crash_paths[0] ), "No helicopter crash paths found in map" );
}

init()
{
	path_start = getentarray( "heli_start", "targetname" ); 		// start pointers, point to the actual start node on path
	loop_start = getentarray( "heli_loop_start", "targetname" ); 	// start pointers for loop path in the map

	if ( !path_start.size && !loop_start.size)
		return;
		
	precachehelicopter( "vehicle_cobra_helicopter_fly" );
	precachehelicopter( "vehicle_mi24p_hind_desert" );
	
	// array of paths, each element is an array of start nodes that all leads to a single destination node
	level.chopper_manned = undefined;
	level.heli_paths = [];
	level.heli_loop_paths = [];
	level.heli_leavenodes = [];
	level.heli_crash_paths = [];
		
	//dvars
	thread heli_update_global_dvars();

	// helicopter fx
	level.chopper_fx["explode"]["death"] = loadfx ("explosions/helicopter_explosion_cobra");
	level.chopper_fx["explode"]["large"] = loadfx ("explosions/aerial_explosion_large");
	level.chopper_fx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
	level.chopper_fx["smoke"]["trail"] = loadfx ("smoke/smoke_trail_white_heli");
	level.chopper_fx["fire"]["trail"]["medium"] = loadfx ("smoke/smoke_trail_black_heli");
	level.chopper_fx["fire"]["trail"]["large"] = loadfx ("fire/fire_smoke_trail_L");

	heli_path_graph();
}

// update helicopter dvars realtime
heli_update_global_dvars()
{
	for( ;; )
	{
		level.heli_loopmax = heli_get_dvar_int( "ex_heli_loopmax", "1" );			// how many times helicopter will circle the map before it leaves
		level.heli_missile_rof = heli_get_dvar_int( "ex_heli_missile_rof", "5" );	// missile rate of fire, one every this many seconds per target, could fire two at the same time to different targets
		level.heli_armor = heli_get_dvar_int( "ex_heli_armor", "500" );			// armor points, after this much damage is taken, helicopter is easily damaged, and health degrades
		level.heli_rage_missile = heli_get_dvar( "ex_heli_rage_missile", "5" );	// higher the value, more frequent the missile assault
		level.heli_maxhealth = heli_get_dvar_int( "ex_heli_maxhealth", "3000" );	// max health of the helicopter 
		level.heli_missile_max = heli_get_dvar_int( "ex_heli_missile_max", "3" );	// max number of missiles helicopter can carry
		level.heli_dest_wait = heli_get_dvar_int( "ex_heli_dest_wait", "2" );		// time helicopter waits (hovers) after reaching a destination
		level.heli_debug = heli_get_dvar_int( "ex_heli_debug", "0" );				// debug mode, draws debugging info on screen
		
		level.heli_targeting_delay = heli_get_dvar( "ex_heli_targeting_delay", "0.5" );	// targeting delay
		level.heli_turretReloadTime = heli_get_dvar( "ex_heli_turretReloadTime", "1.5" );	// mini-gun reload time
		level.heli_turretClipSize = heli_get_dvar_int( "ex_heli_turretClipSize", "40" );	// mini-gun clip size, rounds before reload
		level.heli_visual_range = heli_get_dvar_int( "ex_heli_visual_range", "3500" );		// distance radius helicopter will acquire targets (see)
		level.heli_health_degrade = heli_get_dvar_int( "ex_heli_health_degrade", "0" );	// health degradation after injured, health descrease per second for heavy injury, half for light injury
				
		level.heli_target_spawnprotection = heli_get_dvar_int( "ex_heli_target_spawnprotection", "5" );// players are this many seconds safe from helicopter after spawn
		level.heli_turret_engage_dist = heli_get_dvar_int( "ex_heli_turret_engage_dist", "1000" );		// engaging distance for turret
		level.heli_missile_engage_dist = heli_get_dvar_int( "ex_heli_missile_engage_dist", "2000" );	// engaging distance for missiles
		level.heli_missile_regen_time = heli_get_dvar( "ex_heli_missile_regen_time", "10" );			// gives one more missile to helicopter every interval - seconds
		level.heli_turret_spinup_delay = heli_get_dvar( "ex_heli_turret_spinup_delay", "0.75" );			// seconds it takes for the helicopter mini-gun to spin up before shots fired
		level.heli_target_recognition = heli_get_dvar( "ex_heli_target_recognition", "0.5" );			// percentage of the player's body the helicopter sees before it labels him as a target
		level.heli_missile_friendlycare = heli_get_dvar_int( "ex_heli_missile_friendlycare", "256" );	// if friendly is within this distance of the target, do not shoot missile
		level.heli_missile_target_cone = heli_get_dvar( "ex_heli_missile_target_cone", "0.3" );		// dot product of vector target to helicopter forward, 0.5 is in 90 range, bigger the number, smaller the cone
		level.heli_armor_bulletdamage = heli_get_dvar( "ex_heli_armor_bulletdamage", "0.3" );			// damage multiplier to bullets onto helicopter's armor
		
		level.heli_attract_strength = heli_get_dvar( "ex_heli_attract_strength", "1000" );
		level.heli_attract_range = heli_get_dvar( "ex_heli_attract_range", "4096" );		
		
		wait 1;
	}
}

heli_get_dvar_int( dvar, def )
{
	return int( heli_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
heli_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

spawn_helicopter( owner, origin, angles, model, targetname )
{
	chopper = spawnHelicopter( owner, origin, angles, model, targetname );
	chopper.attractor = Missile_CreateAttractorEnt( chopper, level.heli_attract_strength, level.heli_attract_range );
	return chopper;
}

spawnCobraFx()
{
	self endon ( "death" );
	
	wait .07;
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_right" );
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_left" );
	wait .07;
	playfxontag( level.fx_heli_green_blink, self, "tag_light_L_wing" );
	playfxontag( level.fx_heli_green_blink, self, "tag_light_R_wing" );
	wait .07;
	playfxontag( level.fx_heli_red_blink, self, "tag_light_belly" );
	playfxontag( level.fx_heli_red_blink, self, "tag_light_tail" );
	
}

spawnMi28Fx()
{
	self endon ( "death" );
	
	wait .07;
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_right" );
	playfxontag( level.fx_heli_afterburner, self, "tag_engine_left" );
	wait .07;
	playfxontag( level.fx_heli_green_blink, self, "tag_light_L_wing" );
	playfxontag( level.fx_heli_green_blink, self, "tag_light_R_wing" );
	wait .07;
	playfxontag( level.fx_heli_red_blink, self, "tag_light_belly" );
	playfxontag( level.fx_heli_red_blink, self, "tag_light_tail" );
	
}

// spawn helicopter at a start node and monitors it
heli_think( owner, startnode, heli_team, requiredDeathCount )
{
	heliOrigin = owner.origin + (0,0,1000);
	heliAngles = startnode.angles;
	
	if ( heli_team == "allies" )
	{
		chopper = spawn_helicopter( owner, heliOrigin, heliAngles, "cobra_mp", "vehicle_cobra_helicopter_fly" );
		chopper playLoopSound( "mp_cobra_helicopter" );
		chopper thread spawnCobraFx();
	}
	else
	{
		chopper = spawn_helicopter( owner, heliOrigin, heliAngles, "cobra_mp", "vehicle_mi24p_hind_desert" );
		chopper playLoopSound( "mp_hind_helicopter" );
		chopper thread spawnMi28Fx();
	}
	
	chopper.requiredDeathCount = owner.deathCount;
	
	chopper.team = heli_team;
	chopper.pers["team"] = heli_team;
		
	chopper.owner = owner;
	owner.choppa = chopper;
	chopper thread heli_existance();
	
	level.chopper_manned = chopper;
	
	chopper.reached_dest = false;						// has helicopter reached destination
	chopper.maxhealth = level.heli_maxhealth;			// max health chopper.maxhealth
	chopper.waittime = level.heli_dest_wait;			// the time helicopter will stay stationary at destination
	chopper.loopcount = 0; 								// how many times helicopter circled the map
	chopper.evasive = false;							// evasive manuvering
	chopper.health_bulletdamageble = level.heli_armor;	// when damage taken is above this value, helicopter can be damage by bullets to its full amount
	chopper.health_evasive = level.heli_armor;			// when damage taken is above this value, helicopter performs evasive manuvering
	chopper.health_low = level.heli_maxhealth*0.8;		// when damage taken is above this value, helicopter catchs on fire
	chopper.targeting_delay = level.heli_targeting_delay;		// delay between per targeting scan - in seconds
	chopper.primaryTarget = undefined;					// primary target ( player )
	chopper.secondaryTarget = undefined;				// secondary target ( player )
	chopper.attacker = undefined;						// last player that shot the helicopter
	chopper.missile_ammo = level.heli_missile_max;		// initial missile ammo
	chopper.currentstate = "ok";						// health state
	chopper.lastRocketFireTime = -1;
	
	// helicopter loop threads
	owner hide();
	if( owner.pers["team"] == "allies" )
	{
		heli_centroid = chopper.origin + ( 0, 0, -145 );
		heli_forward_norm = anglestoforward( chopper.angles );
		heli_turret_point = heli_centroid + 110*heli_forward_norm;
	}
	else
	{
		heli_centroid = chopper.origin + ( 0, 0, -100 );
		heli_forward_norm = anglestoforward( chopper.angles );
		heli_turret_point = heli_centroid + 120*heli_forward_norm;
	}
	owner setorigin( heli_turret_point );
	owner.flyingheli = true;
	
	self.zething = spawn("script_origin", owner.origin);
	owner linkto( self.zething );
	self.zething linkto( chopper );
	
	self.ex_invulnerable = true;

	owner thread remove_health_shaders( owner ); 
	//owner thread chopper_health_meter(); 

	owner takeallweapons();
	owner [[level.ex_clientcmd]]("gocrouch");
	owner setclientdvar( "cg_thirdperson", "1" );
	owner setclientdvar( "cg_thirdpersonrange", "500" );
	
	chopper thread heli_fly( owner );
	chopper thread heli_damage_monitor();	// monitors damage
	chopper thread heli_health();			// display helicopter's health through smoke/fire
	chopper thread heli_missile_regen();	// regenerates missile ammo 
}

heli_existance()
{
	self waittill_any( "death", "crashing", "leaving" );
	level notify( "helicopter gone" );
}

heli_missile_regen()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	for( ;; )
	{
		debug_print3d( "Missile Ammo: " + self.missile_ammo, ( 0.5, 0.5, 1 ), self, ( 0, 0, -100 ), 0 );
		
		if( self.missile_ammo >= level.heli_missile_max )
			self waittill( "missile fired" );
		else
		{
			// regenerates faster when damaged
			if ( self.currentstate == "heavy smoke" )
				wait( level.heli_missile_regen_time/4 );
			else if ( self.currentstate == "light smoke" )
				wait( level.heli_missile_regen_time/2 );
			else
				wait( level.heli_missile_regen_time );
		}
			if( self.missile_ammo < level.heli_missile_max )
			self.missile_ammo++;
	}
}

// helicopter targeting logic
heli_targeting()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	// targeting sweep cycle
	for ( ;; )
	{		
		// array of helicopter's targets
		targets = [];
		
		// scan for all players in game
		players = level.players;
		for (i = 0; i < players.size; i++)
		{
			player = players[i];
			if ( canTarget_turret( player ) )
			{
				if( isdefined( player ) )
					targets[targets.size] = player;
			}
			else
				continue;
		}
	
		// no targets found
		if ( targets.size == 0 )
		{
			self.primaryTarget = undefined;
			self.secondaryTarget = undefined;
			debug_print_target(); // debug
			wait ( self.targeting_delay );
			continue;
		}
		else if ( targets.size == 1 )
		{
			update_player_threat( targets[0] );
			self.primaryTarget = targets[0];	// primary only
			self notify( "primary acquired" );
			self.secondaryTarget = undefined;
			debug_print_target(); // debug
			wait ( self.targeting_delay );
			continue;
		}
		else if ( targets.size > 1 )
			assignTargets( targets );
			
		debug_print_target(); //debug
	}	
}

// targetability
canTarget_turret( player )
{
	canTarget = true;
	
	if ( !isalive( player ) || player.sessionstate != "playing" )
		return false;
		
	if ( distance( player.origin, self.origin ) > level.heli_visual_range )
		return false;
	
	if ( !isdefined( player.pers["team"] ) )
		return false;
	
	if ( level.teamBased && player.pers["team"] == self.team )
		return false;
	
	if ( player == self.owner )
		return false;
	
	if ( player.pers["team"] == "spectator" )
		return false;
	
	if ( isdefined( player.spawntime ) && ( gettime() - player.spawntime )/1000 <= level.heli_target_spawnprotection )
		return false;
		
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	if ( player sightConeTrace( heli_turret_point, self) < level.heli_target_recognition )
		return false;	
	
	/*
	// IMPORTANT: the following if statement will take 5 server frames to process
	if( player improved_sightconetrace( self ) < level.heli_target_recognition )
		return false;
	*/	
	return canTarget;
}

// assign targets to primary and secondary
assignTargets( targets )
{
	for( idx=0; idx<targets.size; idx++ )
		update_player_threat ( targets[idx] );
	
	assertex( targets.size >= 2, "Not enough targets to assign primary and secondary" );
	
	// find primary target, highest threat level
	highest = 0;	
	second_highest = 0;
	primaryTarget = undefined;
	secondaryTarget = undefined;
	
	// find max and second max, 2n
	for( idx=0; idx<targets.size; idx++ )
	{
		assertex( isdefined( targets[idx].threatlevel ), "Target player does not have threat level" );
		if( targets[idx].threatlevel >= highest )
		{
			highest = targets[idx].threatlevel;
			primaryTarget = targets[idx];
		}
	}
	for( idx=0; idx<targets.size; idx++ )
	{
		assertex( isdefined( targets[idx].threatlevel ), "Target player does not have threat level" );
		if( targets[idx].threatlevel >= second_highest && targets[idx] != primaryTarget )
		{
			second_highest = targets[idx].threatlevel;
			secondaryTarget = targets[idx];
		}
	}	
	
	assertex( isdefined( primaryTarget ), "Targets exist, but none was assigned as primary" );
	self.primaryTarget = primaryTarget;
	self notify( "primary acquired" );
	
	assertex( isdefined( secondaryTarget ), "2+ targets exist, but none was assigned as secondary" );
	self.secondaryTarget = secondaryTarget;
	self notify( "secondary acquired" );
		
	assertex( self.secondaryTarget != self.primaryTarget, "Primary and secondary targets are the same" );
	
	wait ( self.targeting_delay );
}

// threat factors
update_player_threat( player )
{
	player.threatlevel = 0;
	
	// distance factor
	dist = distance( player.origin, self.origin );
	player.threatlevel += ( (level.heli_visual_range - dist)/level.heli_visual_range )*100; // inverse distance % with respect to helicopter targeting range
	
	// behavior factor
	if ( isdefined( self.attacker ) && player == self.attacker )
		player.threatlevel += 100;
	
	// class factor - projectile weapon class has higher threat
	if ( isdefined( player.pers["class"] ) && ( player.pers["class"] == "CLASS_ASSAULT" || player.pers["class"] == "CLASS_RECON" ) )
		player.threatlevel += 200;

	// player score factor
	player.threatlevel += player.score*4;
		
	if( isdefined( player.antithreat ) )
		player.threatlevel -= player.antithreat;
		
	if( player.threatlevel <= 0 )
		player.threatlevel = 1;
}

// resets helicopter's motion values
heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 60, 25 );	
	self setyawspeed( 75, 45, 45 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.9);
}

heli_wait( waittime )
{
	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "evasive" );

	wait( waittime );
}

// hover movements
heli_hover()
{
	// stop hover when anything at all happens
	self endon( "death" );
	self endon( "stop hover" );
	self endon( "evasive" );
	self endon( "leaving" );
	self endon( "crashing" );
	
	original_pos = self.origin;
	original_angles = self.angles;
	self setyawspeed( 10, 45, 45 );
	
	x = 0;
	y = 0;
}

// accumulate damage and react
heli_damage_monitor()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	self.damageTaken = 0;
	
	for( ;; )
	{
		// this damage is done to self.health which isnt used to determine the helicopter's health, damageTaken is.
		self waittill( "damage", damage, attacker, direction_vec, P, type );
		
		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;
		
		heli_friendlyfire = maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker );
		// skip damage if friendlyfire is disabled
		if( !heli_friendlyfire )
			continue;

		if(	isDefined( self.owner ) && attacker == self.owner )
			continue;
		
		if ( level.teamBased )
			isValidAttacker = (isdefined( attacker.pers["team"] ) && attacker.pers["team"] != self.team);
		else
			isValidAttacker = true;

		if ( !isValidAttacker )
			continue;

		attacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
		self.attacker = attacker;

		if ( type == "MOD_RIFLE_BULLET" || type == "MOD_PISTOL_BULLET" )
		{
			if( self.damageTaken >= self.health_bulletdamageble )
				self.damageTaken += damage;
			else
				self.damageTaken += damage*level.heli_armor_bulletdamage;
		}
		else
			self.damageTaken += damage;
			
			if( self.damageTaken > self.maxhealth )
			if(level.ex_destroyedhelireward) attacker bonuspoints(attacker); 
			attacker notify( "destroyed_helicopter" );
	}
}

bonuspoints(attacker)
{  
	wait 0.20; 
	attacker.pers["score"] = attacker.pers["score"] + level.ex_helidestroyedpoints;
	attacker.score = attacker.score + 5;
	attacker iprintlnbold("Heli destroyed bonus: ^2+ " + level.ex_helidestroyedpoints + " ^7pts");
	wait 0.50; 
}

heli_health()
{
	self endon( "death" );
	self endon( "leaving" );
	self endon( "crashing" );
	
	self.currentstate = "ok";
	self.laststate = "ok";
	self setdamagestage( 3 );
	
	for ( ;; )
	{
		if ( self.health_bulletdamageble > self.health_low )
		{
			if ( self.damageTaken >= self.health_bulletdamageble )
				self.currentstate = "heavy smoke";
			else if ( self.damageTaken >= self.health_low )
				self.currentstate = "light smoke";
		}
		else
		{
			if ( self.damageTaken >= self.health_low )
				self.currentstate = "heavy smoke";
			else if ( self.damageTaken >= self.health_bulletdamageble )
				self.currentstate = "light smoke";
		}
		
		if ( self.currentstate == "light smoke" && self.laststate != "light smoke" )
		{
			self setdamagestage( 2 );
			self.laststate = self.currentstate;

		}
		if ( self.currentstate == "heavy smoke" && self.laststate != "heavy smoke" )
		{
			self setdamagestage( 1 );
			self notify ( "stop body smoke" );
			self.laststate = self.currentstate;
		}
		
		if ( self.currentstate == "heavy smoke" )
		{
			self.damageTaken += level.heli_health_degrade;
			level.heli_rage_missile = 20; // increase missile firing rate more
		}
		if ( self.currentstate == "light smoke" )
		{
			self.damageTaken += level.heli_health_degrade/2;
			level.heli_rage_missile = 10;	// increase missile firing rate
		}
			
		if( self.damageTaken >= self.health_evasive )
		{
			//if( !self.evasive )
			//self thread heli_evasive();
		}
		
		if( self.damageTaken > self.maxhealth )
			self thread heli_crash();
			
		// debug =================================
		if( self.damageTaken <= level.heli_armor )
			debug_print3d_simple( "Armor: " + (level.heli_armor-self.damageTaken), self, ( 0,0,100 ), 20 );
		else
			debug_print3d_simple( "Health: " + ( self.maxhealth - self.damageTaken ), self, ( 0,0,100 ), 20 );
			
		wait 1;
	}
}

// evasive manuvering - helicopter circles the map for awhile then returns to path
heli_evasive()
{
	// only one instance allowed
	self notify( "evasive" );
	
	self.evasive = true;
	
	// set helicopter path to circle the map level.heli_loopmax number of times
	loop_startnode = level.heli_loop_paths[0];
	self thread heli_fly( loop_startnode );
}

// attach helicopter on crash path
heli_crash()
{
	self notify( "crashing" );
	
	// helicopter losing control and spins
	self thread heli_spin( 180 );

	// body explosion fx when on crash path
	playfxontag( level.chopper_fx["explode"]["large"], self, "tag_engine_left" );
	// along with a sound
	self playSound ( level.heli_sound[self.team]["hitsecondary"] );

	self setdamagestage( 0 );
	// form fire smoke trails on body after explosion
	self thread trail_fx( level.chopper_fx["fire"]["trail"]["large"], "tag_engine_left", "stop body fire" );
	
	wait 10;
	self thread heli_explode();
}

// self spin at one rev per 2 sec
heli_spin( speed )
{
	self endon( "death" );
	
	// tail explosion that caused the spinning
	playfxontag( level.chopper_fx["explode"]["medium"], self, "tail_rotor_jnt" );
	// play hit sound immediately so players know they got it
	self playSound ( level.heli_sound[self.team]["hit"] );
	
	// play heli crashing spinning sound
	self thread spinSoundShortly();
	
	// form smoke trails on tail after explosion
	self thread trail_fx( level.chopper_fx["smoke"]["trail"], "tail_rotor_jnt", "stop tail smoke" );
	
	// spins until death
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
	self thread heli_explode();
}

spinSoundShortly()
{
	self endon("death");
	
	wait .25;
	
	self stopLoopSound();
	wait .05;
	self playLoopSound( level.heli_sound[self.team]["spinloop"] );
	wait .05;
	self playSound( level.heli_sound[self.team]["spinstart"] );
}

// TO DO: replace the for-loop to use geotrails for smoke trail fx
// this plays single smoke trail puff on origin per 0.05
// trail_fx is the fx string, trail_tag is the tag string
trail_fx( trail_fx, trail_tag, stop_notify )
{
	// only one instance allowed
	self notify( stop_notify );
	self endon( stop_notify );
	self endon( "death" );
		
	for ( ;; )
	{
		playfxontag( trail_fx, self, trail_tag );
		wait( 0.05 );
	}
}

// crash explosion
heli_explode( owner )
{
	self notify("death");  
	
	forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );
	
	// play heli explosion sound
	self playSound( level.heli_sound[self.team]["crash"] );
	self.owner setclientdvar( "cg_thirdpersonrange", "120" );
	if(!isdefined( self.thirdperson ))
	self.owner setclientdvar( "cg_thirdperson", "0" );
	self.owner [[level.onSpawnPlayer]]();
	self.owner.health = self.owner.maxhealth; 
	if(isDefined(owner)) owner.ex_heliwatch destroy();
	self.owner thread extreme\_ex_healthbar::start(); 
	self.owner maps\mp\gametypes\_class::giveLoadout(self.owner.pers["team"], self.owner.class);
	self.owner show();
	self.owner.ex_invulnerable = false;
	self.owner.flyingheli = undefined;
	self.owner unlink(); 
 	self.owner thread maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem();
	level.chopper_manned = undefined;
	if( isDefined( self ) )
	self delete();
}

// helicopter leaving parameter, can not be damaged while leaving
heli_leave()
{
	self notify( "desintation reached" );
	self notify( "leaving" );
	
	// helicopter leaves randomly towards one of the leave origins
	random_leave_node = randomInt( level.heli_leavenodes.size );
	leavenode = level.heli_leavenodes[random_leave_node];
	
	heli_reset();
	self setspeed( 100, 45 );	
	self setvehgoalpos( leavenode.origin, 1 );
	self waittillmatch( "goal" );
	self notify( "death" );
	
	level.chopper_manned = undefined;	
	self delete();
}
	
// flys helicopter from given start node to a destination on its path
fire_missile( sMissileType, iShots, eTarget )
{
	if ( !isdefined( iShots ) )
		iShots = 1;
	assert( self.health > 0 );
	
	weaponName = undefined;
	weaponShootTime = undefined;
	defaultWeapon = "cobra_20mm_mp";
	tags = [];
	switch( sMissileType )
	{
		case "ffar":
			if ( self.team == "allies" )
				weaponName = "cobra_FFAR_mp";
			else
				weaponName = "hind_FFAR_mp";
				
			tags[ 0 ] = "tag_store_r_2";
			break;
		default:
			assertMsg( "Invalid missile type specified. Must be ffar" );
			break;
	}
	assert( isdefined( weaponName ) );
	assert( tags.size > 0 );
	
	weaponShootTime = weaponfiretime( weaponName );
	assert( isdefined( weaponShootTime ) );
	
	self setVehWeapon( weaponName );
	nextMissileTag = -1;
	for( i = 0 ; i < iShots ; i++ ) 
	{
		nextMissileTag++;
		if ( nextMissileTag >= tags.size )
			nextMissileTag = 0;
		
		if ( isdefined( eTarget ) )
		{
			eMissile = self fireWeapon( tags[ nextMissileTag ], eTarget );
		}
		else
		{
			eMissile = self fireWeapon( tags[ nextMissileTag ] );
		}
		self.lastRocketFireTime = gettime();
		
		if ( i < iShots - 1 )
			wait weaponShootTime;
	}
}

check_owner()
{
	if ( !isdefined( self.owner ) || !isdefined( self.owner.pers["team"] ) || self.owner.pers["team"] != self.team )
	{
		self notify ( "abandoned" );
		self thread heli_leave();	
	}
}

attack_targets()
{
	self thread attack_primary();
	self thread attack_secondary();
}

// missile only
attack_secondary()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );	
	
	for( ;; )
	{
		if ( isdefined( self.secondaryTarget ) )
		{
			self.secondaryTarget.antithreat = undefined;
			self.missileTarget = self.secondaryTarget;
			
			antithreat = 0;

			while( isdefined( self.missileTarget ) && isalive( self.missileTarget ) )
			{
				// if selected target is not in missile hit range, skip
				if( self missile_target_sight_check( self.missileTarget ) )
					self thread missile_support( self.missileTarget, level.heli_missile_rof, true, undefined );
				else
					break;
				
				// lower targets threat after shooting
				antithreat += 100;
				self.missileTarget.antithreat = antithreat;
				
				self waittill( "missile ready" );
				
				// target might disconnect or change during last assault cycle
				if ( !isdefined( self.secondaryTarget ) || ( isdefined( self.secondaryTarget ) && self.missileTarget != self.secondaryTarget ) )
					break;
			}
			// reset the antithreat factor
			if ( isdefined( self.missileTarget ) )
				self.missileTarget.antithreat = undefined;
		}
		self waittill( "secondary acquired" );
		
		// check if owner has left, if so, leave
		self check_owner();
	}	
}

// check if missile is in hittable sight zone
missile_target_sight_check( missiletarget )
{
	heli2target_normal = vectornormalize( missiletarget.origin - self.origin );
	heli2forward = anglestoforward( self.angles );
	heli2forward_normal = vectornormalize( heli2forward );

	heli_dot_target = vectordot( heli2target_normal, heli2forward_normal );
	
	if ( heli_dot_target >= level.heli_missile_target_cone )
	{
		debug_print3d_simple( "Missile sight: " + heli_dot_target, self, ( 0,0,-40 ), 40 );
		return true;
	}
	return false;
}

// if wait for turret turning is too slow, enable missile assault support
missile_support( target_player, rof, instantfire, endon_notify )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );	
	 
	if ( isdefined ( endon_notify ) )
		self endon( endon_notify );
			
	self.turret_giveup = false;
	
	if ( !instantfire )
	{
		wait( rof );
		self.turret_giveup = true;
		self notify( "give up" );
	}
	
	if ( isdefined( target_player ) )
	{
		if ( level.teambased )
		{
			// if target near friendly, do not shoot missile, target already has lower threat level at this stage
			for (i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				if ( isdefined( player.pers["team"] ) && player.pers["team"] == self.team && distance( player.origin, target_player.origin ) <= level.heli_missile_friendlycare )
				{
					debug_print3d_simple( "Missile omitted due to nearby friendly", self, ( 0,0,-80 ), 40 );
					self notify ( "missile ready" );
					return;		
				}
			}
		}
		else
		{
			player = self.owner;
			if ( isdefined( player ) && isdefined( player.pers["team"] ) && player.pers["team"] == self.team && distance( player.origin, target_player.origin ) <= level.heli_missile_friendlycare )
			{
				debug_print3d_simple( "Missile omitted due to nearby friendly", self, ( 0,0,-80 ), 40 );
				self notify ( "missile ready" );
				return;
			}
		}
	}
	
	if ( self.missile_ammo > 0 && isdefined( target_player ) )
	{
		self fire_missile( "ffar", 1, target_player );
		self.missile_ammo--;
		self notify( "missile fired" );
	}
	else
	{
		return;
	}
	
	if ( instantfire )
	{
		wait ( rof );
		self notify ( "missile ready" );
	}
}

// mini-gun with missile support
attack_primary()
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	for( ;; )
	{
		if ( isdefined( self.primaryTarget ) )
		{
			self.primaryTarget.antithreat = undefined;
			self.turretTarget = self.primaryTarget;
			
			antithreat = 0;
			last_pos = undefined;
			
			while( isdefined( self.turretTarget ) && isalive( self.turretTarget ) )
			{
				// shoots one clip of mini-gun none stop
				self setTurretTargetEnt( self.turretTarget, ( 0, 0, 40 ) );
				
				// if wait for turret turning is too slow, enable missile assault support
				if( self missile_target_sight_check( self.turretTarget ) )
					self thread missile_support( self.turretTarget, 10/level.heli_rage_missile, false, "turret on target" );

				self waittill( "turret_on_target" );
					
				self notify( "turret on target" );
				
				self thread turret_target_flag( self.turretTarget );
				
				// wait for turret to spinup and fire
				wait( level.heli_turret_spinup_delay );
				
				// fire gun =================================
				weaponShootTime = weaponfiretime("cobra_20mm_mp" );
				self setVehWeapon( "cobra_20mm_mp" );
				
				// shoot full clip at target, if target lost, shoot at the last position recorded, if target changed, sweep onto next target
				for( i = 0 ; i < level.heli_turretClipSize ; i++ )
				{
					// if turret on primary target, keep last position of the target in case target lost
					if ( isdefined( self.turretTarget ) && isdefined( self.primaryTarget ) )
					{
						if ( self.primaryTarget != self.turretTarget )
							self setTurretTargetEnt( self.primaryTarget, ( 0, 0, 40 ) );
					}
					else
					{
						if ( isdefined( self.targetlost ) && self.targetlost && isdefined( self.turret_last_pos ) )
						{
							//println( "Target lost ---- shooting last pos: " + self.turret_last_pos ); // debug
							self setturrettargetvec( self.turret_last_pos );
						}
						else
						{
							self clearturrettarget();
						}	
					}
					if ( gettime() != self.lastRocketFireTime )
					{
						// fire one bullet
						self setVehWeapon( "cobra_20mm_mp" );
						miniGun = self fireWeapon( "tag_flash" );
					}
					
					// wait for RoF
					if ( i < level.heli_turretClipSize - 1 )
						wait weaponShootTime;
				}
				self notify( "turret reloading" );
				// end fire gun ==============================
				
				// wait for turret reload
				wait( level.heli_turretReloadTime );
				
				// lower the target's threat since already assaulted on
				if ( isdefined( self.turretTarget ) && isalive( self.turretTarget ) )
				{
					antithreat += 100;
					self.turretTarget.antithreat = antithreat;
				}
				
				// primary target might disconnect or change during last assault cycle, if so, find new target
				if ( !isdefined( self.primaryTarget ) || ( isdefined( self.turretTarget ) && isdefined( self.primaryTarget ) && self.primaryTarget != self.turretTarget ) )
					break;
			}
			// reset the antithreat factor
			if ( isdefined( self.turretTarget ) )
				self.turretTarget.antithreat = undefined;
		}
		self waittill( "primary acquired" );
		
		// check if owner has left, if so, leave
		self check_owner();
	}
}

// target lost flaging
turret_target_flag( turrettarget )
{
	// forcing single thread instance
	self notify( "flag check is running" );
	self endon( "flag check is running" );
	
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	self endon( "turret reloading" );
	
	// ends on target player death or undefined
	turrettarget endon( "death" );
	turrettarget endon( "disconnect" );
	
	self.targetlost = false;
	self.turret_last_pos = undefined;
	
	while( isdefined( turrettarget ) )
	{
		heli_centroid = self.origin + ( 0, 0, -160 );
		heli_forward_norm = anglestoforward( self.angles );
		heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
		sight_rec = turrettarget sightconetrace( heli_turret_point, self );
		if ( sight_rec < level.heli_target_recognition )
			break;
		
		wait 0.05;
	}
	
	if( isdefined( turrettarget ) && isdefined( turrettarget.origin ) )
	{
		assertex( isdefined( turrettarget.origin ), "turrettarget.origin is undefined after isdefined check" );
		self.turret_last_pos = turrettarget.origin + ( 0, 0, 40 );
		assertex( isdefined( self.turret_last_pos ), "self.turret_last_pos is undefined after setting it #1" );
		self setturrettargetvec( self.turret_last_pos );
		assertex( isdefined( self.turret_last_pos ), "self.turret_last_pos is undefined after setting it #2" );
		debug_print3d_simple( "Turret target lost at: " + self.turret_last_pos, self, ( 0,0,-70 ), 60 );
		self.targetlost = true;
	}
	else
	{
		self.targetlost = undefined;
		self.turret_last_pos = undefined;
	}
}

// debug on screen elements ===========================================================
debug_print_target()
{
	if ( isdefined( level.heli_debug ) && level.heli_debug == 1.0 )
	{
		// targeting debug print
		if( isdefined( self.primaryTarget ) && isdefined( self.primaryTarget.threatlevel ) )
			primary_msg = "Primary: " + self.primaryTarget.name + " : " + self.primaryTarget.threatlevel;
		else
			primary_msg = "Primary: ";
			
		if( isdefined( self.secondaryTarget ) && isdefined( self.secondaryTarget.threatlevel ) )
			secondary_msg = "Secondary: " + self.secondaryTarget.name + " : " + self.secondaryTarget.threatlevel;
		else
			secondary_msg = "Secondary: ";
			
		frames = int( self.targeting_delay*20 )+1;
		
		thread draw_text( primary_msg, (1, 0.6, 0.6), self, ( 0, 0, 40), frames );
		thread draw_text( secondary_msg, (1, 0.6, 0.6), self, ( 0, 0, 0), frames );
	}
}

debug_print3d( message, color, ent, origin_offset, frames )
{
	if ( isdefined( level.heli_debug ) && level.heli_debug == 1.0 )
		self thread draw_text( message, color, ent, origin_offset, frames );
}

debug_print3d_simple( message, ent, offset, frames )
{
	if ( isdefined( level.heli_debug ) && level.heli_debug == 1.0 )
	{
		if( isdefined( frames ) )
			thread draw_text( message, ( 0.8, 0.8, 0.8 ), ent, offset, frames );
		else
			thread draw_text( message, ( 0.8, 0.8, 0.8 ), ent, offset, 0 );
	}
}

debug_line( from, to, color, frames )
{
	if ( isdefined( level.heli_debug ) && level.heli_debug == 1.0 && !isdefined( frames ) )
	{
		thread draw_line( from, to, color );
	}
	else if ( isdefined( level.heli_debug ) && level.heli_debug == 1.0 )
		thread draw_line( from, to, color, frames);
}

draw_text( msg, color, ent, offset, frames )
{
	if( frames == 0 )
	{
		while ( isdefined( ent ) )
		{
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			wait 0.05;
		}
	}
	else
	{
		for( i=0; i < frames; i++ )
		{
			if( !isdefined( ent ) )
				break;
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			wait 0.05;
		}
	}
}

draw_line( from, to, color, frames )
{
	if( isdefined( frames ) )
	{
		for( i=0; i<frames; i++ )
		{
			line( from, to, color );
			wait 0.05;
		}		
	}
	else
	{
		for( ;; )
		{
			line( from, to, color );
			wait 0.05;
		}
	}
}

// cpu friendly version of sight cone trace performs single trace per frame
// 1/4 second delay
improved_sightconetrace( helicopter )
{
	// obtain start as origin of the turret point
	heli_centroid = helicopter.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( helicopter.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	draw_line( heli_turret_point, self.origin, ( 1, 1, 1 ), 5 );
	start = heli_turret_point;
	yes = 0;
	point = [];
	
	for( i=0; i<5; i++ )
	{
		if( !isdefined( self ) )
			break;
		
		half_height = self.origin+(0,0,36);
		
		tovec = start - half_height;
		tovec_angles = vectortoangles(tovec);
		forward_norm = anglestoforward(tovec_angles);
		side_norm = anglestoright(tovec_angles);

		point[point.size] = self.origin + (0,0,36);
		point[point.size] = self.origin + side_norm*(15, 15, 0) + (0, 0, 10);
		point[point.size] = self.origin + side_norm*(-15, -15, 0) + (0, 0, 10);
		point[point.size] = point[2]+(0,0,64);
		point[point.size] = point[1]+(0,0,64);
		
		// debug =====================================
		draw_line( point[1], point[2], (1, 1, 1), 1 );
		draw_line( point[2], point[3], (1, 1, 1), 1 );
		draw_line( point[3], point[4], (1, 1, 1), 1 );
		draw_line( point[4], point[1], (1, 1, 1), 1 );
		
		if( bullettracepassed( start, point[i], true, self ) )
		{
			draw_line( start, point[i], (randomInt(10)/10, randomInt(10)/10, randomInt(10)/10), 1 );
			yes++;
		}
		waittillframeend;
	}
	return yes/5;
}

heli_fly( owner )
{
	self endon( "death" );
	self endon( "respawn" );
		
	// only one thread instance allowed
	self notify( "flying");
	self endon( "flying" );
	
	// if owner switches teams, helicopter should leave
	self endon( "abandoned" );
	owner iprintlnbold("You have " + level.ex_heli_timer + " Seconds");
	self thread helitimer( owner );
	self thread chopper_hud( owner );
	self setturningability(1);
	self.reached_dest = false;
	heli_reset();
	owner.isturretsafe = true;
	owner.islinked = true;
	self.ispitchedown = false;
	pos = self.origin;

	self setVehWeapon( "cobra_20mm_mp" );
	entity = spawn( "script_origin", (0,0,1000) );
	
	wait 0.5;
	
	owner iprintlnbold( "^2Chopper Ready!" );
	
	while( isAlive( owner ) )
	{
		angle = owner getplayerangles();
		vec = vecscale( anglestoforward( angle ), 10000000 );
		vec2 = vecscale( anglestoforward( angle ), 75 );
		trace = bullettrace( self.origin + vec2, self.origin + vec, true, self.choppa );
		pos = trace["position"];
		entity.origin = pos;
		if( owner meleebuttonpressed() )
		owner thread moveonangle( angle );
		else
		{
			distance = vecscale( anglestoforward( angle ), 1 );
			if( self.ispitchedown )
			{
				self setvehgoalpos( self.origin + distance, 1 );
				self helirotateto( (self.angles[0], self.angles[1], self.angles[2] ), "up" );
			}
			self.angles = owner.angles;
		}
		if( owner attackbuttonpressed() && owner.isturretsafe )
		{
			owner.isturretsafe = false;
			owner thread maketurretsafe();
			oldang = self.angles;
			self.angles = angle;
			fire_missile( "ffar", 1, entity );
			self.angles = oldang;
			
		}
		self.angles = angle;
		wait 0.05;
	}
}

helitimer( owner )
{

	self endon( "death" );
	self endon( "respawn" );

	if(!isDefined(owner.ex_heliwatch)) 
	{
		owner.ex_heliwatch = newClientHudElem(owner);
		owner.ex_heliwatch.x = -190;   
		owner.ex_heliwatch.y = -5; 
		owner.ex_heliwatch.alignx = "right"; 
		owner.ex_heliwatch.aligny = "bottom";
		owner.ex_heliwatch.horzAlign = "right"; 
		owner.ex_heliwatch.vertAlign = "bottom";
		owner.ex_heliwatch.alpha = .9; 
		owner.ex_heliwatch.fontScale = 2; 
		owner.ex_heliwatch.sort = 100; 
		owner.ex_heliwatch.foreground = true; 
		owner.ex_heliwatch setClock( level.ex_heli_timer, 60, "hudStopwatch", 60, 60);
	}
	
  	wait level.ex_heli_timer;

	if(isDefined(owner.ex_heliwatch)) owner.ex_heliwatch destroy();
	
	self.owner setclientdvar( "cg_thirdpersonrange", "120" );
	if(!isdefined( self.thirdperson ))
	self.owner setclientdvar( "cg_thirdperson", "0" );
	self.owner [[level.onSpawnPlayer]]();
	self.owner thread remove_chopper_health_meter( owner );	
	self.owner.health = self.owner.maxhealth; 
	self.owner thread extreme\_ex_healthbar::start(); 
	self.owner maps\mp\gametypes\_class::giveLoadout(self.owner.pers["team"], self.owner.class);
	self.owner show();
	owner.ex_invulnerable = false;
	self.owner.flyingheli = undefined;
	self.owner unlink(); 
 	self.owner thread maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem();
	level.chopper_manned = undefined;
	if( isDefined( self ) )
	self delete();
}

chopper_hud( owner )
{

	self endon( "death" );
	self endon( "respawn" );

	owner.HUDItem[ "keypress" ] = newClientHudElem( owner );		
	owner.HUDItem[ "keypress" ].x = 0;
	owner.HUDItem[ "keypress" ].y = -150;
	owner.HUDItem[ "keypress" ].alignX = "left";
	owner.HUDItem[ "keypress" ].alignY = "bottom";
	owner.HUDItem[ "keypress" ].horzAlign = "left";
	owner.HUDItem[ "keypress" ].vertAlign = "bottom";
	owner.HUDItem[ "keypress" ].fontScale = 1.5;
	owner.HUDItem[ "keypress" ].label = (&"press ^3MELEE ^7to move foward" );
	owner.HUDItem[ "keypress" ] fadeOverTime(2);
	owner.HUDItem[ "keypress" ].alpha = 1.0;
	
	owner.HUDItem[ "keypress" ] fadeOverTime( 15 );
	owner.HUDItem[ "keypress" ].alpha = 0;
	
	owner.HUDItem[ "keypress" ] = newClientHudElem( owner );
	owner.HUDItem[ "keypress" ].x = 0;
	owner.HUDItem[ "keypress" ].y = -135;
	owner.HUDItem[ "keypress" ].alignX = "left";
	owner.HUDItem[ "keypress" ].alignY = "bottom";
	owner.HUDItem[ "keypress" ].horzAlign = "left";
	owner.HUDItem[ "keypress" ].vertAlign = "bottom";
	owner.HUDItem[ "keypress" ].fontScale = 1.5;
	owner.HUDItem[ "keypress" ].label = (&"press ^3FIRE ^7key to fire Missiles" );
	owner.HUDItem[ "keypress" ] fadeOverTime(2);
	owner.HUDItem[ "keypress" ].alpha = 1.0;
	
	owner.HUDItem[ "keypress" ] fadeOverTime( 18 );
	owner.HUDItem[ "keypress" ].alpha = 0;
	
}

remove_health_shaders( owner )
{
	if(isDefined(self.ex_healthbar)) self.ex_healthbar destroy();
	if(isDefined(self.ex_healthback)) self.ex_healthback destroy();
	if(isDefined(self.ex_healthcross)) self.ex_healthcross destroy();  
}

remove_chopper_health_meter( owner )
{
	if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy();	
}

chopper_health_meter()
{

	self endon( "death" );
	self endon( "respawn" );

	self.hud_Chopper_health = newClientHudElem(self);
	self.hud_Chopper_health.archived = false;
	self.hud_Chopper_health.x = 0;
	self.hud_Chopper_health.y = -60;
	self.hud_Chopper_health.sort = 10;
	self.hud_Chopper_health.alignX = "left";
	self.hud_Chopper_health.alignY = "bottom";
	self.hud_Chopper_health.horzAlign = "left";
	self.hud_Chopper_health.vertAlign = "bottom";
	self.hud_Chopper_health.fontscale = 1.4;
	self.hud_Chopper_health.label = (&"^2ChopperHealth::");
	self thread updatemeter();
}

updatemeter( chopper )
{

	self endon( "death" );
	self endon( "respawn" );  
	self endon("disconnect");
	
	for(;;)
	{
		//chopper.maxhealth = level.heli_maxhealth;
		
		if(isDefined(chopper.maxhealth))
		self.hud_Chopper_health setValue(chopper.maxhealth);
		self waittill( "damage", damage, attacker, direction_vec, P, type );
		wait 0.05;
	}
}

helirotateto( vec, dif )
{
	if( dif == "up" )
	{
		for( i = 0; i < 10; i++ )
		{
			self.angles = self.angles + ( 1.5,0,0 );
			wait 0.05;
		}
	}
	else
	{
		for( i = 0; i < 10; i++ )
		{
			self.angles = self.angles - ( 1.5,0,0 );
			wait 0.05;
		}
	}
}

heli_vertical( dir ) 
{
	if( dir == "up" )
	{
		if( bullettracepassed( self.choppa.origin,  self.choppa.origin + (0,0,25), false, self.choppa ) )
		{
			self.choppa setspeed( 100, 100 );	
			self.choppa setvehgoalpos( self.choppa.origin + (0,0,50), 1 );
		}
		else
		{
			if(isDefined(self.ex_heliwatch)) self.ex_heliwatch destroy(); 			
			if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy();
			self.choppa thread heli_explode();
		}
	}
	else
	{
		if( bullettracepassed( self.choppa.origin,  self.choppa.origin - (0,0,25), false, self.choppa ) )
		{
			self.choppa setspeed( 100, 100 );	
			self.choppa setvehgoalpos( self.choppa.origin - (0,0,50), 1 );
		}
		else
		{
			if(isDefined(self.ex_heliwatch)) self.ex_heliwatch destroy();
			if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy();
			self.choppa thread heli_explode();
		}
	}
}

firemissile( angle )
{
	self setVehWeapon( "cobra_20mm_mp" );
	miniGun = self fireWeapon( "tag_flash" );
}

maketurretsafe()
{
	wait 1;
	self.isturretsafe = true;
}

moveonangle( angle )
{
	distance = vecscale( anglestoforward( angle ), 25 );
	if( bullettracepassed( self.origin, self.origin + distance, false, self.choppa ) )
	{
		if( !isDefined( self.choppa ) )
			return;
		if( !self.choppa.ispitchedown )
		{
			self helirotateto( (0,0,0), "down" );
			self.choppa.ispitchedown = true;
		}
		self.choppa setspeed( 50, 50 );	
		self.choppa SetTargetYaw( angle[1] );
		self.choppa SetYawSpeed( 180, 60, 60, 0 );
		self.choppa setvehgoalpos( self.choppa.origin + distance, 0 );
	}
	else
	{
		self iprintlnbold("You Crashed your helicopter");
		if(isDefined(self.ex_heliwatch)) self.ex_heliwatch destroy(); 
		if(isDefined(self.hud_Chopper_health)) self.hud_Chopper_health destroy(); 
		if(isDefined(self.hud_Chopper_health_num)) self.hud_Chopper_health_num destroy();
		self.choppa thread heli_explode();
	}
}

shootingposition()
{
	self endon( "death" );

	self.choppa setvehgoalpos( self.choppa.origin, 0 );
	self.choppa clearTargetYaw();
	self.choppa clearGoalYaw();
	oldorigin = self.origin;
	oldangle = self.angles;
	self giveweapon( "helicopter_mp" );
	self switchtoweapon( "helicopter_mp" );
	wait 2;
	while(1)
	{
		wait 0.05;
		if( self usebuttonpressed() )
			break;
	}
	self setorigin( oldorigin );
	self setplayerangles( oldangle );
	self takeweapon( "helicopter_mp" );
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}