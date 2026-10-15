extends Node2D

@onready var kiri: Node2D = $Kiri
@onready var camera_2d: Camera2D = $Kiri/Camera2D
@onready var dog_bowl: TextureRect = $Decorations/dogBowl
@onready var vase: TextureRect = $Decorations/vase
@onready var tennis_ball: TextureRect = $Decorations/tennisBall


func _ready() -> void:
	HUD.current_location_node = self #Set the current location node as this location.
	HUD.current_location_name = "home"
	Tutorial.side_node = Tutorial.empty_interest
	
	#Probably not the most efficient way to do this
	dog_bowl.visible = InventoryCanvasLayer.furniture.get("dogBowl", false)
	vase.visible = InventoryCanvasLayer.furniture.get("Vase", false)
	tennis_ball.visible = InventoryCanvasLayer.furniture.get("tennisBall", false)

	
	kiri.speed = 1000.0
	AudioPlayer.play_music("Indoor")
	InventoryCanvasLayer.inventory.place_an_item.connect(place_furniture)
	# This was initially for the purpose of having the entire house as viewable.
	#var screen_size = get_viewport_rect().size
	#var zoom_x = screen_size.x / 8000.0
	#var zoom_y = screen_size.y / 6000.0
	
	#camera_2d.zoom = Vector2(zoom_x, zoom_y)
	
	if NaviationManager.spawn_door_tag != null:
		_on_level_spawn(NaviationManager.spawn_door_tag)
	
	if HUD.current_side == "home" and HUD.quest_bought_item:
		HUD.quest_reach_home = true
		HUD.quest_button.just_changed = true if (HUD.quest_reach_home and !HUD.quest_button.just_changed) else HUD.quest_button.just_changed

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/" + destination_tag
	var door = get_node(door_path) as Door
	NaviationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)

	
func place_furniture(name : String):
	match name:
		"dogBowl":
			dog_bowl.visible = true
			InventoryCanvasLayer.furniture["dogBowl"] = true
		"Vase":
			vase.visible = true
			InventoryCanvasLayer.furniture["Vase"] = true
		"tennisBall":
			tennis_ball.visible = true
			InventoryCanvasLayer.furniture["tennisBall"] = true
		_:
			pass
