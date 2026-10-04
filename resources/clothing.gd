class_name ClothingItem
extends Resource


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
@export var cropped_icon: CompressedTexture2D
@export var type: ClothingType

@export var goth: float = 0
@export var cutesy: float = 0
@export var chic: float = 0
@export var athletic: float = 0
@export var formal: float = 0
@export var wacky: float = 0
@export var rugged: float = 0
@export var preppy: float = 0

var equipped = false
var current_sprite

var id = ResourceUID.create_id()


func generate_stat_list():
	return {
		"goth": goth,
		"cutesy": cutesy,
		"chic": chic,
		"athletic": athletic,
		"formal": formal,
		"wacky": wacky,
		"rugged": rugged,
		"preppy": preppy,
	}


func get_most_significant_stat():
	var current_max_value = 0
	var current_max_stat = ""
	
	var stats = generate_stat_list()
	
	for stat in stats:
		var stat_val = stats[stat]
		if stat_val > current_max_value:
			current_max_stat = stat
			current_max_value = stat_val
	
	return current_max_stat


func get_z_index():
	match type:
		ClothingType.Hat:
			return 11
		ClothingType.Bottom:
			return 7
		ClothingType.Shoe:
			return 6
		ClothingType.Top:
			return 8
		ClothingType.NeckAccessory:
			return 10
		ClothingType.WristAccessory:
			return 10
