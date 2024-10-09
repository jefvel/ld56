extends Node2D
class_name Attack

var attackee: Node2D;

var target: Node2D;
var target_pos: Vector2;
var target_dir: Vector2;

signal on_target_get(a: Attack);
signal on_hit(h: Hitbox)

func _ready() -> void:
	pass
	
func set_target(target: Node2D, target_pos: Vector2, target_dir: Vector2):
	self.target = target;
	self.target_pos = target_pos;
	self.target_dir = target_dir;
	on_target_get.emit(self);


func _on_hit_area_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		on_hit.emit(area)
	pass # Replace with function body.
