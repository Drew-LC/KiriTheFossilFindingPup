extends CanvasLayer

# Did the player want a tutorial?
var selected_tutorial := true #Set to false if we want an optional tutorial.
var first_move := false #Has the player made their first move yet?
var near_museum_owner := false #Afterwards, is the player near the owner?
var accepted_quest := false #Afterwards, did the player accept the quest?
var near_exit_to_village := false #Afterwards, is the player near any building exit to the village?
var made_exit_first := false #Afterwards, did the player exit?
var sprint_first := false #Afterwards, did the player sprint?
var touch_cave_exit := false #Afterwards, is the player touching the entrance to the cave?
var sniff_first := false #Afterwards, did the player sniff in the cave?
var over_sniffed_spot := false #Afterwards, is the player on a dig spot which was detected on the radar?
var interacted_spot := false #Afterwards, did the player interact with said spot?
var near_exit_after_found := false #Afterwards, is the player at the museum entrance after finding all the fossils?
var near_podium := false #Afterwards, is the player near the museum's center podium?
@onready var empty_interest := $Area2D/CollisionShape2D #The closest equivalent to null for 
@onready var interest_node := $Area2D/CollisionShape2D #Main quest: The area of interest that the player needs to reach next.
@onready var side_node := $Area2D/CollisionShape2D #Side quest: The area of interest that the player needs to reach next.

var touch_museum_entrance := false #During a quest, is the player at the museum entrance?
var touch_shop_entrance := false #During a quest, is the player touching the entrance to the shop?
var touch_shop_owner := false #During a quest, is the player touching the shop owner?
var touch_home_entrance := false #During a quest, is the player touching the entrance to the home?
var touch_beach_entrance := false #During a quest, is the player touching the entrance to the beach?
var near_skeleton := false #If a museum skeleton is present, is the player touching it?

var touch_shop_exit := false #During a quest, is the player touching the entrance to the shop?
var touch_home_exit := false #During a quest, is the player touching the entrance to the home?
var touch_beach_exit := false #During a quest, is the player touching the entrance to the beach?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !HUD.has_quest: interest_node = empty_interest
	if !HUD.has_side: side_node = empty_interest

func _input(event: InputEvent) -> void:
	if HUD.playing_game and (event.is_action_pressed("move_up") or event.is_action_pressed("move_left") or event.is_action_pressed("move_down") or event.is_action_pressed("move_right")):
		first_move = true
	if HUD.playing_game and made_exit_first and event.is_action_pressed("sprint"):
		sprint_first = true
	if HUD.playing_game and HUD.quest_reach_cave and event.is_action_pressed("sniff"):
		sniff_first = true
