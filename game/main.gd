extends Node2D

@onready var camera_2d = $Camera2D

@onready var menu = $Menu
@onready var desk = $Desk
@onready var photo_wall = $PhotoWall
@onready var dress_up = $DressUp


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _move_screen(target_screen: String):
	var screens = {
		"menu": menu,
		"desk": desk,
		"photo_wall": photo_wall,
		"dress_up": dress_up
	}
	
	var camera_tween = get_tree().create_tween()
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.set_trans(Tween.TRANS_CUBIC)
	print(screens[target_screen].position)
	print("moving screen")
	camera_tween.tween_property(camera_2d, "position", Vector2(0,0), 0.5)
