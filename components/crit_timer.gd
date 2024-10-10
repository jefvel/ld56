extends Node

@onready var crit_snd: AudioStreamPlayer2D = $CritSnd
@export var sprite: Node2D;

func on_crit_time():
	crit_snd.play()
	if is_instance_valid(sprite):
		sprite.scale.y = 0.7;
		var tw = get_tree().create_tween().tween_property(sprite, "scale:y", 1.0, 0.1)
	pass
