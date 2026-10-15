extends TextureButton

var dragging = false
var drag_offset = Vector2.ZERO
var original_position: Vector2
var is_placed = false

@export var piece_id: String = ""

func _ready():
	original_position = global_position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _gui_input(event):
	if is_placed:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
				z_index = 10
			else:
				dragging = false
				z_index = 1
				try_snap()

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func try_snap():
	var snap_radius = 150.0
	var closest_zone = null
	var closest_dist = snap_radius

	for zone in get_tree().get_nodes_in_group("snap_zones"):
		var dist = global_position.distance_to(zone.global_position)
		print("distance to ", zone.name, ": ", dist)  # ← see actual distances

	for zone in get_tree().get_nodes_in_group("snap_zones"):
		if zone.check_piece(self):
			var dist = global_position.distance_to(zone.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_zone = zone

	if closest_zone:
		closest_zone.fill(self)
	else:
		global_position = original_position
		
func _on_mouse_entered():
	if not is_placed:
		#scale = Vector2(1.1, 1.1)
		pass

func _on_mouse_exited():
	if not is_placed:
		#scale = Vector2(1.0, 1.0)
		pass
