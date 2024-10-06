extends Node

var enemies: Array[Enemy] = [];
var friendlies: Array[Friendly] = [];

@onready var sp: Path2D = $SpawnPath

var wave: int = 0;
var max_waves = 30;

@onready var world: Node2D = $"../World/Things"

const BIG_EVIL = preload("res://creatures/evil/big_evil.tscn")
const LIL_EVIL = preload("res://creatures/evil/lil_evil.tscn")

func _ready() -> void:
	pass

func reset():
	wave = 0;
	
func _physics_process(_delta: float) -> void:
	
	pass

func spawn_wave():
	var l = sp.curve.get_baked_length()
	for i in range(5):
		var type = LIL_EVIL;
		if randf() > 0.5: type = BIG_EVIL; 
		var p = sp.curve.sample_baked(randf() * l)
		var b = type.instantiate()
		b.position = p;
		world.add_child(b)
		pass
	pass
