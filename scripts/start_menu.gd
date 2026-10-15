extends Control
@onready var load_game: Panel = $loadGame
@onready var about_panel: Panel = $aboutPanel
@onready var new_game_button: Button = $loadGame/MarginContainer/Header/Body/VBoxContainer/newGameButton
@onready var load_game_button: Button = $loadGame/MarginContainer/Header/Body/VBoxContainer/loadGameButton

const museum_scene = preload("res://scenes/museum.tscn")
const village_scene = preload("res://scenes/village.tscn")
const blacksmith_scene = preload("res://scenes/black_smith.tscn")
const home_scene = preload("res://scenes/kiri_home.tscn")
const cave_scene = preload("res://scenes/crystalcave.tscn")
const beach_scene = preload("res://scenes/sandybeach.tscn")
const customization_scene = preload("res://scenes/scene_customization.tscn")

@onready var intro_animation_scene: Control = $intro_animation
@onready var intro_animation: AnimationPlayer = $intro_animation/AnimationPlayer
@onready var color_rect: ColorRect = $intro_animation/colorRect

func _ready() -> void:
	HUD.in_assembly = false
	HUD.in_ID_sheet = false
	HUD.in_video = false
	# disables HUD, Inventory, and Reference Page
	if !HUD.playing_game:
		intro_animation.play("rotate")
		color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		await intro_animation.animation_finished
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		HUD.playing_game = false
		intro_animation_scene.visible = false
	AudioPlayer.play_music("Indoor")
	
# prevents using esc to open settings while in the start Screen but may close tabs

func play_barking():
	AudioPlayer.play_sound("dog_bark")
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		Settings.visible = false
		about_panel.visible = false
		load_game.visible = false
		get_viewport().set_input_as_handled()
		
func _on_start_button_pressed() -> void:
	load_game.visible = true

func _on_settings_button_pressed() -> void:
	Settings.visible = true

func _on_about_button_pressed() -> void:
	about_panel.visible = true

func _on_exit_load_pressed() -> void:
	load_game.visible = false

func _on_exit_about_pressed() -> void:
	about_panel.visible = false

func _on_load_game_button_pressed() -> void:
	HUD.playing_game = true
	match HUD.current_location_name:
		"village": NaviationManager._change_scene(village_scene, "skull")
		"blacksmith": NaviationManager._change_scene(blacksmith_scene, "skull")
		"home": NaviationManager._change_scene(home_scene, "skull")
		"crystal_cave": NaviationManager._change_scene(cave_scene, "skull")
		"sandy_beach": NaviationManager._change_scene(beach_scene, "skull")
		_:
			NaviationManager._change_scene(museum_scene, "skull")

func _on_new_game_button_pressed() -> void:
	HUD.playing_game = false
	ConfigFileHandler.set_default_progress()
	NaviationManager._change_scene(customization_scene, "skull")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
