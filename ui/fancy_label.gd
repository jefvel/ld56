@tool
extends Label

@onready var bg: Label = $Bg

func _ready() -> void:
	init();
	pass

func _set(property: StringName, value: Variant) -> bool:
	if !is_instance_valid(bg): return false
	if property != "position":
		bg.set(property, value)
	return false
	
func init():
	bg.horizontal_alignment = horizontal_alignment;
	bg.vertical_alignment = vertical_alignment;
	bg.set("theme_override_fonts/font", get("theme_override_fonts/font"))
	bg.set("theme_override_font_sizes/font_size", get("theme_override_font_sizes/font_size"))
	pass

func _process(_delta: float) -> void:
	bg.text = text;
	bg.size = size;
	bg.global_position = global_position + Vector2(2, 2);
