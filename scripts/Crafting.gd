extends Area2D

var player_in_range = false
var minigame_open = false
var player_reference = null
var dinosaurs = []
var current_index = 0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $CollisionShape2D/List/BlackDarkSeamlessFabricTextureInterlacingStructureScannedVeryHighExtensionResolutionCanBeUsedCreating242259845/Label
@onready var check: TextureButton = $CollisionShape2D/List/Check

var dino_requirements = {
	"Trex": {
		"trex_tail": 1,
		"trex_legs": 1,
		"trex_torso": 1,
		"trex_hands": 1,
		"trex_skull": 1
	},
	"Ankylosaurus": {
		"anky_skull": 1,
		"anky_armR": 1,
		"anky_armL": 1,
		"anky_legL": 1,
		"anky_legR": 1,
		"anky_torso": 1,
		"anky_tail": 1
	},
	"Mamenchisaurus": {
		"mame_skull": 1,
		"mame_arms": 1,
		"mame_legs": 1,
		"mame_spine": 1,
		"mame_torso": 1,
		"mame_tail": 1
	},
	"Pterosaurs": {
		"pter_skull": 1,
		"pter_torso": 1,
		"pter_legs": 1,
		"pter_armR": 1,
		"pter_armL": 1
	}
}

var minigame_map = {
	"Trex": "TrexMinigame",
	"Ankylosaurus": "AnkylosaurusMinigame",
	"Mamenchisaurus": "MamenchisaurusMinigame",
	"Pterosaurs": "PterosaursMinigame"
}

func _ready():
	
	print("InventoryCanvasLayer: ", InventoryCanvasLayer)
	for child in InventoryCanvasLayer.get_children():
		print("child: ", child.name)
	print("Left node: ", $CollisionShape2D/List/Left)
	print("Left type: ", $CollisionShape2D/List/Left.get_class())
	$CollisionShape2D/List.visible = false
	
	for child in $CollisionShape2D/List.get_children():
		if not child.name.begins_with("Black") and child.name != "Left" \
		and child.name != "Right" and child.name != "Close" and child.name != "Check":
			dinosaurs.append(child)
	
	update_display()

func get_item_count(item_name: String) -> int:
	var grid = InventoryCanvasLayer.inventory.get_node("MarginContainer/VBoxContainer/HBoxInventory&profile/ItemInventory/GridContainer")
	if grid != null:
		for slot in grid.get_children():
			if slot.get_child_count() == 1:
				var item = slot.get_child(0)
				if item.item_name == item_name:
					return item.count_count
	return 0

func get_missing_bones() -> Dictionary:
	var dino_name = dinosaurs[current_index].name
	var missing = {}
	if dino_name in dino_requirements:
		for bone_name in dino_requirements[dino_name]:
			var required = dino_requirements[dino_name][bone_name]
			var have = get_item_count(bone_name)
			if have < required:
				missing[bone_name] = required - have
	return missing

func _on_body_entered(body: Node2D) -> void:
	print("body entered: ", body.name)
	if body.is_in_group("Kiri") or body.name == "Kiri" or body.name == "KiriSprite":
		player_in_range = true
		player_reference = body
		print("Kiri in range!")
		if HUD.quest_reach_museum: Tutorial.near_podium = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri" or body.name == "KiriSprite":
		player_in_range = false
		player_reference = null
		if HUD.quest_reach_museum: Tutorial.near_podium = false
		close_list()

func start_list():
	current_index = 0
	$CollisionShape2D/List.visible = true
	minigame_open = true
	print("Dinosaurs array: ", dinosaurs)
	print("Current index: ", current_index)
	for i in dinosaurs.size():
		print("Dino ", i, ": ", dinosaurs[i].name, " visible: ", dinosaurs[i].visible)
	update_display()
	if player_reference:
		player_reference.set_physics_process(false)
		player_reference.velocity = Vector2.ZERO

func close_list():
	$CollisionShape2D/List.visible = false
	minigame_open = false
	if player_reference:
		player_reference.set_physics_process(true)

func open_minigame(dino_name: String):
	TransitionScreen.transition("skull")
	await TransitionScreen.on_transition_finished
	var minigame_name = minigame_map[dino_name]
	var minigame = get_parent().get_node("Minigames/" + minigame_name)
	print("minigame node: ", minigame)
	print("setting dino_name to: ", dino_name)
	if minigame:
		minigame.dino_name = dino_name
		print("dino_name after set: ", minigame.dino_name)
		minigame.visible = true
		if player_reference:
			player_reference.set_physics_process(false)
			player_reference.velocity = Vector2.ZERO
	else:
		push_error("Minigame not found: " + minigame_name)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("press") and (!HUD.in_assembly and !HUD.in_ID_sheet and !HUD.in_video):
		print("E pressed!")
		if !minigame_open:
			start_list()
	match HUD.current_quest:
		"trex": check.disabled = false if dinosaurs[current_index].name == "Trex" else true
		"anky": check.disabled = false if dinosaurs[current_index].name == "Ankylosaurus" else true
		"mame": check.disabled = false if dinosaurs[current_index].name == "Mamenchisaurus" else true
		"pter": check.disabled = false if dinosaurs[current_index].name == "Pterosaurs" else true

func update_display():
	for i in dinosaurs.size():
		dinosaurs[i].visible = (i == current_index)

func _on_right_pressed():
	current_index = (current_index + 1) % dinosaurs.size()
	update_display()

func _on_left_pressed():
	print("LEFT FIRED, index before: ", current_index)
	current_index = (current_index - 1 + dinosaurs.size()) % dinosaurs.size()
	print("index after: ", current_index)
	update_display()


func _on_check_pressed():
	var dino_name = dinosaurs[current_index].name
	print("Check pressed, dino: ", dino_name)
	var missing = get_missing_bones()
	print("Missing: ", missing)
	if missing.is_empty():
		print("All bones found! Opening: ", dino_name)
		HUD.in_assembly = true
		open_minigame(dino_name)
		close_list()
	else:
		print("Missing bones: ", missing)
		await create_tween().tween_property(label, "modulate:a", 1, 0.2).finished
		await get_tree().create_timer(1.5).timeout
		create_tween().tween_property(label, "modulate:a", 0, 0.2)

func _on_close_pressed() -> void:
	close_list()
	if player_reference:
		player_reference.set_physics_process(true)
