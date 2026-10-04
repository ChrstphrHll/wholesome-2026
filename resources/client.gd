class_name Client
extends Resource


@export var goth: int = 0
@export var cutesy: int = 0
@export var chic: int = 0
@export var athletic: int = 0
@export var formal: int = 0
@export var wacky: int = 0
@export var rugged: int = 0
@export var preppy: int = 0


var dialog_info = {}


@export var name: String
@export var image: CompressedTexture2D

@export var dialogue_file: DialogueResource


func _init():
	dialog_info["goth"] = {
		"total": goth,
		"current": 0
	}
	dialog_info["cutesy"] = {
		"total": cutesy,
		"current": 0
	}
	dialog_info["chic"] = {
		"total": chic,
		"current": 0
	}
	dialog_info["athletic"] = {
		"total": athletic,
		"current": 0
	}
	dialog_info["formal"] = {
		"total": formal,
		"current": 0
	}
	dialog_info["wacky"] = {
		"total": wacky,
		"current": 0
	}
	dialog_info["rugged"] = {
		"total": rugged,
		"current": 0
	}
	dialog_info["preppy"] = {
		"total": preppy,
		"current": 0
	}


func check_clothing_triggers(item: ClothingItem):
	print("cheking triggers", item.name)
	var stat = item.most_significant_stat
	print("most significant stat", stat)
	if not stat:
		return ""
	
	return get_dialog_cue(stat)
		

func get_dialog_cue(stat: String):
	print("looking for dialog cue for ", stat)
	var stat_info = dialog_info[stat]
	
	if stat_info.current == stat_info.total:
		return ""
	
	var cue = stat + str(stat_info.current)
	stat_info.current += 1
	return cue
