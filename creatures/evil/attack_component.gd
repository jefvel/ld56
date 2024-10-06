extends Node
class_name AttackComponent
@export var anim: AnimationPlayer;
@export var sprite: Sprite2D;
@export var enemy: Enemy;

@export var walker: WalkerComponent;

@export var attack_pos: Node2D;

@export_range(0.5, 10.0) var attack_interval = 3.0;
@export_range(1, 10) var damage = 1;

@export_range(0.0, 100.0) var attack_range = 30.0;
@export_range(0.2, 1.0) var attack_prepare_time = 1.0;

@export var attack_type: PackedScene = preload("res://creatures/attacks/base_swoosh.tscn");

signal on_do_attack(atk: AttackComponent);

var attack_target: Node2D;

var until_find_target = 0.0;

var aggro = false;

func find_target():
	if !GameData.game.sword.life.dead:
		attack_target = GameData.game.sword;
	else: 
		attack_target = null;
	if aggro:
		return;
	
	var pos = sprite.global_position;
	var closest_sq = 1600 * 1600;
	var closest: Friendly = null;
	
	if attack_target == GameData.game.sword:
		var dist_to_sword = GameData.game.global_position.distance_squared_to(pos)
		if dist_to_sword < 350 * 350:
			return;
	
	for f in GameData.game.friendlies:
		if !is_instance_valid(f):
			return
		var d_sq = f.global_position.distance_squared_to(pos)
		if d_sq < closest_sq:
			closest = f;
			closest_sq = d_sq;
			if randf() > 0.8: break;
		pass
	
	if closest:
		attack_target = closest;
	
	pass
	

var attacking: bool = false;
var attack_time = .0;
var target_position: Vector2;

func start_attack():
	attacking = true;
	attack_time = 0.0;
	target_position = attack_target.global_position;
	anim.play("attack")
	pass

func do_attack():
	attacking = false;
	anim.play("idle")
	var a = attack_type.instantiate() as Attack
	enemy.get_parent().add_child(a)
	a.attackee = enemy;
	a.global_position = attack_pos.global_position
	a.set_target(attack_target, target_position)
	pass
	
func process_attack(delta:float):
	attack_time += delta;
	if attack_time > attack_prepare_time:
		do_attack()
	pass

func _physics_process(delta: float) -> void:
	until_find_target -= delta;
	if until_find_target < 0:
		until_find_target = randf_range(0.5, 1.0);
		find_target()
			
	
	if !walker.stepping and is_instance_valid(attack_target):
		if attack_target.life and attack_target.life.dead:
			aggro = false;
			attack_target = null;
			find_target()
			return
			
		if !attacking:
			sprite.flip_h = attack_target.position.x < enemy.position.x;
			walker.target_position = attack_target.global_position;
		
		var d = attack_target.position - enemy.position;
		var dist = d.length()
		
		if attacking:
			process_attack(delta)
			return
		
		if dist < attack_range:
			start_attack();
			pass
		pass
	


func _on_life_component_on_hurt(damage: int) -> void:
	aggro = true;
	find_target()
	pass # Replace with function body.
