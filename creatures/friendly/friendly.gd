extends Node2D
class_name Friendly

@onready var life: LifeComponent = $LifeComponent
@onready var anim: AnimationPlayer = $Sprite/AnimationPlayer

@export var hitbox: Hitbox;

const MEAT = preload("res://items/meat.tscn")

var level = 0;
var lvlnames = ["a","b","c","d"]

func _ready() -> void:
	life.make_invulnerable(0.4)
	GameData.game.on_friendly_spawn.emit(self);
	play_anim()
	
func play_anim():
	if level < lvlnames.size():
		anim.play(lvlnames[level])
		do_poof()
	pass

func lvlup():
	level += 1;
	play_anim();

func do_poof():
	if get_parent():
		var explo = EXPLOSION.instantiate()
		explo.global_position = hitbox.global_position;
		get_parent().add_child(explo)
		explo.play(true)

var meat_counts = [1, 3, 9, 12, 24, 32]
func spawn_meat():
	var tospawn = 1;
	if level >= meat_counts.size():
		tospawn = 32;
	else:
		tospawn = meat_counts[level]
	var autopickup = false;
	if GameData.game.sword.life.dead:
		tospawn = int(tospawn * 0.5)
		tospawn = max(tospawn, 1)
		autopickup = true;
	for r in range(tospawn):
		var meat = MEAT.instantiate()
		get_parent().add_child(meat)
		meat.global_position = global_position
		if autopickup:
			meat.force_pickup()
	pass

func _on_life_component_on_died() -> void:
	#if life_component.last_hitter is Sword:
	spawn_meat()
	do_poof()
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	if life.dead:
		queue_free()
		
	
const EXPLOSION = preload("res://items/explosion.tscn")
