extends Control
#signal item_clicked(description) #Commented out b/c it prevented non-first added items' descriptions from appearing

@export var item_data: ItemData
@export var count_count : int = 1
@export var panel_size_x : float = 80 #Assume all panels are 80px x 80px
@export var panel_size_y : float = 80

@onready var icon: TextureRect = $TextureRect
@onready var count: Label = $Label
@export var item_name : String
@export var description : String
@export var max_stack : int

#init item
func _ready():
	if item_data:
		mouse_filter = Control.MOUSE_FILTER_PASS
		icon.texture = item_data.icon
		item_name = item_data.item_name
		description = item_data.description
		max_stack = item_data.max_stack
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		if icon.size.x > panel_size_x:
			icon.size.x = panel_size_x
		if icon.size.y > panel_size_y:
			icon.size.y = panel_size_y
		incCount()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	incCount()

func incCount():
	if count_count > 1: 
		count.text = str(count_count)
	else:
		count.text = ""
		
func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_data.icon == null:
		return null
 	
	icon.visible = false
	count.visible = false
	
	var preview = Control.new() #Create a temporary node for the player to click and drag to hold.
	preview.size = Vector2(80, 80)

	var preview_icon = TextureRect.new() #Assign the same item's icon to the temporary node.
	preview_icon.texture = icon.texture
	preview_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	preview_icon.anchor_left = 0
	preview_icon.anchor_top = 0
	preview_icon.anchor_right = 1
	preview_icon.anchor_bottom = 1
	
	preview_icon.z_index = 1
	preview_icon.position -= Vector2(40,40)
	
	preview.add_child(preview_icon)
	
	if count_count > 1: #Assign the same item's count (if applicable) to the temporary node.
		var preview_count = count.duplicate()
		preview_count.visible = true
		preview_count.position -= Vector2(40,40)
		preview_count.z_index = 2
		preview.add_child(preview_count)
	
	preview.modulate = Color(1,1,1,0.85)

	set_drag_preview(preview)

	return self

#The icon within the panel will become visible once again once drag ends. 
func _notification(notif):
	if notif == NOTIFICATION_DRAG_END:
		icon.visible = true
		count.visible = true

#Emits signal of the entire item when clicked on
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			InventoryCanvasLayer.selected_item_desc = description
		
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			InventoryCanvasLayer.inventory.place_item(self)
		
