extends Node

var game: Game;

var meat_bank: int = 0;
var meat: int = 0;

signal on_upgrade_done(upgrade: UpgradeResource, level: int)

var rounds_played = 0;
var first_start = true;
#region friendlies
var initial_friendlies: int = 1;
#endregion

#region Weapon
var weapon_pierce = 1;
var weapon_max_speed = 5.0;
#endregion

var upgrade_levels = {
	"pierce": 0,
	"speed": 0,
	"damage": 0,
	"initial_friends": 0,
	"pickup_radius": 0,
	"attack_speed": 0,
	"insurance": 0,
	"life": 0,
}

func get_upgrade_level(id: String):
	if !upgrade_levels.has(id): return 0
	return upgrade_levels.get(id)
	pass

func request_upgrade(up: UpgradeResource):
	var curLevel = upgrade_levels.get(up.id)
	if curLevel == null: return false;
	if curLevel >= up.costs.size():
		return false;
	var cost = up.costs[curLevel]
	if meat_bank >= cost:
		meat_bank -= cost;
		upgrade_levels.set(up.id, curLevel + 1)
		on_upgrade_done.emit(up, curLevel + 1)
	pass

func reset():
	meat = 0;
