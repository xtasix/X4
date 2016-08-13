#include extreme\_ex_weapons;

start()
{
	self endon("disconnect");
	self endon("ex_dead");
	self endon("joined_spectators");

	// make sure it initializes the zoom
	iZoomLevel = 0;
	sOldCurrentWeapon = "unknown";

	while(isAlive(self))
	{
		wait .05;

		sCurrentWeapon = self getCurrentWeapon();

		// reset zoom level if switching weapons
		if(level.ex_zoom_switchreset && sCurrentWeapon != sOldCurrentWeapon)
		{
			iZoomLevel = 0;
			sOldCurrentWeapon = sCurrentWeapon;
		}

		// reset zoom level if not ADS
		if(level.ex_zoom_adsreset && !self playerADS())
			iZoomLevel = 0;

		if(isWeaponType(sCurrentWeapon, "sniper") && self playerADS())
		{
			if(!iZoomLevel)
			{
			  iZoomLevel = level.ex_zoom_default;
				setZoomLevel(iZoomLevel, false);
			}

			if(!isDefined(self.ex_zoomhud))
			{
				self.ex_zoomhud = newClientHudElem(self);
				self.ex_zoomhud.x = 320;
				self.ex_zoomhud.y = 450;
				self.ex_zoomhud.alignx = "center";
				self.ex_zoomhud.aligny = "middle";
				self.ex_zoomhud.horzAlign = "fullscreen";
				self.ex_zoomhud.vertAlign = "fullscreen";
				self.ex_zoomhud.alpha = .9;
				self.ex_zoomhud.fontScale = 2;
				self.ex_zoomhud.label = &"EXTREME_ZOOMLEVEL";
				self.ex_zoomhud setvalue(iZoomLevel);
			}

			if(self useButtonPressed() && iZoomLevel > level.ex_zoom_min)
			{
				iZoomLevel--;
				if(level.ex_zoom_gradual) self playlocalsound("zoomauto");
					else self playlocalsound("zoommanual");
				thread setZoomLevel(iZoomLevel, level.ex_zoom_gradual);
				wait .2;
			}
			else
			if(self meleeButtonPressed() && iZoomLevel < level.ex_zoom_max)
			{
				iZoomLevel++;
				if(level.ex_zoom_gradual) self playlocalsound("zoomauto");
					else self playlocalsound("zoommanual");
				thread setZoomLevel(iZoomLevel, level.ex_zoom_gradual);
				wait .2;
			}
		}
		else if(isDefined(self.ex_zoomhud)) self.ex_zoomhud destroy();
	}
}

setZoomLevel(zoomlevel, gradual)
{
	self endon("disconnect");
	self endon("ex_dead");
	self endon("joined_spectators");

	self notify("stop_zooming");
	waittillframeend;
	self endon("stop_zooming");

	self.ex_zoomtarget = (81 - (zoomlevel * 8));

	if(gradual && isDefined(self.ex_zoom))
	{
		if(self.ex_zoomtarget > self.ex_zoom)
		{
			for(i = self.ex_zoom + 1; i <= self.ex_zoomtarget; i++) setZoom(zoomlevel, i);
		}
		else
		if(self.ex_zoomtarget < self.ex_zoom)
		{
			for(i = self.ex_zoom - 1; i >= self.ex_zoomtarget; i--) setZoom(zoomlevel, i);
		}
	}
	else setZoom(zoomlevel, self.ex_zoomtarget);
}

setZoom(zoomlevel, zoomvalue)
{
	self endon("disconnect");
	self endon("ex_dead");

	self.ex_zoom = zoomvalue;
	self setclientDvar("cg_fovmin", self.ex_zoom);

	if(isDefined(self.ex_zoomhud))
		self.ex_zoomhud setvalue(zoomlevel);

	wait .05;
}
