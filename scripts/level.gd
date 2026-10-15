extends Node

func _ready() -> void:
	if NaviationManager.spawn_door_tag != null:
		_on_level_spawn(NaviationManager.spawn_door_tag)
		
func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/" + destination_tag
	var door = get_node(door_path) as Door
	NaviationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
