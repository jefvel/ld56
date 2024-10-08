extends Control

@onready var wave_spawner: Node = $"../../../../WaveSpawner"
@onready var control: Control = $Control

var stage_blips: Array[Sprite2D] = [];
const STAGE_BLIP = preload("res://ui/stage_blip.tscn")

func _ready() -> void:
	for i in range(wave_spawner.max_waves):
		var b = STAGE_BLIP.instantiate()
		control.add_child(b);
		stage_blips.push_back(b)
	_refresh()
	
func _refresh():
	if !is_instance_valid(wave_spawner):
		return

	var sx = size.x
	var dx = floor(sx / (wave_spawner.max_waves - 1));
	for i in range(stage_blips.size()):
		var b = stage_blips[i];
		b.position.x = i * dx;
		
		if i + 1 > wave_spawner.wave:
			b.frame = 0;
		elif i + 1 == wave_spawner.wave:
			b.frame = 1;
		else:
			b.frame = 2;
	pass

func _on_wave_spawner_on_wave_spawned() -> void:
	_refresh();

func _on_control_resized() -> void:
	_refresh()
