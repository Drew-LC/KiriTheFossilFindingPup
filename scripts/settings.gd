extends Control
@onready var display_button: OptionButton = $settingsContainer/VBoxContainer/TabContainer/Display/DisplayTab/HBoxContainer/DisplayMode/MarginContainer2/displayButton
@onready var brightness_slider: HSlider = $settingsContainer/VBoxContainer/TabContainer/Display/DisplayTab/HBoxContainer/Brightness/MarginContainer2/brightnessSlider
@onready var volume_slider: HSlider = $"settingsContainer/VBoxContainer/TabContainer/Audio/AudioTab/HBoxContainer/Volume Level/MarginContainer2/volumeSlider"
@onready var music_button: CheckButton = $settingsContainer/VBoxContainer/TabContainer/Audio/AudioTab/HBoxContainer/Music/MarginContainer2/musicButton
@onready var sfx_button: CheckButton = $settingsContainer/VBoxContainer/TabContainer/Audio/AudioTab/HBoxContainer/SFX/MarginContainer2/sfxButton
@onready var ambience_button: CheckButton = $settingsContainer/VBoxContainer/TabContainer/Audio/AudioTab/HBoxContainer/Ambience/MarginContainer2/ambienceButton

@onready var settings_container: MarginContainer = $settingsContainer
@onready var save_screen: Panel = $saveScreen
@onready var display_tab: TabBar = $settingsContainer/VBoxContainer/TabContainer/Display/DisplayTab
@onready var return_to_menu: Button = $settingsContainer/VBoxContainer/TabContainer/Display/DisplayTab/HBoxContainer/MenuCont/returnToMenu
@onready var imminent_menu_exit := false

var unsavedDisplay : int
var unsavedBrightness : float
var unsavedVolume : float
var unsavedMusic : bool
var unsavedAmbience : bool
var unsavedSFX : bool
var user_saved : bool = true


func _ready() -> void:
	# initialize settings 
	var video_settings = ConfigFileHandler.load_video_settings()
	brightness_slider.value = video_settings.get("brightness", 1.05)
	display_button.select(video_settings["fullscreen"])
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	volume_slider.value = audio_settings["volume_slider"]
	sfx_button.button_pressed = audio_settings["sfx_toggle"]
	ambience_button.button_pressed = audio_settings["ambience_toggle"]
	music_button.button_pressed = audio_settings["music_toggle"]

	unsavedBrightness = brightness_slider.value
	unsavedDisplay = display_button.get_selected()

	unsavedVolume = volume_slider.value
	unsavedSFX = sfx_button.button_pressed
	unsavedAmbience = ambience_button.button_pressed
	unsavedMusic = music_button.button_pressed
	
	var progress_settings = ConfigFileHandler.load_progress_settings()
	HUD.has_quest = progress_settings["has_quest"]
	HUD.has_side = progress_settings["has_side"]
	HUD.current_quest = progress_settings["current_quest"]
	HUD.current_side = progress_settings["current_side"]
	HUD.quest_reach_cave = progress_settings["quest_reach_cave"]
	HUD.quest_find_fossils = progress_settings["quest_find_fossils"]
	HUD.quest_found_fossils = progress_settings["quest_found_fossils"]
	HUD.quest_fossils_list = progress_settings["quest_fossils_list"]
	HUD.quest_reach_museum = progress_settings["quest_reach_museum"]
	HUD.quest_finish_assembly = progress_settings["quest_finish_assembly"]
	HUD.quest_finish_ID = progress_settings["quest_finish_ID"]
	HUD.quest_submit = progress_settings["quest_submit"]
	HUD.quest_trex_ID = progress_settings["quest_trex_ID"]
	HUD.quest_trex_submit = progress_settings["quest_trex_submit"]
	HUD.quest_anky_ID = progress_settings["quest_anky_ID"]
	HUD.quest_anky_submit = progress_settings["quest_anky_submit"]
	HUD.quest_mame_ID = progress_settings["quest_mame_ID"]
	HUD.quest_mame_submit = progress_settings["quest_mame_submit"]
	HUD.quest_pter_ID = progress_settings["quest_pter_ID"]
	HUD.quest_pter_submit = progress_settings["quest_pter_submit"]
	HUD.trex_tweened = progress_settings["trex_tweened"]
	HUD.anky_tweened = progress_settings["anky_tweened"]
	HUD.mame_tweened = progress_settings["mame_tweened"]
	HUD.pter_tweened = progress_settings["pter_tweened"]
	HUD.quest_reach_shop = progress_settings["quest_reach_shop"]
	HUD.quest_bought_item = progress_settings["quest_bought_item"]
	HUD.quest_customized = progress_settings["quest_customized"]
	HUD.quest_shop_submit = progress_settings["quest_shop_submit"]
	HUD.quest_reach_home = progress_settings["quest_reach_home"]
	HUD.quest_put_furniture = progress_settings["quest_put_furniture"]
	HUD.quest_home_submit = progress_settings["quest_home_submit"]
	HUD.quest_side_submit = progress_settings["quest_side_submit"]
	HUD.current_location_node = progress_settings["current_location_node"]
	HUD.current_location_name = progress_settings["current_location_name"]
	
	var tutorial_settings = ConfigFileHandler.load_tutorial_settings()
	Tutorial.selected_tutorial = tutorial_settings["selected_tutorial"]
	Tutorial.first_move = tutorial_settings["first_move"]
	Tutorial.accepted_quest = tutorial_settings["accepted_quest"]
	Tutorial.made_exit_first = tutorial_settings["made_exit_first"]
	Tutorial.sprint_first = tutorial_settings["sprint_first"]
	Tutorial.sniff_first = tutorial_settings["sniff_first"]
	Tutorial.over_sniffed_spot = tutorial_settings["over_sniffed_spot"]
	Tutorial.interacted_spot = tutorial_settings["interacted_spot"]
	Tutorial.interest_node = tutorial_settings["interest_node"]
	Tutorial.side_node = tutorial_settings["side_node"]
	
	var inventory_settings = ConfigFileHandler.load_inventory_settings()
	InventoryCanvasLayer.styles = inventory_settings["bought_wearables"]
	InventoryCanvasLayer.unused_styles = inventory_settings["unbought_wearables"]
	InventoryCanvasLayer.kiri_style = inventory_settings["current_wearable"]
	InventoryCanvasLayer.bought_items = inventory_settings["bought_items"]
	InventoryCanvasLayer.furniture = inventory_settings["furniture"]
	InventoryCanvasLayer.inventory_list = inventory_settings["inventory_list"]
	for item in InventoryCanvasLayer.inventory_list.values():
		print(item)
		InventoryCanvasLayer.inventory.add_item(item[0], item[1], "Items")
	InventoryCanvasLayer.gem_count = inventory_settings["gem_count"]
	
	user_saved = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return_to_menu.visible = HUD.playing_game

func save_settings() -> void:
	ConfigFileHandler.save_video_setting("fullscreen", unsavedDisplay)
	ConfigFileHandler.save_video_setting("brightness", unsavedBrightness)
	
	ConfigFileHandler.save_audio_setting("volume_slider", unsavedVolume)
	ConfigFileHandler.save_audio_setting("sfx_toggle", unsavedSFX)
	ConfigFileHandler.save_audio_setting("ambience_toggle", unsavedAmbience)
	ConfigFileHandler.save_audio_setting("music_toggle", unsavedMusic)
	
	ConfigFileHandler.save_progress_setting("has_quest", HUD.has_quest)
	ConfigFileHandler.save_progress_setting("has_side", HUD.has_side)
	ConfigFileHandler.save_progress_setting("current_quest", HUD.current_quest)
	ConfigFileHandler.save_progress_setting("current_side", HUD.current_side)
	ConfigFileHandler.save_progress_setting("quest_reach_cave", HUD.quest_reach_cave)
	ConfigFileHandler.save_progress_setting("quest_find_fossils", HUD.quest_find_fossils)
	ConfigFileHandler.save_progress_setting("quest_found_fossils", HUD.quest_found_fossils)
	ConfigFileHandler.save_progress_setting("quest_fossils_list", HUD.quest_fossils_list)
	ConfigFileHandler.save_progress_setting("quest_reach_museum", HUD.quest_reach_museum)
	ConfigFileHandler.save_progress_setting("quest_finish_assembly", HUD.quest_finish_assembly)
	ConfigFileHandler.save_progress_setting("quest_finish_ID", HUD.quest_finish_ID)
	ConfigFileHandler.save_progress_setting("quest_submit", HUD.quest_submit)
	ConfigFileHandler.save_progress_setting("quest_trex_ID", HUD.quest_trex_ID)
	ConfigFileHandler.save_progress_setting("quest_trex_submit", HUD.quest_trex_submit)
	ConfigFileHandler.save_progress_setting("quest_anky_ID", HUD.quest_anky_ID)
	ConfigFileHandler.save_progress_setting("quest_anky_submit", HUD.quest_anky_submit)
	ConfigFileHandler.save_progress_setting("quest_mame_ID", HUD.quest_mame_ID)
	ConfigFileHandler.save_progress_setting("quest_mame_submit", HUD.quest_mame_submit)
	ConfigFileHandler.save_progress_setting("quest_pter_ID", HUD.quest_pter_ID)
	ConfigFileHandler.save_progress_setting("quest_pter_submit", HUD.quest_pter_submit)
	ConfigFileHandler.save_progress_setting("trex_tweened", HUD.trex_tweened)
	ConfigFileHandler.save_progress_setting("anky_tweened", HUD.anky_tweened)
	ConfigFileHandler.save_progress_setting("mame_tweened", HUD.mame_tweened)
	ConfigFileHandler.save_progress_setting("pter_tweened", HUD.pter_tweened)
	ConfigFileHandler.save_progress_setting("quest_reach_shop", HUD.quest_reach_shop)
	ConfigFileHandler.save_progress_setting("quest_bought_item", HUD.quest_bought_item)
	ConfigFileHandler.save_progress_setting("quest_customized", HUD.quest_customized)
	ConfigFileHandler.save_progress_setting("quest_shop_submit", HUD.quest_shop_submit)
	ConfigFileHandler.save_progress_setting("quest_reach_home", HUD.quest_reach_home)
	ConfigFileHandler.save_progress_setting("quest_put_furniture", HUD.quest_put_furniture)
	ConfigFileHandler.save_progress_setting("quest_home_submit", HUD.quest_home_submit)
	ConfigFileHandler.save_progress_setting("quest_side_submit", HUD.quest_side_submit)
	ConfigFileHandler.save_progress_setting("current_location_node", HUD.current_location_node)
	ConfigFileHandler.save_progress_setting("current_location_name", HUD.current_location_name)
	
	ConfigFileHandler.save_tutorial_setting("selected_tutorial", Tutorial.selected_tutorial)
	ConfigFileHandler.save_tutorial_setting("first_move", Tutorial.first_move)
	ConfigFileHandler.save_tutorial_setting("accepted_quest", Tutorial.accepted_quest)
	ConfigFileHandler.save_tutorial_setting("made_exit_first", Tutorial.made_exit_first)
	ConfigFileHandler.save_tutorial_setting("sprint_first", Tutorial.sprint_first)
	ConfigFileHandler.save_tutorial_setting("sniff_first", Tutorial.sniff_first)
	ConfigFileHandler.save_tutorial_setting("over_sniffed_spot", Tutorial.over_sniffed_spot)
	ConfigFileHandler.save_tutorial_setting("interacted_spot", Tutorial.interacted_spot)
	ConfigFileHandler.save_tutorial_setting("interest_node", Tutorial.interest_node)
	ConfigFileHandler.save_tutorial_setting("side_node", Tutorial.side_node)
	
	ConfigFileHandler.save_inventory_setting("bought_wearables", InventoryCanvasLayer.styles)
	ConfigFileHandler.save_inventory_setting("unbought_wearables", InventoryCanvasLayer.unused_styles)
	ConfigFileHandler.save_inventory_setting("current_wearable", InventoryCanvasLayer.kiri_style)
	ConfigFileHandler.save_inventory_setting("bought_items", InventoryCanvasLayer.bought_items)
	ConfigFileHandler.save_inventory_setting("furniture", InventoryCanvasLayer.furniture)
	ConfigFileHandler.save_inventory_setting("inventory_list", InventoryCanvasLayer.inventory_list)
	ConfigFileHandler.save_inventory_setting("gem_count", InventoryCanvasLayer.gem_count)
	
	user_saved = true
	
# Apply the last saved properties from our ConFigFileHandler
func revert_settings() -> void:
	_ready()

func show_save_screen()-> void:
	settings_container.visible = false
	save_screen.visible = true

func _on_brightness_slider_value_changed(value: float) -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = value
	user_saved = false
	unsavedBrightness = value

func _on_display_button_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	unsavedDisplay = index
	user_saved = false
		
func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
	unsavedVolume = value 
	user_saved = false

func _on_music_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), 0.0)
	else:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), 0.5)
		
	unsavedMusic = toggled_on
	user_saved = false

func _on_sfx_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), 0.0)

	else:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), 0.5)
	
	unsavedSFX = toggled_on
	user_saved = false

func _on_ambience_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Ambience"), 0.0)
		
	else:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Ambience"), 0.5)
	
	unsavedAmbience = toggled_on
	user_saved = false
