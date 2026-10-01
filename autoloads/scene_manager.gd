extends Node

var SCENE_PATHS: Dictionary = {
	"main_menu": "res://menu/menu.tscn",
	"game": "res://game/main.tscn"
}


func go_to(scene_id: String) -> Error:
	var scene_path: String = SCENE_PATHS.get(scene_id, "")
	if scene_path.is_empty():
		push_error("Unknown scene ID: %s", scene_id)
		return ERR_DOES_NOT_EXIST
	
	get_tree().paused = false
	return get_tree().change_scene_to_file(scene_path)
