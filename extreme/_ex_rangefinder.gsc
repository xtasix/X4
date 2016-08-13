start()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("ex_dead");
	self endon("joined_spectators");

	trace = [];
	endOrigin = [];
	startOrigin = [];
	ground = [];

	while(isAlive(self))
	{
		wait .2;
		startOrigin = self getEye();
		forward = anglesToForward( self getPlayerAngles() );
		forward = vectorscale( forward, 100000);
		if(isdefined(startOrigin) && isdefined(forward))
			endOrigin = startOrigin + forward;

		if(isDefined(startOrigin) && isDefined(endorigin))
		{
			startOrigin = startOrigin + (0,0,20);
			weap = self getCurrentWeapon();
			hasScope = maps\mp\gametypes\_weapons::hasScope( weap );

			if(self playerADS() && (hasScope || !level.ex_rangefinder_scopesonly))
			{
				trace = bulletTrace( startOrigin, endOrigin, true, self );

				if(!isDefined(self.ex_rangehud))
				{
					self.ex_rangehud = newClientHudElem(self);
					self.ex_rangehud.x = 320;
					self.ex_rangehud.y = 45;
					self.ex_rangehud.alignx = "center";
					self.ex_rangehud.aligny = "middle";
					self.ex_rangehud.alpha =0.8;
					self.ex_rangehud.fontScale = 1.4;
				}

				if(level.ex_rangefinder_units == 1)
				{
					self.ex_rangehud.label = &"MISC_RANGE_YARDS";
					range = int(distance(startOrigin, trace["position"]) * 0.02778); // range in yards
				}
				else
				{
					self.ex_rangehud.label = &"MISC_RANGE_METERS";
					range = int(distance(startOrigin, trace["position"]) * 0.0254); // range in meters
				}
				self.ex_rangehud setvalue(range);
			}
			else if(isDefined(self.ex_rangehud)) self.ex_rangehud destroy();
		}
	}
}

vectorScale(vector, scale)
{
	vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
	return vector; 
}
