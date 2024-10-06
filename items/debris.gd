extends Sprite2D

var vel = Vector2(randf_range(-4,4), randf_range(-4, -7))
var rotvel = randf_range(-2, 2);
var active = false;
func activate():
	active = true;
	visible = true;
	
func _physics_process(delta: float) -> void:
	if !active: return
	if TimeFreeze.frozen: return
	
	global_position += vel;
	rotation += rotvel;
	vel *= 0.94;
	vel.y += 0.4;
	rotvel *= 0.98;
	
	pass
