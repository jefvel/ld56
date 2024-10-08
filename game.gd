extends Node2D
class_name Game

signal on_friendly_die(friend: Friendly);
signal on_enemy_die(enemy: Enemy);

signal on_friendly_spawn(friend: Friendly);
signal on_enemy_spawn(enemy: Enemy);

var game_over: bool = false;

signal on_friendlies_dead();
signal on_sword_exploded;
signal on_wave_cleared;

@onready var things: Node2D = $World/Things
@onready var wave_spawner: Node = $WaveSpawner

@onready var friendly_spawner: Node = $FriendlySpawner

@onready var sword: Sword = $Sword

var friendlies: Array[Friendly] = [];
var enemies: Array[Enemy] = []

var first_start = false;

func _ready() -> void:
	TimeFreeze.node_to_freeze = self
	first_start = GameData.first_start;
	GameData.game = self;
	sword.active = false;
	sword.position.x = (512 >> 1) - 12;
	sword.position.y = (320 >> 1);
	if first_start:
		$UILayer/UI.visible = false;
		$FirstScreen.visible =true
		
		GameData.first_start = false;
		return;
	else:
		$FirstScreen.queue_free()
		pass
		
	
	
	start()
	
@onready var flash: Sprite2D = $Flash
func _on_sword_on_died() -> void:
	flash.visible = true;
	if game_over: return;
	
	do_game_over();

func out_of_friendlies():
	if game_over: return
	on_friendlies_dead.emit()
	do_game_over()
	
@onready var store: MeatStore = $UILayer/UI/Store

func open_store():
	GameData.meat_bank += GameData.meat
	GameData.meat = 0;
	
	store.show_store()
	pass

func do_game_over():
	
	muisic.stop()
	music_2.stop();
	game_over = true;
	GameData.rounds_played += 1;

	
	# sword.active = false;
	$UILayer/UI/MarginContainer/Win/Control.visible = false;
	pass
	
@onready var ambiance_sfx: AudioStreamPlayer = $ambiance_sfx
@onready var muisic: AudioStreamPlayer = $muisic
@onready var music_2: AudioStreamPlayer = $music2


var started = false;

func start():
	if started: return;
	$UILayer/UI.visible = true;
	sword.active = true;
	started = true;
	GameData.meat = 0;
	friendlies = []
	wave_spawner.init();
	friendly_spawner.init()
	ambiance_sfx.play(randf() * 5.0)
	muisic.play();
	music_2.play();
	music_2.volume_db = -80;
	pass

var faded = false
func fade2():
	if faded: return
	faded = true;
	music_2.volume_db = muisic.volume_db;
	music_2.play()
	muisic.stop();
	

func reset():
	get_tree().reload_current_scene()
	pass

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		GameData.reset()
		reset()
	if !started: 
		if Input.is_action_just_pressed("attack"):
			var tw = get_tree().create_tween().tween_property($FirstScreen, "modulate:a", 0.0, 0.3)
			
			start()
		return
	if !game_over:
		process_game(_delta);

func process_game(_delta: float):
	var objects = things.get_children();
	var new_enemies: Array[Enemy] = []
	var new_friendlies: Array[Friendly] = [];
	
	for o in objects:
		if o is Enemy:
			new_enemies.push_back(o)
		if o is Friendly and !o.life.dead:
			new_friendlies.push_back(o)
	
	friendlies = new_friendlies;
	enemies = new_enemies;
	
	if enemies.size() == 0:
		on_wave_clear()
	
	if new_friendlies.size() == 0:
		out_of_friendlies()

func on_wave_clear():
	if wave_spawner.done:
		return;
	for f in friendlies:
		if is_instance_valid(f):
			f.lvlup()
	if wave_spawner.wave >= 2: #wave_spawner.max_waves - 3:
		fade2();
		pass
	on_wave_cleared.emit()
	wave_spawner.spawn_wave();

	pass

func _on_store_on_closed() -> void:
	reset();
	pass # Replace with function body.


func _on_store_on_open() -> void:
	var tw = get_tree().create_tween().tween_property(ambiance_sfx, "volume_db", -80, 2.0)
	
	pass # Replace with function body.


func _on_sword_on_died_complete() -> void:
	on_sword_exploded.emit();
	if GameData.get_upgrade_level("insurance") > 0:
		for f in friendlies:
			f.life.hurt(100)
	pass # Replace with function body.


@onready var win_text: Label = $UILayer/UI/MarginContainer/Win/Control/WinText


func win_game():
	muisic.stop();
	music_2.stop();
	win_text.text += "\nYOU WON IN %s ROUNDS." % GameData.rounds_played;
	winanim.play("show")
@onready var winanim: AnimationPlayer = $UILayer/UI/MarginContainer/Win/winanim

func _on_wave_spawner_on_completed_all() -> void:
	win_game()
	pass # Replace with function body.
