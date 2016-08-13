isLinuxServer()
{
	version = getDvar ("version");
	endstr = "";
	for(i = 0; i < 7; i ++)
		endstr += version[i + version.size - 7];
	ex_linux = (endstr != "win-x86");
	return(ex_linux);
}

// The FIXED procedures below now depend on level.ex_linux init in varcache
// level.ex_linux = extreme\_ex_linux::isLinuxServer();

iprintlnFIXED(locstring, player, target)
{
	if(level.ex_linux)
	{
		if(isDefined(target))
			target iprintln(locstring, player.name);
		else
			iprintln(locstring, player.name);
	}
	else
	{
		if(isDefined(target))
			target iprintln(locstring, player);
		else
			iprintln(locstring, player);
	}
}

iprintlnboldFIXED(locstring, player, target)
{
	if(level.ex_linux)
	{
		if(isDefined(target))
			target iprintlnbold(locstring, player.name);
		else
			iprintlnbold(locstring, player.name);
	}
	else
	{
		if(isDefined(target))
			target iprintlnbold(locstring, player);
		else
			iprintlnbold(locstring, player);
	}
}
