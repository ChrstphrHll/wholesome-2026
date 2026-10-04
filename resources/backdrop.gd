class_name Backdrop
extends Resource

@export var name: String
@export var image: Array[CompressedTexture2D]

var id = ResourceUID.create_id()

func get_image():
	return image[0]
