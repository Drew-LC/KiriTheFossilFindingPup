extends TextureRect

@export var item_data: ItemData

func _ready() -> void:
	self.texture = item_data.icon
