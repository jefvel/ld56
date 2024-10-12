extends Node

signal on_input_type_changed(type: InputType);

enum InputType {
	Mouse,
	Keyboard,
	Controller,
}

var input_type: InputType = InputType.Mouse:
	set(i):
		if i == input_type: return;
		input_type = i;
		on_input_type_changed.emit(i);
		_update_cursor()

var cursor_visible: bool = true:
	set(cv):
		cursor_visible = cv;
		_update_cursor()
		pass

var last_mouse_pos:Vector2;

func is_using_mouse(): return input_type == InputType.Mouse;
func is_using_keyboard(): return input_type == InputType.Keyboard;

func _update_cursor():
	if input_type != InputType.Mouse or !cursor_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if input_type != InputType.Mouse:
			if event.position.distance_to(last_mouse_pos) > 10:
				input_type = InputType.Mouse;
		else:
			last_mouse_pos = event.position;
	
	if event is InputEventMouseButton:
		input_type = InputType.Mouse;
	if event is InputEventKey:
		input_type = InputType.Keyboard;
	pass
