extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"): #Skip to each quest's assembly section.
		match HUD.current_quest:
			"trex":
				if !HUD.quest_reach_museum: #Skip the digging
					HUD.quest_reach_cave = true
					HUD.quest_find_fossils = true
					HUD.quest_found_fossils = 5
					HUD.quest_fossils_list = ["trex_hands", "trex_legs", "trex_tail", "trex_torso", "trex_skull"]
					HUD.quest_reach_museum = true
					HUD.quest_button.just_changed = true
					Tutorial.sprint_first = true
					Tutorial.sniff_first = true
					
					var tail_data = ItemData.new()
					tail_data.item_name = "trex_tail"
					tail_data.description = "A Trex tail bone."
					tail_data.icon = load("res://assets/gfx/fossil_mg/trex/trex_tail_fossil.png")
					tail_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(tail_data, 1, "Items")

					var legs_data = ItemData.new()
					legs_data.item_name = "trex_legs"
					legs_data.description = "Trex leg bones."
					legs_data.icon = load("res://assets/gfx/fossil_mg/trex/trex_legs_fossil.png")
					legs_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(legs_data, 1, "Items")

					var body_data = ItemData.new()
					body_data.item_name = "trex_torso"
					body_data.description = "Trex body bones."
					body_data.icon = load("res://assets/gfx/fossil_mg/trex/trex_torso_fossil.png")
					body_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(body_data, 1, "Items")

					var arm_data = ItemData.new()
					arm_data.item_name = "trex_hands"
					arm_data.description = "Trex arm bones."
					arm_data.icon = load("res://assets/gfx/fossil_mg/trex/trex_hands_fossil.png")
					arm_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(arm_data, 1, "Items")

					var head_data = ItemData.new()
					head_data.item_name = "trex_skull"
					head_data.description = "Trex head bone."
					head_data.icon = load("res://assets/gfx/fossil_mg/trex/trex_skull_fossil.png")
					head_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(head_data, 1, "Items")
				else: #Skip the assembling
					HUD.quest_finish_assembly = true
					HUD.quest_finish_ID = true
					HUD.quest_trex_ID = true
					HUD.quest_button.just_changed = true
			
			"anky":
				if !HUD.quest_reach_museum: #Skip the digging
					HUD.quest_reach_cave = true
					HUD.quest_find_fossils = true
					HUD.quest_found_fossils = 5
					HUD.quest_fossils_list = ["anky_armL", "anky_armR", "anky_legL", "anky_legR", "anky_tail", "anky_torso", "anky_skull"]
					HUD.quest_reach_museum = true
					HUD.quest_button.just_changed = true
			
					var ankyhead_data = ItemData.new()
					ankyhead_data.item_name = "anky_skull"
					ankyhead_data.description = "Anky head bone."
					ankyhead_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_skull_fossil.png")
					ankyhead_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankyhead_data, 1, "Items")
					
					var ankytorso_data = ItemData.new()
					ankytorso_data.item_name = "anky_torso"
					ankytorso_data.description = "Anky torso bone."
					ankytorso_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_torso_fossil.png")
					ankytorso_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankytorso_data, 1, "Items")
					
					var ankytail_data = ItemData.new()
					ankytail_data.item_name = "anky_tail"
					ankytail_data.description = "Anky tail bone."
					ankytail_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_tail_fossil.png")
					ankytail_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankytail_data, 1, "Items")

					var ankyarmL_data = ItemData.new()
					ankyarmL_data.item_name = "anky_armL"
					ankyarmL_data.description = "Anky Left Arm bone."
					ankyarmL_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_armL_fossil.png")
					ankyarmL_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankyarmL_data, 1, "Items")

					var ankyarmR_data = ItemData.new()
					ankyarmR_data.item_name = "anky_armR"
					ankyarmR_data.description = "Anky Right Arm bone."
					ankyarmR_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_armR_fossil.png")
					ankyarmR_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankyarmR_data, 1, "Items")

					var ankyLegL_data = ItemData.new()
					ankyLegL_data.item_name = "anky_legL"
					ankyLegL_data.description = "Anky Left Leg bone."
					ankyLegL_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_legL_fossil.png")
					ankyLegL_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankyLegL_data, 1, "Items")
					
					var ankyLegR_data = ItemData.new()
					ankyLegR_data.item_name = "anky_legR"
					ankyLegR_data.description = "Anky Right Leg bone."
					ankyLegR_data.icon = load("res://assets/gfx/fossil_mg/anky/anky_legR_fossil.png")
					ankyLegR_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ankyLegR_data, 1, "Items")
				else: #Skip the assembling
					HUD.quest_finish_assembly = true
					HUD.quest_finish_ID = true
					HUD.quest_anky_ID = true
					HUD.quest_button.just_changed = true
			
			"mame":
				if !HUD.quest_reach_museum: #Skip the digging
					HUD.quest_reach_cave = true
					HUD.quest_find_fossils = true
					HUD.quest_found_fossils = 5
					HUD.quest_fossils_list = ["mame_arms", "mame_legs", "mame_spine", "mame_tail", "mame_torso", "mame_skull"]
					HUD.quest_reach_museum = true
					HUD.quest_button.just_changed = true
					
					var mameskull_data = ItemData.new()
					mameskull_data.item_name = "mame_skull"
					mameskull_data.description = "Mamenchisaurus Head bone."
					mameskull_data.icon = load("res://assets/gfx/fossil_mg/mame/mame_skull_fossil.png")
					mameskull_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(mameskull_data, 1, "Items")
					
					var mamespine_data = ItemData.new()
					mamespine_data.item_name = "mame_spine"
					mamespine_data.description = "Mamenchisaurus Spine bone."
					mamespine_data.icon = load("res://assets/gfx/fossil_mg/mame/mame_spine_fossil.png")
					mamespine_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(mamespine_data, 1, "Items")

					var mamebody_data = ItemData.new()
					mamebody_data.item_name = "mame_torso"
					mamebody_data.description = "Mamenchisaurus Torso bone."
					mamebody_data.icon = load("res://assets/gfx/fossil_mg/mame/mame_torso_fossil.png")
					mamebody_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(mamebody_data, 1, "Items")
					
					var mamelegs_data = ItemData.new()
					mamelegs_data.item_name = "mame_legs"
					mamelegs_data.description = "Mamenchisaurus leg bones."
					mamelegs_data.icon = load("res://assets/gfx/fossil_mg/mame/mame_legs_fossil.png")
					mamelegs_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(mamelegs_data, 1, "Items")
					
					var mamearms_data = ItemData.new()
					mamearms_data.item_name = "mame_arms"
					mamearms_data.description = "Mamenchisaurus Arm bones."
					mamearms_data.icon = load("res://assets/gfx/fossil_mg/mame/mame_arms_fossil.png")
					mamearms_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(mamearms_data, 1, "Items")
					
					var mametail_data = ItemData.new()
					mametail_data.item_name = "mame_tail"
					mametail_data.description = "Mamenchisaurus tail bone."
					mametail_data.icon = load("res://assets/gfx/fossil_mg/mame/mame_tail_fossil.png")
					mametail_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(mametail_data, 1, "Items")
				else: #Skip the assembling
					HUD.quest_finish_assembly = true
					HUD.quest_finish_ID = true
					HUD.quest_mame_ID = true
					HUD.quest_button.just_changed = true
		
			"pter":
				if !HUD.quest_reach_museum: #Skip the digging
					HUD.quest_reach_cave = true
					HUD.quest_find_fossils = true
					HUD.quest_found_fossils = 5
					HUD.quest_fossils_list = ["pter_armL", "pter_armR", "pter_torso", "pter_legs", "pter_skull"]
					HUD.quest_reach_museum = true
					HUD.quest_button.just_changed = true
					
					var pterarmL_data = ItemData.new()
					pterarmL_data.item_name = "pter_armL"
					pterarmL_data.description = "Pterosaur Left Arm bone."
					pterarmL_data.icon = load("res://assets/gfx/fossil_mg/pter/pter_armL_fossil.png")
					pterarmL_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(pterarmL_data, 1, "Items")
					
					var pterarmR_data = ItemData.new()
					pterarmR_data.item_name = "pter_armR"
					pterarmR_data.description = "Pterosaur Right Arm bone."
					pterarmR_data.icon = load("res://assets/gfx/fossil_mg/pter/pter_armR_fossil.png")
					pterarmR_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(pterarmR_data, 1, "Items")

					var ptertorso_data = ItemData.new()
					ptertorso_data.item_name = "pter_torso"
					ptertorso_data.description = "Pterosaur Torso bone."
					ptertorso_data.icon = load("res://assets/gfx/fossil_mg/pter/pter_torso_fossil.png")
					ptertorso_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(ptertorso_data, 1, "Items")
					
					var pterlegs_data = ItemData.new()
					pterlegs_data.item_name = "pter_legs"
					pterlegs_data.description = "Pterosaur leg bones."
					pterlegs_data.icon = load("res://assets/gfx/fossil_mg/pter/pter_legs_fossil.png")
					pterlegs_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(pterlegs_data, 1, "Items")
					
					var pterskull_data = ItemData.new()
					pterskull_data.item_name = "pter_skull"
					pterskull_data.description = "Pterosaur Skull bones."
					pterskull_data.icon = load("res://assets/gfx/fossil_mg/pter/pter_skull_fossil.png")
					pterskull_data.max_stack = 1
					InventoryCanvasLayer.get_node("inventory").add_item(pterskull_data, 1, "Items")
				else: #Skip the assembling
					HUD.quest_finish_assembly = true
					HUD.quest_finish_ID = true
					HUD.quest_pter_ID = true
					HUD.quest_button.just_changed = true
