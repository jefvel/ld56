extends Node

var until_new = randf_range(0.5, 3.0)

var min_p = Vector2(130, 87)
var max_p = Vector2(380, 222)

@export var walker: WalkerComponent;

func _physics_process(delta: float) -> void:
	until_new -= delta;
	if until_new > 0: return
	
	until_new = randf_range(1.0, 4.0)
	
	var p = walker.parent_node.global_position;
	p += Vector2.from_angle(randf() * TAU) * randf_range(10, 80);
	
	if p.x < min_p.x: p.x = max_p.x;
	if p.x > max_p.x: p.x = min_p.x;
	if p.y < min_p.y: p.y = max_p.y;
	if p.y > max_p.y: p.y = min_p.y;
	
	p = p.clamp(min_p, max_p)
	
	walker.target_position = p;
	
