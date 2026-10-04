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
var special_item_shown = false

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


func generate_sprite_sheet():
	var sprite = AnimatedSprite2D.new()
	var sprite_frames = SpriteFrames.new()
	sprite_frames.add_animation("blinking")
	sprite_frames.add_frame("blinking", image, 20.0)
	sprite_frames.add_frame("blinking", forth_closed)
	sprite_frames.add_frame("blinking", three_forths_closed)
	sprite_frames.add_frame("blinking", closed)
	sprite_frames.set_animation_loop("blinking", true)
	sprite_frames.set_animation_loop_mode("blinking", SpriteFrames.LOOP_PINGPONG)
	
	sprite.sprite_frames = sprite_frames
	sprite.animation = "blinking"
	
	return sprite


func check_clothing_triggers(item: ClothingItem):
	var special_item_cue = check_special_item_trigger(item)
	
	if special_item_cue:
		return special_item_cue
	
	var stat = item.get_most_significant_stat()
	if not stat:
		return ""
	
	return get_dialog_cue(stat)


func check_special_item_trigger(item: ClothingItem):
	print(item.name)
	print(special_triggers)
	print(special_triggers.has(item.name))
	if special_item_shown:
		return ""
	
	if special_triggers.has(item.name):
		return "special_item"

func get_dialog_cue(stat: String):
	seen_info[stat] = seen_info[stat] + 1
	var times_seen_stat = seen_info[stat]
	print("looking for dialog cue for ", stat, " ", str(times_seen_stat))
	var next_trigger = get_stat_next_trigger(stat)
	
	if not next_trigger:
		return ""
	
	if times_seen_stat == next_trigger:
		pop_front_trigger(stat)
		var cue = stat + str(times_seen_stat)
		print("you should play the dialog at cue ", cue)
		return cue
	
	return ""


func pop_front_trigger(stat: String):
	match stat:
		"goth":
			goth.pop_front()
		"cutesy":
			cutesy.pop_front()
		"chic":
			chic.pop_front()
		"athletic":
			athletic.pop_front()
		"formal":
			formal.pop_front()
		"wacky":
			wacky.pop_front()
		"rugged":
			rugged.pop_front()
		"preppy":
			preppy.pop_front()


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
