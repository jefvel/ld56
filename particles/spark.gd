extends Node2D
func _ready() -> void:
	$CPUParticles2D.one_shot = true
	sprite.frame = randi() % (sprite.hframes * sprite.vframes)
func done():
	queue_free()
	
@onready var sprite: Sprite2D = $sprite

var f = 2;
func _physics_process(delta: float) -> void:
	f -= 1;
	if f <= 0:
		sprite.visible = false;
