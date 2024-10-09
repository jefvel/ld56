extends Area2D
class_name PickUpper

@onready var pick_up_rad: CollisionShape2D = $PickUpRad

signal on_pickup(p:Pickup);

var pickup_radius: float:
	set(r):
		pick_up_rad.scale.x = r;
		pick_up_rad.scale.y = r;
	get:
		return pick_up_rad.scale.x;

func _physics_process(_delta: float) -> void:
	for area in get_overlapping_areas():
		if area is Pickup:
			if area.can_pick_up():
				area.pick_up()
