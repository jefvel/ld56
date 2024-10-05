extends Node
class_name WalkerComponent

@export var parent_node: Node2D;
@export var sprite_node: Sprite2D;

var start_pos: Vector2;

func _ready() -> void:
	start_pos = sprite_node.position;
	pass
