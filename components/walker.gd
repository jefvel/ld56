extends Node
class_name WalkerComponent

@export var parent_node: RigidBody2D;
@export var sprite_node: Sprite2D;

@export_range(1.0, 100.0) var max_speed: float = 50.0;
@export_range(0.1, 3.0) var step_interval = 1.0;
@export_range(0.1, 2.0) var step_duration = 0.5;

@export_range(10.0, 60.0) var range_satisfaction = 16.0;

@export var attack_component: AttackComponent;

var cur_step_time = 0.0;

var target_position: Vector2;

var start_pos: Vector2;

var step_t = 0.0;
var stepping = false;

func _ready() -> void:
	start_pos = sprite_node.position;
	cur_step_time = randf() * step_interval;
	pass
	
var shake = .0;
var stime = 0.0;
func _physics_process(delta: float) -> void:
	if !stepping:
		stime *= 0.98;
	var aggro_scale = 1.0;
	
	bonk_s *= 0.8;
	

	if attack_component:
		if attack_component.attacking:
			return;
		if attack_component.aggro:
			aggro_scale *= 2;
			shake += delta * 100.0;
		
	var vel = parent_node.linear_velocity.length()
	var cvel = (clamp(vel, 0, max_speed) / max_speed);
	stime += delta * cvel * 50;
	
	var pwr = cvel;
	
	sprite_node.rotation = sin(stime) * 0.1 * pwr;
	sprite_node.position.y = start_pos.y - abs(cos(stime * 0.4) * 4) * pwr
	sprite_node.rotation += sin(shake * 10) * 0.05;
	sprite_node.position.x = sin(bonk_s) * 4.5;
	
	if stepping and abs(vel) > 1:
		sprite_node.scale.x = sign(parent_node.linear_velocity.x);
		pass
		
	if cur_step_time <= step_interval:
		cur_step_time += delta * aggro_scale;
		step_t = step_duration;
		return
	else:
		stepping = true;
	
	if step_t > 0.0 and target_position.length_squared() > 0:
		var d = target_position - parent_node.position;
		if d.length_squared() < range_satisfaction * range_satisfaction:
			step_t = 0.0;
			return;
		
		d = d.normalized();
		d *= 2000.0 * parent_node.mass;
		
		var max_spd = max_speed * aggro_scale;
		if parent_node.linear_velocity.length_squared() < max_spd * max_spd:
			parent_node.apply_central_force(d * aggro_scale)
		step_t -= delta;
	else:
		stepping = false;
		cur_step_time -= step_interval * randf_range(0.96, 1.02)
	pass
	

var bonk_s = .0
func _on_life_component_on_hurt(damage: int) -> void:
	bonk_s = 1.0;
	pass # Replace with function body.
