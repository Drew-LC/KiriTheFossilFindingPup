extends Area2D

@export var item_data : ItemData
@export var item_count : int = 1

@onready var icon: TextureRect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon.texture = item_data.icon
	


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.pickup_item(item_data, item_count)
		queue_free()
		
