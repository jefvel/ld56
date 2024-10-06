extends Node

@export var walker: WalkerComponent;

func _physics_process(delta: float) -> void:
	walker.target_position = get_viewport().get_mouse_position()
	pass
