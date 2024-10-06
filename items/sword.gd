extends Node2D
class_name Sword

var vel: Vector2;
var dx: float = 0.0;
var ax: float = 0.0;

@export var active: bool = true;
@onready var sprite: Sprite2D =  $Holder/Sprite

@onready var attack_animations: AnimationPlayer = $AttackAnimations

@onready var area: Area2D = $Holder/Sprite/Area2D
@onready var sword_progress_sprite: Node2D = $Holder/Sprite/Sprite2/SwordProgress

signal on_weapon_ready();

@export var attack_duration = 0.25;
var attack_time = 0.0;
var attacking: bool = false;

var max_pierce = GameData.weapon_pierce;
var cur_pierce = 0;

var cooling_down = false;
var attack_cooldown: float = 0.0;
var attack_cooldown_duration = 1.5;

var attack_press_coyote_time = 0.0;

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	if TimeFreeze.frozen:
		attack_animations.speed_scale = 0;
		return
	else:
		attack_animations.speed_scale = 1.0;
	
	var is_away_from_cursor = false;
	if active:
		var vp = get_viewport()
		var unclamped_pos = vp.get_mouse_position()
		var p = 16;
		var pos = unclamped_pos.clamp(Vector2(p,p), Vector2(512 - p, 320 - p))
		var d = (pos - position);
		
		position += d * 0.5
		dx += d.x * 0.03;
		dx *= 0.4;
		is_away_from_cursor = unclamped_pos.distance_to(pos) > 3
		
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
	
	attack_cooldown = attack_cooldown_duration;
	
	cur_pierce = 0;
	attacking = true;
	attack_time = 0.0;
	attack_animations.play("stab", 0, 1, false)
@onready var hit_sfx: AudioStreamPlayer = $hit_sfx

func hit_target(e: Hitbox):
	if !attacking: return
	e.hit(1)
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
