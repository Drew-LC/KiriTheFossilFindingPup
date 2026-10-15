extends Control
signal shop_quit

#Onready variables for the nodes.
@onready var wear_grid: GridContainer = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/WearGrid
@onready var furniture_grid: GridContainer = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/FurnitureGrid
@onready var wear_button: Button = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Wearables
@onready var furniture_button: Button = $HBoxContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Furniture
@onready var item_name: Label = $HBoxContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/Name
@onready var item_description: Label = $HBoxContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/Description
@onready var item_cost: Label = $HBoxContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/Cost
@onready var comment: Label = $HBoxContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Comment
@onready var buy_button: Button = $HBoxContainer/VBoxContainer/Description/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Buy
@onready var otes: AnimatedSprite2D = $HBoxContainer/Shopkeeper/AnimatedSprite2D

#Variables keeping track of a currently selected item.
@onready var selected_item : TextureRect
@onready var selected_data : ItemData
@onready var selected_name : String
@onready var selected_cost : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Iterates through the shop screen's pre-defined items to recieve their respective signals.
	for panel in wear_grid.get_children():
		var current_item = panel.get_child(0)
		if name_already_bought(current_item.item_data.item_name, InventoryCanvasLayer.bought_items): #If a pre-defined item is already bought, it is removed.
			current_item.queue_free()
			continue
		current_item.selected_shop_item.connect(update_description)
	for panel in furniture_grid.get_children():
		var current_item = panel.get_child(0)
		if name_already_bought(current_item.item_data.item_name, InventoryCanvasLayer.bought_items): #If a pre-defined item is already bought, it is removed.
			current_item.queue_free()
			continue
		current_item.selected_shop_item.connect(update_description)
	otes.play()

# Checks if the currently checked item is already bought.
func name_already_bought(checked_name : String, bought_names : Array) -> bool:
	for a_name in bought_names:
		if checked_name == a_name:
			return true
	return false

#Updates the shop's descriptions to match the current selected item's info.
func update_description(clicked_item : TextureRect, shop_item_data : ItemData) -> void:
	selected_item = clicked_item #STORES THE SELECTED ITEM NODE
	selected_data = shop_item_data #STORES THE SELECTED ITEM'S ITEMDATA
	buy_button.disabled = false
	item_name.text = shop_item_data.item_name
	selected_name = shop_item_data.item_name
	item_description.text = shop_item_data.description
	item_cost.text = "Cost: " + str(shop_item_data.gem_cost) + " Gems"
	selected_cost = shop_item_data.gem_cost

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if selected_item != null: #Ensures an item needs to be selected
		buy_button.disabled = false
	else:
		buy_button.disabled = true

func clear_description() -> void: #Empty the description box.
	item_name.text = ""
	item_description.text = ""
	item_cost.text = ""

func _on_wearables_pressed() -> void: #Switch to wearables tab.
	wear_grid.visible = true
	furniture_grid.visible = false
	furniture_button.button_pressed = false
	selected_item = null
	wear_button.disabled = true
	furniture_button.disabled = false
	clear_description()

func _on_furniture_pressed() -> void: #Switch to furniture tab.
	wear_grid.visible = false
	furniture_grid.visible = true
	wear_button.button_pressed = false
	selected_item = null
	wear_button.disabled = false
	furniture_button.disabled = true
	clear_description()

func _on_buy_pressed() -> void: #Buy the selected item.
	if selected_cost > InventoryCanvasLayer.gem_count: #If the cost of gems exceeds the player's count, then deny the purchase.
		comment.text = "Not enough gems!"
		await get_tree().create_timer(2).timeout #After 2 seconds, empty it.
		comment.text = ""
	else: #Otherwise, remove the gems from the player's inventory (update count appropriately) and recieve the purchased item.
		AudioPlayer.play_sound("victory_2")
		InventoryCanvasLayer.gem_count -= selected_cost
		InventoryCanvasLayer.inventory.update_label("gems", (-selected_cost))
		InventoryCanvasLayer.inventory.remove_item("gem", selected_cost, "Items")
		InventoryCanvasLayer.bought_items.append(selected_name)
		if wear_grid.visible:
			InventoryCanvasLayer._update_styles(selected_name)
			print("updating styles...")
		else:
			InventoryCanvasLayer.inventory.add_item(selected_data, 1, "Items")
			InventoryCanvasLayer.furniture[selected_data.item_name] = false
			print("This has been added to our furniture list: ", selected_data.item_name)
		selected_item.queue_free()
		clear_description()
		buy_button.disabled = true
		comment.text = "Sold!"
		if HUD.has_side:
			HUD.quest_bought_item = true
			HUD.quest_button.just_changed = true if (HUD.quest_bought_item and !HUD.quest_button.just_changed) else HUD.quest_button.just_changed
		await get_tree().create_timer(2).timeout #After 2 seconds, empty it.
		comment.text = ""

func _on_quit_pressed() -> void:
	shop_quit.emit()
	clear_description()
