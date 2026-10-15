extends Control

@onready var keyboard: AnimatedSprite2D = $Keyboard
@onready var shift: AnimatedSprite2D = $Shift
@onready var label: Label = $Label
@onready var time_tutorial_fade_in : float = 0.1 #How long it takes for the tutorial keys/text to fade away.
@onready var time_tutorial_fade_out : float = 0.5 #How long it takes for the tutorial keys/text to fade away.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !HUD.has_quest and !Tutorial.first_move:
		keyboard.play("wasd")
		label.text = "Move!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	elif Tutorial.near_museum_owner or Tutorial.touch_shop_owner:#(!HUD.has_quest and Tutorial.near_museum_owner):
		keyboard.play("e")
		label.text = "Talk!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	elif Tutorial.near_exit_to_village and (HUD.current_location_name != "crystal_cave" and HUD.current_location_name != "sandy_beach"):#(HUD.has_quest and Tutorial.near_exit_to_village):# and !Tutorial.made_exit_first):
		keyboard.play("e")
		label.text = "Exit!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	elif Tutorial.touch_museum_entrance or Tutorial.touch_shop_entrance or Tutorial.touch_home_entrance:
		keyboard.play("e")
		label.text = "Enter!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
		create_tween().tween_property(shift, "modulate:a", 0, time_tutorial_fade_out)
	elif (Tutorial.over_sniffed_spot and !Tutorial.interacted_spot):
		keyboard.play("e")
		label.text = "Dig!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	elif (HUD.quest_reach_museum and Tutorial.near_podium and !HUD.quest_finish_ID):
		keyboard.play("e")
		label.text = "Assemble!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	elif (Tutorial.made_exit_first and !Tutorial.sprint_first):
		keyboard.play("wasd")
		shift.play("shift")
		label.text = "Sprint!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
		create_tween().tween_property(shift, "modulate:a", 1, time_tutorial_fade_in)
	elif HUD.quest_reach_cave and !Tutorial.sniff_first and HUD.current_location_name == "crystal_cave":
		visible = true
		keyboard.play("space")
		label.text = "Sniff!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	elif Tutorial.near_skeleton:
		keyboard.play("e")
		label.text = "Inspect!"
		create_tween().tween_property(self, "modulate:a", 1, time_tutorial_fade_in)
	else:
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "modulate:a", 0, time_tutorial_fade_out)
		tween.parallel().tween_property(shift, "modulate:a", 0, time_tutorial_fade_out)
