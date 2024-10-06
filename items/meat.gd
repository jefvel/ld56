extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shadow_small: Sprite2D = $ShadowSmall

var vel: Vector2;

var until_can_pick_up = 0.25;

func _ready() -> void:
	vel = Vector2.from_angle(randf() * TAU) * randf_range(1.5, 6.0)
	animation_player.play("bounce")
	pass
	
func _physics_process(delta: float) -> void:
	position += vel;
	vel *= 0.7;
	until_can_pick_up -= delta;
	check_pickup()
	pass
@onready var pickup_sfx: AudioStreamPlayer = $pickup_sfx

var picked_up = false;
func check_pickup():
	if picked_up: return
	if hovered:
		if until_can_pick_up > 0: return;
		pickup_sfx.play()
		picked_up = true;
		animation_player.play("spawn")
		GameData.meat += 1;
	pass

var hovered = false;
func _on_area_entered(_area: Area2D) -> void:
	hovered = true;
	check_pickup();
	pass # Replace with function body.


func _on_area_exited(_area: Area2D) -> void:
	hovered = false;
	pass # Replace with function body.
