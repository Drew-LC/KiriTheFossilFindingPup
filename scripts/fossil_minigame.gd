extends CanvasLayer

@export var fossil_max_health := 12 #The maximum health points of a fossil.
@export var health_delay := false #Did enough time from the player's last hit of the fossil pass?
@export var is_hover_over_fossil := false #Is the player's cursor hovering over the fossil?
@export var time_fossil_fade_red := 0.2 #How long does it take for the fossil to fade in as red, and fade out from red?
@export var time_health_appears := 1.0 #How long does the health bar and damaged fossil animation play for?
@export var shake_offset := 20.0 #How many pixels should the fossil shake when damaged?
@export var shake_duration := 0.05 #How long does it take for the fossil to shift to a specific position when shaking when damaged?
@export var shake_count := 20 #How many times does the fossil shift in position when shaking when damanged?
@export var screen_zoom := 0.5 #How long does it take for the screen to zoom in/out?

# Store the image files of the fossil icons
@onready var gem_transparent = $Organism/Fossils/Misc/Gem.texture_normal
@onready var trex_tail_fossil = $Organism/Fossils/TRex/Tail.texture_normal
@onready var trex_torso_fossil = $Organism/Fossils/TRex/Torso.texture_normal
@onready var trex_hands_fossil = $Organism/Fossils/TRex/Hands.texture_normal
@onready var trex_legs_fossil = $Organism/Fossils/TRex/Legs.texture_normal
@onready var trex_skull_fossil = $Organism/Fossils/TRex/Skull.texture_normal
@onready var anky_tail_fossil = $Organism/Fossils/Anky/Tail.texture_normal
@onready var anky_torso_fossil = $Organism/Fossils/Anky/Torso.texture_normal
@onready var anky_armL_fossil = $Organism/Fossils/Anky/ArmL.texture_normal
@onready var anky_armR_fossil = $Organism/Fossils/Anky/ArmR.texture_normal
@onready var anky_legL_fossil = $Organism/Fossils/Anky/LegL.texture_normal
@onready var anky_legR_fossil = $Organism/Fossils/Anky/LegR.texture_normal
@onready var anky_skull_fossil = $Organism/Fossils/Anky/Skull.texture_normal
@onready var mame_tail_fossil = $Organism/Fossils/Mame/Tail.texture_normal
@onready var mame_torso_fossil = $Organism/Fossils/Mame/Torso.texture_normal
@onready var mame_arms_fossil = $Organism/Fossils/Mame/Arms.texture_normal
@onready var mame_legs_fossil = $Organism/Fossils/Mame/Legs.texture_normal
@onready var mame_skull_fossil = $Organism/Fossils/Mame/Skull.texture_normal
@onready var mame_spine_fossil = $Organism/Fossils/Mame/Spine.texture_normal
@onready var pter_torso_fossil = $Organism/Fossils/Pter/Torso.texture_normal
@onready var pter_armL_fossil = $Organism/Fossils/Pter/ArmL.texture_normal
@onready var pter_armR_fossil = $Organism/Fossils/Pter/ArmR.texture_normal
@onready var pter_legs_fossil = $Organism/Fossils/Pter/Legs.texture_normal
@onready var pter_skull_fossil = $Organism/Fossils/Pter/Skull.texture_normal
# Preload all non-fossil textures
@onready var health_bar := $CanvasLayer/HealthBar
@onready var fossil := $Organism/Fossils
@onready var extracting_background := $"Organism/3_Extracting_BG"
@onready var extracting_section := $"Organism/3_Extracting_Outline"
@onready var paw_damage = 1
@onready var pickaxe_chisel_damage = 2
@onready var block: Control = $CanvasLayer/Block
@onready var trex_dust_hands: Sprite2D = $"Organism/4_Dusting/TRex/Hands"
@onready var trex_dust_legs: Sprite2D = $"Organism/4_Dusting/TRex/Legs"
@onready var trex_dust_skull: Sprite2D = $"Organism/4_Dusting/TRex/Skull"
@onready var trex_dust_tail: Sprite2D = $"Organism/4_Dusting/TRex/Tail"
@onready var trex_dust_torso: Sprite2D = $"Organism/4_Dusting/TRex/Torso"
@onready var anky_dust_arm_l: Sprite2D = $"Organism/4_Dusting/Anky/ArmL"
@onready var anky_dust_arm_r: Sprite2D = $"Organism/4_Dusting/Anky/ArmR"
@onready var anky_dust_leg_l: Sprite2D = $"Organism/4_Dusting/Anky/LegL"
@onready var anky_dust_leg_r: Sprite2D = $"Organism/4_Dusting/Anky/LegR"
@onready var anky_dust_skull: Sprite2D = $"Organism/4_Dusting/Anky/Skull"
@onready var anky_dust_tail: Sprite2D = $"Organism/4_Dusting/Anky/Tail"
@onready var anky_dust_torso: Sprite2D = $"Organism/4_Dusting/Anky/Torso"
@onready var mame_dust_arms: Sprite2D = $"Organism/4_Dusting/Mame/Arms"
@onready var mame_dust_legs: Sprite2D = $"Organism/4_Dusting/Mame/Legs"
@onready var mame_dust_skull: Sprite2D = $"Organism/4_Dusting/Mame/Skull"
@onready var mame_dust_tail: Sprite2D = $"Organism/4_Dusting/Mame/Tail"
@onready var mame_dust_torso: Sprite2D = $"Organism/4_Dusting/Mame/Torso"
@onready var mame_dust_spine: Sprite2D = $"Organism/4_Dusting/Mame/Spine"
@onready var pter_dust_arm_l: Sprite2D = $"Organism/4_Dusting/Pter/ArmL"
@onready var pter_dust_arm_r: Sprite2D = $"Organism/4_Dusting/Pter/ArmR"
@onready var pter_dust_legs: Sprite2D = $"Organism/4_Dusting/Pter/Legs"
@onready var pter_dust_skull: Sprite2D = $"Organism/4_Dusting/Pter/Skull"
@onready var pter_dust_torso: Sprite2D = $"Organism/4_Dusting/Pter/Torso"
@onready var misc_dust_gem: Sprite2D = $"Organism/4_Dusting/Misc/Gem"
@onready var dust: Node2D = $"Organism/4_Dusting"

# Node variables.
@onready var organism: Control = $Organism
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var exit_button: TextureButton = $CanvasLayer/ExitButton
@onready var confirm_screen: Panel = $CanvasLayer/ConfirmScreen
@onready var failed_screen: Panel = $CanvasLayer/FailedScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var digging_section: Control = $"1_Digging"
@onready var mining_section: Control = $"2_Mining"
@onready var artifact: Label = $Victory/Artifact
@onready var progress_bar: TextureProgressBar = $CanvasLayer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = fossil_max_health
	health_bar.value = fossil_max_health
	extracting_section.fossil_hit.connect(_on_fossil_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Adjusts the item to be find depending on the dig spot interacted with.
	#print(SelectTools.cur_attribute)
	match SelectTools.cur_attribute:
		"empty":
			organism.visible = false
			$"Organism/3_Extracting_BG".visible = false
		"gem": make_fossil_visible("Misc", "Gem")
		"trex_tail": make_fossil_visible("TRex", "Tail")
		"trex_torso": make_fossil_visible("TRex", "Torso")
		"trex_hands": make_fossil_visible("TRex", "Hands")
		"trex_legs": make_fossil_visible("TRex", "Legs")
		"trex_skull": make_fossil_visible("TRex", "Skull")
		"anky_armL": make_fossil_visible("Anky", "ArmL")
		"anky_armR": make_fossil_visible("Anky", "ArmR")
		"anky_legL": make_fossil_visible("Anky", "LegL")
		"anky_legR": make_fossil_visible("Anky", "LegR")
		"anky_torso": make_fossil_visible("Anky", "Torso")
		"anky_tail": make_fossil_visible("Anky", "Tail")
		"anky_skull": make_fossil_visible("Anky", "Skull")
		"mame_arms": make_fossil_visible("Mame", "Arms")
		"mame_legs": make_fossil_visible("Mame", "Legs")
		"mame_torso": make_fossil_visible("Mame", "Torso")
		"mame_tail": make_fossil_visible("Mame", "Tail")
		"mame_skull": make_fossil_visible("Mame", "Skull")
		"mame_spine": make_fossil_visible("Mame", "Spine")
		"pter_armL": make_fossil_visible("Pter", "ArmL")
		"pter_armR": make_fossil_visible("Pter", "ArmR")
		"pter_legs": make_fossil_visible("Pter", "Legs")
		"pter_torso": make_fossil_visible("Pter", "Torso")
		"pter_skull": make_fossil_visible("Pter", "Skull")
	#Update the progress bar appropriately.
	if SelectTools.cur_attribute != "empty":
		if !SelectTools.mg_digging_done:
			var increment
			var denominator = (organism.num_particles - organism.min_particles) * 0.01
			if denominator > 0.0:
				increment = 2.5 / (organism.num_particles - organism.min_particles)
			else:
				increment = 2.5
			create_tween().tween_property(progress_bar, "value", 0.0 + increment, 0.25)
		elif !SelectTools.mg_mining_done:
			create_tween().tween_property(progress_bar, "value", 2.5 + 2.5 * (float(mining_section.rocklayer_bg.frame) / float(mining_section.rocklayer_maxhits)), 0.25)
		elif !SelectTools.mg_extracting_done:
			create_tween().tween_property(progress_bar, "value", 5.0, 0.25)
		elif !SelectTools.mg_dusting_done:
			var increment
			var denominator = ((SelectTools.dust_left * 100) - (0.01 * 100))
			if denominator > 0.0:
				increment = 2.5 / denominator
			else:
				increment = 2.5
			create_tween().tween_property(progress_bar, "value", 7.5 + increment, 0.25)
		else:
			create_tween().tween_property(progress_bar, "value", 10.0, 0.25)
	else:
		progress_bar.visible = false
	#When the fossil mini-game is completed, reset the mini-game's states.
	if SelectTools.mg_dusting_done and !SelectTools.fossil_minigame_won:
		SelectTools.fossil_minigame_won = true
		SelectTools.untoggle_all()
		disappear_all()
		AudioPlayer.play_music("Silence")
		match SelectTools.cur_attribute:
			"gem": artifact.text = "GEM"
			_: artifact.text = "FOSSIL"
		await get_tree().create_timer(0.75).timeout
		animation_player.play("victory")
		AudioPlayer.play_sound("victory_1")
		await get_tree().create_timer(3.0).timeout
		match HUD.current_location_name:
			"crystal_cave": AudioPlayer.play_music("Cave")
			"sandy_beach": AudioPlayer.play_music("Beach")
		TransitionScreen.transition("skull")
		await TransitionScreen.on_transition_finished
		SelectTools.mg_digging_done = false
		SelectTools.mg_mining_done = false
		SelectTools.mg_extracting_done = false
		SelectTools.mg_dusting_done = false
		
		visible = false
		SelectTools.visible = false
		SelectTools.in_fossil_minigame = false
		SelectTools.cur_attribute = ""
		Tutorial.interacted_spot = false
		SelectTools.reappear_all()
		queue_free()
	
	canvas_layer.visible = visible

# Disappear everything for the victory animation.
func disappear_all() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(exit_button, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(digging_section, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(dust, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(progress_bar, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(SelectTools.paw, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(SelectTools.pickaxe, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(SelectTools.chisel, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(SelectTools.brush, "modulate:a", 0, 0.25)
	tween.parallel().tween_property(SelectTools.tutorial, "modulate:a", 0, 0.25)

# For a given type of organism and the subtype of fossil found, make its associate nodes visible and active.
func make_fossil_visible(type : String, subtype : String) -> void:
	organism.visible = true
	extracting_background.visible = true
	get_node("Organism/Fossils/" + type + "/" + subtype).visible = true
	organism.current_fossil = get_node("Organism/Fossils/" + type + "/" + subtype)
	get_node("Organism/3_Extracting_BG/" + type).monitoring = true
	get_node("Organism/3_Extracting_BG/" + type + "/" + subtype).disabled = false
	match type: #This is unavoidable due to the nature of the dust. I could hard-code it but that is not preferable at the moment.
		"TRex":
			match subtype:
				"Hands":
					trex_dust_hands.cur_img = trex_dust_hands.texture.get_image()
					trex_dust_hands.visible = true
					organism.dust = trex_dust_hands
				"Legs":
					trex_dust_legs.cur_img = trex_dust_legs.texture.get_image()
					trex_dust_legs.visible = true
					organism.dust = trex_dust_legs
				"Skull":
					trex_dust_skull.cur_img = trex_dust_skull.texture.get_image()
					trex_dust_skull.visible = true
					organism.dust = trex_dust_skull
				"Tail":
					trex_dust_tail.cur_img = trex_dust_tail.texture.get_image()
					trex_dust_tail.visible = true
					organism.dust = trex_dust_tail
				"Torso":
					trex_dust_torso.cur_img = trex_dust_torso.texture.get_image()
					trex_dust_torso.visible = true
					organism.dust = trex_dust_torso
		"Anky":
			match subtype:
				"ArmL":
					anky_dust_arm_l.cur_img = anky_dust_arm_l.texture.get_image()
					anky_dust_arm_l.visible = true
					organism.dust = anky_dust_arm_l
				"ArmR":
					anky_dust_arm_r.cur_img = anky_dust_arm_r.texture.get_image()
					anky_dust_arm_r.visible = true
					organism.dust = anky_dust_arm_r
				"LegL":
					anky_dust_leg_l.cur_img = anky_dust_leg_l.texture.get_image()
					anky_dust_leg_l.visible = true
					organism.dust = anky_dust_leg_l
				"LegR":
					anky_dust_leg_r.cur_img = anky_dust_leg_r.texture.get_image()
					anky_dust_leg_r.visible = true
					organism.dust = anky_dust_leg_r
				"Skull":
					anky_dust_skull.cur_img = anky_dust_skull.texture.get_image()
					anky_dust_skull.visible = true
					organism.dust = anky_dust_skull
				"Tail":
					anky_dust_tail.cur_img = anky_dust_tail.texture.get_image()
					anky_dust_tail.visible = true
					organism.dust = anky_dust_tail
				"Torso":
					anky_dust_torso.cur_img = anky_dust_torso.texture.get_image()
					anky_dust_torso.visible = true
					organism.dust = anky_dust_torso
		"Mame":
			match subtype:
				"Arms":
					mame_dust_arms.cur_img = mame_dust_arms.texture.get_image()
					mame_dust_arms.visible = true
					organism.dust = mame_dust_arms
				"Legs":
					mame_dust_legs.cur_img = mame_dust_legs.texture.get_image()
					mame_dust_legs.visible = true
					organism.dust = mame_dust_legs
				"Skull":
					mame_dust_skull.cur_img = mame_dust_skull.texture.get_image()
					mame_dust_skull.visible = true
					organism.dust = mame_dust_skull
				"Tail":
					mame_dust_tail.cur_img = mame_dust_tail.texture.get_image()
					mame_dust_tail.visible = true
					organism.dust = mame_dust_tail
				"Torso":
					mame_dust_torso.cur_img = mame_dust_torso.texture.get_image()
					mame_dust_torso.visible = true
					organism.dust = mame_dust_torso
				"Spine":
					mame_dust_spine.cur_img = mame_dust_spine.texture.get_image()
					mame_dust_spine.visible = true
					organism.dust = mame_dust_spine
		"Pter":
			match subtype:
				"ArmL":
					pter_dust_arm_l.cur_img = pter_dust_arm_l.texture.get_image()
					pter_dust_arm_l.visible = true
					organism.dust = pter_dust_arm_l
				"ArmR":
					pter_dust_arm_r.cur_img = pter_dust_arm_r.texture.get_image()
					pter_dust_arm_r.visible = true
					organism.dust = pter_dust_arm_r
				"Legs":
					pter_dust_legs.cur_img = pter_dust_legs.texture.get_image()
					pter_dust_legs.visible = true
					organism.dust = pter_dust_legs
				"Skull":
					pter_dust_skull.cur_img = pter_dust_skull.texture.get_image()
					pter_dust_skull.visible = true
					organism.dust = pter_dust_skull
				"Torso":
					pter_dust_torso.cur_img = pter_dust_torso.texture.get_image()
					pter_dust_torso.visible = true
					organism.dust = pter_dust_torso
		"Misc":
			match subtype:
				"Gem":
					misc_dust_gem.cur_img = misc_dust_gem.texture.get_image()
					misc_dust_gem.visible = true
					organism.dust = misc_dust_gem

# Back away from the fossil mini-game: reset everything.
func _on_exit_button_pressed() -> void:
	if SelectTools.cur_attribute != "empty":
		create_tween().tween_property(confirm_screen, "scale", Vector2(1.0, 1.0), screen_zoom).set_trans(Tween.TRANS_SINE)
		SelectTools.untoggle_all()
		block.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		exit_and_remove_dig_spot("empty")

# Upon being clicked on, reduce the fossil's health bar.
func _on_fossil_pressed() -> void:
	# Counts as long as any tool besides the brush or no other tool is selected, and allows breathing room with 1 second of delay.
	if !SelectTools.selected_brush and (SelectTools.selected_paw or SelectTools.selected_pickaxe or SelectTools.selected_chisel) and !health_delay:
		health_bar.visible = true
		AudioPlayer.play_sound("tool_pickaxe")
		if SelectTools.selected_paw: #If paw is selected, only partially damage the fossil
			health_bar.value -= paw_damage
		else: #If pickaxe/chisel is selected, damage the fossil
			health_bar.value -= pickaxe_chisel_damage
		health_delay = true
		block.mouse_filter = Control.MOUSE_FILTER_STOP
		
		#Animate the fossil turning red and shaking. Dust does not seem to work (commented out).
		var cur_position = fossil.position
		var tween_1 = create_tween()
		tween_1.parallel().tween_property(fossil, "modulate", Color.RED, time_fossil_fade_red)
		#tween_1.parallel().tween_property(dust, "modulate", Color.RED, time_fossil_fade_red)
		var tween_2 = create_tween()
		for shake in shake_count:
			var shake_x_position = cur_position.x + randf_range(-shake_offset, shake_offset)
			tween_2.tween_property(fossil, "position", Vector2(shake_x_position, cur_position.y), shake_duration).set_trans(Tween.TRANS_SINE)
			#tween_2.tween_property(dust, "position", Vector2(shake_x_position, cur_position.y), shake_duration).set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(time_health_appears).timeout
		var tween_3 = create_tween()
		tween_3.parallel().tween_property(fossil, "modulate", Color.WHITE, time_fossil_fade_red)
		#tween_3.parallel().tween_property(dust, "modulate", Color.WHITE, time_fossil_fade_red)
		var tween_4 = create_tween()
		tween_4.parallel().tween_property(fossil, "position", Vector2(cur_position.x, cur_position.y), shake_duration)
		#tween_4.parallel().tween_property(dust, "position", Vector2(cur_position.x, cur_position.y), shake_duration)
		
		health_bar.visible = false
		health_delay = false
		block.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if health_bar.value == 0:
			SelectTools.untoggle_all()
			create_tween().tween_property(failed_screen, "scale", Vector2(1.0, 1.0), screen_zoom).set_trans(Tween.TRANS_SINE)
			AudioPlayer.play_sound("failed_1")
			block.mouse_filter = Control.MOUSE_FILTER_STOP

# Exit the fossil mini-game and remove the dig spot.
func exit_and_remove_dig_spot(check : String) -> void:
	if (check == "empty" and SelectTools.cur_attribute == check):
		SelectTools.exited_empty_minigame = true
		print("runs")
	TransitionScreen.transition("skull")
	await TransitionScreen.on_transition_finished
	SelectTools.mg_digging_done = false
	SelectTools.mg_mining_done = false
	SelectTools.mg_extracting_done = false
	SelectTools.mg_dusting_done = false
	SelectTools.visible = false
	SelectTools.in_fossil_minigame = false
	SelectTools.cur_attribute = ""
	Tutorial.interacted_spot = false
	visible = false
	queue_free()

#Updates the variable checking if the mouse is hovering over the fossil.
func _on_fossil_mouse_entered() -> void:
	is_hover_over_fossil = true

func _on_fossil_mouse_exited() -> void:
	is_hover_over_fossil = false

#Confirm screen for trying to leave the mini-game in the middle of it.
func _on_yes_button_pressed() -> void:
	create_tween().tween_property(confirm_screen, "scale", Vector2(0.0, 0.0), screen_zoom).set_trans(Tween.TRANS_SINE)
	exit_and_remove_dig_spot("empty")
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_no_button_pressed() -> void:
	create_tween().tween_property(confirm_screen, "scale", Vector2(0.0, 0.0), screen_zoom).set_trans(Tween.TRANS_SINE)
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE

#Try again button.
func _on_try_again_button_pressed() -> void:
	create_tween().tween_property(failed_screen, "scale", Vector2(0.0, 0.0), screen_zoom).set_trans(Tween.TRANS_SINE)
	exit_and_remove_dig_spot("empty")
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE
