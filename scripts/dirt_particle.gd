extends Area2D

# Preload all possible random textures of the dirt particle.
@onready var dirt_trex1 = preload("uid://c3ikiq4ng6661")
@onready var dirt_trex2 = preload("uid://bb8ubeapb7rj6")
@onready var dirt_trex3 = preload("uid://bv5ieylm7dfce")
@onready var dirt_trex4 = preload("uid://o7ptcfgvgsae")
@onready var dirt_trex5 = preload("uid://dvaqw8obltl50")
@onready var dirt_anky1 = preload("uid://c4xnm32p8ixk2")
@onready var dirt_anky2 = preload("uid://d2qunyhv5v3e7")
@onready var dirt_anky3 = preload("uid://llbmwl0n1tv0")
@onready var dirt_anky4 = preload("uid://cpoqgq5xvbnlc")
@onready var dirt_anky5 = preload("uid://b5dxgmalqbnkp")
@onready var dirt_mame1 = preload("uid://t6ggqgchfals")
@onready var dirt_mame2 = preload("uid://ceihv1lgiy5xh")
@onready var dirt_mame3 = preload("uid://cpgouhiovotfh")
@onready var dirt_mame4 = preload("uid://ktene4jqfaep")
@onready var dirt_mame5 = preload("uid://c36khwl1ag5dj")
@onready var dirt_pter1 = preload("uid://dut55rh0cobgr")
@onready var dirt_pter2 = preload("uid://cwvb7ey1ya6om")
@onready var dirt_pter3 = preload("uid://txjsn7i4hevf")
@onready var dirt_pter4 = preload("uid://dujr1n2ygt280")
@onready var dirt_pter5 = preload("uid://dd8l5mdwp5c4t")
@onready var dirt_texture_array := []

# Onready variable for the random texture.
@onready var random_texture: TextureRect = $RandomTexture

# Whether the particle is to be dragged or not.
@export var draggable := false
# Variable keeping track of the position's distance from the cursor's position to prevent snapping to the cursor.
@export var offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match HUD.current_quest:
		"trex": dirt_texture_array = [dirt_trex1, dirt_trex2, dirt_trex3, dirt_trex4, dirt_trex5]
		"anky": dirt_texture_array = [dirt_anky1, dirt_anky2, dirt_anky3, dirt_anky4, dirt_anky5]
		"mame": dirt_texture_array = [dirt_mame1, dirt_mame2, dirt_mame3, dirt_mame4, dirt_mame5]
		"pter": dirt_texture_array = [dirt_pter1, dirt_pter2, dirt_pter3, dirt_pter4, dirt_pter5]
		"": dirt_texture_array = [dirt_trex1, dirt_trex2, dirt_trex3, dirt_trex4, dirt_trex5]
	# Randomly decide the particle's texture
	random_texture.texture = dirt_texture_array.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#If draggable and the paw is selected, then the particle follows the cursor.
	if draggable and SelectTools.selected_paw:
		global_position = get_global_mouse_position() - offset

#Detects player's clicks onto only the dirt particles.
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#Detects if the paw is selected, and detects left mouse button AND if it is being pressed, not released.
	if SelectTools.selected_paw and event.is_action_pressed("click"):
		#Ensure only the top dragged dirt particle will be clicked on. Credit to Cashew OldDew.
		#var parameters : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		#parameters.position = event.position
		#parameters.collide_with_areas = true
		#var objects_clicked = get_world_2d().direct_space_state.intersect_point(parameters)
		#print(objects_clicked)
		#var colliders = objects_clicked.map(func(dict): return dict.collider)
		#colliders.sort_custom(func(collider1, collider2): return collider1.z_index < collider2.z_index)
		#if len(colliders) > 0:
			#if colliders[-1] == self:
		#If so, can be dragged and ensure it does not snap to the cursor.
		draggable = true
		offset = get_global_mouse_position() - global_position

# Have the release mouse click feature as a separate function in case the cursor releases when it is not on a dirt particle.
func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		#If not, cannot be dragged.
		draggable = false
