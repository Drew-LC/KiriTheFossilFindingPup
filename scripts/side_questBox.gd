extends Panel

@onready var default_style = preload("res://assets/styles/side_style_box_flat.tres")
@onready var hover_style = preload("res://assets/styles/side_style_box_hover.tres")
@onready var scribbles: AnimatedSprite2D = %scribbles

@onready var my_button = $MarginContainer/HBoxContainer/HBoxContainer/Button

func _on_mouse_entered() -> void:
	self.modulate = Color(1.2,1.2,1.2)
	add_theme_stylebox_override("panel", hover_style)

func _on_mouse_exited() -> void:
	self.modulate = Color(1.0,1.0,1.0)
	add_theme_stylebox_override("panel", default_style)


func _on_button_mouse_entered() -> void:
	if not my_button.disabled:
		my_button.add_theme_font_size_override("font_size", 42)
	else: 
		scribbles.visible = true
		scribbles.global_position = my_button.global_position + my_button.size/2 + Vector2(0, 5)
		scribbles.centered = true
		scribbles.play("default")
	
func _on_button_mouse_exited() -> void:
	if not my_button.disabled:
		my_button.add_theme_font_size_override("font_size", 35)
	else:
		scribbles.visible = false
		scribbles.stop()
