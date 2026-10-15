extends Area2D

@export var required_piece_id: String = ""
@export var snap_offset: Vector2 = Vector2(0, 0)
var is_filled = false

func check_piece(piece) -> bool:
	if is_filled:
		return false
	return piece.piece_id == required_piece_id

func fill(piece):
	is_filled = true
	piece.global_position = global_position + snap_offset
	piece.is_placed = true
	piece.dragging = false
	piece.disabled = false
	piece.z_index = 0
	check_puzzle_complete()

func check_puzzle_complete():
	# get snap zones only from this minigame, not all scenes
	for zone in get_parent().get_children():
		if zone.is_in_group("snap_zones"):
			if not zone.is_filled:
				return
	on_win()

func on_win():
	HUD.quest_finish_assembly = true
	HUD.quest_button.just_changed = true
	print("You win!")
	await get_tree().create_timer(1.0).timeout #Adjust appropriately.
	
	var minigame_root = get_parent().get_parent()
	var dino = minigame_root.dino_name
	print("dino name: ", dino)
	
	#var bench = get_tree().get_root().get_node("museumScene/Bench")
	#if bench and dino != "":
		#var requirements = bench.dino_requirements[dino]
		#print("requirements: ", requirements)
		#for bone_name in requirements:
			#print("trying to remove: ", bone_name)
			#InventoryCanvasLayer.inventory.remove_item(bone_name, requirements[bone_name], "Items")
	
	minigame_root.visible = false
	
	# show ID sheet
	var id_sheet = get_tree().get_root().get_node("museumScene/IDSheet")
	if id_sheet:
		id_sheet.show_sheet(dino)
	else:
		push_error("IDSheet not found!")
