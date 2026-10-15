extends Node

#Onready variables for the nodes.
@onready var ambience: AudioStreamPlayer = $Ambience
@onready var bgm: AudioStreamPlayer = $BGM

# List of all user mutable inputs
var input_actions = {
	"inventory" : "Inventory",
	"move_left" : "Left",
	"move_right" : "Right",
	"move_up" : "Up",
	"move_down" : "Down",
	"sprint" : "Sprint",
	"press" : "Press",
	"quit" : "Quit",
	"click" : "Interact",
	"sniff" : "Sniff",
	"referencePage" : "Reference Page"
}

# List of keys that are the user can access but should not necessarily
# produce an error noise
var silent_keys = [KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, 
KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_F11, KEY_F12, KEY_VOLUMEUP, 
KEY_VOLUMEDOWN, KEY_VOLUMEMUTE, KEY_Q]

func _ready() -> void:
	get_tree().scene_changed.connect(_on_scene_changed) #Reconnect the buttons in case disconnection happens between scenes
	_connect_group_buttons()  	# all buttons within the group ("UI") will play a SFX when hovered

func _on_scene_changed():
	_connect_group_buttons()
	
# For all inputs outside of input_actions, a invalid input SFX
# will play to let users know that it does nothing. 
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		if event.keycode in silent_keys:
			return
			
		_check_valid_input(event)
	

func _check_valid_input(event: InputEvent) -> void:
	var matched := false
	
	# Check against all mapped actions
	for action in input_actions.keys():
		if InputMap.event_is_action(event, action):
			matched = true
			break
	
	if not matched:
		play_sound("invalid_input")
			
func _connect_group_buttons():
	var buttons = get_tree().get_nodes_in_group("UI")
	
	for button in buttons:
		if !button.mouse_entered.is_connected(_on_button_hover):
			button.mouse_entered.connect(_on_button_hover)

				
func _on_button_hover():
	play_sound("hover_button")
	
# In any scene, call on AudioPlayer.play_ambience(name) to start playing the ambience with the name parameter.
func play_ambience(audio : String) -> void:
	if not ambience.playing:
		ambience.play()
	ambience.get_stream_playback().switch_to_clip_by_name(audio)

# In any scene, call on AudioPlayer.play_music(name) to start playing the music with the name parameter.
func play_music(audio : String) -> void:
	if not bgm.playing:
		bgm.play()
	bgm.get_stream_playback().switch_to_clip_by_name(audio)

# In any scene, call on AudioPlayer.play_sound(name) to play a sound effect with the name parameter.
func play_sound(audio : String) -> void:
	get_node("SFX/" + audio).play()

# In any scene, call on AudioPlayer.play_sound(name) to play a sound effect with the name parameter.
func play_sound_pitch(audio : String) -> void:
	get_node("SFX/" + audio).pitch_scale = randf_range(0.75, 1.25)
	get_node("SFX/" + audio).play()

# In any scene, call on AudioPlayer.play_sound(name) to stop a sound effect with the name parameter.
func stop_sound(audio : String) -> void:
	get_node("SFX/" + audio).stop()
