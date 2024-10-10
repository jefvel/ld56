extends Node2D
func _ready() -> void:
	$CPUParticles2D.one_shot = true
	sprite.frame = randi() % (sprite.hframes * sprite.vframes)
func done():
	queue_free()
	
@onready var sprite: Sprite2D = $sprite
@onready var crit_strike: Sprite2D = $crit_strike

var f = 2;
var cf = 4;
func _physics_process(delta: float) -> void:
	f -= 1;
	cf -= 1;
	if f <= 0:
		sprite.visible = false;
	if cf <= 0:
		crit_strike.visible = false;

func do_crit():
	crit_strike.visible = true;
	crit_strike.frame = randi() % (crit_strike.hframes * crit_strike.vframes)
	pass
