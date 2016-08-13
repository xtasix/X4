init()
{
	// HOW TO USE THIS FILE:
	// 1. Copy the template for each CUSTOM map you want to add.
	// 2. Uncomment the lines.
	// 3. For the "longname" and "loclname" fields, replace the text between quotes
	//	with the map name and long name of the CUSTOM map.
	// 4. The "gametype" field is used for map vote mode 4 and 5 (see mapcontrol.cfg)
	//	For this field, remove all game types the map doesn't support or you
	//	don't want to vote for (if you want "lib", you must add it yourself).

	// IMPORTANT:
	// - DO NOT ADD STOCK MAPS. They are already in here.
	//   If you don't want stock maps, see mapcontrol.cfg -- ex_mapvote_ignore_stock.
	// - ONLY REPLACE TEXT BETWEEN QUOTES. Otherwise you corrupt the structure.
	// - DO NOT REMOVE THE &-SIGN. This needs to be there.
	// - DO NOT ADD COLOR CODES TO THE GAMETYPES. It will mess up the system.
	// - KEEP THIS FILE UNDER 750 LINES (including comments)!
	//   IMPORTANT: Please Add 1 Map at a Time (including stock maps), the total number of maps is limited!!!!!!!!!

	// Add stock maps
	if(!level.ex_mapvote_ignore_stock)
	{
		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_backlot";
		level.ex_maps[level.ex_maps.size-1].longname = "Backlot";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Backlot";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_bloc";
		level.ex_maps[level.ex_maps.size-1].longname = "Bloc";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Bloc";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_bog";
		level.ex_maps[level.ex_maps.size-1].longname = "Bog";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Bog";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";
		
		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_carentan";
		level.ex_maps[level.ex_maps.size-1].longname = "Carentan";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Carentan";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_cargoship";
		level.ex_maps[level.ex_maps.size-1].longname = "Wet Work";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Wet Work";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_convoy";
		level.ex_maps[level.ex_maps.size-1].longname = "Ambush";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Ambush";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_countdown";
		level.ex_maps[level.ex_maps.size-1].longname = "Countdown";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Countdown";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_crash";
		level.ex_maps[level.ex_maps.size-1].longname = "Crash";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Crash";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_crash_snow";
		level.ex_maps[level.ex_maps.size-1].longname = "Crash Snow";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Crash Snow";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";
		
		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_creek";
		level.ex_maps[level.ex_maps.size-1].longname = "Creek";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Creek";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_farm";
		level.ex_maps[level.ex_maps.size-1].longname = "Downpour";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Downpour";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";
		
		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_killhouse";
		level.ex_maps[level.ex_maps.size-1].longname = "Killhouse";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Killhouse";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_overgrown";
		level.ex_maps[level.ex_maps.size-1].longname = "Overgrown";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Overgrown";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_pipeline";
		level.ex_maps[level.ex_maps.size-1].longname = "Pipeline";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Pipeline";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_shipment";
		level.ex_maps[level.ex_maps.size-1].longname = "Shipment";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Shipment";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_showdown";
		level.ex_maps[level.ex_maps.size-1].longname = "Showdown";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Showdown";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_strike";
		level.ex_maps[level.ex_maps.size-1].longname = "Strike";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Strike";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

		level.ex_maps[level.ex_maps.size] = spawnstruct();
		level.ex_maps[level.ex_maps.size-1].mapname = "mp_vacant";
		level.ex_maps[level.ex_maps.size-1].longname = "Vacant";
		level.ex_maps[level.ex_maps.size-1].loclname = &"Vacant";
		level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";
		
	}
	// DON'T CHANGE ANYTHING ABOVE THIS LINE
	// (unless you want to restrict game types for stock maps in map vote mode 4 or 5)

	// Add custom maps
	// TEMPLATE:
	//level.ex_maps[level.ex_maps.size] = spawnstruct();
	//level.ex_maps[level.ex_maps.size-1].mapname = "mapname";
	//level.ex_maps[level.ex_maps.size-1].longname = "longname";
	//level.ex_maps[level.ex_maps.size-1].loclname = &"longname";
	//level.ex_maps[level.ex_maps.size-1].gametype = "dm dom koth sab sd war ctf ctfb htf";

	// DON'T CHANGE ANYTHING BELOW THIS LINE
}
