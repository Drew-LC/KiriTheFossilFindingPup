extends TextureButton

@onready var exclaimation_mark: Sprite2D = $ExclaimationMark
@onready var just_changed := false
@onready var margin_container_1: MarginContainer = $MarginContainer1
@onready var margin_container_2: MarginContainer = $MarginContainer2
@onready var label_1: Label = $MarginContainer1/Panel/HBoxContainer/Control/Label
@onready var label_2: Label = $MarginContainer2/Panel/HBoxContainer/Control/Label
@onready var quest_key: AnimatedSprite2D = $AnimatedSprite2D
@onready var button_is_toggled : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	quest_key.frame = 1 if button_pressed else 0
	if just_changed:
		just_changed = false
		if !margin_container_1.visible: exclaimation_mark.visible = true
	# Handle main quests.
	if !HUD.has_quest: label_1.text = "Talk to the Museum Owner!"
	else:
		if !HUD.quest_reach_cave:
			match HUD.current_quest:
				"trex": label_1.text = "Go to the Crystal Cave!"
				"anky": label_1.text = "Go to the Sandy Beach!"
				"mame": label_1.text = "Go to the Crystal Cave!"
				"pter": label_1.text = "Go to the Sandy Beach!"
		elif !HUD.quest_find_fossils:
			match HUD.current_quest:
				"trex": label_1.text = "Find " + str(HUD.max_trex_fossils) + " fossils! Currently found: " + str(HUD.quest_found_fossils)
				"anky": label_1.text = "Find " + str(HUD.max_anky_fossils) + " fossils! Currently found: " + str(HUD.quest_found_fossils)
				"mame": label_1.text = "Find " + str(HUD.max_mame_fossils) + " fossils! Currently found: " + str(HUD.quest_found_fossils)
				"pter": label_1.text = "Find " + str(HUD.max_pter_fossils) + " fossils! Currently found: " + str(HUD.quest_found_fossils)
		elif !HUD.quest_reach_museum:
			label_1.text = "Return to the Museum!"
		elif !HUD.quest_finish_assembly:
				label_1.text = "Piece together the dinosaur!"
		elif !HUD.quest_finish_ID:
				label_1.text = "Identify the dinosaur!"
		elif !HUD.quest_submit: label_1.text = "Talk to the Museum Owner!"
	# Handle side quests.
	if HUD.has_side:
		match HUD.current_side:
			"shop":
				if !HUD.quest_reach_shop: label_2.text = "Go to the Blacksmith Shop!"
				elif !HUD.quest_bought_item: label_2.text = "Buy a hat from the Blacksmith!"
				elif !HUD.quest_customized: label_2.text = "Wear your newest hat!"
				elif !HUD.quest_shop_submit: label_2.text = "Talk to the Museum Owner!"
			"home":
				if !HUD.quest_reach_shop: label_2.text = "Go to the Blacksmith Shop!"
				elif !HUD.quest_bought_item: label_2.text = "Buy furniture from the Blacksmith!"
				elif !HUD.quest_reach_home: label_2.text = "Go to Kiri's home!"
				elif !HUD.quest_put_furniture: label_2.text = "Put your newest furniture down!"
				elif !HUD.quest_home_submit: label_2.text = "Talk to the Museum Owner!"
	margin_container_2.visible = true if button_is_toggled and HUD.has_side else false

func _on_toggled(toggled_on: bool) -> void:
	margin_container_1.visible = true if toggled_on else false
	button_is_toggled = toggled_on
	exclaimation_mark.visible = false

func _input(event): #If q is pressed, open the panel.
	if event.is_action_pressed("quest"):
		button_pressed = true if !button_pressed else false
