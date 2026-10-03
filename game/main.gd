extends Node2D

@onready var camera_2d = $Camera2D

@onready var menu = $Menu
@onready var desk = $Desk
@onready var photo_wall = $PhotoWall
@onready var dress_up = $DressUp


var current_jacket: Sprite2D


@onready var cotopaxi_2 = $DressUp/Cotopaxi2
@onready var red_jacket_2 = $DressUp/RedJacket2

@onready var top = $DressUp/Horse/Top
@onready var off = $DressUp/Horse/Off


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func move_sprite_to_point(sprite: Sprite2D, target_position: Vector2):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	print("moving", sprite, "to ", target_position)
	tween.tween_property(sprite, "global_position", target_position, 0.5)


func get_screen(screen_name: String):
	match screen_name:
		"menu":
			return menu
		"desk":
			return desk
		"photo_wall":
			return photo_wall
		"dress_up":
			return dress_up
		_:
			printerr("💣 NOT A VALID SCREEN NAME 💣")


func _move_screen(target_screen_name: String):
	var camera_tween = get_tree().create_tween()
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.set_trans(Tween.TRANS_CUBIC)
	var target_screen = get_screen(target_screen_name)
	camera_tween.tween_property(camera_2d, "position", target_screen.position, 0.5)


func _on_jacket_pressed(jacket_node_path: NodePath):
	print(jacket_node_path)
	var jacket_sprite = get_node(jacket_node_path)
	print("moving jacket")
	

	move_sprite_to_point(current_jacket, off.global_position)
	if current_jacket == jacket_sprite:
		current_jacket = null
		return
	
	move_sprite_to_point(jacket_sprite, top.global_position)
	current_jacket = jacket_sprite


func _on_red_jacket_pressed():
	print("moving red jacket")
	if current_jacket == red_jacket_2:
		return
	move_sprite_to_point(red_jacket_2, top.global_position)
	current_jacket = red_jacket_2
