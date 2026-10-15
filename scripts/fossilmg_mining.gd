extends Control

# Onready variable for the rock layer.
@onready var rocklayer_bg: AnimatedSprite2D = $BG
@onready var rocklayer_button: Button = $Button
@onready var broke_time := 0.2

# Maximum number of clicks to smash the rock layer.
@export var rocklayer_maxhits := 13

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match HUD.current_quest:
		"trex": rocklayer_bg.animation = "trex"
		"anky": rocklayer_bg.animation = "anky"
		"mame": rocklayer_bg.animation = "mame"
		"pter": rocklayer_bg.animation = "pter"
		"": rocklayer_bg.animation = "trex"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Checks if the player has hit the rock layer enough times.
	if rocklayer_bg.frame >= rocklayer_maxhits:
		#If so, the mining portion is completed.
		create_tween().tween_property(rocklayer_bg, "modulate:a", 0.0, broke_time).set_trans(Tween.TRANS_SINE)
		SelectTools.mg_mining_done = true
		rocklayer_button.visible = false #Ensures it doesn't impact the next sections.
	elif !SelectTools.in_fossil_minigame: #Debug.
		SelectTools.mg_mining_done = false

#Detects player's clicks onto only the rock layer.
func _on_button_pressed() -> void:
	#If the pickaxe is selected after the digging section is done, then visually update the rock layer.
	if SelectTools.selected_pickaxe and SelectTools.mg_digging_done:
		rocklayer_bg.frame += 1
		AudioPlayer.play_sound_pitch("tool_pickaxe")
