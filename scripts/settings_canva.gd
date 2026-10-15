extends CanvasLayer

@onready var settings: Control = $Settings
@onready var settings_container: MarginContainer = $Settings/settingsContainer
@onready var save_screen: Panel = $Settings/saveScreen
const menu_scene = preload("res://scenes/start_menu.tscn")

func _ready() -> void:
	self.visible = false
	
func _input(event): 
	if event.is_action_pressed("quit") and !InventoryCanvasLayer.inventory.visible and !ReferencePage.reference_page.visible:
		if self.visible:
			_on_exit_button_pressed()
		else:
			self.visible = true

# Saves the Game Settings. 
func _on_save_button_pressed() -> void:
	settings.save_settings()
	self.visible = false # To make more intuitive that the settings are already saved. 
	
# Leaves the Game Setting. Will prompt the user to save if the change is unsaved. 
func _on_exit_button_pressed() -> void:
	if settings.user_saved:
		self.visible = false
	else:
		settings.show_save_screen()

func _on_yes_button_pressed() -> void:
	settings.save_settings()
	_close_save_screen()

func _on_no_button_pressed() -> void:
	settings.revert_settings()
	_close_save_screen()

func _close_save_screen():
	save_screen.visible = false
	settings_container.visible = true
	self.visible = false
	if settings.imminent_menu_exit:
		settings.imminent_menu_exit = false
		NaviationManager._change_scene(menu_scene, "skull")

func _on_return_to_menu_pressed() -> void:
	settings.imminent_menu_exit = true
	settings.show_save_screen()
