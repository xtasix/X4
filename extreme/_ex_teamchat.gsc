//******************************************************************************
// Team Chat Monitor functions for Extreme
//******************************************************************************

Start_ChatName()
{
	self endon("disconnect");
	self endon ("death");

	while(isPlayer(self) && isAlive(self) && self.sessionstate == "playing")
	{
		wait .05;
		if(self isTalking()) // Team chat button pressed....
		{
			self addplayertalking();
			if(!isDefined(self.teamchathud))
			{
				self.teamchathud = NewTeamHudElem(self.team);
				self.teamchathud.sort = -1;
				self.teamchathud.x = level.ex_displaychat_posx;
				self.teamchathud.y = level.ex_displaychat_posy;
				self.teamchathud.horzAlign = "fullscreen";
				self.teamchathud.vertAlign = "fullscreen";
				self.teamchathud.AlignX = "left";
				self.teamchathud.AlignY = "top";
				self.teamchathud.font = "default";
				self.teamchathud.alpha = 0.6;
				self.teamchathud.fontScale = 1.4;
			}
			self.teamchathud settext(self gettalkingstring());
		} 
		else 
		{
			self delplayertalking();
			if(isDefined(self.teamchathud)) self.teamchathud settext(self gettalkingstring());
		}
	}
}

isplayertalking( )
{
	//logprint("isplayertalking team = " + self.team + "\n");

	switch (self.team)
	{
		case "axis":
			for(i = 0;i < level.axistalking.size;i++)
			{
				if(level.axistalking[i] == self.name)
					return true;
			}
			break;
		default:
			for(i = 0;i < level.alliestalking.size;i++)
			{
				if(level.alliestalking[i] == self.name)
					return true;
			}
			break;
	}
	return false;
}

addplayertalking( )
{
	if(!self isplayertalking())
	{
		//logprint("addplayertalking team = " + self.team + "\n");
		
		// add player to talking list
		switch (self.team)
		{
			case "axis":
				sizeofarray = level.axistalking.size;
				level.axistalking[sizeofarray] = self.name;
				break;
			default:
				sizeofarray = level.alliestalking.size;
				level.alliestalking[sizeofarray] = self.name;
				break;
		}
	}
}

delplayertalking( )
{
	arrayshrink = false;
	
	//logprint("delplayertalking team = " + self.team + "\n");

	switch (self.team)
	{
		case "axis":
			for(i = 0;i < level.axistalking.size ; i++)
			{
				if(level.axistalking[i] == self.name)
					arrayshrink = true;
				if(arrayshrink)
				{
					level.axistalking[i] = level.axistalking[i+1];
				}
			}
			break;
		default:
			for(i = 0;i < level.alliestalking.size;i++)
			{
				if(level.alliestalking[i] == self.name)
					arrayshrink = true;
				if(arrayshrink)
				{
					level.alliestalking[i] = level.alliestalking[i+1];
				}
			}
			break;
	}
}

gettalkingstring()
{
	displaynames = "";
	//logprint("gettalkingstring team = " + self.team + "\n");
	switch (self.team)
	{
		case "axis":
			for(i = 0;i < level.axistalking.size;i++)
			{
				if(level.axistalking[i] != "")
				{
					displaynames = displaynames + "^" + level.ex_TeamChat_AxisColor + level.axistalking[i] + level.ex_TeamChat_Msg + "\n";
				}
			}
			break;
		default:
			for(i = 0;i < level.alliestalking.size;i++)
			{
				if(level.alliestalking[i] != "")
				{
					displaynames = displaynames + "^" + level.ex_TeamChat_AlliesColor + level.alliestalking[i] + level.ex_TeamChat_Msg + "\n";
				}
			}
			break;
	}
	return displaynames;
}
