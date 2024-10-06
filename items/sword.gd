extends Node2D
class_name Sword

var vel: Vector2;
var dx: float = 0.0;
var ax: float = 0.0;

@export var life: LifeComponent;
@export var hitbox: Hitbox;

@export var active: bool = true;
@onready var sprite: Sprite2D =  $Holder/Sprite

@onready var attack_animations: AnimationPlayer = $AttackAnimations

@onready var area: Area2D = $Holder/Sprite/Area2D
@onready var sword_progress_sprite: Node2D = $Holder/Sprite/Sprite2/SwordProgress

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
func _ready():
	max_pierce = pierce_levels[GameData.get_upgrade_level("pierce")]
	cur_damage = damage_levels[GameData.get_upgrade_level("damage")]
	max_speed = max_speeds[GameData.get_upgrade_level("speed")]
	attack_cooldown_duration = cooldown_speeds[GameData.get_upgrade_level("attack_speed")]
	var rad = pu_rads[GameData.get_upgrade_level("pickup_radius")]
	pick_up_rad.scale = Vector2(rad, rad)
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
	var is_away_from_cursor = false;
	if active:
		var vp = get_viewport()
		var unclamped_pos = vp.get_mouse_position()
		var p = 16;
		var pos = unclamped_pos.clamp(Vector2(p,p), Vector2(512 - p, 320 - p))
		var d = (pos - position);
		
		d = d.limit_length(max_speed)
		
		position += d * 0.5
		dx += d.x * 0.03;
		dx *= 0.4;
		is_away_from_cursor = unclamped_pos.distance_to(position) > 3
		
	sprite.rotation = dx;
	var max_rotation = 0.5;
	sprite.rotation = clamp(sprite.rotation, -max_rotation, max_rotation)
	
	attack_press_coyote_time -= _delta;
	
	if active and !is_away_from_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	process_cooldown(_delta)
	
	if !active: return
	
	if Input.is_action_just_pressed("attack"):
		attack()
	if attacking: process_attack(_delta)


func process_cooldown(d:float):
	sword_progress_sprite.scale.y = clamp(attack_cooldown / attack_cooldown_duration, 0.0, 1.0)
	if !cooling_down:return
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
				hit_target(b)
	pass

func attack():
	if attacking or cooling_down: 
		attack_press_coyote_time = 0.2;
		return
	
	life.make_invulnerable(0.2)
	
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
	
	e.hit(cur_damage, self)
	cur_pierce += 1;
	TimeFreeze.freeze(3);
	hit_sfx.play()
	if cur_pierce >= max_pierce:
		finish_attack();
	

func finish_attack():
	attacking = false;
	cooling_down = true;
	attack_cooldown = attack_cooldown_duration;


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
