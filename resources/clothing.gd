class_name ClothingItem
extends Resource

enum ClothingType {
	Hat,
	Top,
	Bottom,
	Shoe,
	Accessory
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

var equipped = false

var id = ResourceUID.create_id()
