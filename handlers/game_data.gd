extends Node

var game: Game;

var meat_bank: int = 0;
var meat: int = 0;

#region friendlies
var initial_friendlies: int = 1;

#endregion

#region Weapon
var weapon_pierce = 1;

#endregion


func reset():
	meat = 0;
