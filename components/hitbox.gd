extends Area2D
class_name Hitbox

@export var life: LifeComponent;

@export var friendly_immune: bool = false;
@export var enemy_immune: bool = false;

signal on_hit(damage: int, attacker: Node2D);

func hit(damage: int, attacker: Node2D):
	if attacker is Enemy and enemy_immune: return false;
	on_hit.emit(damage, attacker)
	if life: return life.hurt(damage, attacker)
	
	return null;

var enabled: bool:
	set(e):
		set_collision_mask_value(1, e);
	get:
		return get_collision_mask_value(1);
