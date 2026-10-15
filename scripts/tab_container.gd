extends TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_audio_tab_tab_hovered(tab: int) -> void:
	print("WHY WON'T YOU WORK!!!")


func _on_volume_mouse_entered() -> void:
	print("im going insane.")
