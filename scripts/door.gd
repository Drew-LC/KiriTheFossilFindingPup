extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"
@export var check: bool
@onready var spawn: Marker2D = $Spawn
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player_inside = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside = true
		tutorial_check_for_kiri()
		match check:
			true:
				if Input.is_action_pressed("press"):
					print("got_signal")
					NaviationManager.go_to_level(destination_level_tag, destination_door_tag)
			false:
				verify_progress(false)

func _on_body_exited(body: Node2D) -> void:
	if body is Player: 
		player_inside = false
		if destination_level_tag == "village":
			Tutorial.near_exit_to_village = false
		elif destination_level_tag == "museum":
			Tutorial.touch_museum_entrance = false
			Tutorial.near_exit_after_found = false
		elif destination_level_tag == "crystalCave":
			Tutorial.touch_cave_exit = false
		elif destination_level_tag == "sandyBeach":
			Tutorial.touch_beach_entrance = false
		elif destination_level_tag == "blacksmith":
			Tutorial.touch_shop_entrance = false
		elif destination_level_tag == "kiriHome":
			Tutorial.touch_home_entrance = false
		HUD.not_leaving_yet = false

# if Match is true, that means it requires interaction to move between the two spaces. Otherwise, 
# the transition just happens by being at the area.
func _process(_delta: float) -> void:
	if player_inside: 
		match check: 
			true:
				if Input.is_action_just_pressed("press"):
					NaviationManager.go_to_level(destination_level_tag, destination_door_tag)
			false:
				verify_progress(true)

# Check for Kiri touching the associated doors.
func tutorial_check_for_kiri() -> void:
	if destination_level_tag == "village":
		Tutorial.near_exit_to_village = true
	elif destination_level_tag == "museum":
		Tutorial.touch_museum_entrance = true
		Tutorial.made_exit_first = true
		if HUD.quest_found_fossils: Tutorial.near_exit_after_found = true
	elif destination_level_tag == "crystalCave":
		Tutorial.touch_cave_exit = true
	elif destination_level_tag == "sandyBeach":
		Tutorial.touch_beach_entrance = true
	elif destination_level_tag == "blacksmith":
		Tutorial.touch_shop_entrance = true
	elif destination_level_tag == "kiriHome":
		Tutorial.touch_home_entrance = true

# Have a pop-up appear if the player is leaving a dig site and hasn't found their quest's fossils yet.
func verify_progress(is_process : bool) -> void:
	if Tutorial.near_exit_to_village and (HUD.current_location_name == "crystal_cave" or HUD.current_location_name == "sandy_beach"):
		var meets_requirements := false
		match HUD.current_quest:
			"trex", "mame": if HUD.current_location_name == "crystal_cave" and !HUD.quest_find_fossils: meets_requirements = true
			"anky", "pter": if HUD.current_location_name == "sandy_beach" and !HUD.quest_find_fossils: meets_requirements = true
		if meets_requirements and !HUD.not_leaving_yet and !is_process:
			HUD.given_destination = destination_level_tag
			HUD.given_door = destination_door_tag
			create_tween().tween_property(HUD.confirm_screen, "scale", Vector2(1.0, 1.0), HUD.screen_zoom).set_trans(Tween.TRANS_SINE)
		elif !HUD.not_leaving_yet and !is_process:
			NaviationManager.go_to_level(destination_level_tag, destination_door_tag)
	elif !is_process:
		NaviationManager.go_to_level(destination_level_tag, destination_door_tag)
