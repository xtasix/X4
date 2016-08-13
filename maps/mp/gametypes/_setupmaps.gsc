/**/
init()
{
	if(getDvar("mapname") == "mp_subway") 		thread subway();
	if(getDvar("mapname") == "mp_village") 	thread village();
	if(getDvar("mapname") == "mp_offices_v2") 	thread offices();
	if(getDvar("mapname") == "mp_pk_harbor") 	thread harbor();
	if(getDvar("mapname") == "mp_offices_v3") 	thread offices3();
	if(getDvar("mapname") == "mp_qmx_matmata") thread matmata();
}

subway()
{
	if(getDvar("g_gametype") != "htf")
	{
		addobj("allied_flag", (-913, -234, 0), (0, 0, 0));
		addobj("axis_flag", (3402, -1512, 64), (0, 0, 0));
	}
}

village()
{
	if(getDvar("g_gametype") != "htf")
	{
		addobj("allied_flag", (-682, -1754, 369), (0, 0, 0));
		addobj("axis_flag", (-6640, -3048, 503), (0, 0, 0));
	}
}

offices()
{
	if(getDvar("g_gametype") != "htf")
	{
		addobj("allied_flag", (821, -112, -160), (0, 0, 0));
		addobj("axis_flag", (52, 57, 328), (0, 0, 0));
	}
}

offices3()
{
	if(getDvar("g_gametype") != "htf")
	{
		addobj("allied_flag", (873, -528, -160), (0, 0, 0));
		addobj("axis_flag", (52, 57, 328), (0, 0, 0));
	}
}

harbor()
{
	if(getDvar("g_gametype") != "htf")
	{
		addobj("allied_flag", (1319, -2205, 328), (0, 0, 0));
		addobj("axis_flag", (-2979, -1952, 328), (0, 0, 0));
	}
	
	////////////////////// Start Spawns ////////////////////////////////////
	
	//---Allies---
	addnewspawn("mp_ctf_spawn_allies_start",(2291, -1960, 328),(0,155,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1996, -1608, 328),(0,193,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1628, -1924, 328),(0,168,0));
	addnewspawn("mp_ctf_spawn_allies_start",(776, -2158, 328),(0,34,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1531, -2558, 328),(0,149,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1508, -2885, 328),(0,129,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1162, -2801, 328),(0,4,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1547, -3449, 328),(0,155,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1067, -3205, 328),(0,176,0));
	addnewspawn("mp_ctf_spawn_allies_start",(1301, -2812, 328),(0,51,0));
	
	//---Axis---
	addnewspawn("mp_ctf_spawn_axis_start",(-3124, -3141, 328),(0,14,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-3639, -2806, 328),(0,17,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-3649, -2429, 328),(0,352,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-3546, -1557, 328),(0,302,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-3557, -2029, 328),(0,325,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-3230, -1661, 328),(0,323,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-2591, -1547, 392),(0,233,0));	
	addnewspawn("mp_ctf_spawn_axis_start",(-2901, -1552, 328),(0,295,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-2919, -2185, 328),(0,15,0));
	addnewspawn("mp_ctf_spawn_axis_start",(-3212, -1640, 328),(0,298,0));
	
	//////////////////// Standard Spawns ///////////////////////////////////
	
	//Group 1 --- Allies
	addnewspawn("mp_ctf_spawn_allies",(-549, -1046, 328),(0,184,0));
	addnewspawn("mp_ctf_spawn_allies",(-905, -344, 328),(0,265,0));
	addnewspawn("mp_ctf_spawn_allies",(-587, -3202, 521),(0,91,0));
	addnewspawn("mp_ctf_spawn_allies",(-661, -2630, 328),(0,62,0));
	addnewspawn("mp_ctf_spawn_allies",(-755, -2350, 328),(0,352,0));
	addnewspawn("mp_ctf_spawn_allies",(-587, -2871, 328),(0,85,0));
	addnewspawn("mp_ctf_spawn_allies",(6, -2897, 328),(0,346,0));
	addnewspawn("mp_ctf_spawn_allies",(-614, -1927, 328),(0,176,0));
	addnewspawn("mp_ctf_spawn_allies",(-637, -2063, 328),(0,176,0));

	//Group 1 --- Axis
	addnewspawn("mp_ctf_spawn_axis",(-1474, -2865, 336),(0,167,0));
	addnewspawn("mp_ctf_spawn_axis",(-1826, -2691, 504),(0,286,0));
	addnewspawn("mp_ctf_spawn_axis",(-1860, -3175, 552),(0,353,0));
	addnewspawn("mp_ctf_spawn_axis",(-1567, -2428, 552),(0,290,0));
	addnewspawn("mp_ctf_spawn_axis",(-1456, -2708, 552),(0,119,0));
	addnewspawn("mp_ctf_spawn_axis",(-1757, -2615, 336),(0,253,0));
	addnewspawn("mp_ctf_spawn_axis",(-1750, -2958, 416),(0,83,0));
	addnewspawn("mp_ctf_spawn_axis",(-1545, -2431, 336),(0,266,0));
	addnewspawn("mp_ctf_spawn_axis",(-1636, -3135, 336),(0,22,0));
	
	//Group 2 --- Allies
	addnewspawn("mp_ctf_spawn_allies",(-515, -818, 328),(0,221,0));
	addnewspawn("mp_ctf_spawn_allies",(-513, -1056, 328),(0,173,0));
	addnewspawn("mp_ctf_spawn_allies",(-907, -302, 328),(0,256,0));
	addnewspawn("mp_ctf_spawn_allies",(-1014, -1258, 328),(0,168,0));
	addnewspawn("mp_ctf_spawn_allies",(-1372, -292, 328),(0,276,0));
	addnewspawn("mp_ctf_spawn_allies",(-1201, -353, 328),(0,166,0));
	addnewspawn("mp_ctf_spawn_allies",(-1175, -786, 328),(0,340,0));
	addnewspawn("mp_ctf_spawn_allies",(-1408, -1523, 328),(0,16,0));
	addnewspawn("mp_ctf_spawn_allies",(-1053, -1512, 328),(0,176,0));
	
	//Group 2 --- Axis
	addnewspawn("mp_ctf_spawn_axis",(-1389, -2535, 328),(0,349,0));
	addnewspawn("mp_ctf_spawn_axis",(-1346, -2948, 328),(0,358,0));
	addnewspawn("mp_ctf_spawn_axis",(-1391, -3416, 328),(0,82,0));
	addnewspawn("mp_ctf_spawn_axis",(-804, -3396, 328),(0,78,0));
	addnewspawn("mp_ctf_spawn_axis",(-1118, -2607, 328),(0,132,0));
	addnewspawn("mp_ctf_spawn_axis",(-1364, -3399, 328),(0,87,0));
	addnewspawn("mp_ctf_spawn_axis",(-1112, -2123, 328),(0,174,0));
	addnewspawn("mp_ctf_spawn_axis",(-1114, -2726, 520),(0, 235,0));
	addnewspawn("mp_ctf_spawn_axis",(-1111, -2997, 520),(0,292,0));
}

matmata()
{

	if(getDvar("g_gametype") != "htf")
	{
		addobj("allied_flag", (-432, 955, -6), (0, 0, 0));
		addobj("axis_flag", (2520, 2656, -16), (0, 0, 0));
	}

	////////////////////// Start Spawns ////////////////////////////////////
	
	//---Allies---
	addnewspawn("mp_ctf_spawn_allies_start",(-329, 202, -7),(0,105,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-506, 178, -14),(0,81,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-515, 354, -11),(0,86,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-659, 522, -2),(0,356,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-656, 659, 0),(0,354,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-662, 840, 2),(0,352,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-667, 1007, 3),(0,360,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-674, 1196, 0),(0,357,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-280, 604, -5),(0, 96,0));
	addnewspawn("mp_ctf_spawn_allies_start",(-382, 588, -5),(0,72,0));
	
	//---Axis---
	addnewspawn("mp_ctf_spawn_axis_start",(2683, 2950, -13),(0,178,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2561, 3306, -9),(0,196,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2365, 3045, -16),(0,345,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2908, 3151, -14),(0,265,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2985, 2975, -10),(0,165,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2979, 2796, -2),(0,162,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2723, 2629, -4),(0,176,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2759, 2711, 0),(0,159,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2374, 2792, -24),(0,342,0));
	addnewspawn("mp_ctf_spawn_axis_start",(2582, 2441, -3),(0,156,0));

	//////////////////// Standard Spawns ///////////////////////////////////
	
	//Group 1 --- Allies
	addnewspawn("mp_ctf_spawn_allies",(-430, 2990, 6),(0,290,0));
	addnewspawn("mp_ctf_spawn_allies",(-391, 2421, 4),(0,16,0));
	addnewspawn("mp_ctf_spawn_allies",(-325, 2378, 3),(0,106,0));
	addnewspawn("mp_ctf_spawn_allies",(-386, 2593, 4),(0,14,0));
	addnewspawn("mp_ctf_spawn_allies",(172, 2738, 19),(0,99,0));
	addnewspawn("mp_ctf_spawn_allies",(-19, 2708, 12),(0,99,0));
	addnewspawn("mp_ctf_spawn_allies",(-357, 3068, 6),(0,278,0));
	addnewspawn("mp_ctf_spawn_allies",(-552, 2707, 5),(0,8,0));
	
	//Group 1 --- Axis
	addnewspawn("mp_ctf_spawn_axis",(2225, 1118, -31),(0,139,0));
	addnewspawn("mp_ctf_spawn_axis",(2984, 1634, -44),(0,173,0));
	addnewspawn("mp_ctf_spawn_axis",(2788, 1643, -50),(0,177,0));
	addnewspawn("mp_ctf_spawn_axis",(2626, 1653, -42),(0,176,0));
	addnewspawn("mp_ctf_spawn_axis",(3004, 1262, -50),(0,173,0));
	addnewspawn("mp_ctf_spawn_axis",(2863, 1065, -48),(0,86,0));
	addnewspawn("mp_ctf_spawn_axis",(2823, 1327, -64),(0,92,0));
	
	//Group 2 --- Allies
	addnewspawn("mp_ctf_spawn_allies",(1878, -234, 14),(0, 87,0));
	addnewspawn("mp_ctf_spawn_allies",(1884, -112, 16),(0, 87,0));
	addnewspawn("mp_ctf_spawn_allies",(1795, -66, 15),(0, 87,0));
	addnewspawn("mp_ctf_spawn_allies",(1719, -28, 17),(0, 89,0));
	addnewspawn("mp_ctf_spawn_allies",(1575, -83, 15),(0, 85,0));
	addnewspawn("mp_ctf_spawn_allies",(1597, -289, 8),(0, 87,0));
	addnewspawn("mp_ctf_spawn_allies",(1341, 291, 9),(0, 27,0));
	
	//Group 2 --- Axis
	addnewspawn("mp_ctf_spawn_axis",(1414, 3352, 11),(0,263,0));
	addnewspawn("mp_ctf_spawn_axis",(1484, 3377, 8),(0,263,0));
	addnewspawn("mp_ctf_spawn_axis",(1555, 3060, 7),(0,177,0));
	addnewspawn("mp_ctf_spawn_axis",(1367, 3050, 4),(0,182,0));
	addnewspawn("mp_ctf_spawn_axis",(1201, 3248, 2),(0,265,0));
	addnewspawn("mp_ctf_spawn_axis",(1032, 3280, 4),(0,269,0));
	addnewspawn("mp_ctf_spawn_axis",(813, 3304, -2),(0,264,0));

}

addobj(name, origin, angles)
{
   ent = spawn("trigger_radius", origin, 0, 48, 148);
   ent.targetname = name;
   ent.angles = angles;
}

addnewspawn(name, origin, angles)
{
	ent=spawn("script_model", origin);
	ent.targetname = name;
	ent.angles = angles;
	
}