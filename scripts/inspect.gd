extends Area2D
@onready var kiri: Player = $"../Kiri"

signal call_tween(object_position: Vector2, zoom_value: Vector2, duration: float)
#_call_tween(self.global_position + Vector2(0,-900), Vector2(0.3,0.3), 2.0)
var dino_name : String = ""

var player_in_range : bool
var statue_zoom := Vector2(0.3, 0.3)
var duration := 2.5 

func _ready() -> void:
	if name.contains("trex"):
		dino_name = "Trex"
	elif name.contains("anky"):
		dino_name = "Anky"
	elif name.contains("mame"):
		dino_name = "Mame"
	elif name.contains("pter"):
		dino_name = "Pter"
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var statue_position := kiri.global_position + Vector2(0, -1100)
	if player_in_range and Input.is_action_just_pressed("press") and visible and Tutorial.near_skeleton:
		Tutorial.near_skeleton = false
		emit_signal("call_tween", statue_position, statue_zoom, duration)

func _on_body_entered(body: Node2D) -> void:
	if body == kiri:
		player_in_range = true
		if visible: Tutorial.near_skeleton = true

func _on_body_exited(body: Node2D) -> void:
	if body == kiri:
		player_in_range = false
		Tutorial.near_skeleton = false
