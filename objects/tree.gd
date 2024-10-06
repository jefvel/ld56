extends Node2D
@onready var tree: Sprite2D = $Tree

var t = randf_range(0.0, TAU);
func rot():
	tree.rotation = sin(t) * 0.1;
	if (t > TAU): t -= TAU
	pass
func _process(delta: float) -> void:
	t += delta * 0.5;
	rot()
