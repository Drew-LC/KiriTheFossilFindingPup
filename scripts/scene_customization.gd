extends Control
@onready var style_name: Label = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/Panel/MarginContainer/VBoxContainer/HBoxContainer/styleName
@onready var default_prev: AnimatedSprite2D = $MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/Panel/defaultPrev
@onready var front_prev: AnimatedSprite2D = $MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Panel3/frontPrev
@onready var back_prev: AnimatedSprite2D = $MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Panel4/backPrev

const museum_scene = preload("res://scenes/museum.tscn")

var entry : Dictionary
var current_frame : SpriteFrames 
var current_style : String = "grey"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_current_style()
	
func _on_prev_butotn_pressed() -> void:
	_change_style(-1)

func _on_next_button_pressed() -> void:
	_change_style(1)

func apply_current_style():
	current_frame = InventoryCanvasLayer.kiri_style
	for style in InventoryCanvasLayer.styles:
		if style["frame"] == current_frame:
			current_frame = style["frame"]
			current_style = style["name"]
	
	default_prev.sprite_frames = current_frame
	front_prev.sprite_frames = current_frame
	back_prev.sprite_frames = current_frame
	
	style_name.text = current_style

	default_prev.play("default")
	front_prev.play("walkDown")
	back_prev.play("walkUp")
	
func _change_style(direction : int):
	var styles = InventoryCanvasLayer.styles
	var current_index = InventoryCanvasLayer.current_style_index
	current_index = (current_index + direction + styles.size()) % styles.size()
	InventoryCanvasLayer.current_style_index = current_index

	entry = InventoryCanvasLayer.styles[current_index]
	current_frame = entry["frame"]
	current_style = entry["name"]
	
	print("We are changing style: ", current_style)

	default_prev.sprite_frames = current_frame
	front_prev.sprite_frames = current_frame
	back_prev.sprite_frames = current_frame
	
	style_name.text = current_style

	default_prev.play("default")
	front_prev.play("walkDown")
	back_prev.play("walkUp")
		
func _on_confirm_button_pressed() -> void:
	var current_index = InventoryCanvasLayer.current_style_index
	entry = InventoryCanvasLayer.styles[current_index]
	current_frame = entry["frame"]
	current_style = entry["name"]
	
	InventoryCanvasLayer.kiri_style = current_frame
	InventoryCanvasLayer.inventory._update_profilePic(current_style)
	if !InventoryCanvasLayer.bought_items.has(current_style):
		InventoryCanvasLayer.bought_items.append(current_style)
	
	# If the game is just being initialized, remove the remaining styles 
	# accordingly after the initial customization scene. 
	if InventoryCanvasLayer.init_customization:
		var new_styles : Array[Dictionary]
		var removed_styles : Array[Dictionary]
		var removed_keys : Array
		
		# remove all other styles except for the one chosen and the default
		for styleEntry in InventoryCanvasLayer.styles:
			if (styleEntry["name"] == current_style):
				new_styles.append(styleEntry)
			else:
				removed_styles.append(styleEntry)
		
		InventoryCanvasLayer.styles = new_styles
		InventoryCanvasLayer.unused_styles = removed_styles
		
		# remove this style from the shop
		InventoryCanvasLayer.bought_items.append(entry["shop"])
		InventoryCanvasLayer.init_customization = false
		
		InventoryCanvasLayer.current_style_index = 0
		
	if !HUD.playing_game:
		HUD.playing_game = true
		NaviationManager._change_scene(museum_scene, "skull")
	else:
		AudioPlayer.play_sound("victory_2")
		if HUD.quest_bought_item:
			HUD.quest_customized = true #UPDATE TO KEEP TRACK OF DIFFERENCE
			HUD.quest_button.just_changed = true if (HUD.quest_customized and !HUD.quest_button.just_changed) else HUD.quest_button.just_changed
		InventoryCanvasLayer.inventory.visible = false
