extends Area2D
class_name AutoAim

var closest_target: Hitbox;

func _physics_process(delta: float) -> void:
	var closest: Hitbox = null;
	var closest_distance_sq = 1000.0 * 1000.0;
	var overlaps = get_overlapping_areas()
	var pos = global_position;
	for a in overlaps:
		if a is Hitbox:
			if a.friendly_immune:
				continue
			if a.life and a.life.is_invulnerable:
				continue
			var dsq = pos.distance_squared_to(a.global_position)
			if dsq < closest_distance_sq:
				closest_distance_sq  = dsq;
				closest = a;
		pass
		
	closest_target = closest;
