extends Control

@onready var wave_spawner: Node = $"../../../../WaveSpawner"
@onready var control: Control = $Control

var stage_blips: Array[Sprite2D] = [];
const STAGE_BLIP = preload("res://ui/stage_blip.tscn")

func _ready() -> void:
	var dx = floor((get_parent().size.x - 52) / (wave_spawner.max_waves));
	for i in range(wave_spawner.max_waves):
		var b = STAGE_BLIP.instantiate()
		control.add_child(b);
		b.position.x = i * dx;
		stage_blips.push_back(b)
		pass
	_refresh()
	pass
	
func _refresh():
	for i in range(stage_blips.size()):
		var b = stage_blips[i];
		if i + 1 > wave_spawner.wave:
			b.frame = 0;
		elif i + 1 == wave_spawner.wave:
			b.frame = 1;
		else:
			b.frame = 2;
		pass
	pass



func _on_wave_spawner_on_wave_spawned() -> void:
	_refresh();
	pass # Replace with function body.
