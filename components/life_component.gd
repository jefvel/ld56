extends Node
class_name LifeComponent

@export_range(1, 100) var max_health: int = 10;
@export_range(0.0, 10.0) var invulnerability_time = 0.5;

@export var hit_flash: Sprite2D;

@export var attack_component: AttackComponent;

var _invuln_time = 0.0;

var is_invulnerable: bool:
	get: return _invuln_time > 0;

@onready var health: int = max_health;
var dead: bool = false;

signal on_died();
signal on_hurt(damage: int);

var last_hitter: Node2D

var start_material;
var flash_material = preload("res://creatures/evil/hurt_material.tres")
var flash_t = 0.0;
func _physics_process(delta: float) -> void:
	if is_instance_valid(hit_flash) and flash_t > 0.0:
		flash_t -= delta;
		if flash_t < 0:
			hit_flash.material = start_material;
			
	if _invuln_time > 0:
		_invuln_time -= delta;

func die():
	if dead: return
	dead = true
	on_died.emit()
	
var material : ShaderMaterial = null;
func _ready() -> void:
	if hit_flash: start_material = hit_flash.material;
	pass

func flash():
	if hit_flash: hit_flash.material = flash_material;
	flash_t = .1;

func make_invulnerable(duration: float = 0.4):
	_invuln_time = duration;

# Returns true when hurt hits
func hurt(amount: int = 1, hurter: Node2D = null) -> HitData:
	if _invuln_time > 0: return null;
	
	var dmg = amount;
	var crit_hit = false;
	if attack_component and attack_component.vulnerable:
		dmg *= 2;
		crit_hit = true;
	
	_invuln_time = invulnerability_time;
	last_hitter = hurter;
	health -= dmg;
	if health > 0:
		on_hurt.emit(dmg)
		flash()
	else:
		die()
	var data = HitData.new()
	data.critical_hit = crit_hit
	return data;
	
class HitData:
	var critical_hit: bool;
	pass
