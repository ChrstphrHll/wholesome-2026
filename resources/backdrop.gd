class_name Backdrop
extends Resource

@export var name: String
@export var image: Array[CompressedTexture2D]

var id = ResourceUID.create_id()


func get_image():
	return image[0]


func get_frames() -> SpriteFrames:
	var frames: SpriteFrames = SpriteFrames.new()
	
	for frame in image:	
		frames.add_frame("default", frame)
	
	frames.set_animation_loop_mode("default", SpriteFrames.LOOP_PINGPONG)
	return frames
