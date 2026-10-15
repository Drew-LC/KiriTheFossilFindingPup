extends Node2D

@onready var kiri: Node2D = $Kiri
@onready var tutorial_arrow: TextureRect = $TutorialArrow
@onready var door_to_cave: Door = $Doors/door_to_cave
@onready var door_to_museum: Door = $Doors/door_to_museum
@onready var door_to_beach: Door = $Doors/door_to_beach
@onready var door_to_blacksmith: Door = $Doors/door_to_blacksmith
@onready var door_to_home: Door = $Doors/door_to_home
@onready var stop: TextureRect = $NoEntry/Stop
@onready var time_no_fade := 0.2

func _ready() -> void:
	HUD.current_location_node = self #Set the current location node as this location.
	HUD.current_location_name = "village"
	Tutorial.side_node = Tutorial.empty_interest
	kiri.speed = 600
	if NaviationManager.spawn_door_tag != null:
		_on_level_spawn(NaviationManager.spawn_door_tag)
	AudioPlayer.play_music("Village")
	Tutorial.made_exit_first = true #The player reached outside the museum.
	match HUD.current_quest:
		"trex", "mame":
			if !HUD.quest_find_fossils: #If before finding all fossils, point to Crystal Cave.
				Tutorial.interest_node = door_to_cave.collision_shape_2d
			else: #Else, point to the museum.
				Tutorial.interest_node = door_to_museum.collision_shape_2d
		"anky", "pter":
			if !HUD.quest_find_fossils: #If before finding all fossils, point to Sandy Beach.
				Tutorial.interest_node = door_to_beach.collision_shape_2d
	match HUD.current_side:
		"shop":
			if !HUD.quest_reach_shop:
				Tutorial.side_node = door_to_blacksmith.collision_shape_2d
		"home":
			if !HUD.quest_reach_shop:
				Tutorial.side_node = door_to_blacksmith.collision_shape_2d
			elif HUD.quest_bought_item:
				Tutorial.side_node = door_to_home.collision_shape_2d

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#tutorial_arrow.visible = true if (Tutorial.selected_tutorial and Tutorial.made_exit_first and !HUD.quest_reach_cave) else false

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/" + destination_tag
	var door = get_node(door_path) as Door
	NaviationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)

#Visibly prevent the player from entering the below 
func _on_no_entry_body_entered(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri":
		create_tween().tween_property(stop, "modulate:a", 1, time_no_fade)

func _on_no_entry_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri":
		create_tween().tween_property(stop, "modulate:a", 0, time_no_fade)
