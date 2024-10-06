extends Node
@export var sprite: Sprite2D;
@export var attack: Attack;

var initial_vel = 5.0;
var dir: Vector2;

@onready var vel = initial_vel;
func _ready() -> void:
	attack.on_target_get.connect(_on_attack_on_target_get)
	pass

func _on_attack_on_target_get(a: Attack) -> void:
	if attack.target and attack.target.hitbox:
		dir = attack.target.hitbox.global_position - attack.position
		pass
	
	pass

func _physics_process(delta: float) -> void:
	if TimeFreeze.frozen: return
	
	var d = dir;
	d = d.normalized();
	vel *= 0.9;
	attack.position += d * vel;
	sprite.scale.x = vel / initial_vel;
	sprite.rotation = d.angle()
	if vel < 0.1:
		attack.queue_free();
	pass


func _on_attack_on_hit(h: Hitbox) -> void:
	if vel < 2:
		return;
	if is_instance_valid(attack.attackee):
		h.hit(1, attack.attackee)
	else: 
		h.hit(1, null)
	
	pass # Replace with function body.
