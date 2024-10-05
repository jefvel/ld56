extends Node2D
class_name Friendly

const MEAT = preload("res://items/meat.tscn")

func _on_life_component_on_died() -> void:
	queue_free()
	var meat = MEAT.instantiate()
	get_parent().add_child(meat)
	meat.global_position = global_position
	pass # Replace with function body.
