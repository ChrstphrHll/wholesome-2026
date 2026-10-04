extends Control


@export var image: Image
@export var caption: String


@onready var texture_rect = $TextureRect
@onready var label = $Control/Label


signal animation_done


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = ImageTexture.create_from_image(image)
	label.text = caption

func animation_completed():
	animation_done.emit()
