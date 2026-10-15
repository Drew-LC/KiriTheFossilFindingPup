extends Node

var CursorPawLeft = load("uid://b3ysw02k08f1g")
var CursorPawRight = load("uid://bgoflf75qqbge")
var CursorPickaxe = load("uid://d28kluhfb2xi0")
var CursorChisel = load("uid://jaij2qfqp8r5")
var CursorBrush = load("uid://b5kuviv0n7ftw")
var switch_hands := false #false = left, true = right

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if SelectTools.selected_paw == true and !switch_hands:
		Input.set_custom_mouse_cursor(CursorPawLeft, 0, Vector2(62, 62))
	elif SelectTools.selected_paw == true and switch_hands:
		Input.set_custom_mouse_cursor(CursorPawRight, 0, Vector2(62, 62))
	elif SelectTools.selected_pickaxe == true:
		Input.set_custom_mouse_cursor(CursorPickaxe, 0, Vector2(0, 90))
	elif SelectTools.selected_chisel == true:
		Input.set_custom_mouse_cursor(CursorChisel, 0, Vector2(20, 124))
	elif SelectTools.selected_brush == true:
		Input.set_custom_mouse_cursor(CursorBrush, 0, Vector2(28, 120))
	else:
		Input.set_custom_mouse_cursor(null)

func _input(event: InputEvent) -> void: #Switch hands upon releasing click.
	if event.is_action_released("click"):
		switch_hands = true if !switch_hands else false
