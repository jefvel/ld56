extends Node

var enemies: Array[Enemy] = [];
var friendlies: Array[Friendly] = [];

var wave: int = 0;
var max_waves = 30;

@onready var world: Node2D = $"../World"

func reset():
	wave = 0;
	
func _physics_process(delta: float) -> void:
	
	pass

func spawn_wave():
	pass
