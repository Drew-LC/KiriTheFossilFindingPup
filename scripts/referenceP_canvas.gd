extends CanvasLayer
@onready var reference_page: Control = $referencePage
var enable: bool 

func _ready() -> void:
	enable = true

func _input(event): 
	if Input.is_action_just_pressed("referencePage"): 
		if !InventoryCanvasLayer.inventory.visible and !SelectTools.in_fossil_minigame:
			if !Settings.visible and HUD.playing_game:
				if reference_page.visible:
					reference_page.visible = false
				else:
					reference_page.visible = true
	
	elif Input.is_action_just_pressed("quit") and reference_page.visible:
		reference_page.visible = false
		get_viewport().set_input_as_handled()
		
func _on_exit_button_pressed() -> void:
	reference_page.visible = false
	print("BUTTON PRESSED")
