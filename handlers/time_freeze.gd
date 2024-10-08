extends Node

var frozen: bool = false;

var frozen_frames:int = 0;

var node_to_freeze: Node;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS;
	pass
	
func freeze(frames: int = 1):
	frozen_frames = frames;
	frozen = true;
	
func _physics_process(_delta: float) -> void:
	if !is_instance_valid(node_to_freeze): return
	
	if frozen:
		node_to_freeze.process_mode = Node.PROCESS_MODE_DISABLED
		frozen_frames -= 1;
		if frozen_frames <= 0:
			frozen = false;
	else:
		node_to_freeze.process_mode = Node.PROCESS_MODE_INHERIT
		
