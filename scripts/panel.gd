extends Panel

#checks for items to be dropped within panels. 
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is Control
	
#drops item within panel
func _drop_data(_position: Vector2, data: Variant) -> void:
	var old_parent = data.get_parent()
	
	# swap items, if the space is occupied
	if get_child_count() > 0:
		var existing = get_child(0)
		remove_child(existing)
		old_parent.add_child(existing)

	# Remove dragged item from its old parent
	old_parent.remove_child(data)

	# Add the item to new slot
	add_child(data)
