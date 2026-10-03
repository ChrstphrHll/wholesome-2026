extends Node2D

var all_clothing: Dictionary[int, ClothingItem] = {}
var equipped_clothes: Dictionary[ClothingItem.ClothingType, Sprite2D]

var client_queue: Array[Client] = [ResourceLoader.load("res://resources/clients/lost_my_job.tres")]
var active_client: Client = client_queue[0]

@onready var camera_2d = $Camera2D
@onready var balloon = $Desk/DeskBalloon

# Screen Base Nodes
@onready var menu = $Menu
@onready var desk = $Desk
@onready var photo_wall = $PhotoWall
@onready var dress_up = $DressUp

enum Location { MENU, DESK, DRESS_UP, PHOTO_WALL }

# Horse Sprites
@onready var dress_up_horse: Sprite2D = $DressUp/Horse
@onready var lobby_horse: Sprite2D = $Desk/LobbyHorse
var photo_horse

# Called when the node enters the scene tree for the first time.
func _ready():
	load_clothes()
	populate_closet()


func move_sprite_to_point(sprite: Sprite2D, target_position: Vector2):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	print("moving", sprite, "to ", target_position)
	tween.tween_property(sprite, "global_position", target_position, 0.5)


func get_screen(screen_name: Location):
	match screen_name:
		Location.MENU:
			return menu
		Location.DESK:
			return desk
		Location.PHOTO_WALL:
			return photo_wall
		Location.DRESS_UP:
			return dress_up
		_:
			printerr("💣 NOT A VALID SCREEN NAME 💣")


func _move_screen(target_screen_name: Location):
	var camera_tween = get_tree().create_tween()
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.set_trans(Tween.TRANS_CUBIC)
	var target_screen = get_screen(target_screen_name)
	camera_tween.tween_property(camera_2d, "position", target_screen.position, 0.5)


#region front desk


func call_next_client():
	#set_active_client()
	bring_client_into_lobby()
	start_client_lobby_dialog()
	await listen_for_dialog_end()
	#put_client_into_dressing_room()
	_move_screen(Location.DRESS_UP)


func bring_client_into_lobby():
	lobby_horse.show()


func set_all_horses(texture: CompressedTexture2D):
	lobby_horse.texture = texture
	dress_up_horse.texture = texture


func start_client_lobby_dialog():
	DialogueManager.show_dialogue_balloon_scene(balloon, active_client.dialogue_file)


func listen_for_dialog_end():
	await DialogueManager.dialogue_ended


#endregion


#region dress up


func load_clothes():
	var base_directory = "res://resources/clothing/"
	var clothes_raw = ResourceLoader.list_directory(base_directory)
	
	for clothing_item_path in clothes_raw:
		var full_path = base_directory + clothing_item_path
		var item = ResourceLoader.load(full_path)
		all_clothing[item.id] = item
	print(all_clothing)


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

	dress_up_horse.add_child(sprite)


func get_clothing_item_from_id(id: int):
	return all_clothing[id]


func _on_dress_up_finished():
	photo_horse = dress_up_horse.duplicate()
	photo_horse.position = Vector2(300, 300)
	photo_wall.add_child(photo_horse)
	_move_screen(Location.PHOTO_WALL)


#endregion


#region Photo Booth


func _on_beach_pressed():
	$PhotoWall/Beach.show()
	$PhotoWall/Space.hide()


func _on_space_pressed():
	$PhotoWall/Beach.hide()
	$PhotoWall/Space.show()


func _on_change_outfit_pressed():
	_move_screen(Location.DRESS_UP)
	photo_horse.queue_free()


#endregion
