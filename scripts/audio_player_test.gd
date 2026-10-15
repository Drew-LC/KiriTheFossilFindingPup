extends Control

func _on_amb_silence_button_pressed() -> void:
	AudioPlayer.play_ambience("Silence")

func _on_amb_1_button_pressed() -> void:
	AudioPlayer.play_ambience("BasementAmbience")

func _on_amb_2_button_pressed() -> void:
	AudioPlayer.play_ambience("HotelAmbience")

func _on_amb_3_button_pressed() -> void:
	AudioPlayer.play_ambience("RiverAmbience")

func _on_bgm_silence_button_pressed() -> void:
	AudioPlayer.play_music("Silence")

func _on_bgm_1_button_pressed() -> void:
	AudioPlayer.play_music("SpookyMusic")

func _on_bgm_2_button_pressed() -> void:
	AudioPlayer.play_music("FocusMusic")

func _on_bgm_3_button_pressed() -> void:
	AudioPlayer.play_music("PeacefulMusic")

func _on_sfx_1_button_pressed() -> void:
	AudioPlayer.play_sound("placeholder_boom")

func _on_sfx_2_button_pressed() -> void:
	AudioPlayer.play_sound("placeholder_pipe")

func _on_sfx_3_button_pressed() -> void:
	AudioPlayer.play_sound("placeholder_voice")
