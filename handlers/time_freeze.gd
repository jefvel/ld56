extends Node

var frozen: bool = false;

var frozen_frames:int = 0;
func freeze(frames: int = 1):
	frozen_frames = frames;
	frozen = true;
	
func _physics_process(delta: float) -> void:
	if frozen:
		frozen_frames -= 1;
		if frozen_frames <= 0:
			frozen = false;
