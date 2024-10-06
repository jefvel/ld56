extends Node

var enemies: Array[Enemy] = [];
var friendlies: Array[Friendly] = [];

signal on_wave_spawned;

@onready var sp: Path2D = $SpawnPath

var wave: int = 0;
var max_waves = 20;

var lil_spawns = 2;
var fast_spawns = 0;
var big_spawns = 0;

@onready var world: Node2D = $"../World/Things"

const BIG_EVIL = preload("res://creatures/evil/big_evil.tscn")
const LIL_EVIL = preload("res://creatures/evil/lil_evil.tscn")
const FAST_EVIL = preload("res://creatures/evil/fast_evil.tscn")


func _ready() -> void:
	pass

func reset():
	wave = 0;

func init():
	reset();
	spawn_wave();

func _physics_process(_delta: float) -> void:
	pass

@onready var l = sp.curve.get_baked_length()
func get_rand_p():
	return sp.curve.sample_baked(randf() * l)

func spawn_enemy(e: PackedScene, pos: Vector2):
	var b = e.instantiate()
	b.position = pos;
	world.add_child(b)

func spawn_wave():
	wave += 1;
	
	for i in range(lil_spawns):
		spawn_enemy(LIL_EVIL, get_rand_p())
	for i in range(big_spawns):
		spawn_enemy(BIG_EVIL, get_rand_p())
	for i in range(fast_spawns):
		spawn_enemy(FAST_EVIL, get_rand_p())

	print("running wave ", wave)
	
	if wave < 5:
		lil_spawns += 2;
	else:
		lil_spawns += 1;
	if wave == 5 or (wave > 5 and wave % 2 == 0):
		big_spawns += 1;
		
	if wave >= 8 && wave % 4 == 0:
		fast_spawns += 2;
		
	on_wave_spawned.emit();
