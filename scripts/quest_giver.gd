extends Area2D

#Onready variables.
@onready var player_in_range := false
@onready var quest_open := false
@onready var player_reference : Node2D = null
@onready var overlay := $QuestBoard
@onready var quest_screen: Control = $QuestBoard/QuestBoard
@onready var exclaimation_mark: Sprite2D = $Owner/ExclaimationMark
@onready var is_mouse_hover := false # Is the mouse hovering over the dig spot if clicking on it?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_screen.quest_board_quit.connect(quit_quest_board)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Checks that the player is in range and clicked either E or the left mouse button.
	if player_in_range and (Input.is_action_just_pressed("press") or Input.is_action_just_pressed("click")):
		Tutorial.near_museum_owner = false
		# Checks that if the player clicked on the left mouse button, the button is actually over the shop.
		if Input.is_action_just_pressed("click") and !is_mouse_hover:
			return
		if !quest_open:
			AudioPlayer.play_sound("meow")
			overlay.visible = true
			quest_open = true
			HUD.in_quest_board = true
			if player_reference:
				player_reference.set_physics_process(false)
				player_reference.velocity = Vector2.ZERO
	# If the player has a quest, don't show the exclaimation mark.
	exclaimation_mark.visible = false if (HUD.has_quest and !HUD.quest_finish_ID) else true

func quit_quest_board() -> void: #Ensures player can move when the shop screen is down.
	overlay.visible = false
	quest_open = false
	HUD.in_quest_board = false
	if player_reference:
		player_reference.set_physics_process(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri":
		player_in_range = true
		player_reference = body
		Tutorial.near_museum_owner = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri":
		player_in_range = false
		player_reference = null
		Tutorial.near_museum_owner = false

func _on_mouse_entered() -> void:
	is_mouse_hover = true

func _on_mouse_exited() -> void:
	is_mouse_hover = false
