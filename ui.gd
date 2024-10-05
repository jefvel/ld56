extends Control
@onready var meat_text: Label = $"MarginContainer/TopTexts/Meat Text"
@onready var label: Label = $"MarginContainer/TopTexts/Meat Text/Label"

func _physics_process(delta: float) -> void:
	var txt = "%s" % GameData.meat
	meat_text.text = txt;
	label.text = txt;
