extends Node
class_name LifeComponent

@export_range(1, 100) var max_health: int = 10;
@export_range(0.0, 10.0) var invulnerability_time = 0.5;

var _invuln_time = 0.0;

var is_invulnerable: bool:
	get: return _invuln_time > 0;

@onready var health: int = max_health;
var dead: bool = false;

signal on_died();
signal on_hurt(damage: int);

func _physics_process(delta: float) -> void:
	if _invuln_time > 0:
		_invuln_time -= delta;

func die():
	if dead: return
	dead = true
	on_died.emit()

# Returns true when hurt hits
func hurt(amount: int = 1) -> bool:
	if _invuln_time > 0: return false;
	
	_invuln_time = invulnerability_time;
	
	health -= amount;
	if health > 0:
		on_hurt.emit(amount)
	else:
		die()
	return true;
	
