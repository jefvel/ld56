extends Control

@export var upgrade: UpgradeResource;
@onready var namel: Label = $Name
@onready var description: Label = $Description
@onready var lvl_text: Label = $LvlText

@export var available_color = Color(0x65856dff);
@export var unavailable_color = Color(0x974133ff)
@export var maxed_color = Color(0xcbcbcbff)

@onready var color_rect: ColorRect = $ColorRect

@export var store: MeatStore;

var level = 0;

func _ready() -> void:
	if !upgrade:
		print("ehu")
		print(name)
		return
	namel.text = upgrade.name;
	description.text = upgrade.desc;
	
	if GameData and GameData.on_upgrade_done:
		GameData.on_upgrade_done.connect(_test_upgrade)
	
	refresh()
	
	if store:
		store.on_open.connect(refresh)
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
	var cc = available_color;
	if level < costs.size():
		var c = costs[level];
	#	print(c);
		if GameData.meat_bank < c:
			#print("set cc to ", unavailable_color)
			cc = unavailable_color;
			pass
		costtxt.text = str(c);
	if level == 0 or level == null:
		lvl_text.text = "-"
	elif level == costs.size():
		cc = maxed_color;
		lvl_text.text = "MAX"
		costtxt.text = "";
	else:
		lvl_text.text = "Lv %s" % (level + 1)
		pass
	
	if is_instance_valid(color_rect) and cc:
		color_rect.modulate = cc
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		GameData.request_upgrade(upgrade);
		pass
	pass # Replace with function body.
