extends Control


@export var image: Image
@export var tilt = 0.0


@onready var photo = $Photo


signal animation_done


# Called when the node enters the scene tree for the first time.
func _ready():
	photo.texture = ImageTexture.create_from_image(image)
	rotation = tilt
	pivot_offset = size / 2.0
	


func spin():
	$AnimationPlayer.play("reveal")


func animation_completed():
	animation_done.emit()
