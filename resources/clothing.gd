class_name ClothingItem
extends Resource


const SIGNIFICANCE_THRESHOLD = 0.3


enum ClothingType {
	Hat,
	Top,
	Bottom,
	Shoe,
	NeckAccessory,
	WristAccessory,
}

@export var name: String
@export var image: CompressedTexture2D
@export var type: ClothingType

@export var goth: float = 0
@export var cutesy: float = 0
@export var chic: float = 0
@export var athletic: float = 0
@export var formal: float = 0
@export var wacky: float = 0
@export var rugged: float = 0
@export var preppy: float = 0

var most_significant_stat: String
var equipped = false

var id = ResourceUID.create_id()
var stats = {
	"goth": goth
}


func init_most_significant_stat():
	var current_max_value = 0
	var current_max_stat = ""
	
	for stat in stats:
		print("looking at ", stat)
		var stat_val = stats[stat]
		print(stat_val)
		if stat_val > current_max_value:
			current_max_stat = stat
			current_max_value = stat_val
	
	return current_max_stat

func get_stats():
	var significant_stats = []
	
	for stat in stats:
		if stats[stat] > SIGNIFICANCE_THRESHOLD:
			significant_stats.append(stat)
	
	return significant_stats
