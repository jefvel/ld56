extends Area2D
class_name Pickup

@export_enum("Meat", "Item") var pickup_type;

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shadow_small: Sprite2D = $ShadowSmall
@onready var pickup_sfx: AudioStreamPlayer = $pickup_sfx

signal on_picked_up;

var vel: Vector2;

var until_can_pick_up = 0.25;

func can_pick_up():
	return !picked_up and until_can_pick_up < 0;

func _ready() -> void:
	vel = Vector2.from_angle(randf() * TAU) * randf_range(1.5, 6.0)
	animation_player.play("bounce")
	pass
	
func _physics_process(delta: float) -> void:
	position += vel;
	vel *= 0.7;
	until_can_pick_up -= delta;
	pass

var picked_up = false;
func pick_up():
	if !can_pick_up(): return
	pickup_sfx.play()
	force_pickup()
	pass

func force_pickup():
	if picked_up: return
	
	on_picked_up.emit()
	
	picked_up = true;
	animation_player.play("spawn")
	GameData.meat += 1;
	pass
