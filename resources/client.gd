class_name Client
extends Resource


@export var order: int

@export var goth: Array[int] = []
@export var cutesy: Array[int] = []
@export var chic: Array[int] = []
@export var athletic: Array[int] = []
@export var formal: Array[int] = []
@export var wacky: Array[int] = []
@export var rugged: Array[int] = []
@export var preppy: Array[int] = []


@export var special_triggers: Array[String] = []


var seen_info = {
	"goth": 0,
	"cutesy": 0,
	"chic": 0,
	"athletic": 0,
	"formal": 0,
	"wacky": 0,
	"rugged": 0,
	"preppy": 0
}


@export var name: String
@export var image: CompressedTexture2D
@export var forth_closed: CompressedTexture2D
@export var three_forths_closed: CompressedTexture2D
@export var closed: CompressedTexture2D
@export var smile: CompressedTexture2D
@export var talking: CompressedTexture2D
@export var sad: CompressedTexture2D


@export var dialogue_file: DialogueResource


func check_clothing_triggers(item: ClothingItem):
	var stat = item.get_most_significant_stat()
	if not stat:
		return ""
	
	return get_dialog_cue(stat)
		

func get_dialog_cue(stat: String):
	seen_info[stat] = seen_info[stat] + 1
	var times_seen_stat = seen_info[stat]
	print("looking for dialog cue for ", stat, " ", str(times_seen_stat))
	var next_trigger = get_stat_next_trigger(stat)
	
	if not next_trigger:
		return ""
	
	if times_seen_stat == next_trigger:
		var cue = stat + str(times_seen_stat)
		print("you should play the dialog at cue ", cue)
		return cue
	
	return ""


func get_stat_next_trigger(stat: String):
	match stat:
		"goth":
			return next_stat_trigger(goth)
		"cutesy":
			return next_stat_trigger(cutesy)
		"chic":
			return next_stat_trigger(chic)
		"athletic":
			return next_stat_trigger(athletic)
		"formal":
			return next_stat_trigger(formal)
		"wacky":
			return next_stat_trigger(wacky)
		"rugged":
			return next_stat_trigger(rugged)
		"preppy":
			return next_stat_trigger(preppy)


func next_stat_trigger(triggers: Array[int]):
	if triggers.size() == 0:
		return false
	return triggers[0]
