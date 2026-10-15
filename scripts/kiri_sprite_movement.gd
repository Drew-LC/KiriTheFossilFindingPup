extends CharacterBody2D

class_name Player

@export var speed = 95
@export var sprint_multiplier = 2
@onready var frozen := false #Is Kiri frozen?
@onready var animated_sprite_2d: AnimatedSprite2D = $animated_sprite_2d

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var vertical_collision: CollisionShape2D = $verticalCollision
@onready var camera_2d: Camera2D = $Camera2D
@onready var radar_icon: TextureRect = $RadarIcon
@onready var radar_scan: Node2D = $RadarScan

@onready var sprite_2d: Sprite2D = $animated_sprite_2d/Sprite2D
@onready var drop_shadow_2d: DropShadow2D = $animated_sprite_2d/Sprite2D/DropShadow2D
@onready var tutorial_arrow: TextureRect = $TutorialArrow
@onready var side_arrow: TextureRect = $SideArrow

# A method of switching Kiri skins.  
@onready var brown_frame = preload("res://assets/styles/sprite_frame_brown.tres")
@onready var grey_frame = preload("res://assets/styles/sprite_frame_grey.tres")
@onready var pink_frame = preload("res://assets/styles/sprite_frame_pink.tres")

var kiri_frame : SpriteFrames

#Variables determining the timings within the sniff function.
@export var time_kiri_sniffing := 2.0 #How long does it take for Kiri to sniff?
@export var time_spots_fade := 0.3 #How long does it take for the dig spots to fade in and out?
@export var time_spots_appear := 2.0 #How long does it take for the dig spots to stay on the radar?
@export var is_sniffing := false #Is Kiri sniffing right now?
@export var maximum_distance := 7000 #The highest distance that a dig spot can be to be detected by Kiri's sniff.
@export var time_emote_fade := 0.3 #How long does it take for the emote to fade in and out?
@export var time_emote_apppear := 1.0 #How long does it take for the emote to stay on the screen?
@onready var emotes: AnimatedSprite2D = $Emotes
@export var found_spot := false #Did the player just interact with a sniffed dig spot?
@export var time_found := (time_emote_fade * 2) + time_emote_apppear #How long does it take for the exclaimation mark animation to play?
@export var time_scan := 0.3 #How long does it take for the scanning animation to finish?
@export var time_radar_red := 0.2 #How long does it take for the radar to fade in and fade out as red?

var current_speed : float = speed
var last_animation := ""

@onready var id_sheet: CanvasLayer = $"../IDSheet"

# Called when the node enters the scene tree for the first time.
func _ready():
	NaviationManager.on_trigger_player_spawn.connect(_on_spawn)
	
func _on_spawn(_position: Vector2, _Direction: String):
	global_position = _position
	match _Direction:
		"down":
			animated_sprite_2d.play("walkUp")
		"up":
			animated_sprite_2d.play("walkDown")
		"left":
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("default")
		"right":
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("default")
			
	# self.Camera2D.position_smoothing = true.

# Check input each frame
func _process(_delta):
	if found_spot:
		found_spot = false
		emotes.play("!")
		create_tween().tween_property(emotes, "modulate:a", 1, time_emote_fade)
		await get_tree().create_timer(time_emote_apppear).timeout 
		create_tween().tween_property(emotes, "modulate:a", 0, time_emote_fade)
	tutorial_arrow.kiri_position = position
	side_arrow.kiri_position = position

#Splitting up the movement and animation modules
func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	if !frozen:
		
		# Get the input direction and handle the movement/deceleration.
		var direction_x := Input.get_axis("move_left", "move_right")
		var direction_y := Input.get_axis("move_up", "move_down")
		direction = Vector2(direction_x, direction_y)
		
		if direction.length() > 1:
			direction = direction.normalized()
		
		if Input.is_action_pressed("sprint"):
			current_speed = speed * sprint_multiplier
		else:
			current_speed = speed
		
		velocity = direction * current_speed
		move_and_slide()
		
		_play_animation(direction, current_speed)
	#radar_icon.position = position
	
	# For the purpose of syncing the 2d sprite behind Kiri and its shadow. 
	_sync_sprite()
	
# For sprinting, possibly incresae the default frame? 

func _on_scene_customization_change_kiri(spriteFrame: SpriteFrames) -> void:
	kiri_frame = spriteFrame
	
func _play_animation(direction : Vector2, _speed : float):
	animated_sprite_2d.sprite_frames = InventoryCanvasLayer.kiri_style

	var current_animation := ""
	if !frozen:
	
		if direction == Vector2.ZERO:
			animated_sprite_2d.stop()
			
		if direction[0] > 0:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("default")
			sprite_2d.flip_h = false
			drop_shadow_2d.flip_h = false
			
		elif direction[0] < 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("default")
			sprite_2d.flip_h = true
			drop_shadow_2d.flip_h = true

		elif direction[1] > 0:
			animated_sprite_2d.play("walkDown")
			
		elif direction[1] < 0:
			animated_sprite_2d.play("walkUp")
		

		current_animation = animated_sprite_2d.animation
		if current_animation != last_animation:
			_update_collision(animated_sprite_2d.animation)
			last_animation = current_animation

# Adjusting the collision box relative to the animation. Otherwise,
# Kiri's size feels and looks visually wonky. 
func _update_collision(animationN):
	if animationN == "default":
		collision_shape_2d.set_deferred("disabled", false)
		vertical_collision.set_deferred("disabled", true)
	else: 
		collision_shape_2d.set_deferred("disabled", true)
		vertical_collision.set_deferred("disabled", false)

func _sync_sprite():
	sprite_2d.texture = animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame)
	drop_shadow_2d.texture = sprite_2d.texture

func temporary_frozen(time : float) -> void:
	frozen = true
	animated_sprite_2d.play("sniff")
	velocity = Vector2.ZERO
	await get_tree().create_timer(time).timeout
	frozen = false
	
func _on_inspect_call_tween(object_position: Vector2, zoom_value: Vector2, duration: float) -> void:
	var tween = create_tween()
	temporary_frozen(duration * 2.5)
	
	tween.tween_property(camera_2d, "global_position", object_position, duration/2)
	tween.tween_property(camera_2d, "zoom", zoom_value, duration/2)
	
	#returns camera back to Kiri
	tween.tween_interval(duration/2) 
	tween.tween_property(camera_2d, "global_position", global_position, duration/2)
	tween.tween_property(camera_2d, "zoom", Vector2(0.25,0.25), duration/2)

# Detect inputs
func _input(event):
	if event.is_action_pressed("sniff") and !is_sniffing:
		sniff()

# Whenever Kiri sniffs, reveal all nearby enough dig spots on the radar map.
func sniff() -> void:
	is_sniffing = true
	temporary_frozen(time_kiri_sniffing)
	AudioPlayer.play_sound("kiri_sniff")
	await get_tree().create_timer(time_kiri_sniffing).timeout
	is_sniffing = false
	var cur_dig_spots = 0 #Counter number of nearby dig spots
	create_tween().tween_property(radar_scan, "scale", Vector2(1.0, 1.0), time_scan) #Scanning animation.
	if HUD.current_location_node.get("dig_spot_spawner") != null:
		var all_dig_spots = HUD.current_location_node.dig_spot_spawner.get_children() #All findable dig spots
		var num_dig_spots = len(all_dig_spots) #Total number of all dig spots
		for dig_spot in all_dig_spots:
			if dig_spot.position.distance_squared_to(position) <= maximum_distance:
				create_tween().tween_property(dig_spot.spot_look, "modulate:a", 1, time_spots_fade)
				dig_spot.just_detected = true
				cur_dig_spots += 1
			else:
				dig_spot.just_detected = false
		#radar_scan.scale = Vector2(0, 0)
		if cur_dig_spots > 0:
			AudioPlayer.play_sound("dog_bark")
			await get_tree().create_timer(time_spots_appear).timeout 
			for dig_spot in all_dig_spots:
				if dig_spot != null:
					create_tween().tween_property(dig_spot.spot_look, "modulate:a", 0, time_spots_fade)
	radar_scan.scale = Vector2(0.0, 0.0) #Rescale the scan back to nothing.
	if cur_dig_spots == 0:
		emotes.play("?")
		AudioPlayer.play_sound("invalid_input")
		var tween = create_tween()
		tween.parallel().tween_property(emotes, "modulate:a", 1, time_emote_fade)
		#I'm worried making the radar red is distracting, but let's see.
		tween.parallel().tween_property(HUD.sub_viewport_container, "modulate", Color.RED, time_radar_red)
		tween.tween_property(HUD.sub_viewport_container, "modulate", Color.WHITE, time_radar_red)
		await get_tree().create_timer(time_emote_apppear).timeout
		var tween_2 = create_tween().set_parallel(true)
		tween_2.tween_property(emotes, "modulate:a", 0, time_emote_fade)


func _on_id_sheet_call_tween(object_position: Vector2, zoom_value: Vector2, duration: float) -> void:
	var tween = create_tween()
	temporary_frozen(duration * 2.5)
	
	tween.tween_property(camera_2d, "global_position", object_position, duration/2)
	tween.tween_property(camera_2d, "zoom", zoom_value, duration/2)
	
	#returns camera back to Kiri
	tween.tween_interval(duration/2) 
	tween.tween_property(camera_2d, "global_position", global_position, duration/2)
	tween.tween_property(camera_2d, "zoom", Vector2(0.25,0.25), duration/2)
