extends Node2D

# Preload the fossil minigame and the dig spot.
var current_fossil_minigame = preload("uid://dwoyvmikmdo3n")
var dig_spot = preload("uid://12mfdo2iok4q")

# Node variables.
@onready var current_cave := self.name
@onready var dig_spot_spawner: Node2D = $DigSpotSpawner
@onready var kiri: Player = $Kiri

# Variables ensuring every section, and every item type (e.g. all fossils of the current quest's dinosaur) is represented.
@onready var spot_index = 0
@onready var spot_iterated = false
@onready var attribute_index = 0
@onready var attribute_iterated = false

# Variables determining the dig spots' properties.
@export var num_particles : int
# A super array defining the specific sections that a dig spot can spawn in. Defined as [x_mostleft, x_mostright, y_mosttop, y_mostbottom]
@export var crystal_spot_sections := [[240, 280, 170, 230], #Top left corner
									  [330, 360, 250, 330], #Tall left rectangle (top half)
									  [330, 360, 410, 430], #Tall left rectangle (bottom half)
									  [185, 200, 495, 515], #Near the ponds
									  [330, 380, 460, 520], #Rectangle below central crystals (left half)
									  [460, 530, 460, 520], #Rectangle below central crystals (right half)
									  [265, 335, 650, 690], #Underneath long orange crystals
									  [540, 610, 360, 430], #Rectangle right of central crystals (left half)
									  [690, 710, 360, 430], #Rectangle right of central crystals (right half)
									  [740, 750, 590, 700], #Tall thin rightmost rectangle
									  [420, 530, 180, 240], #Top middle rectangle
									  [420, 530, 290, 370]  #Middle middle rectangle
									 ]
@export var sandy_spot_sections := [[30, 190, 30, 100], #Topmost shore area
									[30, 140, 140, 220], #Top-center shore area
									[30, 110, 290, 410], #Bottom-center shore area
									[30, 250, 490, 550], #Bottommost shore area
									[350, 430, 100, 200], #Top-left island area
									[500, 580, 100, 200], #Top-center island area
									[640, 770, 130, 200], #Top-right island area
									[260, 390, 260, 330], #Center-left island area
									[450, 580, 260, 330], #Center-center island area
									[640, 790, 260, 330], #Center-right island area
									[320, 390, 390, 440], #Bottom-left island area
									[450, 560, 370, 520], #Bottom-center island area
									[640, 790, 390, 440], #Bottom-right island area
									[785, 795, 495, 505] #Bottom-right corner
								   ]
@onready var current_spot_sections : Array
@export var crystal_opening_section := [700, 715, 155, 185] #At the spawn point
@export var tutorial_once := false #Did a dig spot spawn at the player's spawn point once for the sake of the tutorial?
@export var tutorial_once_again := false
# An array of all attributes of a dig spot's possible items.
@export var attributes := ["empty", "gem"] #Initially just the non-quest items, will append quest items in setup
# An array of all possible of a dig spot's quest attributes
@export var quest_trex_attributes := ["trex_tail", "trex_torso", "trex_hands", "trex_legs", "trex_skull"]
@export var quest_anky_attributes := ["anky_tail", "anky_torso", "anky_armL", "anky_armR", "anky_legL", "anky_legR", "anky_skull"]
@export var quest_mame_attributes := ["mame_tail", "mame_torso", "mame_arms", "mame_legs", "mame_skull", "mame_spine"]
@export var quest_pter_attributes := ["pter_torso", "pter_armL", "pter_armR", "pter_legs", "pter_skull"]
# Node paths.
@export var fossil_mg_crystal_path := "/root/crystalcaveScene/FossilMinigame"
@export var fossil_mg_beach_path := "/root/sandybeachScene/FossilMinigame"

@export var secret = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kiri.speed = 60
	Tutorial.interest_node = Tutorial.empty_interest
	if NaviationManager.spawn_door_tag != null: #Navigation.
		_on_level_spawn(NaviationManager.spawn_door_tag)
	
	HUD.current_location_node = self #Set the current location node as this location.
	match current_cave:
		"crystalcaveScene":
			AudioPlayer.play_music("Cave")
			HUD.current_location_name = "crystal_cave"
			current_spot_sections = crystal_spot_sections
			current_spot_sections.shuffle() #Randomize the sections: comment this out for debugging purposes!
			match HUD.current_quest:
				"trex":
					attributes.append_array(quest_trex_attributes)
					attributes.shuffle()
					num_particles = len(attributes)
					HUD.quest_reach_cave = true
				"mame":
					attributes.append_array(quest_mame_attributes)
					attributes.shuffle()
					num_particles = len(attributes)
					HUD.quest_reach_cave = true
				"anky", "pter", "": num_particles = len(current_spot_sections) #Can comment out to debug.
		"sandybeachScene":
			AudioPlayer.play_music("Beach")
			HUD.current_location_name = "sandy_beach"
			current_spot_sections = sandy_spot_sections
			current_spot_sections.shuffle() #Randomize the sections: comment this out for debugging purposes!
			match HUD.current_quest:
				"anky":
					attributes.append_array(quest_anky_attributes)
					attributes.shuffle()
					num_particles = len(attributes)
					HUD.quest_reach_cave = true
				"pter":
					attributes.append_array(quest_pter_attributes)
					attributes.shuffle()
					num_particles = len(attributes)
					HUD.quest_reach_cave = true
				"trex", "mame", "": num_particles = len(current_spot_sections) #Can comment out to debug.
	HUD.quest_button.just_changed = true if (HUD.has_quest and !HUD.quest_reach_cave) else HUD.quest_button.just_changed #Update the exclaimation mark such that it only triggers if the player just initially entered the cave.
	# Spawn in num_particles number of particles.
	for i in num_particles:
		var dig_instance = dig_spot.instantiate()
		# Choose the section that the current dig spot will spawn in.
		var selected_section : Array
		if Tutorial.selected_tutorial and !tutorial_once and HUD.quest_reach_cave and (current_cave == "crystalcaveScene"):
			tutorial_once = true
			selected_section = crystal_opening_section
		else:
			selected_section = current_spot_sections[spot_index]  #Can comment out to debug.
		# Ensure every section has at least one dig spot. After all sections are represented, go for true randomness.
		if spot_iterated:
			spot_index = randi_range(0, num_particles)
		elif spot_index >= num_particles:
			spot_index = randi_range(0, num_particles)
			spot_iterated = true
		else:
			spot_index += 1
		# Randomly assign an attribute to a spot.
		if Tutorial.selected_tutorial and !tutorial_once_again and HUD.quest_reach_cave and (current_cave == "crystalcaveScene"):
			tutorial_once_again = true
			if attributes[attribute_index] == "empty":
				dig_instance.spot_item = "trex_skull" #The first closest dig spot will not be empty to avoid confusion.
			else:
				dig_instance.spot_item = attributes[attribute_index]
		else:
			dig_instance.spot_item = attributes[attribute_index]
		# Ensure every dig spot has at least one of every attribute. After all item types are represented, go for true randomness.
		if attribute_iterated:
			attribute_index = randi_range(0, len(attributes) - 1)
		if attribute_index >= (len(attributes) - 1):
			attribute_index = randi_range(0, len(attributes) - 1)
			attribute_iterated = true
		else:
			attribute_index += 1
		# Randomize the position of the particles.
		dig_instance.position = Vector2(randi_range(selected_section[0], selected_section[1]), randi_range(selected_section[2], selected_section[3]))
		
		dig_spot_spawner.add_child(dig_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match current_cave:
		"crystalcaveScene":
			if !has_node(NodePath(fossil_mg_crystal_path)):
				var minigame_instance = current_fossil_minigame.instantiate()
				add_child(minigame_instance)
				SelectTools.fossil_minigame_won = false
		"sandybeachScene":
			if !has_node(NodePath(fossil_mg_beach_path)):
				var minigame_instance = current_fossil_minigame.instantiate()
				add_child(minigame_instance)
				SelectTools.fossil_minigame_won = false

# Exit the cave.
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/" + destination_tag
	var door = get_node(door_path) as Door
	NaviationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
