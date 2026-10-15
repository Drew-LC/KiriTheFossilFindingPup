extends Node2D

@onready var kiri: Node2D = $Kiri
@onready var shop: Area2D = $Shop

func _ready() -> void:
	kiri.speed = 1000.0
	HUD.current_location_node = self #Set the current location node as this location.
	HUD.current_location_name = "blacksmith"
	AudioPlayer.play_music("Indoor")
	if NaviationManager.spawn_door_tag != null:
		_on_level_spawn(NaviationManager.spawn_door_tag)
	if Tutorial.accepted_quest: #If in tutorial...
		match HUD.current_side:
			"shop":
				HUD.quest_reach_shop = true
				HUD.quest_button.just_changed = true if (HUD.quest_reach_shop and !HUD.quest_button.just_changed) else HUD.quest_button.just_changed
				if !HUD.quest_bought_item:
					Tutorial.side_node = shop.collision_shape_2d
				else:
					Tutorial.side_node = Tutorial.empty_interest
			"home":
				HUD.quest_reach_shop = true
				HUD.quest_button.just_changed = true if (HUD.quest_reach_shop and !HUD.quest_button.just_changed) else HUD.quest_button.just_changed
				if !HUD.quest_bought_item:
					Tutorial.side_node = shop.collision_shape_2d
				else:
					Tutorial.side_node = Tutorial.empty_interest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Tutorial.accepted_quest: #If in tutorial...
		match HUD.current_side:
			"shop":
				if !HUD.quest_bought_item:
					Tutorial.side_node = shop.collision_shape_2d
				else:
					Tutorial.side_node = Tutorial.empty_interest
			"home":
				if !HUD.quest_bought_item:
					Tutorial.side_node = shop.collision_shape_2d
				else:
					Tutorial.side_node = Tutorial.empty_interest

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/" + destination_tag
	var door = get_node(door_path) as Door
	NaviationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
