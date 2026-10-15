extends Control

@onready var current_fossil : TextureButton #The current fossil being examined.

# Keep track of the number of dirt particles on the fossil.
@export var num_particles := 0

# Minimum number of dirt fossils left on the fossil needed to move on to the mining phase.
@export var min_particles := 4

#Onready variable versions of the different organism types' lines.
@onready var extracting_background: Node2D = $"3_Extracting_BG"
@onready var extracting_section: Control = $"3_Extracting_Outline"
@onready var dust : Sprite2D

#Miscellaneous variables
@onready var confirmed_attribute := false #Makes sure the match statement runs only once.
@onready var current_fossil_extract : Node2D #The current fossil's collision polygon node.
@onready var current_fossil_answer : Line2D #The current fossil's collision polygon node.
@onready var fade_away := 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Keep dust's position consistent with fossil.
	if (current_fossil != null) and (dust != null):
		dust.position = current_fossil.position
		dust.rotation = current_fossil.rotation
	# If the minimum number of particles on the dinosaur is reached, the digging section is done.
	if (num_particles <= min_particles) and SelectTools.in_fossil_minigame:
		SelectTools.mg_digging_done = true
	else:
		SelectTools.mg_digging_done = false
	# Once in the extracting section, making the rock background and outlines respectively appear.
	if SelectTools.mg_mining_done:
		match SelectTools.cur_attribute:
			"gem": make_extracting_bg_outline_appear("Misc", "Gem")
			"trex_tail": make_extracting_bg_outline_appear("TRex", "Tail")
			"trex_torso": make_extracting_bg_outline_appear("TRex", "Torso")
			"trex_hands": make_extracting_bg_outline_appear("TRex", "Hands")
			"trex_legs": make_extracting_bg_outline_appear("TRex", "Legs")
			"trex_skull": make_extracting_bg_outline_appear("TRex", "Skull")
			"anky_armL": make_extracting_bg_outline_appear("Anky", "ArmL")
			"anky_armR": make_extracting_bg_outline_appear("Anky", "ArmR")
			"anky_legL": make_extracting_bg_outline_appear("Anky", "LegL")
			"anky_legR": make_extracting_bg_outline_appear("Anky", "LegR")
			"anky_tail": make_extracting_bg_outline_appear("Anky", "Tail")
			"anky_torso": make_extracting_bg_outline_appear("Anky", "Torso")
			"anky_skull": make_extracting_bg_outline_appear("Anky", "Skull")
			"mame_arms": make_extracting_bg_outline_appear("Mame", "Arms")
			"mame_legs": make_extracting_bg_outline_appear("Mame", "Legs")
			"mame_tail": make_extracting_bg_outline_appear("Mame", "Tail")
			"mame_torso": make_extracting_bg_outline_appear("Mame", "Torso")
			"mame_skull": make_extracting_bg_outline_appear("Mame", "Skull")
			"mame_spine": make_extracting_bg_outline_appear("Mame", "Spine")
			"pter_armL": make_extracting_bg_outline_appear("Pter", "ArmL")
			"pter_armR": make_extracting_bg_outline_appear("Pter", "ArmR")
			"pter_legs": make_extracting_bg_outline_appear("Pter", "Legs")
			"pter_torso": make_extracting_bg_outline_appear("Pter", "Torso")
			"pter_skull": make_extracting_bg_outline_appear("Pter", "Skull")
	#Once a current attribute has been recieved, assign the correct points for the extracting section based on that attribute once.
	if SelectTools.cur_attribute != "" and !confirmed_attribute:
		confirmed_attribute = true
		match SelectTools.cur_attribute:
			"gem": assign_correct_points("Misc", "Gem")
			"trex_tail": assign_correct_points("TRex", "Tail")
			"trex_torso": assign_correct_points("TRex", "Torso")
			"trex_hands": assign_correct_points("TRex", "Hands")
			"trex_legs": assign_correct_points("TRex", "Legs")
			"trex_skull": assign_correct_points("TRex", "Skull")
			"anky_armL": assign_correct_points("Anky", "ArmL")
			"anky_armR": assign_correct_points("Anky", "ArmR")
			"anky_legL": assign_correct_points("Anky", "LegL")
			"anky_legR": assign_correct_points("Anky", "LegR")
			"anky_tail": assign_correct_points("Anky", "Tail")
			"anky_torso": assign_correct_points("Anky", "Torso")
			"anky_skull": assign_correct_points("Anky", "Skull")
			"mame_arms": assign_correct_points("Mame", "Arms")
			"mame_legs": assign_correct_points("Mame", "Legs")
			"mame_tail": assign_correct_points("Mame", "Tail")
			"mame_torso": assign_correct_points("Mame", "Torso")
			"mame_skull": assign_correct_points("Mame", "Skull")
			"mame_spine": assign_correct_points("Mame", "Spine")
			"pter_armL": assign_correct_points("Pter", "ArmL")
			"pter_armR": assign_correct_points("Pter", "ArmR")
			"pter_legs": assign_correct_points("Pter", "Legs")
			"pter_torso": assign_correct_points("Pter", "Torso")
			"pter_skull": assign_correct_points("Pter", "Skull")
	#Once the extracting section is done, make the rock background and outlines disappear.
	if SelectTools.mg_extracting_done:
		var tween = create_tween()
		tween.set_parallel().tween_property(extracting_background, "modulate:a", 0.0, fade_away)
		tween.set_parallel().tween_property(extracting_section, "modulate:a", 0.0, fade_away)

# For a given type of organism and the subtype of fossil found, make its associate extracting background and outline nodes visible and active.
func make_extracting_bg_outline_appear(type : String, subtype : String) -> void:
	get_node("3_Extracting_BG/" + type + "/" + subtype).visible = true
	get_node("3_Extracting_Outline/" + type + "/" + subtype).visible = true

# For a given type of organism and the subtype of fossil found, assign the extracting section's answer as the points of the associated Line2D answer node.
func assign_correct_points(type : String, subtype : String) -> void:
	extracting_section.correct_points = get_node("3_Extracting_Outline/" + type + "/" + subtype + "/Answer").points

# Detects dirt particles.
func _on_area_2d_area_entered(_area: Area2D) -> void:
	num_particles += 1
func _on_area_2d_area_exited(_area: Area2D) -> void:
	num_particles -= 1
