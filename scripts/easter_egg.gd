extends Area2D
var secret = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if secret and Input.is_action_just_pressed("press"):
		$Sprite2D.visible = true
		$AnimationPlayer.play("rotate")
		AudioPlayer.play_sound("meow")
		
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.stop()
		AudioPlayer.stop_sound("meow")
		$Sprite2D.visible = false
	
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D: 
		secret = true


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D: 
		secret = false
