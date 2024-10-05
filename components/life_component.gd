extends Node
class_name LifeComponent

@export_range(1, 100) var max_health: int = 10;

@onready var health: int = max_health;
var dead: bool = false;

signal on_died();
signal on_hurt(damage: int);

func die():
	if dead: return
	dead = true
	on_died.emit()

func hurt(amount:int = 1):
	health -= amount;
	if health > 0:
		on_hurt.emit(amount)
	else:
		die()
	
