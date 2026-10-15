extends Control
signal quest_board_quit

@onready var quest_trex_container: MarginContainer = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TRex_MarginContainer
@onready var quest_shop_container: MarginContainer = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Shop_MarginContainer
@onready var quest_home_container: MarginContainer = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Home_MarginContainer
@onready var quest_anky_container: MarginContainer = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Anky_MarginContainer
@onready var quest_mame_container: MarginContainer = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Mame_MarginContainer
@onready var quest_pter_container: MarginContainer = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Pter_MarginContainer
@onready var quest_trex_button: Button = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TRex_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var quest_shop_button: Button = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Shop_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var quest_home_button: Button = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Home_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var quest_anky_button: Button = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Anky_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var quest_mame_button: Button = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Mame_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var quest_pter_button: Button = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Pter_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/Button
@onready var quest_trex_reward := ItemData.new()
@onready var num_trex_reward := 3
@onready var quest_shop_reward := ItemData.new()
@onready var num_shop_reward := 2
@onready var quest_home_reward := ItemData.new()
@onready var num_home_reward := 2
@onready var quest_anky_reward := ItemData.new()
@onready var num_anky_reward := 3
@onready var quest_mame_reward := ItemData.new()
@onready var num_mame_reward := 3
@onready var quest_pter_reward := ItemData.new()
@onready var num_pter_reward := 3
@onready var gem_transparent = preload("uid://6841kwpmw5m")

@onready var trex_gem: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TRex_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var shop_gem: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Shop_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var home_gem: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Home_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var anky_gem: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Anky_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var mame_gem: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Mame_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var pter_gem: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Pter_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/Label

@onready var trex_reward_image: TextureRect = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TRex_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/textureRect
@onready var shop_reward_image: TextureRect = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Shop_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/textureRect
@onready var home_reward_image: TextureRect = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Home_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/textureRect
@onready var anky_reward_image: TextureRect = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Anky_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/textureRect
@onready var mame_reward_image: TextureRect = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Mame_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/textureRect
@onready var pter_reward_image: TextureRect = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Pter_MarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/VBoxContainer/textureRect

@onready var trex_desc: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/TRex_MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Desc
@onready var shop_desc: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Shop_MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Desc
@onready var home_desc: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Home_MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Desc
@onready var anky_desc: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Anky_MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Desc
@onready var mame_desc: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Mame_MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Desc
@onready var pter_desc: Label = $HBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/Pter_MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Desc

@export var multi_gem : Texture2D
@export var reward_amount : int
@onready var iris: AnimatedSprite2D = $HBoxContainer/Shopkeeper/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	define_rewards()
	
	trex_gem.text = str(num_trex_reward) + " Gems"
	shop_gem.text = str(num_shop_reward) + " Gems"
	home_gem.text = str(num_home_reward) + " Gems"
	anky_gem.text = str(num_anky_reward) + " Gems"
	mame_gem.text = str(num_mame_reward) + " Gems"
	pter_gem.text = str(num_pter_reward) + " Gems"
	
	trex_reward_image.texture = multi_gem
	shop_reward_image.texture = multi_gem
	home_reward_image.texture = multi_gem
	anky_reward_image.texture = multi_gem
	mame_reward_image.texture = multi_gem
	pter_reward_image.texture = multi_gem
	
	trex_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	trex_desc.text = "Find your first dinosaur!"

func define_rewards() -> void:
	quest_trex_reward.item_name = "gem"
	quest_trex_reward.description = "A precious jewel! The shopkeeper knows what to do with it."
	quest_trex_reward.icon = gem_transparent
	quest_trex_reward.max_stack = 64
	
	quest_shop_reward.item_name = "gem"
	quest_shop_reward.description = "A precious jewel! The shopkeeper knows what to do with it."
	quest_shop_reward.icon = gem_transparent
	quest_shop_reward.max_stack = 64
	
	quest_home_reward.item_name = "gem"
	quest_home_reward.description = "A precious jewel! The shopkeeper knows what to do with it."
	quest_home_reward.icon = gem_transparent
	quest_home_reward.max_stack = 64
	
	quest_anky_reward.item_name = "gem"
	quest_anky_reward.description = "A precious jewel! The shopkeeper knows what to do with it."
	quest_anky_reward.icon = gem_transparent
	quest_anky_reward.max_stack = 64
	
	quest_mame_reward.item_name = "gem"
	quest_mame_reward.description = "A precious jewel! The shopkeeper knows what to do with it."
	quest_mame_reward.icon = gem_transparent
	quest_mame_reward.max_stack = 64
	
	quest_pter_reward.item_name = "gem"
	quest_pter_reward.description = "A precious jewel! The shopkeeper knows what to do with it."
	quest_pter_reward.icon = gem_transparent
	quest_pter_reward.max_stack = 64

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_quest_progress("trex", quest_trex_container, quest_trex_button)
	_quest_progress("shop", quest_shop_container, quest_shop_button)
	_quest_progress("home", quest_home_container, quest_home_button)
	_quest_progress("anky", quest_anky_container, quest_anky_button)
	_quest_progress("mame", quest_mame_container, quest_mame_button)
	_quest_progress("pter", quest_pter_container, quest_pter_button)
	iris.play()
	if HUD.quest_trex_submit and HUD.quest_anky_submit and HUD.quest_mame_submit and HUD.quest_pter_submit and HUD.quest_shop_submit and HUD.quest_home_submit:
		HUD.quest_trex_submit = false
		HUD.quest_anky_submit = false
		HUD.quest_mame_submit = false
		HUD.quest_pter_submit = false
		HUD.quest_shop_submit = false
		HUD.quest_home_submit = false
		HUD.quest_trex_ID = false
		HUD.quest_anky_ID = false
		HUD.quest_mame_ID = false
		HUD.quest_pter_ID = false

func _on_quit_pressed() -> void:
	quest_board_quit.emit()

func _quest_progress(quest_name : String, quest_container : MarginContainer, quest_button: Button):
	var submit_text : String = "quest_" + quest_name + "_submit"
	var submit_bool : bool = HUD.get(submit_text)
	
	#Container Only disappears after submitting the Quest
	quest_container.visible = false if submit_bool else true
	
	#Pre-Requisites 
	if quest_name == "anky" and !HUD.quest_trex_submit:
		quest_button.text = "Locked"
		quest_button.disabled = true
		return
		
	elif quest_name == "shop" and !HUD.quest_trex_submit:
		quest_button.text = "Locked"
		quest_button.disabled = true
		return 
		
	elif quest_name == "home" and !HUD.quest_shop_submit:
		quest_button.text = "Locked"
		quest_button.disabled = true
		return
		
	elif quest_name == "mame" and !HUD.quest_anky_submit:
		quest_button.text = "Locked"
		quest_button.disabled = true
		return 
	
	elif quest_name == "pter" and !HUD.quest_mame_submit:
		quest_button.text = "Locked"
		quest_button.disabled = true
		return 
	# Main quest
	elif HUD.current_quest == quest_name and !HUD.quest_finish_ID:
		quest_button.text = "In Progress"
		quest_button.disabled = true
	# Side quest
	elif HUD.current_side == quest_name and (!HUD.quest_customized and !HUD.quest_put_furniture):
		quest_button.text = "In Progress"
		quest_button.disabled = true
	# Main quest
	elif HUD.current_quest == quest_name and HUD.quest_finish_ID:
		quest_button.text = "Claim!"
		quest_button.disabled = false
	# Side quest
	elif HUD.current_side == quest_name and (HUD.quest_customized or HUD.quest_put_furniture):
		quest_button.text = "Claim!"
		quest_button.disabled = false
	else:
		quest_button.text = "Accept"
		quest_button.disabled = false
	
# Set the current quest based on the button pressed.
func _on_quest_trex_pressed() -> void:
	if !HUD.quest_finish_ID:
		HUD.current_quest = "trex" #Change this to whatever dinosaur for ease of debugging
		HUD.quest_button.just_changed = true
		Tutorial.accepted_quest = true
		AudioPlayer.play_sound("victory_2")
	else:
		HUD.quest_submit = true
		HUD.quest_trex_submit = true
		Tutorial.selected_tutorial = false
		
		shop_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		shop_desc.text = "Give Kiri a hat!"
		quest_shop_container.visible = true
		
		anky_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		anky_desc.text = "Find your second dinosaur!"
		quest_anky_container.visible = true
		
		receive_rewards(quest_trex_reward, num_trex_reward, "Items")
		AudioPlayer.play_sound("victory_1")

func _on_quest_shop_pressed() -> void:
	if !HUD.quest_customized:
		HUD.current_side = "shop"
		HUD.quest_button.just_changed = true
		Tutorial.selected_tutorial = true
		AudioPlayer.play_sound("victory_2")
	else:
		HUD.quest_side_submit = true
		HUD.quest_shop_submit = true
		Tutorial.selected_tutorial = false if HUD.current_quest != "anky" else true
		
		home_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		home_desc.text = "Decorate Kiri's home!"
		quest_home_container.visible = true
		
		receive_rewards(quest_shop_reward, num_shop_reward, "Items")
		AudioPlayer.play_sound("victory_1")

func _on_quest_home_pressed() -> void:
	if !HUD.quest_put_furniture:
		HUD.current_side = "home"
		HUD.quest_button.just_changed = true
		Tutorial.selected_tutorial = true
		AudioPlayer.play_sound("victory_2")
	else:
		HUD.quest_side_submit = true
		HUD.quest_home_submit = true
		Tutorial.selected_tutorial = false if HUD.current_quest != "anky" else true
		
		receive_rewards(quest_home_reward, num_home_reward, "Items")
		AudioPlayer.play_sound("victory_1")

func _on_quest_anky_pressed() -> void:
	if !HUD.quest_finish_ID:
		HUD.current_quest = "anky"
		HUD.quest_button.just_changed = true
		Tutorial.selected_tutorial = true
		AudioPlayer.play_sound("victory_2")
	else:
		HUD.quest_submit = true
		HUD.quest_anky_submit = true
		Tutorial.selected_tutorial = false if !HUD.has_side else true
		
		mame_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		mame_desc.text = "Find your third dinosaur!"
		quest_mame_container.visible = true
		
		receive_rewards(quest_anky_reward, num_anky_reward, "Items")
		AudioPlayer.play_sound("victory_1")
		
func _on_quest_mame_pressed() -> void:
	if !HUD.quest_finish_ID:
		HUD.current_quest = "mame"
		HUD.quest_button.just_changed = true
		AudioPlayer.play_sound("victory_2")
	else:
		HUD.quest_submit = true
		HUD.quest_mame_submit = true
		
		pter_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		pter_desc.text = "Find your fourth dinosaur!"
		quest_pter_container.visible = true
		
		receive_rewards(quest_mame_reward, num_mame_reward, "Items")
		AudioPlayer.play_sound("victory_1")

func _on_quest_pter_pressed() -> void:
	if !HUD.quest_finish_ID:
		HUD.current_quest = "pter"
		HUD.quest_button.just_changed = true
		AudioPlayer.play_sound("victory_2")
	else:
		HUD.quest_submit = true
		HUD.quest_pter_submit = true
		
		receive_rewards(quest_pter_reward, num_pter_reward, "Items")
		AudioPlayer.play_sound("victory_1")

func receive_rewards(reward : ItemData, content : int , tab_name : String):
	InventoryCanvasLayer.inventory.add_item(reward, content, "Items")
	InventoryCanvasLayer.gem_count += content
	InventoryCanvasLayer.inventory.update_label("gems", content)	
	print("Rewarded")
