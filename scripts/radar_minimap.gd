extends SubViewport

#Code provided by Merxon22

# Reference the camera and the player
# "@export" keyword will expose these two variables in the inspector
@onready var camera_node := $Camera2D
@onready var player_node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# "world_2d" refers to this SubViewport's own 2D world.
	# "get_tree().root" will fetch the game's main viewport.
	world_2d = get_tree().root.world_2d

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Find the Kiri node based on HUD's recorded current location.
	if HUD.current_location_node != null:
		if "kiri" in HUD.current_location_node:
			player_node = HUD.current_location_node.kiri
	# Let camera move with player
	if player_node != null:
		camera_node.position = player_node.global_position
		if (HUD.current_location_name == "crystal_cave") or (HUD.current_location_name == "sandy_beach"):
			camera_node.zoom.x = 1.0
			camera_node.zoom.y = 1.0
		else:
			camera_node.zoom.x = 0.1
			camera_node.zoom.y = 0.1
