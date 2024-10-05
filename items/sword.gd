extends Node2D

var vel: Vector2;
var dx:float = 0.0;

@export var active: bool = true;
@onready var sprite: Sprite2D = $Sprite


func _physics_process(_delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	var d = (pos - position);
	
	position += d * 0.5
	dx += d.x * 0.03;
	dx *= 0.5;
	sprite.rotation = dx;
	var max_rotation = .1;
	sprite.rotation = clamp(sprite.rotation, -max_rotation, max_rotation)
	
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	pass
