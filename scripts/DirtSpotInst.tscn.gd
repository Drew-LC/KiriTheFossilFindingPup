extends Area2D

@onready var player_in_range := false
@onready var minigame_open := false
@onready var player_reference = null
@onready var overlay: CanvasLayer = null  # will be set in _ready
@onready var is_mouse_hover := false # Is the mouse hovering over the dig spot if clicking on it?
@export var item_data : ItemData
@export var item_count : int = 1
@onready var icon: TextureRect = $InventoryIcon
@onready var just_detected := false # Did the dig spot just show up on the radar when Kiri sniffed?

# Preload all possible random textures of the dig spot.
@onready var dirt_texture_1 = preload("uid://cpgqvggwd4y1b")
@onready var dirt_texture_2 = preload("uid://ofqnvtkmmj7r")
@onready var dirt_texture_array := [dirt_texture_1, dirt_texture_2]
@onready var spot_look: TextureRect = $DigSpotIcon

# Attributes of the dig spot
# Example attributes: "gem", "trex_torso_fossil", "ankylosaurus_torso_fossil", etc.
@export var spot_item := "default" #is "default" by default to prevent triggering other attributes' code

func _ready():
	# Find the overlay safely
	overlay = get_parent().get_parent().get_node("FossilMinigame")
	if overlay:
		overlay.visible = false
	else:
		push_error("MinigameOverlay not found in this instance!")
	icon.texture = item_data.icon
	
	# Randomly decide the particle's texture
	spot_look.texture = dirt_texture_array.pick_random()

# Detects when Kiri enters the area
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "KiriSprite":
		player_in_range = true
		player_reference = body
		print(spot_item)
		if just_detected:
			Tutorial.over_sniffed_spot = true

# Detects when Kiri exits the area
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "KiriSprite":
		player_in_range = false
		player_reference = null
		if just_detected:
			Tutorial.over_sniffed_spot = false

# Opens the minigame overlay
func start_minigame():
	if overlay:
		TransitionScreen.transition("skull")
		await TransitionScreen.on_transition_finished
		overlay.visible = true
		SelectTools.visible = true
	minigame_open = true
	if player_reference:
		player_reference.set_physics_process(false)
		player_reference.velocity = Vector2.ZERO
	SelectTools.in_fossil_minigame = true
	SelectTools.cur_attribute = spot_item

# Closes the minigame overlay #Note: Currently not called anywhere.
func close_minigame():
	if overlay:
		overlay.visible = false
	minigame_open = false
	if player_reference:
		player_reference.set_physics_process(true)

# Check input each frame
func _process(_delta):
	# Checks that the player is in range and clicked either E or the left mouse button, AND that this dig spot was detected by Kiri's sniff.
	if !SelectTools.in_fossil_minigame and player_in_range and (Input.is_action_just_pressed("press") or Input.is_action_just_pressed("click")) and just_detected:
		Tutorial.interacted_spot = true
		# Checks that if the player clicked on the left mouse button, the button is actually over the dig spot.
		if Input.is_action_just_pressed("click") and !is_mouse_hover:
			return
		player_reference.found_spot = true
		await get_tree().create_timer(player_reference.time_found).timeout 
		if !minigame_open:
			start_minigame()
	# Ensures player can move when the mini-game is down.
	if overlay != null:
		if !overlay.visible:
			minigame_open = false
			if player_reference:
				player_reference.set_physics_process(true)
	else:
		overlay = get_parent().get_parent().get_node("FossilMinigame")
		if overlay:
			overlay.visible = false
		else:
			push_error("MinigameOverlay not found in this instance!")
	# Add the inventory item upon the mini-game being finished, or despawn if the player already checked the dig spot and it was empty
	if (SelectTools.fossil_minigame_won or SelectTools.exited_empty_minigame) and minigame_open: #Make sure to check if this local dig spot has its minigame_open var set to true to prevent other dig spots' code from running.
		SelectTools.exited_empty_minigame = false
		minigame_open = false
		if player_reference:
			player_reference.set_physics_process(true)
		# Only add to the inventory if the mini-game wasn't empty.
		if SelectTools.fossil_minigame_won:
			#TransitionScreen.transition("travel_second_half")
			#await TransitionScreen.on_transition_finished
			# Ensures the dig spot's decided item has the appropriate characteristics.
			if spot_item != null:
				match spot_item:
					"gem":
						item_data.item_name = "gem"
						item_data.description = "A precious jewel! The shopkeeper knows what to do with it."
						item_data.icon = overlay.gem_transparent
						item_data.max_stack = 64
					"trex_tail":
						item_data.item_name = "trex_tail"
						item_data.description = "One of five of dinosaur 1's fossils."
						item_data.icon = overlay.trex_tail_fossil
						item_data.max_stack = 1
					"trex_torso":
						item_data.item_name = "trex_torso"
						item_data.description = "One of five of dinosaur 1's fossils."
						item_data.icon = overlay.trex_torso_fossil
						item_data.max_stack = 1
					"trex_hands":
						item_data.item_name = "trex_hands"
						item_data.description = "One of five of dinosaur 1's fossils."
						item_data.icon = overlay.trex_hands_fossil
						item_data.max_stack = 1
					"trex_legs":
						item_data.item_name = "trex_legs"
						item_data.description = "One of five of dinosaur 1's fossils."
						item_data.icon = overlay.trex_legs_fossil
						item_data.max_stack = 1
					"trex_skull":
						item_data.item_name = "trex_skull"
						item_data.description = "One of five of dinosaur 1's fossils."
						item_data.icon = overlay.trex_skull_fossil
						item_data.max_stack = 1
					"anky_tail":
						item_data.item_name = "anky_tail"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_tail_fossil
						item_data.max_stack = 1
					"anky_torso":
						item_data.item_name = "anky_torso"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_torso_fossil
						item_data.max_stack = 1
					"anky_armL":
						item_data.item_name = "anky_armL"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_armL_fossil
						item_data.max_stack = 1
					"anky_armR":
						item_data.item_name = "anky_armR"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_armR_fossil
						item_data.max_stack = 1
					"anky_legL":
						item_data.item_name = "anky_legL"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_legL_fossil
						item_data.max_stack = 1
					"anky_legR":
						item_data.item_name = "anky_legR"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_legR_fossil
						item_data.max_stack = 1
					"anky_skull":
						item_data.item_name = "anky_skull"
						item_data.description = "One of seven of dinosaur 2's fossils."
						item_data.icon = overlay.anky_skull_fossil
						item_data.max_stack = 1
					"mame_tail":
						item_data.item_name = "mame_tail"
						item_data.description = "One of six of dinosaur 3's fossils."
						item_data.icon = overlay.mame_tail_fossil
						item_data.max_stack = 1
					"mame_torso":
						item_data.item_name = "mame_torso"
						item_data.description = "One of six of dinosaur 3's fossils."
						item_data.icon = overlay.mame_torso_fossil
						item_data.max_stack = 1
					"mame_arms":
						item_data.item_name = "mame_arms"
						item_data.description = "One of six of dinosaur 3's fossils."
						item_data.icon = overlay.mame_arms_fossil
						item_data.max_stack = 1
					"mame_legs":
						item_data.item_name = "mame_legs"
						item_data.description = "One of six of dinosaur 3's fossils."
						item_data.icon = overlay.mame_legs_fossil
						item_data.max_stack = 1
					"mame_skull":
						item_data.item_name = "mame_skull"
						item_data.description = "One of six of dinosaur 3's fossils."
						item_data.icon = overlay.mame_skull_fossil
						item_data.max_stack = 1
					"mame_spine":
						item_data.item_name = "mame_spine"
						item_data.description = "One of six of dinosaur 3's fossils."
						item_data.icon = overlay.mame_spine_fossil
						item_data.max_stack = 1
					"pter_torso":
						item_data.item_name = "pter_torso"
						item_data.description = "One of five of dinosaur 4's fossils."
						item_data.icon = overlay.pter_torso_fossil
						item_data.max_stack = 1
					"pter_armL":
						item_data.item_name = "pter_armL"
						item_data.description ="One of five of dinosaur 4's fossils."
						item_data.icon = overlay.pter_armL_fossil
						item_data.max_stack = 1
					"pter_armR":
						item_data.item_name = "pter_armR"
						item_data.description = "One of five of dinosaur 4's fossils."
						item_data.icon = overlay.pter_armR_fossil
						item_data.max_stack = 1
					"pter_legs":
						item_data.item_name = "pter_legs"
						item_data.description = "One of five of dinosaur 4's fossils."
						item_data.icon = overlay.pter_legs_fossil
						item_data.max_stack = 1
					"pter_skull":
						item_data.item_name = "pter_skull"
						item_data.description = "One of five of dinosaur 4's fossils."
						item_data.icon = overlay.pter_skull_fossil
						item_data.max_stack = 1
				if spot_item != "gem":
					var has_duplicate := false #Did the player already find the same type of fossil?
					for fossil in HUD.quest_fossils_list:
						if fossil == spot_item: has_duplicate = true
					if !has_duplicate:
						HUD.quest_fossils_list.append(spot_item) #If not, record it.
						HUD.quest_button.just_changed = true
					HUD.quest_found_fossils = len(HUD.quest_fossils_list) #The number of fossils found is the length of the fossils' list
					match HUD.current_quest:
						"trex": HUD.quest_find_fossils = (HUD.quest_found_fossils >= HUD.max_trex_fossils) #If the player's fossils matches the total fossils, they found all fossils
						"anky": HUD.quest_find_fossils = (HUD.quest_found_fossils >= HUD.max_anky_fossils)
						"mame": HUD.quest_find_fossils = (HUD.quest_found_fossils >= HUD.max_mame_fossils)
						"pter": HUD.quest_find_fossils = (HUD.quest_found_fossils >= HUD.max_pter_fossils)
			InventoryCanvasLayer.inventory.add_item(item_data, 1, "Items")
			
			if spot_item == "gem": 
				InventoryCanvasLayer.gem_count += 1
				InventoryCanvasLayer.inventory.update_label("gems", 1)
				InventoryCanvasLayer.inventory.gem_count += 1
				
			if spot_item != "gem":
				InventoryCanvasLayer.inventory.update_label("totalFossil", 1)
			
		queue_free()

#These two functions verify that the mouse is actually hovering over the dig spot in order to click on it to activate the mini-game.
func _on_mouse_entered() -> void:
	is_mouse_hover = true

func _on_mouse_exited() -> void:
	is_mouse_hover = false
