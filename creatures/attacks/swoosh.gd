extends Node
@export var sprite: Sprite2D;
@export var attack: Attack;

@export var initial_vel = 5.0;
var dir: Vector2;

@onready var vel = initial_vel;
func _ready() -> void:
	attack.on_target_get.connect(_on_attack_on_target_get)
	pass

func _on_attack_on_target_get(a: Attack) -> void:
	if attack.target and attack.target.hitbox:
		dir = attack.target_dir


func _physics_process(delta: float) -> void:
	if TimeFreeze.frozen: return
	
	var d = dir;
	d = d.normalized();
	vel *= 0.9;
	attack.position += d * vel;
	attack.scale.x = vel / initial_vel;
	attack.rotation = d.angle()
	if vel < 0.1:
		attack.queue_free();
	pass


var has_hit = false;
func _on_attack_on_hit(h: Hitbox) -> void:
	if has_hit: return;
	if vel < 1:
		return;
	
	var res = false
	if is_instance_valid(attack.attackee):
		res = h.hit(1, attack.attackee)
	else: 
		res = h.hit(1, null)
	if res:
		has_hit = true;
	pass # Replace with function body.
