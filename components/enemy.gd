extends Node2D
class_name Enemy

@onready var walker_component: WalkerComponent = $WalkerComponent
@export var life: LifeComponent;
@export_range(1, 100) var points: int = 1;

var max_speed = .0;

func _ready() -> void:
	life.on_died.connect(died);
	if GameData.game and is_instance_valid(GameData.game):
		GameData.game.on_enemy_spawn.emit(self);
	max_speed = walker_component.max_speed;
	
func died():
	if GameData.game:
		GameData.game.on_enemy_die.emit(self);
	queue_free();
	
