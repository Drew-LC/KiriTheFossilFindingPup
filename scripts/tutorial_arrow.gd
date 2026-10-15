extends TextureRect

#Keep track of Kiri's position point.
@onready var kiri_position : Vector2

#Make an exception the visibility property.
@onready var exception := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Adjust visibility depending on in-game progress.
	if Tutorial.interest_node != null and self.name == "TutorialArrow":
		determine_visibility(Tutorial.interest_node)
	elif Tutorial.side_node != null and self.name == "SideArrow":
		determine_visibility(Tutorial.side_node)
	#During the tutorial, perform geometric calculations in order to determine the angle at which Kiri is at to the interest area's position, to then determine how much to rotate the arrow per frame.
	if Tutorial.interest_node != null and Tutorial.interest_node != Tutorial.empty_interest and self.name == "TutorialArrow":
		update_arrow(Tutorial.interest_node)
	elif Tutorial.side_node != null and Tutorial.side_node != Tutorial.empty_interest and self.name == "SideArrow":
		update_arrow(Tutorial.side_node)

# Update the arrow's current position.
func update_arrow(interest_node : CollisionShape2D) -> void:
	#Keep track of the interest area's position point.
		var interest_position = interest_node.global_position
		#IMPORTANT NOTE: Remember that the lower the value of the y-coordinate, the higher it visually is.
		#				 Remember that the higher the value of the y-coordinate, the lower it visually is.
		#Consider everything to the left of Kiri.
		if interest_position.x <= kiri_position.x:
			#Edge case: interest area is exactly to the top of Kiri
			if (interest_position.x == kiri_position.x) and (interest_position.y < kiri_position.y):
				rotation_degrees = 270
			#Edge case: interest area is exactly to the bottom of Kiri
			elif (interest_position.x == kiri_position.x) and (interest_position.y > kiri_position.y):
				rotation_degrees = 90
			#Edge case: interest area is exactly to the left of Kiri
			elif (interest_position.x < kiri_position.x) and (interest_position.y == kiri_position.y):
				rotation_degrees = 180
			#Edge case: interest area is exactly on Kiri
			elif (interest_position.x == kiri_position.x) and (interest_position.y == kiri_position.y):
				exception = true
			#If not the above edge cases, then make the geometric calculations.
			#If the interest area is strictly to the left of Kiri...
			elif (interest_position.x < kiri_position.x):
				exception = false
				#And if the interest area is strictly to the bottom-left side of Kiri...
				if (interest_position.y > kiri_position.y):
					rotation_degrees = 180.0 - theta(kiri_position, interest_position)
				#Or if the interest area is strictly to the top-left side of Kiri...
				elif (interest_position.y < kiri_position.y):
					rotation_degrees = 180.0 + theta(kiri_position, interest_position)
		#Consider everything to the right of Kiri.
		else:
			#Edge case: interest area is exactly to the right of Kiri
			if (kiri_position.x < interest_position.x) and (kiri_position.y == interest_position.y):
				rotation_degrees = 0
			#If not the above edge case, then make the geometric calculations.
			elif (kiri_position.x < interest_position.x):
				exception = false
				#And if the interest area is strictly to the bottom-right side of Kiri...
				if (kiri_position.y < interest_position.y):
					rotation_degrees = theta(kiri_position, interest_position)
				#Or if the interest area is strictly to the top-right side of Kiri...
				elif (kiri_position.y > interest_position.y):
					rotation_degrees = - theta(kiri_position, interest_position)

#Amongst many possible conditions, determine this arrow's visibility.
func determine_visibility(interest_node : CollisionShape2D) -> void:
	var is_there_an_interest_area = interest_node != Tutorial.empty_interest
	var did_player_accept_quest = Tutorial.accepted_quest
	var is_touching_any_interest_area
	var is_done_final_step
	var is_during_quest
	var not_empty_interest
	match interest_node:
		Tutorial.interest_node:
			is_touching_any_interest_area = Tutorial.near_exit_to_village or Tutorial.touch_cave_exit or Tutorial.touch_museum_entrance or Tutorial.near_podium or Tutorial.touch_beach_entrance
			is_done_final_step = HUD.quest_finish_ID
			is_during_quest = HUD.current_quest
			not_empty_interest = interest_node != Tutorial.empty_interest
		Tutorial.side_node:
			is_touching_any_interest_area = Tutorial.touch_shop_entrance or Tutorial.touch_shop_owner or Tutorial.touch_home_entrance
			is_done_final_step = HUD.quest_customized or HUD.quest_put_furniture
			is_during_quest = HUD.has_side
			not_empty_interest = interest_node != Tutorial.empty_interest
	visible = true if (is_there_an_interest_area and did_player_accept_quest and !is_touching_any_interest_area and !is_done_final_step and is_during_quest and not_empty_interest) else false

#For point A and point B, calculate the angle θ in degrees in-between side A and side C.
#The intersection point (point AB) is the point that shares point A's y-coordinate and point B's x-coordinate.
#Side A is the side between point A and point AB.
#Side B is the side between point B and point AB.
#Side C is the side between point A and point B.
func theta(pointA : Vector2, pointB : Vector2) -> float:
	var intersection_point := Vector2(pointB.x, pointA.y)
	var a_side := intersection_point.distance_to(pointA)
	var c_side := pointB.distance_to(pointA)
	return acos(a_side/c_side) * (180.0 / PI)
