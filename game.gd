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
@onready var wave_spawner: WaveSpawner = $WaveSpawner

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
	sword.position.x = (512 >> 1) - 10;
	sword.position.y = (320 >> 1) - 11;
	
	if first_start:
		$UILayer/UI.visible = false;
		$FirstScreen.visible = true
		$FirstScreen/intro_screen_anim.play("fade_in")
		#sword.modulate.a = 0.;
		#var tw = get_tree().create_tween().tween_property(sword, "modulate:a", 1.0, 0.8);
		
		GameData.first_start = false;
		return;
	else:
		sword.freeze_time = 0.1;
		$FirstScreen.queue_free()
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
	if game_over: return
	stop_music()
	game_over = true;
	GameData.rounds_played += 1;
	
	$UILayer/UI.hide_ingame_ui();
	pass
	
@onready var music: AudioStreamPlayer = $music
@onready var music_clips: AudioStreamPlaybackInteractive;
@onready var ambiance_sfx: AudioStreamPlayer = $ambiance_sfx
@onready var camera: Camera2D = $Camera

var started = false;

var _pressed_start = false;
func start_pressed():
	if _pressed_start or started: return
	_pressed_start = true;
	sword.attack(true)
	sword.attack_cooldown = 0.0;
	$FirstScreen/intro_screen_anim.play("fade_out");
	pass

func start():
	if started: return;
	
	if !is_instance_valid($FirstScreen):
		$UILayer/UI.visible = true;
		
	sword.active = true;
	started = true;
	GameData.meat = 0;
	friendlies = []
	wave_spawner.init();
	friendly_spawner.init()
	ambiance_sfx.play(randf() * 5.0)
	music.play()
	music_clips = music.get_stream_playback();

	pass



var faded = false
func fade2():
	if faded: return
	faded = true;
	music_clips.switch_to_clip_by_name("Music2")

var faded3 = false
func fade3():
	if faded3: return
	faded3 = true;
	music_clips.switch_to_clip_by_name("Music3")
		

func reset():
	get_tree().reload_current_scene()
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_1):
			music_clips.switch_to_clip(0);
		if Input.is_key_pressed(KEY_2):
			faded = false;
			fade2();
		if Input.is_key_pressed(KEY_3):
			faded3 = false;
			fade3();
func _physics_process(_delta: float) -> void:

	
	if Input.is_action_just_pressed("reset"):
		GameData.reset()
		reset()
	if !started: 
		if Input.is_action_just_pressed("attack"):
			start_pressed()
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
	print("Cleared wave ", wave_spawner.wave)
	for f in friendlies:
		if is_instance_valid(f):
			f.lvlup()
	if wave_spawner.wave >= 3: #wave_spawner.max_waves - 3:
		fade2();
		pass
	if wave_spawner.wave >= 6:
		fade3();
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
	#if GameData.get_upgrade_level("insurance") > 0:
	for f in friendlies:
		f.life.hurt(100)
	for i in things.get_children():
		if i is Pickup:
			i.force_pickup()
			
	pass # Replace with function body.


@onready var win_text: Label = $UILayer/UI/MarginContainer/Win/Control/WinText
@onready var winanim: AnimationPlayer = $UILayer/UI/MarginContainer/Win/winanim

func stop_music():
	music.stop();
	pass

func win_game():
	stop_music()
	win_text.text += "\nYOU WON IN %s ROUNDS." % GameData.rounds_played;
	winanim.play("show")

func _on_wave_spawner_on_completed_all() -> void:
	win_game()
	pass # Replace with function body.
