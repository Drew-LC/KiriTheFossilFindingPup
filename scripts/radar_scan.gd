extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Create a circle with changable width.
func _draw() -> void:
	draw_arc(Vector2(0,0), 600.0, 0.0, 360.0, 100, Color.SKY_BLUE, -1.0, true)
