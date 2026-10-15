extends CanvasLayer

@export var in_fossil_minigame := false #Is the player currently in the fossil mini-game?
@export var cur_attribute : String #What item does the current dig spot have?
@export var exited_empty_minigame := false #Did the player just exit the mini-game when cur_attribute is empty?
@onready var fossil_minigame_won := false #Did the player just win the game?

#Variables keeping track of what tool has the player selected.
@export var selected_paw := false
@export var selected_pickaxe := false
@export var selected_chisel := false
@export var selected_brush := false

#Onready variables for the tools buttons.
@onready var paw: TextureButton = $Paw
@onready var pickaxe: TextureButton = $Pickaxe
@onready var chisel: TextureButton = $Chisel
@onready var brush: TextureButton = $Brush
@onready var paw_texture_rect: TextureRect = $Paw/TextureRect
@onready var pickaxe_texture_rect: TextureRect = $Pickaxe/TextureRect
@onready var chisel_texture_rect: TextureRect = $Chisel/TextureRect
@onready var brush_texture_rect: TextureRect = $Brush/TextureRect
@onready var tutorial: Control = $Tutorial
@onready var paw_label: Label = $Paw/Label
@onready var pickaxe_label: Label = $Pickaxe/Label
@onready var chisel_label: Label = $Chisel/Label
@onready var brush_label: Label = $Brush/Label

# Is the digging minigame done?
@export var mg_digging_done := false
# Is the mining minigame done?
@export var mg_mining_done := false
# Is the extracting minigame done?
@export var mg_extracting_done := false
# Is the dusting minigame done?
@export var mg_dusting_done := false
# Track the amount of dust left in the dusting section
@export var dust_left := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Ensures the tools aren't already selected between different dig spots.
	if !in_fossil_minigame:
		untoggle_all()
		dust_left = 0.0

# Pressing the paw tool button updates the player selection variables.
func _on_paw_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selected_paw = true
		paw_texture_rect.visible = false
		paw_label.visible = true
		pickaxe.button_pressed = false
		chisel.button_pressed = false
		brush.button_pressed = false
		tutorial.first_paw_select = true
	else:
		selected_paw = false
		paw_texture_rect.visible = true
		paw_label.visible = false

# Pressing the pickaxe tool button updates the player selection variables.
func _on_pickaxe_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selected_pickaxe = true
		pickaxe_texture_rect.visible = false
		pickaxe_label.visible = true
		paw.button_pressed = false
		chisel.button_pressed = false
		brush.button_pressed = false
		if mg_digging_done:
			tutorial.first_pickaxe_select = true
	else:
		selected_pickaxe = false
		pickaxe_texture_rect.visible = true
		pickaxe_label.visible = false

# Pressing the chisel tool button updates the player selection variables.
func _on_chisel_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selected_chisel = true
		chisel_texture_rect.visible = false
		chisel_label.visible = true
		pickaxe.button_pressed = false
		paw.button_pressed = false
		brush.button_pressed = false
		if mg_mining_done:
			tutorial.first_chisel_select = true
	else:
		selected_chisel = false
		chisel_texture_rect.visible = true
		chisel_label.visible = false

# Pressing the brush tool button updates the player selection variables.
func _on_brush_toggled(toggled_on: bool) -> void:
	if toggled_on:
		selected_brush = true
		brush_texture_rect.visible = false
		brush_label.visible = true
		pickaxe.button_pressed = false
		chisel.button_pressed = false
		paw.button_pressed = false
		if mg_extracting_done:
			tutorial.first_brush_select = true
	else:
		selected_brush = false
		brush_texture_rect.visible = true
		brush_label.visible = false

func untoggle_all() -> void:
	selected_paw = false
	selected_pickaxe = false
	selected_chisel = false
	selected_brush = false
	paw.button_pressed = false
	pickaxe.button_pressed = false
	chisel.button_pressed = false
	brush.button_pressed = false

func reappear_all() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(paw, "modulate:a", 1, 0.5)
	tween.parallel().tween_property(pickaxe, "modulate:a", 1, 0.5)
	tween.parallel().tween_property(chisel, "modulate:a", 1, 0.5)
	tween.parallel().tween_property(brush, "modulate:a", 1, 0.5)
	tween.parallel().tween_property(tutorial, "modulate:a", 1, 0.5)
