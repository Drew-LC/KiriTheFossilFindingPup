extends CanvasLayer

@onready var inventory: Control = $inventory
@onready var selected_item_desc := ""
var gem_count := 0
@onready var in_shop := false
var inventory_list := {}

var enable : bool = false
var bought_items : Array
var init_customization : bool = true 
@onready var current_style_index : int = 0 
var current_style

var unused_styles := []
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

var kiri_style : SpriteFrames = preload("res://assets/styles/sprite_frame_grey.tres")
var furniture : Dictionary = {}

func _ready() -> void:
	enable = true

func _input(event): 
	if event.is_action_pressed("inventory"):
		if !SelectTools.in_fossil_minigame and !Settings.visible and !ReferencePage.reference_page.visible and !in_shop:
			if !in_shop and HUD.playing_game:
				if inventory.visible:
					inventory.visible = false
				else:
					inventory.visible = true
					inventory._on_item_tab_button_pressed()
					HUD.inventory_exclaimation_mark.visible = false #Disable the notification.
					create_tween().tween_property(HUD.tutorial_arrow, "modulate:a", 0, 0.2)
	
	elif event.is_action_pressed("quit") and inventory.visible:
		inventory.visible = false

func _update_styles(shop_name : String):
	for style in unused_styles:
		
		if style["shop"] == shop_name:
			styles.append(style)
			unused_styles.erase(style)
	
