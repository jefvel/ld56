extends Node2D
class_name Sword

var vel: Vector2;
var dx: float = 0.0;
var ax: float = 0.0;

@export var game: Game;

@export var life: LifeComponent;
@export var hitbox: Hitbox;

@export var active: bool = true;
@onready var sprite: Sprite2D =  $Holder/Sprite

@onready var attack_animations: AnimationPlayer = $AttackAnimations

@onready var area: Area2D = $Holder/Sprite/SwordPoint
@onready var sword_progress_sprite: Node2D = $Holder/Sprite/Sprite2/SwordProgress

## 1.0 = completely moved by user input, 0 = only by higher powers
var control_power:float = 1.0;

var freeze_time = 0.4;

signal on_weapon_ready();

@export var attack_duration = 0.25;

var attack_time = 0.0;
var attacking: bool = false;

var cur_damage = 1;

var max_pierce = GameData.weapon_pierce;
var cur_pierce = 0;

var max_speed = GameData.weapon_max_speed;

var cooling_down = false;
var attack_cooldown: float = 0.0;
var attack_cooldown_duration = 1.5;

var attack_press_coyote_time = 0.0;
signal on_died_complete;
var dcomplete = false;

@onready var pick_up_rad: CollisionShape2D = $Holder/PickUpper/PickUpRad

var pierce_levels = [1,2,3,4,5,6,7,8]
var damage_levels = [1,2,3,4,5,6]
var max_speeds = [5.0, 8.0, 12.0, 20.0, 35.0];
var cooldown_speeds = [1.5, 1.2, 0.9, 0.7, 0.4];
var pu_rads = [5.0, 10.0, 15.0, 25.0]
var lives = [1, 2, 3, 4];

@onready var pick_upper: PickUpper = $Holder/PickUpper

func _ready():
	max_pierce = pierce_levels[GameData.get_upgrade_level("pierce")]
	cur_damage = damage_levels[GameData.get_upgrade_level("damage")]
	max_speed = max_speeds[GameData.get_upgrade_level("speed")]
	attack_cooldown_duration = cooldown_speeds[GameData.get_upgrade_level("attack_speed")]
	
	life.max_health = lives[GameData.get_upgrade_level("life")]
	life.health = life.max_health
	
	var rad = pu_rads[GameData.get_upgrade_level("pickup_radius")]
	pick_upper.pickup_radius = rad;
	print("set pierce: ", max_pierce, ", dmg: ", cur_damage, ", rad: ", rad)
	pass

func _physics_process(_delta: float) -> void:
	if TimeFreeze.frozen:
		attack_animations.speed_scale = 0;
		return
	else:
		attack_animations.speed_scale = 1.0;
		if life.dead and !dcomplete:
			$dead_sfx.play()
			modulate = Color.WHITE
			dcomplete = true;
			on_died_complete.emit();
			GameData.game.flash.visible = false;
	
	process_move(_delta);
		
	sprite.rotation = dx;
	var max_rotation = 0.5;
	sprite.rotation = clamp(sprite.rotation, -max_rotation, max_rotation)
	
	attack_press_coyote_time -= _delta;
	if life.health > 1:
		hpbip.frame = life.health - 2
	else:
		hpbip.visible = false;
	
	InputHandler.cursor_visible = !active or is_away_from_cursor

	process_cooldown(_delta)
	
	if !active: return
	
	if Input.is_action_just_pressed("attack"):
		attack()
	if attacking: process_attack(_delta)
	
	
@onready var auto_aim: AutoAim = $AutoAim

var using_mouse = false;
var is_away_from_cursor: bool;

func process_move(_delta: float):
	is_away_from_cursor = true;
	
	using_mouse = InputHandler.is_using_mouse()
	
	if !active: return
	
	if freeze_time > 0:
		freeze_time -= _delta;
		return;

	var vp = get_viewport()
	var unclamped_pos = vp.get_mouse_position()
	if !using_mouse:
		var mult = 1.0;
		if Input.is_action_pressed("precision_move"):
			mult = 0.2;
		unclamped_pos = position + mult * 10 * Input.get_vector("move_left","move_right","move_up","move_down")
	var p = 16;
	
	if attacking and is_instance_valid(auto_aim.closest_target):
		unclamped_pos += (auto_aim.closest_target.global_position -unclamped_pos) * 0.8;
		pass
	
	var pos = unclamped_pos.clamp(Vector2(p,p), Vector2(512 - p, 320 - p))
	var d = (pos - position);
	
	d = d.limit_length(max_speed)
	
	vel = d * 0.5;
	position += d * 0.5
	dx += d.x * 0.03;
	dx *= 0.4;
	is_away_from_cursor = unclamped_pos.distance_to(position) > 3
	
	auto_aim.position = (vel * 5.0).limit_length(30.0);
	pass

func process_cooldown(d:float):
	sword_progress_sprite.visible = !attacking
	sword_progress_sprite.scale.y = clamp(attack_cooldown / attack_cooldown_duration, 0.0, 1.0)
	if !cooling_down: return
	attack_cooldown -= d;
	if attack_cooldown <= 0:
		cooling_down = false;
		on_weapon_ready.emit();
	pass

func process_attack(_d: float):
	attack_time += _d
	if attack_time >= attack_duration:
		finish_attack()
		return
	if attacking:
		for b in area.get_overlapping_areas():
			if b is Hitbox:
				if b.friendly_immune:
					continue
				hit_target(b)
	pass

@onready var hpbip: Sprite2D = $Holder/hpbip

func attack(force = false):
	if !force and (attacking or cooling_down): 
		attack_press_coyote_time = 0.2;
		return
	
	life.make_invulnerable(0.4)
	
	hit_targets = [];
	attack_cooldown = attack_cooldown_duration;
	
	cur_pierce = 0;
	attacking = true;
	attack_time = 0.0;
	attack_animations.play("stab", 0, 1, false)

@onready var hit_sfx: AudioStreamPlayer = $hit_sfx
var hit_targets: Array[Hitbox] = [];
func hit_target(e: Hitbox):
	if !attacking: return
	if hit_targets.has(e): return;
	
	hit_targets.push_back(e)
	
	var res = e.hit(cur_damage, self)
	if res and res.critical_hit:
		crit_hit.play();
		TimeFreeze.freeze(7);
		game.camera.shake(2)
		pass
	else:
		game.camera.shake()
		TimeFreeze.freeze(4)
		
	cur_pierce += 1;

	
	
	var spark = SPARK.instantiate(); 
	get_parent().add_child(spark)
	spark.global_position = tip.global_position;
	if res.critical_hit:
		spark.do_crit()
	hit_sfx.play()
	
	if cur_pierce >= max_pierce:
		finish_attack();

@onready var crit_hit: AudioStreamPlayer = $crit_hit

const SPARK = preload("res://particles/spark.tscn")
@onready var tip: Node2D = $Holder/tip

func finish_attack():
	attacking = false;
	cooling_down = true;

func _on_on_weapon_ready() -> void:
	attack_animations.play("ready")
	if attack_press_coyote_time > 0.0:
		attack();
	pass # Replace with function body.


func _on_store_on_open() -> void:
	active = false;
	pass # Replace with function body.


func _on_store_on_close() -> void:
	# active = true;
	pass # Replace with function body.


func _on_life_component_on_hurt(damage: int) -> void:
	TimeFreeze.freeze(20)
	shield_sfx.play();

@onready var shield_sfx: AudioStreamPlayer = $shield_sfx
@onready var death_crack: Node2D = $DeathCrack

@onready var c1: Sprite2D = $DeathCrack/Sprite2D
@onready var c2: Sprite2D = $DeathCrack/Sprite2D2

signal on_died;
func _on_life_component_on_died() -> void:
	TimeFreeze.freeze(60);
	on_died.emit();
	sprite.visible = false;
	
	modulate = Color.BLACK;
	z_index = 3;
	
	c1.visible = true;
	c2.visible = true;
	
	c1.activate();
	c2.activate();
	if active:
		$crack_sfx.play()
	active = false;
	pass # Replace with function body.
