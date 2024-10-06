extends Control

@onready var anim: AnimationPlayer = $anim
@onready var meat_text: Label = $"Content/Control/Meat Text"

var is_open: bool = false;

signal on_open;
signal on_close;
signal on_closed;

var open_ready = false
func _on_open_ready():
	open_ready = true;
	pass

func _on_closed():
	on_closed.emit()

func _ready() -> void:
	visible = true;
	position.y = 666;
	
func deposit():
	GameData.meat_bank += GameData.meat;
	GameData.meat = 0;
	
func _physics_process(delta: float) -> void:
	meat_text.text = "%s" % GameData.meat_bank
	if Input.is_action_just_pressed("close"):
		hide_store();

func show_store():
	if is_open: return
	is_open = true;
	
	on_open.emit();
	anim.play("show")

func hide_store():
	if !open_ready: return
	if !is_open: return
	is_open = false;
	
	open_ready = false;
	
	on_close.emit();
	anim.play("hide");
	
