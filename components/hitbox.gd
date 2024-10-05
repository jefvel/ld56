extends Area2D
class_name Hitbox

@export var life: LifeComponent;

func hit(damage: int):
	if life: life.hurt(damage)

var enabled: bool:
	set(e):
		set_collision_mask_value(1, e);
	get:
		return get_collision_mask_value(1)
