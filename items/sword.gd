extends Node2D

var vel: Vector2;
var dx: float = 0.0;
var ax: float = 0.0;

@export var active: bool = true;
@onready var sprite: Sprite2D =  $Holder/Sprite

@onready var attack_animations: AnimationPlayer = $AttackAnimations

@onready var area: Area2D = $Holder/Sprite/Area2D

@export var attack_duration = 0.5;
var attack_time = 0.0;
var attacking: bool = false;

var max_pierce = 1;
var cur_pierce = 0;

var cooling_down = false;
var attack_cooldown: float = 0.0;
var attack_cooldown_duration = 1.0;

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	if TimeFreeze.frozen:
		attack_animations.speed_scale = 0;
		return
	else:
		attack_animations.speed_scale = 1.0;
	
	var pos = get_viewport().get_mouse_position()
	var d = (pos - position);
	
	position += d * 0.5
	dx += d.x * 0.03;
	#ax *= .5;
	#dx += ax;
	dx *= 0.4;
	sprite.rotation = dx;
	var max_rotation = 0.5;
	sprite.rotation = clamp(sprite.rotation, -max_rotation, max_rotation)
	
	
	
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	process_cooldown(_delta)
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	if attacking: process_attack(_delta)

@onready var sword_progress_sprite: Node2D = $Holder/Sprite/Sprite2/SwordProgress

func process_cooldown(d:float):
	sword_progress_sprite.scale.y = clamp(attack_cooldown / attack_cooldown_duration, 0.0, 1.0)
	if !cooling_down:return
	attack_cooldown -= d;
	if attack_cooldown <= 0:
		cooling_down = false;
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
	if attacking: return
	if cooling_down: return;
	
	attack_cooldown = attack_cooldown_duration;
	
	cur_pierce = 0;
	attacking = true;
	attack_time = 0.0;
	attack_animations.play("stab", 0, 1, false)

func hit_target(e: Hitbox):
	if !attacking: return
	e.hit(1)
	cur_pierce += 1;
	TimeFreeze.freeze(3);
	if cur_pierce >= max_pierce:
		finish_attack();
	

func finish_attack():
	attacking = false;
	cooling_down = true;
	attack_cooldown = attack_cooldown_duration;
