extends Area2D

#Onready variables.
@onready var player_in_range := false
@onready var shop_open := false
@onready var player_reference : Node2D = null
@onready var overlay := $ShopScreen
@onready var shop_screen: Control = $ShopScreen/ShopScreen
@onready var is_mouse_hover := false # Is the mouse hovering over the dig spot if clicking on it?
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_screen.shop_quit.connect(quit_shop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Checks that the player is in range and clicked either E or the left mouse button.
	if player_in_range and (Input.is_action_just_pressed("press") or Input.is_action_just_pressed("click")):
		# Checks that if the player clicked on the left mouse button, the button is actually over the shop.
		if Input.is_action_just_pressed("click") and !is_mouse_hover:
			return
		if !shop_open:
			overlay.visible = true
			shop_open = true
			AudioPlayer.play_sound("meow")
			HUD.in_shop = true
			InventoryCanvasLayer.enable = false
			ReferencePage.enable = false
			if player_reference:
				player_reference.set_physics_process(false)
				player_reference.velocity = Vector2.ZERO

func quit_shop() -> void: #Ensures player can move when the shop screen is down.
	overlay.visible = false
	shop_open = false
	HUD.in_shop = false
	InventoryCanvasLayer.enable = true
	ReferencePage.enable = true
	
	if player_reference:
		player_reference.set_physics_process(true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri":
		player_in_range = true
		player_reference = body
		Tutorial.touch_shop_owner = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Kiri") or body.name == "Kiri":
		player_in_range = false
		player_reference = null
		Tutorial.touch_shop_owner = false

func _on_mouse_entered() -> void:
	is_mouse_hover = true

func _on_mouse_exited() -> void:
	is_mouse_hover = false
