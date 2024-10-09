extends Control
@onready var meat_text: Label = $"MarginContainer/TopTexts/Meat Text"
@onready var control: Control = $MarginContainer/GameOver/Control
@onready var uianim: AnimationPlayer = $uianim

@onready var tanim: AnimationPlayer = $MarginContainer/TopTexts/tanim
@onready var gameoveranim: AnimationPlayer = $MarginContainer/GameOver/gameoveranim

var d = 0.0;
var top_shown = false;
func _ready() -> void:
	uianim.play("fadein")
	pass
@onready var lbl: Label = $MarginContainer/GameOver/Control/OutOfFriendlies

func hide_ingame_ui():
	$MarginContainer/StageContainer.visible = false;
	$MarginContainer/TopTexts.visible = false;
	$MarginContainer/Win.visible = false;
	pass

func _physics_process(_delta: float) -> void:
	if !top_shown and GameData.meat > 0:
		tanim.play("show_top")
		top_shown = true
	var txt = "%s" % GameData.meat
	meat_text.text = txt;
	d += _delta;
	control.rotation = sin(d) * 0.02
	control.scale.x = cos(d) * 0.02 + 1
	control.scale.y = control.scale.x

var gover = false;	
func show_gameover(txt: String):
	if gover: return;
	gover = true;
	lbl.text = txt;
	gameoveranim.play("show");
	
	pass

func _on_game_on_friendlies_dead() -> void:
	show_gameover("OUT OF FRIENDS")
	pass # Replace with function body.


func _on_game_on_sword_exploded() -> void:
	show_gameover("SWORD EXPLODED")
	pass # Replace with function body.
