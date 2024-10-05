extends Node2D
class_name Enemy

@export var life: LifeComponent;

func _ready() -> void:
	life.on_died.connect(died);
	
func died():
	queue_free();
