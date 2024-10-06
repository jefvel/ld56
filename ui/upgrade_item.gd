@tool
extends Control

@export var upgrade: UpgradeResource;

@onready var namel: Label = $Name
@onready var description: Label = $Description
@onready var lvl_text: Label = $LvlText

var level = 0;

func _ready() -> void:
	namel.text = upgrade.name;
	description.text = upgrade.desc;
	
	if GameData and GameData.on_upgrade_done:
		GameData.on_upgrade_done.connect(_test_upgrade)
	
	refresh()
	pass

func _test_upgrade(up: UpgradeResource, level: int):
	refresh();
@onready var costtxt: Label = $Cost

func refresh():
	if GameData != null and GameData.upgrade_levels:
		level = GameData.upgrade_levels.get(upgrade.id)
	# print(level);
	# print(upgrade.id);
	costtxt.text = "";
	var costs = GameData.upgrade_costs.get(upgrade.id);
	# print("SS", costs.size())
	if level < costs.size():
		var c = costs[level];
		print(c);
		costtxt.text = str(c);
	if level == 0 or level == null:
		lvl_text.text = "-"
	elif level == costs.size():
		lvl_text.text = "MAX"
		costtxt.text = "";
	else:
		lvl_text.text = "Lv %s" % (level + 1)
		pass
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		GameData.request_upgrade(upgrade);
		pass
	pass # Replace with function body.
