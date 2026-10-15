extends Sprite2D

# Load in texture image manually (does not work if not included)
@onready var cur_img : Image
@onready var once := true # Ensures the image texture is only loaded in once in process.
# Credit to Octodemy for much of the code.
@export var paint_color := Color(0,0,0,0) #The "paint tool" will have a transparent color, making it an eraser.
@export var img_size := Vector2i(0,0) #The size of the dust's image resolution. By default, null because the size will be recieved in the ready function.
@export var brush_size := 30 #The size of the brush
#@export var brush_texture : Texture 2D ## For later: if we figure out how to change from a square to a given shape.
@onready var is_chosen := false #Is this dust's associated fossil what the current dig spot is focused on?
@onready var holding_down := false #Did the player click to hold down for this section?
@onready var dust_left : float #The percentage of the dust on the fossil left.

# The percentage of opaque pixels (e.g. dust not yet removed) out of all pixels of this node's texture image that is acceptable to continue to finish the dusting phase.
const negligible_dust = 0.01 #This is done so that the players don't have to go on a literal pixel hunt.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Based on the given position, paint the pixels under the set brush size at the position to be the current paint color.
func _paint_tex(pos) -> void:
	#Simpler version with the brush being a square. Note: Brush must look like a square to look natural. Significant time to figure out how to erase in a different shape.
	if cur_img != null:
		cur_img.fill_rect(Rect2i(pos, Vector2i(1,1)).grow(brush_size), paint_color)
	
	#Complex version with the brush being the above commented brush texture.
	#var brush = brush_texture.get_image()
	#brush.resize(brush_size, brush_size)
	#
	#for x in brush.get_size().x:
		#for y in brush.get_size().y:
			#var cc := brush.get_pixel(x, y)
			#brush.set_pixel(x, y, paint_color * cc)
	#
	#img.blend_rect(brush, brush.get_used_rect(), pos - Vector2(brush_size/2.0, brush_size/2.0))

# Draws based on the player's left mouse key movement.
func _input(event: InputEvent) -> void:
	if SelectTools.selected_brush and SelectTools.mg_extracting_done and is_chosen and !SelectTools.tutorial.cannot_skip_animation:
		# Upon CLICKING the key.
		if event is InputEventMouseButton:
			if event.pressed and !event.is_echo() and event.button_index == MOUSE_BUTTON_LEFT:
				var local_position = to_local(event.position) #Convert mouse position to image position.
				var image_position = local_position# - offset + (get_rect().size / 2.0)  #Accounts for the image expanding from the center of the node's position.
				_paint_tex(image_position) #Paint at the current position.
				texture.update(cur_img) #Update the image's texture file.
				holding_down = true
				AudioPlayer.play_sound("tool_brush")
		# Upon HOLDING the key.
		if event is InputEventMouseMotion:
			if event.button_mask == MOUSE_BUTTON_LEFT and holding_down:
				var local_position = to_local(event.position) #Convert mouse position to image position.
				var image_position = local_position# - offset + (get_rect().size / 2.0)  #Accounts for the image expanding from the center of the node's position.
				
				# Enables smooth movement. Checks if "there is enough movement".
				if event.relative.length_squared() > 0:
					var num := ceili(event.relative.length()) #"Save how many pixels the mouse moved.
					var target_position = image_position - (event.relative) #The position the mouse was in the previous frame.
					for i in num: #For each pixel that the mouse moved, paint between the image and target position for the smooth movement.
						image_position = image_position.move_toward(target_position, 1.0)
						_paint_tex(image_position) #Paint at the current position.
				
				if cur_img != null:
					texture.update(cur_img) #Update the image's texture file.
		# Upon RELEASING the key.
		if event.is_action_released("click"):
			holding_down = false
			AudioPlayer.stop_sound("tool_brush")

# Return number of opaque pixels in the image texture. Credit to online forums for broadly figuring out this function's logic.
func num_opaque_pixels(image : Image) -> float:
	var num_pixels = 0.0
	#For every x-coordinate pixel...
	for x in img_size.x:
		#For every y-coordinate pixel...
		for y in img_size.y:
			#Check if the current pixel is transparent or not.
			var pixel_color : Color = image.get_pixel(x, y)
			if pixel_color.a > 0.0:
				num_pixels += 1.0
	return num_pixels

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	is_chosen = visible
	# If the number of remaining opaque pixels (e.g. dust) is below the set negligible bar, then the dusting phase is done.
	if (cur_img != null) and is_chosen:
		#The below 2 code lines are absolutely necessary to prevent the game from crashing. I thought this method would make the dust unbrushable, but it somehow doesn't.
		texture = ImageTexture.create_from_image(cur_img) #Update this node to show the recieved texture file.
		img_size = texture.get_size() #Update img_size to the recieved texture file's resolution.
		SelectTools.dust_left = (num_opaque_pixels(cur_img) / (img_size.x * img_size.y))
		if (SelectTools.dust_left <= negligible_dust) and !SelectTools.fossil_minigame_won:
			SelectTools.mg_dusting_done = true
			AudioPlayer.stop_sound("tool_brush")
