extends Node

const scene_village = preload("res://scenes/village.tscn")
const scene_crystalCave = preload("res://scenes/crystalcave.tscn")
const scene_sandyBeach = preload("res://scenes/sandybeach.tscn")
const scene_home = preload("res://scenes/kiri_home.tscn")
const scene_museum = preload("res://scenes/museum.tscn")
const scene_blacksmith = preload("res://scenes/black_smith.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

# Spawns the character at the scene of level_tag and at the location of destination_tag. 
func go_to_level(level_tag, destination_tag):
	print("Tring to go to a new scene...")
	var scene_to_load
	var animation_name = "travel"
	
	match level_tag:
		"village":
			scene_to_load = scene_village
		"crystalCave":
			scene_to_load = scene_crystalCave
		"kiriHome":
			scene_to_load = scene_home
		"museum":
			scene_to_load = scene_museum
		"blacksmith":
			scene_to_load = scene_blacksmith
		"sandyBeach":
			scene_to_load = scene_sandyBeach
			
	if scene_to_load != null:
		AudioPlayer.play_sound("transition")
		TransitionScreen.transition(animation_name)
		await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

#sends signal to Kiri character scene
func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)

func _change_scene(scene, animation_name : String):
	if scene != null:
		TransitionScreen.transition(animation_name)
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_packed(scene)
