extends Panel

signal place_an_item(String)

@onready var bin: TextureRect = $Bin
@onready var item_grid_container: GridContainer = $"MarginContainer/VBoxContainer/HBoxInventory&profile/ItemInventory/GridContainer"
@onready var custom_grid_container: GridContainer = $"MarginContainer/VBoxContainer/HBoxInventory&profile/CustomInventory/GridContainer"
#@onready var item: Control = $"ItemMarginContainer/VBoxContainer/HBoxInventory&profile/Inventory/GridContainer/Panel/item"
@onready var description: Label = $"MarginContainer/VBoxContainer/HBoxDescrip&Notes/Panel/Description"
#@onready var item_panel: Panel = $"ItemMarginContainer/VBoxContainer/HBoxInventory&profile/Inventory/GridContainer/Panel"
@onready var current_tab := "Items" #All possible tabs: "Items", "Customizables"
@onready var item_inventory: Panel = $"MarginContainer/VBoxContainer/HBoxInventory&profile/ItemInventory" #The items tab.
@onready var custom_inventory: Panel = $"MarginContainer/VBoxContainer/HBoxInventory&profile/CustomInventory" #The customizables tab.
@onready var item_tab_button: Button = $ItemTabButton #Items tab button
@onready var custom_tab_button: Button = $CustomTabButton #Custom tabs button

@onready var funds: Label = $"MarginContainer/VBoxContainer/HBoxDescrip&Notes/MarginContainer/MarginContainer/HBoxContainer/Funds"
@onready var thoughts: Label = $"MarginContainer/VBoxContainer/HBoxDescrip&Notes/MarginContainer/MarginContainer/HBoxContainer/Thoughts"
@onready var total_fossil_count: Label = $"MarginContainer/VBoxContainer/HBoxDescrip&Notes/MarginContainer/MarginContainer/HBoxContainer/Total Fossil Count"

@onready var scene_customization: Control = $MarginContainer/sceneCustomization
@onready var inventory: VBoxContainer = $MarginContainer/VBoxContainer
@onready var decorations: Control = $Decorations

@onready var profile_pic: TextureRect = $"MarginContainer/VBoxContainer/HBoxInventory&profile/Profile/profilePic"
var grey_closeUp = preload("res://assets/gfx/placeholder_mark/closeUpKiri.png")
var partyHat_closeUp = preload("res://assets/gfx/placeholder_mark/greyKiri_partyHat_closeUp.png")
var topHat_closeUp = preload("res://assets/gfx/placeholder_mark/greyKiri_topHat_closeUp.png")
var pink_closeUp = preload("res://assets/gfx/placeholder_mark/pinkKiri_closeUp.png")
var brown_closeUp = preload("res://assets/gfx/placeholder_mark/brownKiri_closeUp.png")

var fossil_count : int
var gem_count : int

var thoughts_timer = 0.0
var thoughts_cycle = 15.0
var thoughts_list = [
	"Hi Hooman!",
	"I wonder what the sun taste like...",	
	"Where am I?",
	"Chicken...",
	"GRrRrR",
	"I want food",
	"Yesterday, I... I forgor",
	
	"The first palm tree...
	On the blue star...
	treasure!!!",
	
	"World domination",
	"I demands pats!",
	
]

var thoughts_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fossil_count = 0
	gem_count = 0
	total_fossil_count.text = "Total Fossil Found : " + str(fossil_count)
	funds.text = "Gems : " + str(gem_count)
	update_label("thoughts", thoughts_list[thoughts_index])
	#Commented out b/c: assume the inventory is empty by default
	#if item != null:
		#description.text = item.item_data.description
	
	#Commented out b/c: if assuming the inventory is empty by default, there's no iterms to check
	#for slot in grid_container.get_children():
		#if slot.get_child_count() > 0:
			#var item = slot.get_child(0)
			#if item.has_signal("item_clicked"):
				#item.item_clicked.connect(_on_item_clicked)
	
	scene_customization.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	description.text = InventoryCanvasLayer.selected_item_desc
	thoughts_timer += _delta
	if thoughts_timer >= thoughts_cycle:
		thoughts_timer = 0.0
		update_label("thoughts", thoughts_list[thoughts_index])
		thoughts_index = (thoughts_index + 1) % thoughts_list.size()
		
#Commented out b/c: original signal system only worked for the first added item clicked on;
#subsequent added items clicked on could not have their descriptions displayed as the first added item's description overrid it.
#func _on_item_clicked(item_description):
	#item_description.text = item_description

# Updates contents (funds, total fossil, and thoughts)
func update_label(labelN : String, content) -> void:	
	match labelN:
		"totalFossil":
			fossil_count += content
			total_fossil_count.text = "Total Fossil Found : " + str(fossil_count)
		"thoughts":
			thoughts.text = "Thoughts: " + content
		"gems":
			gem_count += content
			funds.text = "Gems : " + str(gem_count)
			
func _on_quit_pressed() -> void:
	InventoryCanvasLayer.selected_item_desc = ""
	self.visible = false
	create_tween().tween_property(HUD.tutorial_arrow, "modulate:a", 0, 0.2)

func add_item(item_data, count, sent_tab): #Add an item count times to the sent_tab of the player's inventory.
	HUD.inventory_just_changed = true
	var cur_container : GridContainer # Ensure the correct tab's grid container is being checked.
	match sent_tab:
		"Items": cur_container = item_grid_container
		"Customizables": cur_container = custom_grid_container
	
	for slot in cur_container.get_children():
		if slot.get_child_count() == 1: # If the space already has an item...
			var existing_item = slot.get_child(0)
			if item_data.item_name == existing_item.item_name: #And if there is a matching name...
				existing_item.count_count += count #Increment the count the appropriate number of times
				InventoryCanvasLayer.inventory_list[item_data.item_name] = [item_data, existing_item.count_count]
				return
		if slot.get_child_count() == 0: # If no item exists in a space, then add the item to the space.
			# Instance a new item scene
			var item_scene = preload("res://scenes/item.tscn").instantiate()
			item_scene.item_data = item_data
			item_scene.count_count = count
			slot.add_child(item_scene)
			InventoryCanvasLayer.inventory_list[item_data.item_name] = [item_data, count]
			return

func remove_item(remove_name, count, sent_tab): #Remove an item count times from the sent_tab of the player's inventory.
	var cur_container : GridContainer # Ensure the correct tab's grid container is being checked.
	match sent_tab:
		"Items": cur_container = item_grid_container
		"Customizables": cur_container = custom_grid_container
	
	for slot in cur_container.get_children():
		if slot.get_child_count() == 1: # If the space already has an item...
			var existing_item = slot.get_child(0)
			if remove_name == existing_item.item_name: #And if there is a matching name...
				existing_item.count_count -= count #Decrease the count the appropriate number of times
				InventoryCanvasLayer.inventory_list[remove_name][1] = existing_item.count_count
				if existing_item.count_count == 0: #If this completely depletes the item, remove it.
					existing_item.queue_free()
					InventoryCanvasLayer.inventory_list.erase(remove_name)
				return

#Change the current tab to the Items tab.
func _on_item_tab_button_pressed() -> void:
	item_tab_button.button_pressed = true
	custom_tab_button.button_pressed = false
	
	current_tab = "Items"
	scene_customization.visible = false
	inventory.visible = true
	decorations.visible = true
	InventoryCanvasLayer.selected_item_desc = ""
	
#Change the current tab to the customizables tab.
func _on_custom_tab_button_pressed() -> void:
	custom_tab_button.button_pressed = true
	item_tab_button.button_pressed = false 
	
	current_tab = "Customizables"
	scene_customization.visible = true
	scene_customization.apply_current_style()
	inventory.visible = false
	decorations.visible = false

#Place furniture down.
func place_item(item : Control):
	name = item.item_data.item_name
	print(name)
	print(InventoryCanvasLayer.furniture)
	if InventoryCanvasLayer.furniture.has(name):
		if HUD.current_location_name == "home":
			emit_signal("place_an_item", name)
			remove_item(name, 1, "Items")
			AudioPlayer.play_sound("victory_2")
			if HUD.quest_reach_home:
				HUD.quest_put_furniture = true
				HUD.quest_button.just_changed = true if (HUD.quest_put_furniture and !HUD.quest_button.just_changed) else HUD.quest_button.just_changed

func _update_profilePic(style_name: String):
	match style_name:
		"pink":
			profile_pic.texture = pink_closeUp  
		"brown":
			profile_pic.texture = brown_closeUp
		"grey":
			profile_pic.texture = grey_closeUp
		"topHat":
			profile_pic.texture = topHat_closeUp
		"partyHat":
			profile_pic.texture = partyHat_closeUp
