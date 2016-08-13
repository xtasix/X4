#include maps\mp\_utility;

init()
{
	precacheModel("vehicle_uav");
	precacheModel("c130_zoomrig");
	precacheShader("hudStopwatch");
		
	level.uav_rotationSpeed = 30;

}

main()
{
	uavOrigin = level.ex_playArea_Centre;
	uavOrigin = getAboveBuildingsLocationUAV(uavOrigin);  
	
	level.uav = spawn("script_model", uavOrigin);
	level.uav setModel("c130_zoomrig");
	level.uav.angles = (0,115,0);
	level.uav hide();
  
	level.uavmodel = spawn("script_model", uavOrigin); 
	level.uavmodel setModel("vehicle_uav"); 
	level.uav.angles = (00,115,00);
	level.uavmodel linkTo(level.uav, "tag_player", (00,-100,00), (00,-100,00));
	level.uavmodel hide(); 
	
	thread rotateuavdrone(true);	
}

getAboveBuildingsLocationUAV(location)
{
	trace = bullettrace(location + (0,0,100), location, false, undefined); 
	startorigin = trace["position"] + (0,0,-114);
   
	zpos = 0;
   
	maxxpos = 13; maxypos = 13;
	for (xpos = 0; xpos < maxxpos; xpos++)
	{
		for (ypos = 0; ypos < maxypos; ypos++)
		{
			thisstartorigin = startorigin + ((xpos/(maxxpos-1) - .5) * 1024, (ypos/(maxypos-1) - .5) * 1024, 0);
			thisorigin = bullettrace(thisstartorigin, thisstartorigin + (0,0,-10000), false, undefined);
			zpos += thisorigin["position"][2];
		}
	}

	zpos = zpos / (maxxpos*maxypos);
	zpos = zpos + 1000;
   
	return (location[0], location[1], zpos);
}

rotateuavdrone(toggle)
{
	level notify("stop_rotateuavdrone_thread");
	level endon("stop_rotateuavdrone_thread");
   
	if(toggle)
	{
		for(;;)
		{
			level.uav rotateyaw( 360, level.uav_rotationSpeed );
			wait level.uav_rotationSpeed;
		}
	}
	else level.uavdrone rotateyaw( level.uavdrone.angles[2], 0.05 );
}

uav_drone_go() 
{
   
	if(level.inPrematchPeriod) return;
	
	level.uavmodel hide();
	
	wait 0.05;
	
	level.uavmodel show(); 
	
	self iprintlnbold("You have " + level.ex_radarViewTime + " Seconds");
	iprintln("^3UAV INBOUND ^1TAKE COVER!");
	
	self thread maps\mp\gametypes\_hardpoints::hardpointItemWaiter(); 

	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(players[i] != self)
		players[i] thread maps\mp\gametypes\_hud_message::oldnotifyMessage( self.name + " ^2 HAS CALLED A\n UAV DRONE!!");
	} 
	  
	if(!isDefined(self.ex_UAVtimer)) 
	{
		self.ex_UAVtimer = newClientHudElem(self);
		self.ex_UAVtimer.x = -190;   
		self.ex_UAVtimer.y = -5; 
		self.ex_UAVtimer.alignx = "right"; 
		self.ex_UAVtimer.aligny = "bottom";
		self.ex_UAVtimer.horzAlign = "right"; 
		self.ex_UAVtimer.vertAlign = "bottom";
		self.ex_UAVtimer.alpha = .9; 
		self.ex_UAVtimer.fontScale = 2; 
		self.ex_UAVtimer.sort = 100; 
		self.ex_UAVtimer.foreground = true; 
		self.ex_UAVtimer setClock( level.ex_radarViewTime, 60, "hudStopwatch", 60, 60);
	}
	  	
	wait level.ex_radarViewTime;  
	if(isDefined(self.ex_UAVtimer)) self.ex_UAVtimer destroy();  
		
	level.uavmodel notify("uavplayer_detached");
	level.uavmodel hide();
}