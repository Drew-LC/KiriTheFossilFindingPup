extends Node2D

@onready var kiri: Player = $Kiri
@onready var tutorial_arrow_1: TextureRect = $TutorialArrow1
@onready var tutorial_arrow_2: TextureRect = $TutorialArrow2
@onready var bench: Area2D = $Bench
@onready var museum_entrance: Door = $Doors/museumEntrance
@onready var trex_full: Area2D = $TrexFull
@onready var anky_full: Area2D = $AnkylosaurusFull
@onready var mame_full: Area2D = $MamenchisaurusFull
@onready var pter_full: Area2D = $PterosaurFull

func _ready():
	HUD.current_location_node = self #Set the current location node as this location.
	HUD.current_location_name = "museum"
  	#var camera = $Kiri.get_node("Kiri/Camera2D")
	#camera.zoom = Vector2(2, 2)
	
	if NaviationManager.spawn_door_tag != null:
		_on_level_spawn(NaviationManager.spawn_door_tag)
	
	var player = kiri
	player.speed = 1000
	AudioPlayer.play_music("Indoor")
	
	HUD.quest_button.just_changed = HUD.quest_reach_museum if HUD.quest_reach_museum else HUD.quest_button.just_changed #If the museum is reached, update the exclaimation mark.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#tutorial_arrow_1.visible = true if (Tutorial.selected_tutorial and Tutorial.accepted_quest and !Tutorial.near_exit_to_village) else false
	#tutorial_arrow_2.visible = true if (Tutorial.selected_tutorial and HUD.quest_reach_museum and !Tutorial.near_podium and !HUD.quest_finish_ID) else false
	if HUD.quest_find_fossils: #If the museum is reached after finding all the fossils, furfill that task.
		HUD.quest_reach_museum = true
		if !HUD.quest_finish_ID: Tutorial.interest_node = bench.collision_shape_2d #Point to the bench.
	elif Tutorial.accepted_quest and !HUD.quest_finish_ID: #After accepting the quest but before finding all the fossils, tutorial point to the exit.
		Tutorial.interest_node = museum_entrance.collision_shape_2d
	trex_full.visible = HUD.quest_trex_ID
	anky_full.visible = HUD.quest_anky_ID
	mame_full.visible = HUD.quest_mame_ID
	pter_full.visible = HUD.quest_pter_ID

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/" + destination_tag
	var door = get_node(door_path) as Door
	if door != null: NaviationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
