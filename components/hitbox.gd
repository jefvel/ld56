extends Area2D
class_name Hitbox

@export var life: LifeComponent;

@export var friendly_immune: bool = false;
@export var enemy_immune: bool = false;

func hit(damage: int) -> bool:
	if life: return life.hurt(damage)
	return false;

var enabled: bool:
	set(e):
		set_collision_mask_value(1, e);
	get:
		return get_collision_mask_value(1);
