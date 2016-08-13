#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
init()
{
	precacheModel ( "jokers_stealth");
	precacheItem( "stealth_mp" );
	
	level.bomberfx = loadfx ("explosions/clusterbomb"); 
	level.bombeffect = loadfx ("explosions/artilleryExp_dirt_brown");
	level.bombstrike = loadfx ("explosions/wall_explosion_pm_a");//add
	level.fx_airstrike_contrail = loadfx ("smoke/smoke_geotrail_javelin");
		
}
distance2d(a,b)
{
	return distance((a[0],a[1],0), (b[0],b[1],0));
}

main(origin, hardpointtype, owner, team)
{
	num = 17 + randomint(3);
	
	level.bomberInProgress = true;
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	yaw = getBestBomberDirection( targetpos );
	
	team = self.pers["team"];
	otherTeam = level.otherTeam[team];
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode )
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team))
				{
					if ( pointIsInAirstrikeArea( players[i].origin, targetpos, yaw ) )
						players[i] iprintlnbold("Stealth Bombers Inbound Near Your Position");
				}
			}
		}
		
		maps\mp\gametypes\_globallogic::leaderDialog( "airstrike_inbound", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_airstrike_inbound", otherteam );	
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln("Stealth Bombers called in by ", owner );
			}
		}
	}
	else
	{
		owner maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "airstrike_inbound" );

		if ( !level.hardcoreMode )
		{
			if ( pointIsInAirstrikeArea( owner.origin, targetpos, yaw ) )
				owner iprintlnbold("Stealth Bombers Inbound Near Your Position");
		}
	}
	
	wait 2;

	if ( !isDefined( owner ) )
	{
		level.bomberInProgress = undefined;
		return;
	}
	
	owner notify ( "begin_airstrike" );
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = anglesToForward( (0,yaw,0) );
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	/# level thread debugArtilleryDangerCenters(); #/
	
	wait 1;
	callBomber( owner, targetpos, yaw );
	wait 1;
	callBomber( owner, targetpos + anglestoright( (0,yaw,0) )*500, yaw );
	wait 1;
	callBomber( owner, targetpos - anglestoright ( (0, yaw, 0) )*500, yaw );
		
	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;

	level.bomberInProgress = undefined;
}

getAirstrikeDanger( point )
{
	danger = 0;
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		origin = level.artilleryDangerCenters[i].origin;
		forward = level.artilleryDangerCenters[i].forward;
		
		danger += getSingleAirstrikeDanger( point, origin, forward );
	}
	return danger;
}

getSingleAirstrikeDanger( point, origin, forward )
{
	center = origin + level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius * forward;
	
	diff = point - center;
	diff = (diff[0], diff[1], 0);
	
	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;
	
	circlePos = perpendicularPart + forwardPart / level.artilleryDangerOvalScale;
	
	distsq = lengthSquared( circlePos );
	
	if ( distsq > level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius )
		return 0;
	
	if ( distsq < level.artilleryDangerMinRadius * level.artilleryDangerMinRadius )
		return 1;
	
	dist = sqrt( distsq );
	distFrac = (dist - level.artilleryDangerMinRadius) / (level.artilleryDangerMaxRadius - level.artilleryDangerMinRadius);
	
	assertEx( distFrac >= 0 && distFrac <= 1, distFrac );
	
	return 1 - distFrac;
}

pointIsInAirstrikeArea( point, targetpos, yaw )
{
	return distance2d( point, targetpos ) <= level.artilleryDangerMaxRadius * 1.25;
}

losRadiusDamage(pos, radius, max, min, owner, eInflictor)
{
	ents = maps\mp\gametypes\_weapons::getDamageableEnts(pos, radius, true);

	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		
		if ( ents[i].isPlayer )
		{
			// check if there is a path to this entity 130 units above his feet. if not, they're probably indoors
			indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), 0, undefined );
			if ( !indoors )
			{
				indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), 0, undefined );
				if ( indoors )
				{
					// give them a distance advantage for being indoors.
					dist *= 4;
					if ( dist > radius )
						continue;
				}
			}
		}

		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.airStrikeDamagedEnts[level.airStrikeDamagedEntsCount] = ents[i];
		level.airStrikeDamagedEntsCount++;
	}

		thread BomberDamageEntsThread();
}

BomberDamageEntsThread()
{
	self notify ( "BomberDamageEntsThread" );
	self endon ( "BomberDamageEntsThread" );

	for ( ; level.airstrikeDamagedEntsIndex < level.airstrikeDamagedEntsCount; level.airstrikeDamagedEntsIndex++ )
	{
		if ( !isDefined( level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] ) )
			continue;

		ent = level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( !ent.isPlayer || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a claymore)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"stealth_mp", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			

			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
		}
	}
}

radiusArtilleryShellshock(pos, radius, maxduration,minduration)
{
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]))
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius) {
			duration = int(maxduration + (minduration-maxduration)*dist/radius);
			
			players[i] thread artilleryShellshock("default", duration);
		}
	}
}

artilleryShellshock(type, duration)
{
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}

/#
airstrikeLine( start, end, color, duration )
{
	frames = duration * 20;
	for ( i = 0; i < frames; i++ )
	{
		line(start,end,color);
		wait .05;
	}
}

traceBomb()
{
	self endon("death");
	prevpos = self.origin;
	while(1)
	{
		thread airstrikeLine( prevpos, self.origin, (.5,1,0), 20 );
		prevpos = self.origin;
		wait .2;
	}
}
#/

doBombStrike( owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction , airStrikeType)
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512

	if ( !isDefined( owner ) ) 
		return;
		
	startPathRandomness = 150;
	endPathRandomness = 150;
		
	pathStart = startPoint + ( (randomfloat(2) - 2)*startPathRandomness, (randomfloat(2) - 2)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 2)*endPathRandomness  , (randomfloat(2) - 2)*endPathRandomness  , 0 );
	
   //Assume no change in height on flightpath
   height = (startpoint[2] - bombsite[2]);
   midpoint = bombsite + (0,0,height);
   totaldistance = distance2D(pathstart, pathend);
   speed = totaldistance / flytime; //Units per second

   //Assume 45 degree drop angle to find range in xy from bombsite to releasepoint.
   range = height / sin(45) * cos(45);
   releasepoint = midpoint - anglestoforward(direction) * range;

   //Using plane velocity calculate time from start point to release point.
   //New bombtime replaces original.
   releaseDistance = distance2D(releasepoint, pathStart);
   bombtime = releaseDistance / speed;
	
	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane setModel( "jokers_stealth" );
	plane.angles = direction;
		
	plane moveTo( pathEnd, flyTime, 0, 0 );
		
	thread stealthBomber_killCam( plane, pathEnd, flyTime, airStrikeType );
	
	thread callBomber_planeSound( plane, bombsite );
	
	for ( b = 0; b < 20; b++ ) {
	  thread callStrike_bombEffect( plane, bombTime - 0.1, owner, requiredDeathCount );
	  wait 0.09;
}

	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

callStrike_bombEffect( plane, launchTime, owner, requiredDeathCount )
{
   wait ( launchTime );

   plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
   bomb = spawnbomb( plane.origin, plane.angles );
   bomb.ownerRequiredDeathCount = requiredDeathCount;

   //RUN TRACE TO FIND HIT POINT. ASSUME 45 DEGREE ANGLE
   trace = bullettrace( bomb.origin, bomb.origin + anglestoForward( (45, bomb.angles[1], 0) ) * 5000, false, plane);
   hit = trace["position"] + (0,0,50);
   bomb moveto(hit, 2, 2);
   bomb rotateTo( (45,bomb.angles[1], bomb.angles[2]), 2);

   /#
   if ( getdvar("scr_airstrikedebug") == "1" )
	   bomb thread traceBomb();
   #/

   wait ( 0.85 );
   bomb.killCamEnt = spawn( "script_model", bomb.origin + (0,0,200) );
   bomb.killCamEnt.angles = bomb.angles;
   bomb.killCamEnt thread deleteAfterTime( 10.0 );
   bomb.killCamEnt moveTo( bomb.killCamEnt.origin + vector_scale( anglestoforward( plane.angles ), 1000 ), 3.0 );
   wait ( 0.15 );


   wait 1; // 2 SECONDS MINUS THE KILLCAM WAIT TIMES.

   newBomb = spawn( "script_model", bomb.origin );
   newBomb setModel( "tag_origin" );
	 newBomb.origin = bomb.origin;
	 newBomb.angles = bomb.angles;

   bomb setModel( "tag_origin" );
   wait (0.05);


   bombOrigin = newBomb.origin;
   bombAngles = newBomb.angles;
   playfxontag( level.bomberfx, newBomb, "tag_origin" );

   wait ( 0.05 );
   repeat = 12; //BOMBLETS
   minAngles = 55;
   maxAngles = 100;
   angleDiff = (maxAngles - minAngles) / repeat;

   for( i = 0; i < repeat; i++ )
   {
	  traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
	  traceEnd = bombOrigin + vector_scale( traceDir, 100 );
	  trace = bulletTrace( bombOrigin, traceEnd, false, undefined );

	  traceHit = trace["position"];

	  /#
	  if ( getdvar("scr_airstrikedebug") == "1" )
		 thread airstrikeLine( bombOrigin, traceHit, (1,0,0), 20 );
	  #/

	  thread losRadiusDamage( traceHit + (0,0,16), 512, 200, 100, owner, bomb ); // targetpos, radius, maxdamage, mindamage, player causing damage, entity that player used to cause damage

	  if ( i%3 == 0 )
	  {
		 thread playsoundinspace( "artillery_impact", traceHit );
		 playRumbleOnPosition( "artillery_rumble", traceHit );
		 earthquake( 0.7, 0.75, traceHit, 1000 );
	  }

	  wait ( 0.05 );
   }
   wait ( 5.0 );
   newBomb delete();
   bomb delete();
}

spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );

		bomb thread playPlaneFx(); //----------------------------)

	return bomb;
}

deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( 10.0 );
	
	self delete();
}

drawLine( start, end, timeSlice )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}

playPlaneFx()
{
	self endon ( "death" );

		wait 0.1; 

		playfxontag( level.fx_airstrike_contrail, self, "tag_fx" );
}

stealthBomber_killCam( plane, pathEnd, flyTime, typeOfStrike )
{
	plane waittill ( "begin_airstrike" );

	planedir = anglesToForward( plane.angles );
	
	killCamEnt = spawn( "script_model", plane.origin + (0,0,100) - planedir * 200 );
	plane.killCamEnt = killCamEnt;
	plane.airstrikeType = typeOfStrike;
	killCamEnt.startTime = gettime();
	killCamEnt thread deleteAfterTime( 15.0 );

	killCamEnt linkTo( plane, "tag_origin", (-256,768,768), ( 0,0,0 ) );
}

getBestBomberDirection( hitpos )
{
	if ( getdvarint("scr_airstrikebestangle") != 1 )
		return randomfloat( 360 );
	
	checkPitch = -25;
	
	numChecks = 15;
	
	startpos = hitpos + (0,0,64);
	
	bestangle = randomfloat( 360 );
	bestanglefrac = 0;
	
	fullTraceResults = [];
	
	for ( i = 0; i < numChecks; i++ )
	{
		yaw = ((i * 1.0 + randomfloat(1)) / numChecks) * 360.0;
		angle = (checkPitch, yaw + 180, 0);
		dir = anglesToForward( angle );
		
		endpos = startpos + dir * 1500;
		
		trace = bullettrace( startpos, endpos, false, undefined );
		
		if ( trace["fraction"] > bestanglefrac )
		{
			bestanglefrac = trace["fraction"];
			bestangle = yaw;
			
			if ( trace["fraction"] >= 1 )
				fullTraceResults[ fullTraceResults.size ] = yaw;
		}
		
		if ( i % 3 == 0 )
			wait .05;
	}
	
	if ( fullTraceResults.size > 0 )
		return fullTraceResults[ randomint( fullTraceResults.size ) ];
	
	return bestangle;
}

callBomber( owner, coord, yaw )
{	
	// Get starting and ending point for the plane
	direction = ( 0 , yaw , 0 );
	planeHalfDistance = 12000;
	planeBombExplodeDistance = -1000;
	planeFlyHeight = 800.0 + randomFloat(800.0);
	planeFlySpeed = 800.0 + randomFloat(800.0);

	if ( isdefined( level.airstrikeHeightScale ) )
	{
		planeFlyHeight *= level.airstrikeHeightScale;
	}
	
	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = owner.deathCount;
	
	level.airstrikeDamagedEnts = [];
	level.airStrikeDamagedEntsCount = 0;
	level.airStrikeDamagedEntsIndex = 0;
	level thread doBombStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(1000)), endPoint+(0,0,randomInt(1000)), bombTime, flyTime, direction );
}

callBomber_bomb( bombTime, coord, repeat, owner )
{
	accuracyRadius = 512;
	
	for( i = 0; i < repeat; i++ )
	{
		randVec = ( 0, randomint( 360 ), 0 );
		bombPoint = coord + vector_scale( anglestoforward( randVec ), accuracyRadius );
		
		wait bombTime;
		
		thread playsoundinspace( "artillery_impact", bombPoint );
		radiusArtilleryShellshock( bombPoint, 512, 8, 4);
		losRadiusDamage( bombPoint + (0,0,16), 768, 300, 50, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
	}
}

callBomber_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
	wait 0.05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
	wait 0.05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
	wait 0.05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}

play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}

	org playloopsound (alias);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;
}

flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}

targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}