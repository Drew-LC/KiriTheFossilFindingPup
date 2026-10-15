extends TextureButton



func _on_mouse_entered() -> void:
	self.rotation_degrees = -7



func _on_mouse_exited() -> void:
	self.rotation_degrees = 0
