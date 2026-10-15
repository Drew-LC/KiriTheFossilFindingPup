extends Control

@onready var dino_image: TextureRect = $dinoImageContainer/dinoImage
@onready var book_page: TextureRect = $RefContainer/Panel/MarginContainer/bookCover/MarginContainer/bookPage
@onready var exit_button: TextureButton = $RefContainer/exitContainer/exitButton
@export var referencePages : Array[CompressedTexture2D]
@export var referenceImages: Array[CompressedTexture2D]
var current_page := 0
var max_page : int
@onready var center_x_position = 313.5
@onready var right_x_position = 576.0
@onready var next_button: TextureButton = $buttons/NextButtonCon/NextButton
@onready var prev_button: TextureButton = $buttons/PrevButtonCon/PrevButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	book_page.texture = referencePages[current_page]
	dino_image.texture = referenceImages[current_page]

	max_page = referencePages.size()
	print(current_page)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if HUD.in_assembly: visible = false
	exit_button.visible = !HUD.in_ID_sheet
	position.x = center_x_position if !HUD.in_ID_sheet else right_x_position
	prev_button.modulate = Color(1, 1, 1, 0) if current_page == 0 else Color(1, 1, 1, 1)
	next_button.visible = false if current_page == (max_page - 1) else true

func _on_next_button_pressed() -> void:
	if current_page < max_page - 1:
		book_page.texture = referencePages[current_page + 1] 
		dino_image.texture = referenceImages[current_page + 1]
		current_page+= 1

	else:
		print('Reached End of Book')

func _on_prev_button_pressed() -> void:
	if current_page > 0:
		book_page.texture = referencePages[current_page - 1] 
		dino_image.texture = referenceImages[current_page - 1]
		current_page-= 1
	
	else:
		print('Reached Start of Book')
