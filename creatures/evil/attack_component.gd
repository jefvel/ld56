extends Node
class_name AttackComponent
@export var anim: AnimationPlayer;
@export var sprite: Sprite2D;
@export var enemy: Enemy;

@export var walker: WalkerComponent;

@export_range(0.5, 10.0) var attack_interval = 3.0;
@export_range(1, 10) var damage = 1;

@export_range(0.0, 100.0) var attack_range = 30.0;
@export_range(0.2, 1.0) var attack_prepare_time = 1.0;

var attack_target: Node2D;

var until_find_target = 0.0;

var aggro = false;

func find_target():
	attack_target = GameData.game.sword;
	
	if aggro:
		return;
	
	var pos = sprite.global_position;
	var closest_sq = 600 * 600;
	var closest: Friendly = null;
	
	for f in GameData.game.friendlies:
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
func start_attack():
	attacking = true;
	anim.play("attack")
	pass
	
func process_attack(delta:float):
	
	pass

func _physics_process(delta: float) -> void:
	until_find_target -= delta;
	if until_find_target < 0:
		until_find_target = randf_range(3.0, 20.0);
		find_target()
			
	
	if !walker.stepping and is_instance_valid(attack_target):
		
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
