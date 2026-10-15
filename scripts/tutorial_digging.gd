extends Control

@export var arrow_paw_y := 66.0 #Tutorial arrow positions.
@export var arrow_pickaxe_y := 213.0
@export var arrow_chisel_y := 357.0
@export var arrow_brush_y := 503.0
@onready var first_paw_select := false #First time the player selects the tools in their phases.
@onready var first_pickaxe_select := false
@onready var first_chisel_select := false
@onready var first_brush_select := false
@onready var first_paw_click := false #First time the player clicks while having selected the tools in their phases.
@onready var first_pickaxe_click := false
@onready var first_chisel_click := false
@onready var first_brush_click := false
@onready var time_tutorial_fade := 0.5 #How long it takes for the tutorial assets to fade in/out.
@onready var tutorial_arrow: TextureRect = $TutorialArrow #Node variables
@onready var tutorial_mouse: AnimatedSprite2D = $TutorialMouse
@onready var guide_arrow: TextureRect = $GuideArrow
@onready var guide_outline: TextureRect = $GuideOutline
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label
@onready var mining_position := Vector2(100.0, 319.0)
@onready var cannot_skip_animation := false
@onready var emotes: AnimatedSprite2D = $Emotes
@onready var timer: Timer = $Timer
@onready var timer_once := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Tutorial.selected_tutorial and SelectTools.in_fossil_minigame and SelectTools.cur_attribute != "empty":
		if !first_paw_select:
			tutorial_arrow.position.y = arrow_paw_y
			create_tween().tween_property(tutorial_arrow, "modulate:a", 1, time_tutorial_fade)
		elif !SelectTools.mg_digging_done and !first_paw_click:
			label.text = "Move the dirt!"
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(tutorial_arrow, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(tutorial_mouse, "modulate:a", 1, time_tutorial_fade)
			tween.parallel().tween_property(guide_arrow, "modulate:a", 1, time_tutorial_fade)
			animation_player.play("use_paw")
			prevent_player_control()
		elif SelectTools.mg_digging_done and !first_pickaxe_select:
			tutorial_arrow.position.y = arrow_pickaxe_y
			create_tween().tween_property(tutorial_arrow, "modulate:a", 1, time_tutorial_fade)
		elif SelectTools.mg_digging_done and !SelectTools.mg_mining_done and !first_pickaxe_click:
			label.text = "Mine the rocks!"
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(tutorial_arrow, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(tutorial_mouse, "modulate:a", 1, time_tutorial_fade)
			animation_player.play("use_pickaxe") #This is a useless animation that exists to debug the mouse's position.
			tutorial_mouse.play("use_pickaxe")
			prevent_player_control()
		elif SelectTools.mg_mining_done and !first_chisel_select:
			tutorial_arrow.position.y = arrow_chisel_y
			create_tween().tween_property(tutorial_arrow, "modulate:a", 1, time_tutorial_fade)
		elif SelectTools.mg_mining_done and !SelectTools.mg_extracting_done and !first_chisel_click:
			label.text = "Extract the fossil!"
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(tutorial_arrow, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(tutorial_mouse, "modulate:a", 1, time_tutorial_fade)
			tween.parallel().tween_property(guide_outline, "modulate:a", 1, time_tutorial_fade)
			animation_player.play("use_chisel")
			prevent_player_control()
		elif SelectTools.mg_extracting_done and !first_brush_select:
			tutorial_arrow.position.y = arrow_brush_y
			create_tween().tween_property(tutorial_arrow, "modulate:a", 1, time_tutorial_fade)
		elif SelectTools.mg_extracting_done and !SelectTools.mg_dusting_done and !first_brush_click:
			label.text = "Brush the dust!"
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(tutorial_arrow, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(tutorial_mouse, "modulate:a", 1, time_tutorial_fade)
			animation_player.play("use_brush")
			prevent_player_control()
		else:
			label.text = ""
			var tween = get_tree().create_tween()
			tween.parallel().tween_property(tutorial_arrow, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(tutorial_mouse, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(guide_arrow, "modulate:a", 0, time_tutorial_fade)
			tween.parallel().tween_property(guide_outline, "modulate:a", 0, time_tutorial_fade)
			animation_player.stop()
			tutorial_mouse.stop()
	elif SelectTools.in_fossil_minigame and SelectTools.cur_attribute == "empty" and !timer_once:
		timer_once = true
		timer.start()
	elif !SelectTools.in_fossil_minigame:
		timer_once = false
		label.text = ""
		create_tween().tween_property(emotes, "modulate:a", 0, time_tutorial_fade)
		emotes.stop()

# Detect the player's first clicks under each tool.
func _input(event: InputEvent) -> void:
	if Tutorial.selected_tutorial and SelectTools.in_fossil_minigame:
		if first_paw_select and event.is_action_pressed("click") and !cannot_skip_animation:
			first_paw_click = true
		if SelectTools.mg_digging_done and first_pickaxe_select and event.is_action_pressed("click") and !cannot_skip_animation:
			first_pickaxe_click = true
		if SelectTools.mg_mining_done and first_chisel_select and event.is_action_pressed("click") and !cannot_skip_animation:
			first_chisel_click = true
		if SelectTools.mg_extracting_done and first_brush_select and event.is_action_pressed("click") and !cannot_skip_animation:
			first_brush_click = true

# Prevent the player from skipping through the tutorial animations.
func prevent_player_control() -> void:
	cannot_skip_animation = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	await get_tree().create_timer(1.0).timeout
	cannot_skip_animation = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

# If empty, let the player know.
func _on_timer_timeout() -> void:
	label.text = "Nothing here, try another dig spot!"
	create_tween().tween_property(emotes, "modulate:a", 1, time_tutorial_fade)
	emotes.play()

# Replay the animation depending on the current stage.
func _on_hint_button_pressed() -> void:
	if SelectTools.mg_extracting_done:
		first_brush_click = false
		if !SelectTools.selected_brush: first_brush_select = false
	elif SelectTools.mg_mining_done:
		first_chisel_click = false
		if !SelectTools.selected_chisel: first_chisel_select = false
	elif SelectTools.mg_digging_done:
		first_pickaxe_click = false
		if !SelectTools.selected_pickaxe: first_pickaxe_select = false
	else:
		first_paw_click = false
		if !SelectTools.selected_paw: first_paw_select = false
