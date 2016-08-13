#include extreme\_ex_weapons;

knife()
{
	allowthrow = true;
	for(;;)
	{
		wait 0.01;

		if( self meleebuttonpressed() ) //if we add this we need to make a new keybind were useing keys for to much stuff
		{
			// Block throwing until attack button released
			allowthrow = false;
			
			//self iprintlnbold("Knife Throw");
			
			// Now animate the throw
			knf = spawn("script_model", (0,0,0));
			knf.origin = self geteye(); 
			knf.angles = self.angles;
			knf setModel("weapon_parabolic_knife");
			knf thread knfspin();
			startOrigin = self getEye();
			forward = anglesToForward(self getplayerangles());
			forward = [[level.ex_vectorscale]]( forward, 500 );  // Effective range
			endOrigin = startOrigin + forward;
			knf moveto(endOrigin,.2,0,0);  // Speed the knife moves

			wait(.7);
			knf hide();
			knf delete();

			// Loop until the melee button is released
			while(isdefined(self) && self meleebuttonpressed()) wait(.01);
		}
	}
}

knfspin()
{
	while( isDefined( self ) )
	{
		self rotatepitch(360,.7,0,0); //( 180, 0.35 );
		wait 0.35;
	}
}