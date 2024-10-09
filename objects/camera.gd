extends Camera2D

var vel : Vector2;
var acc : Vector2;

var t = 0.0;
var goal_pos: Vector2;
func _ready() -> void:
	goal_pos = position;

func shake(v : Vector2 = Vector2.from_angle(randf() * TAU)):
	acc += v * 2;
	t = 0
	pass

func _physics_process(delta: float) -> void:
	acc *= 0.9;
	t += delta * 100
	if acc.length() < 1:
		acc = Vector2(0.,0)
	position = goal_pos + acc * sin(t);
	
