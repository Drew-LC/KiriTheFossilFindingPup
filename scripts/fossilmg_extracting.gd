extends Control
signal fossil_hit

@onready var pressed := false #Is the player pressing the left mouse button?
@onready var current_line : Line2D #The player's drawn line.
@onready var drawn_points : Array #The array of points of the player's drawn line.
@onready var correct_points : Array #The correct line to check the player's drawn line with based on the dig spot's organism.
@onready var chisel_size := 5
@onready var chisel_color := "sky blue"
@onready var denied := false #Is the game denying the player from clicking and dragging with the chisel due to hitting the fossil?
@onready var uh_oh_time := 0.3

#The barline for how accurate does the player's drawn line have to be close to the organism's Answer line.
#Measured in terms of the average squared distance between each point of the correct line and their respective closest point on the player's drawn line.
@onready var accuracy := 1000

#Get the superparent FossilMinigame node.
@onready var fossil_mg := get_parent().get_parent()

# Code provided by Arcane Energy.
# Allows the player to draw the line.
func _input(event: InputEvent) -> void:
	if SelectTools.mg_mining_done and SelectTools.selected_chisel: #Only after finishing the mining section, and when selecting the chisel.
		# Creates the line upon clicking the left mouse button.
		if event is InputEventMouseButton and !SelectTools.tutorial.cannot_skip_animation:
			if event.button_index == MOUSE_BUTTON_LEFT:
				pressed = event.pressed
				if pressed:
					denied = false
					current_line = Line2D.new()
					current_line.width = chisel_size
					current_line.default_color = chisel_color
					add_child(current_line)
					AudioPlayer.play_sound("tool_chisel")
		# Draws the line upon dragging the left mouse button.
		if (event is InputEventMouseMotion) and pressed and !denied:
			if current_line != null: current_line.add_point(Vector2(event.position.x, event.position.y))
			if fossil_mg.is_hover_over_fossil:
				denied = true
				fossil_hit.emit()
				if current_line != null: current_line.queue_free()
		# Upon releasing the left mouse button, remove the drawn line and calculate if it is close enough to the organism's designated outline based on the Answer line.
		if event.is_action_released("click") and !denied and !SelectTools.tutorial.cannot_skip_animation and current_line != null:
			if current_line.points.size() > 0: #Ensures just clicking one time and not dragging doesn't trigger the calculations.
				var player_accuracy = calculate_average_squared_distance(current_line.points)
				print(player_accuracy)
				if player_accuracy < accuracy: #If the player's drawn line is close enough, the extracting section is done.
					SelectTools.mg_extracting_done = true
				elif current_line != null:
					if current_line != null: await create_tween().tween_property(current_line, "default_color", Color.DARK_RED, uh_oh_time).finished
					await get_tree().create_timer(uh_oh_time).timeout
					if current_line != null: await create_tween().tween_property(current_line, "modulate:a", 0, uh_oh_time).finished
				if current_line != null: current_line.queue_free() #Comment out to debug.
			#AudioPlayer.stop_sound("tool_chisel")

# Calculate the average squared distance between every point of the organism's designated currect Answer line and their respective closest point on the player's drawn line.
func calculate_average_squared_distance(input_points : Array) -> float:
	var distance_sum := 0 #The sum of every squared distance between every point of the correct line and their respective closest point of the player's drawn line.
	for point in correct_points:
		distance_sum += abs(smallest_distance_to_closest_point(point, input_points))
	@warning_ignore("integer_division")
	if correct_points.size() != 0: #Prevent dividing by 0.
		return distance_sum / correct_points.size()
	else:
		return INF

# Return the squared distance between compared_point and its closest point out of multiple_points based on squared distance.
func smallest_distance_to_closest_point(compared_point : Vector2, multiple_points : Array) -> float:
	var smallest_distance := INF
	for point in multiple_points:
		var current_distance := compared_point.distance_squared_to(point)
		if current_distance < smallest_distance:
			smallest_distance = current_distance
	return smallest_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
