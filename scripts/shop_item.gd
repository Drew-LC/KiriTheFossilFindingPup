extends TextureRect
signal selected_shop_item(selected_item, shop_data)

@export var item_data: ItemData

#Emits signal of the entire item when clicked on
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			selected_shop_item.emit(self, item_data)
