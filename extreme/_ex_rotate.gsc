
init()
{
	while(game["ex_emptytime"] < level.ex_rotateifempty)
	{
		wait(60 * level.fps_multiplier);
		num = 0;
		players = level.players;

		// Count clients that are playing
		for(i = 0; i < players.size; i++)
		if(isDefined(players[i]) && isPlayer(players[i]) && players[i].sessionstate == "playing")
			num++; 

		// Need at least 1 playing clients			
		if(num >= 1)
			game["ex_emptytime"] = 0;
		else
			game["ex_emptytime"]++;
	}

	exitLevel(false);
}
