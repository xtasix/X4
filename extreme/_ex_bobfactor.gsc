
start()
{
	level endon("ex_gameover");
	self endon("disconnect");
	self endon("ex_dead");

	wait 0.5;
	if(isPlayer(self)) self setClientDvar("bg_bobMax", "2"); // Default 8
	wait 0.5;
	if(isPlayer(self)) self setClientDvar("bg_bobamplitudesprinting", ".020 .0110"); // Default .043 .0215
	wait 0.5;
	if(isPlayer(self)) self setClientDvar("bg_bobamplitudestanding", ".01 .0114"); // Default .04 .017
	wait 0.5;
	if(isPlayer(self)) self setClientDvar("bg_bobamplitudeducked", ".01 .01"); // Default .03 .02
	wait 0.5;
	if(isPlayer(self)) self setClientDvar("bg_bobamplitudeprone", ".04 .01"); // Default .06 .04
	wait 2.5;
}
