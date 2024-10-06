extends Node

@onready var collision_shape_2d: CollisionShape2D = $"../World/Grass/FriendlySpawn/CollisionShape2D"
@onready var friendly_spawn: Area2D = $"../World/Grass/FriendlySpawn"

@onready var things: Node2D = $"../World/Things"

const CREATURE = preload("res://creatures/friendly/creature.tscn")

func init() -> void:
	for i in range(GameData.initial_friendlies):
		spawn_friendly()
	pass

func spawn_friendly():
	var rect : Rect2 = collision_shape_2d.shape.get_rect()
	var x = randi_range(rect.position.x, rect.position.x+rect.size.x)
	var y = randi_range(rect.position.y, rect.position.y+rect.size.y)
	var rand_point = friendly_spawn.global_position + Vector2(x,y)
	
	var c = CREATURE.instantiate()
	c.global_position = rand_point;
	things.add_child(c)
	pass
