extends Node

const save_location = "user://SaveFile.tres"
 
var saveFileData : SaveDataResource = SaveDataResource.new() 

func _ready() -> void:
	_load()
	
func _save():
	ResourceSaver.save(saveFileData, save_location)
	
func _load():
	if FileAccess.file_exists(save_location):
		saveFileData = ResourceLoader.load(save_location).duplicate(true)
