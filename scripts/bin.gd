extends TextureRect

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	print("garbage time")
	return data is Control

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print("nom")
	var old_parent = data.get_parent()
	old_parent.remove_child(data)
	data.queue_free()
