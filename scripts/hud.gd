extends CanvasLayer

# * Global variables keeping track of the game state. *

# Keep track of the player's quest. (This is the quest system)=
var has_quest := false #Is the player currently in a main quest?
var has_side := false #Is the player currently in a side quest?
var current_quest : String #What main quest is the player in?
var current_side : String #What side quest is the player in?

var quest_reach_cave := false #Afterwards, did the player enter the right cave?
var quest_find_fossils := false #Afterwards, did the player find all of the fossils?
var quest_found_fossils : int #How many fossils did the player find?
var quest_fossils_list := [] #Array of player's findable fossils.
var quest_reach_museum := false #Afterwards, did the player return to the museum?
var quest_finish_assembly := false #Afterwards, did the player finish the assembly mini-game?
var quest_finish_ID := false #Afterwards, did the player fill out the ID sheet?
var quest_submit := false #Did the player submit this quest?
var quest_trex_ID := false #Did the player fill out the ID sheet for this dinosaur at least once?
var quest_trex_submit := false #Did the player submit this quest?
var quest_anky_ID := false #Did the player fill out the ID sheet for this dinosaur at least once?
var quest_anky_submit := false #Did the player submit this quest?
var quest_mame_ID := false #Did the player fill out the ID sheet for this dinosaur at least once?
var quest_mame_submit := false #Did the player submit this quest?
var quest_pter_ID := false #Did the player fill out the ID sheet for this dinosaur at least once?
var quest_pter_submit := false #Did the player submit this quest?
var max_trex_fossils := 5 #Total number of findable fossils.
var max_anky_fossils := 7
var max_mame_fossils := 6
var max_pter_fossils := 5

var trex_tweened : bool = false
var anky_tweened : bool = false
var mame_tweened : bool = false
var pter_tweened : bool = false

var quest_reach_shop := false #Did the player reach the blacksmith?
var quest_bought_item := false #Did the player buy any hat/furniture from the blacksmith?
var quest_customized := false #Did the player customize Kiri using the bought hat?
var quest_shop_submit := false #Did the player submit this quest?
var quest_reach_home := false #Did the player reach Kiri's home?
var quest_put_furniture := false #Did the player put furniture in Kiri's home?
var quest_home_submit := false #Did the player submit this quest?
var quest_side_submit := false #Did the player submit this quest?

# Keep track of the player's stats.
var playing_game := false #Is the player beyond the start screen?
var current_location_node : Node2D #The node of the location is the player currently at
var current_location_name : String #The name of the location is the player currently at
var in_shop := false #Is the player in the shop?
var in_quest_board := false #Is the player on the quest board?
var in_assembly := false #Is the player looking at the assembly mini-game?
var in_ID_sheet := false #Is the player looking at the ID sheet?
var in_video := false #Is the player looking at the video animation?
var given_destination : String #Given "destination_level_tag"
var given_door : String #Given "destination_door_tag"
var not_leaving_yet := false #Did the player click No on the confirm screen upon trying to leave a dig site while not having found all of the quest's fossils yet?

# Node variables.
@onready var menu_button: TextureButton = $HSplitContainer/MenuButton
@onready var menu_key: AnimatedSprite2D = $HSplitContainer/MenuButton/AnimatedSprite2D
@onready var inventory_button: TextureButton = $HSplitContainer/InventoryButton
@onready var inventory_just_changed := false
@onready var inventory_exclaimation_mark: Sprite2D = $HSplitContainer/InventoryButton/ExclaimationMark
@onready var inventory_key: AnimatedSprite2D = $HSplitContainer/InventoryButton/AnimatedSprite2D
@onready var notebook_button: TextureButton = $HSplitContainer/NotebookButton
@onready var notebook_key: AnimatedSprite2D = $HSplitContainer/NotebookButton/AnimatedSprite2D
@onready var quest_button: TextureButton = $HSplitContainer/QuestButton
@onready var confirm_screen: Panel = $ConfirmScreen
@onready var sub_viewport_container: SubViewportContainer = $Radar/SubViewportContainer
@onready var tutorial_arrow: TextureRect = $HSplitContainer/InventoryButton/TutorialArrow
@onready var arrow_appear_once := false
@onready var keyboard: AnimatedSprite2D = $Radar/Keyboard
@onready var screen_zoom := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = false if (SelectTools.in_fossil_minigame or !playing_game) else true
	
	menu_button.button_pressed = true if Settings.visible else false
	menu_key.frame = 1 if menu_button.button_pressed else 0
	
	inventory_button.button_pressed = true if InventoryCanvasLayer.inventory.visible else false
	inventory_key.frame = 1 if inventory_button.button_pressed else 0
	update_inventory_notif()
	
	notebook_button.button_pressed = true if ReferencePage.reference_page.visible else false
	notebook_key.frame = 1 if notebook_button.button_pressed else 0
	
	has_quest = (current_quest != "") #If current_quest is not empty, the player has_quest
	has_side = (current_side != "") #If current_side is not empty, the player has_side
	
	if quest_submit: #Once a quest is done, reset most variables. (make sure ID sheet being filled out once for each dinosaur is still marked as true)
		quest_submit = false
		#match current_quest: #commented out in case we don't want replayable quests
			#"trex": quest_trex_submit = false
			#"shop": quest_shop_submit = false
			#"home": quest_home_submit = false
			#"anky": quest_anky_submit = false
			#"mame": quest_mame_submit = false
			#"pter": quest_pter_submit = false
		current_quest = ""
		quest_reach_cave = false
		quest_find_fossils = false
		quest_found_fossils = false
		quest_fossils_list = []
		quest_reach_museum = false
		quest_finish_ID = false
		quest_finish_assembly = false
	if quest_side_submit:
		quest_side_submit = false
		current_side = ""
		quest_reach_shop = false
		quest_bought_item = false
		quest_customized = false
		quest_reach_home = false
		quest_put_furniture = false
		arrow_appear_once = false
	
	match HUD.current_side:
		"shop":
			if HUD.quest_bought_item and !arrow_appear_once:
				arrow_appear_once = true
				create_tween().tween_property(tutorial_arrow, "modulate:a", 1, 0.2)
		"home":
			if HUD.quest_reach_home and !arrow_appear_once:
				arrow_appear_once = true
				create_tween().tween_property(tutorial_arrow, "modulate:a", 1, 0.2)
	
	if (HUD.current_location_name == "crystal_cave" or HUD.current_location_name == "sandy_beach") and Tutorial.sniff_first:
		create_tween().tween_property(keyboard, "modulate:a", 1, 0.2)
		keyboard.play()
	else:
		create_tween().tween_property(keyboard, "modulate:a", 0, 0.2)
		keyboard.stop()

#Update the inventory button's notification icon appropriately.
func update_inventory_notif() -> void:
	if inventory_just_changed:
		inventory_just_changed = false
		inventory_exclaimation_mark.visible = true

# Make the settings appear.
func _on_menu_button_pressed() -> void:
	if !Settings.visible: Settings.visible = true

# Make the inventory appear.
func _on_inventory_button_pressed() -> void:
	if !InventoryCanvasLayer.inventory.visible: InventoryCanvasLayer.inventory.visible = true
	InventoryCanvasLayer.inventory._on_item_tab_button_pressed()
	
# Make the notebook appear.
func _on_notebook_button_pressed() -> void:
	if !ReferencePage.reference_page.visible: ReferencePage.reference_page.visible = true

# Confirm screen options upon exiting a dig site without finding all the fossils first.
func _on_yes_button_pressed() -> void:
	NaviationManager.go_to_level(given_destination, given_door)
	not_leaving_yet = false
	create_tween().tween_property(confirm_screen, "scale", Vector2(0.0, 0.0), screen_zoom).set_trans(Tween.TRANS_SINE)

func _on_no_button_pressed() -> void:
	not_leaving_yet = true
	create_tween().tween_property(confirm_screen, "scale", Vector2(0.0, 0.0), screen_zoom).set_trans(Tween.TRANS_SINE)
