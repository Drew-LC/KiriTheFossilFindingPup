extends Area2D
var player_in_range = false
var minigame_open = false
var player_reference = null
var overlay: Node2D = null
@export var dinosaur_name: String = "Trex"

func _ready():
	overlay = get_parent().get_node("CanvasLayer/" + dinosaur_name + "Minigame")
	if overlay:
		overlay.visible = false
		print("Minigame found!")
	else:
		push_error("Minigame not found!")
		
func _on_body_entered(body: Node2D) -> void:
	print("body entered: ", body.name)
	if body.is_in_group("Kiri") or body.name == "Kiri" or body.name == "Kiri Sprite":
		player_in_range = true
		player_reference = body
		print("Kiri in range!")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri" or body.name == "Kiri Sprite":
		player_in_range = false
		player_reference = null

func start_minigame():
	if overlay:
		overlay.visible = true
	minigame_open = true
	if player_reference:
		player_reference.set_physics_process(false)
		player_reference.velocity = Vector2.ZERO

func close_minigame():
	if overlay:
		overlay.visible = false
	minigame_open = false
	if player_reference:
		player_reference.set_physics_process(true)

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("press"):
		if !minigame_open:
			start_minigame()
	if overlay != null:
		if !overlay.visible:
			minigame_open = false
			if player_reference:
				player_reference.set_physics_process(true)
	else:
		overlay = get_parent().get_node("CanvasLayer/TrexMinigame")
		if overlay:
			overlay.visible = false
		else:
			push_error("TrexMinigame not found!")
