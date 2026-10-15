extends Area2D

var player_in_range = false
var minigame_open = false
var player_reference = null

@onready var overlay: CanvasLayer = $MinigameOverlay

#Detects when Kiri Is near a dig site
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "KiriSprite":
		player_in_range = true
		player_reference = body  
#Detects when Kiri Is out of a dig site
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "KiriSprite":
		player_in_range = false
		player_reference = null  

#Changes when the overlaying a minigame but in general pop up the canvas layer
func start_minigame():
	minigame_open = true #
	overlay.visible = true	#
	if player_reference: #Freeze Player
		player_reference.set_physics_process(false)  
		player_reference.velocity = Vector2.ZERO     
#Closes the canvas layer
func close_minigame():
	minigame_open = false
	overlay.visible = false
	if player_reference: #Unfreeze player
		player_reference.set_physics_process(true)  
	
func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("press"):
		if minigame_open:
			close_minigame()
		else:
			start_minigame()
