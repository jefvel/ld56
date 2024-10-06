extends Node2D
class_name Friendly

@onready var life: LifeComponent = $LifeComponent
@onready var anim: AnimationPlayer = $Sprite/AnimationPlayer

@export var hitbox: Hitbox;

const MEAT = preload("res://items/meat.tscn")

var level = 0;
var lvlnames = ["a","b","c","d"]

func _ready() -> void:
	GameData.game.on_friendly_spawn.emit(self);
	play_anim()
	
func play_anim():
	if level < lvlnames.size():
		anim.play(lvlnames[level])
		
	pass
func lvlup():
	level += 1;
	play_anim();

func _on_life_component_on_died() -> void:
	#if life_component.last_hitter is Sword:
	var meat = MEAT.instantiate()
	get_parent().add_child(meat)
	meat.global_position = global_position
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	if life.dead:
		queue_free()
