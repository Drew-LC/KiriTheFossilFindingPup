extends CanvasLayer
signal call_tween(object_position: Vector2, zoom_value: Vector2, duration: float)

var statue_zoom := Vector2(0.3, 0.3)
var duration : float 
var statue_position : Vector2
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var hint: Control = $CanvasLayer/HintButton/Control
@onready var id_sheet: TextureRect = $Panel/IdSheet
@onready var label: Label = $Panel/IdSheet/Label
@onready var hint_key: AnimatedSprite2D = $CanvasLayer/HintButton/AnimatedSprite2D
@onready var hint_button: TextureButton = $CanvasLayer/HintButton
@onready var tutorial_arrow: TextureRect = $CanvasLayer/HintButton/TutorialArrow

var dino_name: String = ""

var dino_video_map = {
	"Trex": "res://assets/video/Trex.ogv",
	"Ankylosaurus": "res://assets/video/Anklyosaurus.ogv",
	"Mamenchisaurus": "res://assets/video/Mamenchisaurus.ogv",
	"Pterosaurs": "res://assets/video/PterosaurA.ogv"
}

var dino_anim_map = {
	"Trex": "TrexAnimation",
	"Ankylosaurus": "AnklyosaurusAnimation",
	"Mamenchisaurus": "MamenchisaurusAnimation",
	"Pterosaurs": "PterosaursAnimation"
}

var correct_answers = {
	"Trex": {
		"name": "TrexCheck",
		"found_in": ["HellCreekCheck"],
		"era": "LateCretaceousCheck",
		"is": "CarnivoreCheck"
	},
	"Ankylosaurus": {
		"name": "AnkylosaurusCheck",
		"found_in": ["LanceCheck"],
		"era": "LateCretaceousCheck",
		"is": "HerbivoreCheck"
	},
	"Mamenchisaurus": {
		"name": "MamenchisaurusCheck",
		"found_in": ["ShaximiaoCheck"],
		"era": "LateJurassicCheck",
		"is": "HerbivoreCheck"
	},
	"Pterosaurs": {
		"name": "PterosaurCheck",
		"found_in": ["NiobraraCheck"],
		"era": "MesozoicCheck",
		"is": "CarnivoreCheck"
	}
}

var dino_display_map = {
	"Trex": "TrexFull",
	"Ankylosaurus": "AnkylosaurusFull",
	"Mamenchisaurus": "MamenchisaurusFull",
	"Pterosaurs": "PterosaurFull"
}

func show_sheet(dino: String):
	dino_name = dino
	print("showing sheet for: ", dino)
	var trex = get_tree().get_root().get_node_or_null("museumScene/TrexFull")
	print("TrexFull visible before: ", trex.visible)
	get_node("CanvasLayer/HintButton/Control/" + dino_name + "Skeleton").visible = true
	
	for node in [
		$Panel/IdSheet/TrexCheck,
		$Panel/IdSheet/AnkylosaurusCheck,
		$Panel/IdSheet/MamenchisaurusCheck,
		$Panel/IdSheet/PterosaurCheck,
		$Panel/IdSheet/NiobraraCheck,
		$Panel/IdSheet/HellCreekCheck,
		$Panel/IdSheet/LanceCheck,
		$Panel/IdSheet/ShaximiaoCheck,
		$Panel/IdSheet/LateJurassicCheck,
		$Panel/IdSheet/LateCretaceousCheck,
		$Panel/IdSheet/MesozoicCheck,
		$Panel/IdSheet/CarnivoreCheck,
		$Panel/IdSheet/HerbivoreCheck,
		$Panel/IdSheet/OmnivoreCheck]:
		node.button_pressed = false
	TransitionScreen.transition("skull")
	await TransitionScreen.on_transition_finished
	visible = true
	HUD.in_assembly = false
	HUD.in_ID_sheet = true

		
func _on_button_pressed() -> void:
	if check_answers():
		print("Correct!")
		label.text = "Correct!"
		create_tween().tween_property(label, "modulate:a", 1, 0.5)
		await create_tween().tween_property(id_sheet, "modulate", Color.GREEN, 0.5).finished
		create_tween().tween_property(id_sheet, "modulate", Color.WHITE, 0.5).finished
		await create_tween().tween_property(label, "modulate:a", 0, 0.5).finished
		label.text = ""
		
		HUD.quest_finish_ID = true
		HUD.quest_button.just_changed = true
		match HUD.current_quest:
			"trex": HUD.quest_trex_ID = true
			"anky": HUD.quest_anky_ID = true
			"mame": HUD.quest_mame_ID = true
			"pter": HUD.quest_pter_ID = true
		
		HUD.in_ID_sheet = false
		HUD.in_video = true
		self.visible = false
		HUD.visible = false
		ReferencePage.reference_page.visible = false
		get_node("CanvasLayer/HintButton/Control/" + dino_name + "Skeleton").visible = false
		
		var dino_anim = get_tree().get_root().get_node_or_null("museumScene/DinoAnim")
		print("DinoAnim: ", dino_anim)
		print("dino_name: ", dino_name)
		print("in map: ", dino_name in dino_anim_map)
		var trex = get_tree().get_root().get_node_or_null("museumScene/TrexFull")
		print("TrexFull visible in submit: ", trex.visible)
		if dino_anim and dino_name in dino_anim_map:
			dino_anim.visible = true
	# hide all video players first
	# show and play only the correct one
		var video_player = dino_anim.get_node_or_null("Control/" + dino_anim_map[dino_name])
		if video_player:
			video_player.visible = true
			video_player.stream = load(dino_video_map[dino_name])
			video_player.play()
			AudioPlayer.play_music("VideoReward")
			print("playing!")
			await video_player.finished
			remove_fossils()
			HUD.in_video = false
			var dino_full = get_tree().get_root().get_node_or_null("museumScene/" + dino_display_map[dino_name])
			print(dino_full)
			print(dino_name)
			if dino_full:
				dino_full.visible = true
			else:
				push_error("DinoFull not found: " + dino_display_map[dino_name])
			AudioPlayer.play_music("Indoor")
			dino_anim.visible = false
			print("dino name: ", dino_name)
			match dino_name:
				"Trex":
					if !HUD.trex_tweened:
						statue_position = Vector2(-2000, -2000)
						duration = 2.0
						HUD.trex_tweened = true
						emit_signal("call_tween", statue_position, statue_zoom, duration)
					
				"Ankylosaurus":
					if !HUD.anky_tweened:
						statue_position = Vector2(2630, 1760)
						duration = 2.0 
						HUD.anky_tweened = true
						emit_signal("call_tween", statue_position, statue_zoom, duration)
						print("Anky_tween")
						
				"Mamenchisaurus":
					if !HUD.mame_tweened: 
						statue_position = Vector2(810, -2050)
						duration = 2.0 
						HUD.mame_tweened = true							
						emit_signal("call_tween", statue_position, statue_zoom, duration)
						print("Mame_tween")
						
				"Pterosaurs":
					if !HUD.pter_tweened:			
						statue_position = Vector2(-1110, -490)
						duration = 2.0 
						HUD.pter_tweened = true							
						emit_signal("call_tween", statue_position, statue_zoom, duration)
						print("Pter_tweened")
				_:
					print("sum ain't right...")
		else:
			push_error("Video player not found: " + dino_anim_map[dino_name])
		
		HUD.visible = true
		
		var kiri = get_tree().get_root().get_node_or_null("museumScene/Kiri")
		print (kiri)
		if kiri:
			kiri.set_physics_process(true)
	else:
		print("Some answers are wrong, try again!")
		label.text = "Try again!"
		create_tween().tween_property(label, "modulate:a", 1, 0.5)
		await create_tween().tween_property(id_sheet, "modulate", Color.RED, 0.5).finished
		create_tween().tween_property(id_sheet, "modulate", Color.WHITE, 0.5).finished
		await create_tween().tween_property(label, "modulate:a", 0, 0.5).finished
		label.text = ""
		
func check_answers() -> bool:
	var answers = correct_answers[dino_name]
	var base = $Panel/IdSheet
	
	# check name
	if not base.get_node(answers["name"]).button_pressed:
		return false
	for box in ["TrexCheck", "AnkylosaurusCheck", "MamenchisaurusCheck", "PterosaurCheck"]:
		if box != answers["name"] and base.get_node(box).button_pressed:
			return false
	
	# check found_in
	for box in ["NiobraraCheck", "HellCreekCheck", "LanceCheck", "ShaximiaoCheck"]:
		if base.get_node(box).button_pressed != (box in answers["found_in"]):
			return false
	
	# check era
	for box in ["LateJurassicCheck", "LateCretaceousCheck", "MesozoicCheck"]:
		if base.get_node(box).button_pressed != (box == answers["era"]):
			return false
	
	# check is
	for box in ["CarnivoreCheck", "HerbivoreCheck", "OmnivoreCheck"]:
		if base.get_node(box).button_pressed != (box == answers["is"]):
			return false
	
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	canvas_layer.visible = visible
	hint_button.button_pressed = ReferencePage.reference_page.visible

# Show the dinosaur skeleton and quick instructions.
func _on_hint_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ReferencePage.reference_page.visible = true
		hint.visible = false
		hint_key.frame = 1
		create_tween().tween_property(tutorial_arrow, "modulate:a", 0, 0.5)
	else:
		ReferencePage.reference_page.visible = false
		hint.visible = true
		hint_key.frame = 0

func remove_fossils():
	var bench = get_tree().get_root().get_node("museumScene/Bench")
	if bench and dino_name != "":
		var requirements = bench.dino_requirements[dino_name]
		print("requirements: ", requirements)
		for bone_name in requirements:
			print("trying to remove: ", bone_name)
			InventoryCanvasLayer.inventory.remove_item(bone_name, requirements[bone_name], "Items")
