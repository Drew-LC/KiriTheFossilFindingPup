extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		print("creating")
		config.set_value("keybinding", "move_left", "A")
		config.set_value("keybinding", "move_right", "D")
		config.set_value("keybinding", "move_down", "S")
		config.set_value("keybinding", "move_up", "W")
		config.set_value("keybinding", "inventory", "I")
		config.set_value("keybinding", "sprint", "Shift")
		config.set_value("keybinding", "press", "E")
		config.set_value("keybinding", "sniff", "Space")
		config.set_value("keybinding", "referencePage", "R")
		config.set_value("keybinding", "click", "mouse_1")
		config.set_value("keybinding", "quit", "Escape")

		config.set_value("video", "fullscreen", 0)
		config.set_value("video", "brightness", 1.05)
		
		config.set_value("audio", "volume_slider", 0.5)
		config.set_value("audio", "music_toggle", false)
		config.set_value("audio", "sfx_toggle", false)
		config.set_value("audio", "ambience_toggle", false)
		
		set_default_progress()
	else:
		config.load(SETTINGS_FILE_PATH)

''' For default-setting the saved in-game variables.'''
func set_default_progress():
	config.set_value("progress", "has_quest", false)
	HUD.has_quest = false
	config.set_value("progress", "has_side", false)
	HUD.has_side = false
	config.set_value("progress", "current_quest", "")
	HUD.current_quest = ""
	config.set_value("progress", "current_side", "")
	HUD.current_side = ""
	config.set_value("progress", "quest_reach_cave", false)
	HUD.quest_reach_cave = false
	config.set_value("progress", "quest_find_fossils", false)
	HUD.quest_find_fossils = false
	config.set_value("progress", "quest_found_fossils", false)
	HUD.quest_found_fossils = false
	config.set_value("progress", "quest_fossils_list", [])
	HUD.quest_fossils_list = []
	config.set_value("progress", "quest_reach_museum", false)
	HUD.quest_reach_museum = false
	config.set_value("progress", "quest_finish_assembly", false)
	HUD.quest_finish_assembly = false
	config.set_value("progress", "quest_finish_ID", false)
	HUD.quest_finish_ID = false
	config.set_value("progress", "quest_submit", false)
	HUD.quest_submit = false
	config.set_value("progress", "quest_trex_ID", false)
	HUD.quest_trex_ID = false
	config.set_value("progress", "quest_trex_submit", false)
	HUD.quest_trex_submit = false
	config.set_value("progress", "quest_anky_ID", false)
	HUD.quest_anky_ID = false
	config.set_value("progress", "quest_anky_submit", false)
	HUD.quest_anky_submit = false
	config.set_value("progress", "quest_mame_ID", false)
	HUD.quest_mame_ID = false
	config.set_value("progress", "quest_mame_submit", false)
	HUD.quest_mame_submit = false
	config.set_value("progress", "quest_pter_ID", false)
	HUD.quest_pter_ID = false
	config.set_value("progress", "quest_pter_submit", false)
	HUD.quest_pter_submit = false
	config.set_value("progress", "trex_tweened", false)
	HUD.trex_tweened = false
	config.set_value("progress", "anky_tweened", false)
	HUD.anky_tweened = false
	config.set_value("progress", "mame_tweened", false)
	HUD.mame_tweened = false
	config.set_value("progress", "pter_tweened", false)
	HUD.pter_tweened = false
	config.set_value("progress", "quest_reach_shop", false)
	HUD.quest_reach_shop = false
	config.set_value("progress", "quest_bought_item", false)
	HUD.quest_bought_item = false
	config.set_value("progress", "quest_customized", false)
	HUD.quest_customized = false
	config.set_value("progress", "quest_shop_submit", false)
	HUD.quest_shop_submit = false
	config.set_value("progress", "quest_reach_home", false)
	HUD.quest_reach_home = false
	config.set_value("progress", "quest_put_furniture", false)
	HUD.quest_put_furniture = false
	config.set_value("progress", "quest_home_submit", false)
	HUD.quest_home_submit = false
	config.set_value("progress", "quest_side_submit", false)
	HUD.quest_side_submit = false
	config.set_value("progress", "current_location_node", Node2D.new())
	HUD.current_location_node = Node2D.new()
	config.set_value("progress", "current_location_name", "")
	HUD.current_location_name = ""
	
	config.set_value("tutorial", "selected_tutorial", true)
	Tutorial.selected_tutorial = true
	config.set_value("tutorial", "first_move", false)
	Tutorial.first_move = false
	config.set_value("tutorial", "accepted_quest", false)
	Tutorial.accepted_quest = false
	config.set_value("tutorial", "made_exit_first", false)
	Tutorial.made_exit_first = false
	config.set_value("tutorial", "sprint_first", false)
	Tutorial.sprint_first = false
	config.set_value("tutorial", "sniff_first", false)
	Tutorial.sniff_first = false
	config.set_value("tutorial", "over_sniffed_spot", false)
	Tutorial.over_sniffed_spot = false
	config.set_value("tutorial", "interacted_spot", false)
	Tutorial.interacted_spot = false
	config.set_value("tutorial", "interest_node", CollisionShape2D.new())
	Tutorial.interest_node = Tutorial.empty_interest
	config.set_value("tutorial", "side_node", CollisionShape2D.new())
	Tutorial.side_node = Tutorial.empty_interest
	
	var styles := [
		{
			"name" : "grey",
			"shop" : "Grey Paint",
	 		"frame" : preload("res://assets/styles/sprite_frame_grey.tres")
		},
		
		{
			"name" : "brown",
			"shop" : "Brown Paint",
			"frame" : preload("res://assets/styles/sprite_frame_brown.tres")
		},
		
		{
			"name" : "pink",
			"shop" : "Pink Paint",
			"frame" : preload("res://assets/styles/sprite_frame_pink.tres")
		},
		
		{
			"name" : "partyHat",
			"shop" : "partyHat",
			"frame" : preload("res://assets/styles/sprite_frame_party.tres")
		},
		
		{
			"name" : "topHat",
			"shop" : "topHat",
			"frame" : preload("res://assets/styles/sprite_frame_tophat.tres")
		},
	]
	config.set_value("inventory", "bought_wearables", styles)
	InventoryCanvasLayer.styles = styles
	config.set_value("inventory", "unbought_wearables", [])
	InventoryCanvasLayer.unused_styles = []
	var default_sprite = preload("res://assets/styles/sprite_frame_grey.tres")
	config.set_value("inventory", "current_wearable", default_sprite)
	InventoryCanvasLayer.kiri_style = default_sprite
	config.set_value("inventory", "furniture", {})
	InventoryCanvasLayer.furniture = {}
	config.set_value("inventory", "bought_items", [])
	InventoryCanvasLayer.bought_items = []
	config.set_value("inventory", "inventory_list", {})
	for item in InventoryCanvasLayer.inventory_list.values():
		InventoryCanvasLayer.inventory.remove_item(item[0].item_name, item[1], "Items")
	InventoryCanvasLayer.inventory_list = {}
	config.set_value("inventory", "gem_count", 0)
	InventoryCanvasLayer.gem_count = 0

	config.save(SETTINGS_FILE_PATH)

''' For Saving and Keeping track of Video Settings '''
func save_video_setting(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key) 
	return video_settings

''' For Saving and Keeping track of Audio Settings '''
func save_audio_setting(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key) 
	return audio_settings

''' For Saving and Keeping track of Keybind Settings '''
func save_keybindings(action: StringName, event: InputEvent):
	var event_str
	
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	
	config.set_value("keybinding", action, event_str)
	config.save(SETTINGS_FILE_PATH)

func load_keybindings():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event 
		var event_str = config.get_value("keybinding", key)
	
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else: 
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	return keybindings

''' For Saving and Keeping track of Progress Settings '''
func save_progress_setting(key: String, value):
	config.set_value("progress", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_progress_settings():
	var progress_settings = {}
	for key in config.get_section_keys("progress"):
		progress_settings[key] = config.get_value("progress", key)
	return progress_settings

''' For Saving and Keeping track of Tutorial Settings '''
func save_tutorial_setting(key: String, value):
	config.set_value("tutorial", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_tutorial_settings():
	var tutorial_settings = {}
	for key in config.get_section_keys("tutorial"):
		tutorial_settings[key] = config.get_value("tutorial", key)
	return tutorial_settings

''' For Saving and Keeping track of Inventory Settings '''
func save_inventory_setting(key: String, value):
	config.set_value("inventory", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_inventory_settings():
	var inventory_settings = {}
	for key in config.get_section_keys("inventory"):
		inventory_settings[key] = config.get_value("inventory", key)
	return inventory_settings
