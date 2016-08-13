init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines_mw";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor_mw";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass_mw";
	game["menu_changemodel_allies_desert"] = "changemodel_allies_desert"; //PeZBOT
	game["menu_changemodel_allies_woodland"] = "changemodel_allies_woodland"; //PeZBOT
	game["menu_changemodel_allies_urban"] = "changemodel_allies_urban"; //PeZBOT
	game["menu_changemodel_axis_desert"] = "changemodel_axis_desert"; //PeZBOT
	game["menu_changemodel_axis_urban"] = "changemodel_axis_urban"; //PeZBOT
	game["menu_changeclass_offline"] = "changeclass_offline";

	game["menu_callvote"] = "callvote";
	game["menu_muteplayer"] = "muteplayer";
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_muteplayer"]);
	
	// game summary popups
	game["menu_eog_main"] = "endofgame";
	game["menu_eog_unlock"] = "popup_unlock";
	game["menu_eog_summary"] = "popup_summary";
	game["menu_eog_unlock_page1"] = "popup_unlock_page1";
	game["menu_eog_unlock_page2"] = "popup_unlock_page2";
	
	precacheMenu(game["menu_eog_unlock"]);
	precacheMenu(game["menu_eog_summary"]);
	precacheMenu(game["menu_eog_unlock_page1"]);
	precacheMenu(game["menu_eog_unlock_page2"]);

	// client commands menu
	game["menu_clientcmd"] = "clientcmd";
	precacheMenu(game["menu_clientcmd"]);

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
	precacheMenu(game["menu_changemodel_allies_desert"]); //PeZBOT
	precacheMenu(game["menu_changemodel_allies_woodland"]); //PeZBOT
	precacheMenu(game["menu_changemodel_allies_urban"]); //PeZBOT
	precacheMenu(game["menu_changemodel_axis_desert"]); //PeZBOT
	precacheMenu(game["menu_changemodel_axis_urban"]); //PeZBOT
	precacheMenu(game["menu_changeclass_offline"]);

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		player.classType = undefined;
		player.selectedClass = false;
		player.classiscustom = false;

		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);

		//logprint( self getEntityNumber() + " menuresponse: " + menu + " " + response + "\n");

		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();
			if ( menu == "changeclass" && self.pers["team"] == "allies" )
			{
				self openMenu( game["menu_changeclass_allies"] );
			}
			else if ( menu == "changeclass" && self.pers["team"] == "axis" )
			{
				self openMenu( game["menu_changeclass_axis"] );			
			}
			else
			{
				self notify("stopmotd");
			}
			continue;
		}
		
		if( getSubStr( response, 0, 7 ) == "loadout" )
		{
			if(!isSubstr( response, "custom" ))
				self maps\mp\gametypes\_modwarfare::processLoadoutResponse( response );
			continue;
		}

		if( response == "startmotd")
		{
			self notify("startmotd");
		}

		if( response == "callvote" )
		{
			if(level.ex_clanvoting)
			{
				if(isDefined(self.ex_clan))
				{
					if(level.ex_clanvote[self.ex_clanid])
					{
						self closeMenu();
						self closeInGameMenu();
						self openMenu(game["menu_callvote"]);
						continue;
					}
				}
			}
			else
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu(game["menu_callvote"]);
				continue;
			}
		}

		if( response == "changeteam" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
		
		if(response == "changemodel_allies")
		{
		
			if(getdvar("scr_modeltype") == "desert")
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_changemodel_allies_desert"] );
			}
			
			if(getdvar("scr_modeltype") == "woodland")
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_changemodel_allies_woodland"] );
			}
			
			if(getdvar("scr_modeltype") == "urban")
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_changemodel_allies_urban"] );
			}
		}
		
		if(response == "changemodel_axis")
		{
			if(getdvar("scr_modeltype") == "desert")
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_changemodel_axis_desert"] );
			}
			
			else
			{
				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_changemodel_axis_urban"] );
			}
		}
	
		if( response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if( response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}
		
		if(response == "changemodel_assault")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("assault");
		}
		
		if(response == "changemodel_specops")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("specops");
		}
		
		if(response == "changemodel_support")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("support");
		}
		
		if(response == "changemodel_demolitions")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("demolitions");
		}
		
		if(response == "changemodel_sniper")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("sniper");
		}
		
		if(response == "changemodel_default")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("default");
		}
		
		if(response == "changemodel_velinda")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("velinda");
		}
		
		if(response == "changemodel_price")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("price"); 
		}
		
		if(response == "changemodel_farmer")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("farmer"); 
		}
		
		if(response == "changemodel_zakhaev")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("zakhaev"); 
		}
		
		if(response == "changemodel_alasad")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("alasad"); 
		}
		
		if(response == "changemodel_ghillie")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("ghillie"); 
		}
		
		if(response == "changemodel_urbansniper")
		{
			self closeMenu();
			self closeInGameMenu();
			self thread maps\mp\gametypes\_changemodel::toggleModel("urbansniper"); 
		}
				
		if( response == "endgame" )
		{
			continue;
		}

		if( menu == game["menu_team"] )
		{
			switch(response)
			{
			case "allies":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.allies]]();
				break;

			case "axis":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.axis]]();
				break;

			case "autoassign":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.autoassign]]();
				break;

			case "spectator":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else 
		if( menu == game["menu_changeclass_allies"] || menu == game["menu_changeclass_axis"] )
		{
			if(!isSubstr( response, "custom" ))
				self maps\mp\gametypes\_modwarfare::setClassChoice( response );
			self closeMenu();
			self closeInGameMenu();
			if(!isSubstr( response, "custom" ))
				self openMenu( game["menu_changeclass"] );
			else
			{
				self.classiscustom = true;
				self maps\mp\gametypes\_globallogic::menuClass(response);
			}
			continue;
		}
		else 
		if( menu == game["menu_changeclass"] )
		{
			self closeMenu();
			self closeInGameMenu();

			self.selectedClass = true;
			if(isSubstr( response, "custom" ))
			{
				self.classiscustom = true;
				self maps\mp\gametypes\_globallogic::menuClass(response);
			}
			else
			{
				self.classiscustom = false;
				self maps\mp\gametypes\_modwarfare::menuAcceptClass();
			}
		}
		else if ( !level.console )
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
			
		}
	}
}
