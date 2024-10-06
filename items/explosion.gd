extends Node2D
func play(small = false):
	if small: $AnimationPlayer.play("smallboom")
	else: $AnimationPlayer.play("boom")
	
func _ready() -> void:
	$AnimationPlayer.play("boom")
	pass
