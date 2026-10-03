extends Node2D

var all_clothing: Dictionary[int, ClothingItem] = {}
var equipped_clothes: Dictionary[ClothingItem.ClothingType, Sprite2D]

@onready var camera_2d = $Camera2D

@onready var menu = $Menu
@onready var desk = $Desk
@onready var photo_wall = $PhotoWall
@onready var dress_up = $DressUp
@onready var horse = $DressUp/Horse


var current_jacket: Sprite2D


@onready var cotopaxi_2 = $DressUp/Cotopaxi2
@onready var red_jacket_2 = $DressUp/RedJacket2

@onready var top = $DressUp/Horse/Top
@onready var off = $DressUp/Horse/Off


# Called when the node enters the scene tree for the first time.
func _ready():
	load_clothes()
	populate_closet()


func load_clothes():
	var base_directory = "res://resources/clothing/"
	var clothes_raw = ResourceLoader.list_directory(base_directory)
	
	for clothing_item_path in clothes_raw:
		var full_path = base_directory + clothing_item_path
		var item = ResourceLoader.load(full_path)
		all_clothing[item.id] = item
	print(all_clothing)

func populate_closet():
	print("loading closet")
	print(all_clothing)
	for clothing_item in all_clothing.values():
		var button = Button.new()
		var texture = TextureRect.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND
		button.custom_minimum_size = Vector2(100, 100)
		texture.custom_minimum_size = Vector2(100, 100)
		texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture.texture = clothing_item.image
		button.add_child(texture)
		get_closet_tab_container(clothing_item).add_child(button)
		print(clothing_item)
		button.pressed.connect(_select_clothing_item.bind(clothing_item.id))


func get_closet_tab_container(item: ClothingItem):
	match item.type:
		ClothingItem.ClothingType.Hat:
			return $%HatsGridContainer
		ClothingItem.ClothingType.Top:
			return $%TopsGridContainer
		ClothingItem.ClothingType.Bottom:
			return $%BottomsGridContainer
		ClothingItem.ClothingType.Shoe:
			return $%ShoesGridContainer
		ClothingItem.ClothingType.Accessory:
			return $%AccessoriesGridContainer


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


func _select_clothing_item(item_id: int):
	var item = get_clothing_item_from_id(item_id)
	print("selecting item ", item.name)
	if item.equipped:
		var equipped_item = equipped_clothes[item.type]
		equipped_item.queue_free()
		equipped_clothes.erase(item.type)
		item.equipped = false
		return
		
	item.equipped = true
	var sprite = Sprite2D.new()
	sprite.texture = item.image
	equipped_clothes[item.type] = sprite

	horse.add_child(sprite)
	

func _on_jacket_pressed(jacket_node_path: NodePath):
	var jacket_sprite = get_node(jacket_node_path)	

	move_sprite_to_point(current_jacket, off.global_position)
	if current_jacket == jacket_sprite:
		current_jacket = null
		return
	
	move_sprite_to_point(jacket_sprite, top.global_position)
	current_jacket = jacket_sprite


func get_clothing_item_from_id(id: int):
	return all_clothing[id]
