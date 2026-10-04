extends Node2D

var all_clothing: Dictionary[int, ClothingItem] = {}
var equipped_clothes: Dictionary[ClothingItem.ClothingType, ClothingItem]

var backdrops: Dictionary[int, Backdrop] = {}
var activeBackdrop: Backdrop

var client_queue: Array[Client] = []
var active_client: Client

const LOBBY_SCALE = Vector2(0.4, 0.4)
const DRESS_UP_SCALE = Vector2(0.4, 0.4)
const PHOTO_SCALE = Vector2(-0.3, 0.3)

const POLAROID = preload("res://components/polaroid.tscn")

@onready var camera_2d = $Camera2D
@onready var balloon = $Camera2D/Balloon

# Screen Base Nodes
@onready var menu = $Menu
@onready var desk = $Desk
@onready var photo_wall = $PhotoWall
@onready var dress_up = $DressUp

@onready var pop_up = $Popups
@onready var pop_up_container = $Popups/CenterContainer
@onready var pop_up_animation_player = $Popups/AnimationPlayer


enum Location { MENU, DESK, DRESS_UP, PHOTO_WALL }

# Horse Sprites
var dress_up_horse: AnimatedSprite2D
var lobby_horse: AnimatedSprite2D
var photo_horse

# Called when the node enters the scene tree for the first time.
func _ready():
	load_clothes()
	populate_closet()
	
	load_backdrop_options()
	populate_backdrops()
	
	load_clients()


func load_clients():
	var clients = load_resources_from_dir("res://resources/clients/")
	clients.sort_custom(func (a: Client, b: Client): return a.order < b.order)
	print("~~~~~~~~sorted~~~~~~~~~~~")
	for client in clients:
		print(client.name, client.order)

	client_queue = clients
	active_client = clients[0]


func load_resources_from_dir(dir: String):
	var raw = ResourceLoader.list_directory(dir)
	var items: Array[Client] = []
	for path in raw:
		var full_path = dir + path
		var item = ResourceLoader.load(full_path)
		items.append(item)
	return items


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


func test():
	print("executed from dialog")
	

func animate(animation: String):
	print("animating sad")
	if lobby_horse:
		lobby_horse.animation = animation
	if dress_up_horse:
		dress_up_horse.animation = animation

func show_dialog(tag: String):
	DialogueManager.show_dialogue_balloon_scene(balloon, active_client.dialogue_file, tag, [self])


func listen_for_dialog_end():
	await DialogueManager.dialogue_ended


func bring_to_credits():
	#TODO: end the game!!!!!
	pass


#region front desk


func call_next_client():
	bring_client_into_lobby(active_client.generate_sprite_sheet())
	%ShopBell.play()
	show_dialog("start")
	await listen_for_dialog_end()
	put_client_into_dressing_room(lobby_horse.duplicate())
	_move_screen(Location.DRESS_UP)
	
	await get_tree().create_timer(2).timeout
	remove_lobby_horse()


func bring_client_into_lobby(sprite: AnimatedSprite2D):
	lobby_horse = sprite
	lobby_horse.position = $Desk/Marker2D.position
	lobby_horse.scale = LOBBY_SCALE
	desk.add_child(lobby_horse)


func remove_lobby_horse():
	lobby_horse.queue_free()


func calculate_outfit_score():
	var score = 0
	for item in equipped_clothes.values():
		score += active_client.get_item_score(item)
	print(score)
	return "post_photo_high"


func client_end_screen():
	bring_client_into_lobby(photo_horse.duplicate())
	_move_screen(Location.DESK)
	
	var score_trigger = calculate_outfit_score()
	
	show_dialog(score_trigger)
	await listen_for_dialog_end()
	remove_lobby_horse()
	equipped_clothes = {}
	client_queue.pop_front()
	active_client = client_queue.front()
	if not active_client:
		bring_to_credits()

#endregion


#region dress up


func load_clothes():
	var base_directory = "res://resources/clothing/"
	var sub_dirs = ["pants/", "shirts/", "shoes/", "hats/", "neck/", "wrist/"]
	
	for sub_dir in sub_dirs:
		var clothes_raw = ResourceLoader.list_directory(base_directory + sub_dir)
	
		for clothing_item_path in clothes_raw:
			var full_path = base_directory + sub_dir + clothing_item_path
			var item = ResourceLoader.load(full_path)
			all_clothing[item.id] = item


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
		ClothingItem.ClothingType.NeckAccessory:
			return $%NeckAccessoriesGridContainer
		ClothingItem.ClothingType.WristAccessory:
			return $%WristAccessoriesGridContainer


func populate_closet():
	print("loading closet")
	for clothing_item in all_clothing.values():
		var button = Button.new()
		var texture = TextureRect.new()
		button.size_flags_horizontal = Control.SIZE_EXPAND
		button.custom_minimum_size = Vector2(100, 100)
		texture.custom_minimum_size = Vector2(100, 100)
		texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if clothing_item.cropped_icon:
			texture.texture = clothing_item.cropped_icon
		else:
			texture.texture = clothing_item.image
		button.add_child(texture)
		get_closet_tab_container(clothing_item).add_child(button)
		button.pressed.connect(_select_clothing_item.bind(clothing_item.id))


func put_client_into_dressing_room(sprite: AnimatedSprite2D):
	dress_up_horse = sprite
	dress_up_horse.position = $DressUp/Marker2D.position
	dress_up_horse.scale = DRESS_UP_SCALE
	dress_up.add_child(dress_up_horse)


func _select_clothing_item(item_id: int):
	var item = get_clothing_item_from_id(item_id)
	print("selecting item ", item.name)
	
	if equipped_clothes.has(item.type):
		var equipped_item = equipped_clothes[item.type]
		equipped_item.current_sprite.queue_free()
		equipped_item.current_sprite = null
		equipped_clothes.erase(item.type)
		
		if item.id == equipped_item.id:
			return
		
	var sprite = Sprite2D.new()
	sprite.texture = item.image
	item.current_sprite = sprite
	equipped_clothes[item.type] = item
	check_item_dialog_triggers(item)
	print("adding child to sprute")
	print(dress_up_horse)
	dress_up_horse.add_child(sprite)


func check_item_dialog_triggers(item: ClothingItem):
	var cue = active_client.check_clothing_triggers(item)
	
	if cue:
		show_dialog(cue)


func get_clothing_item_from_id(id: int):
	return all_clothing[id]


func _on_dress_up_finished():
	put_client_into_photo_booth(dress_up_horse.duplicate())
	_move_screen(Location.PHOTO_WALL)
	await get_tree().create_timer(2).timeout
	dress_up_horse.queue_free()


#endregion


#region Photo Booth


func load_backdrop_options():
	var base_directory = "res://resources/backdrops/"

	var backdrops_raw = ResourceLoader.list_directory(base_directory)

	for backdrop_path in backdrops_raw:
		var full_path = base_directory + backdrop_path
		var item = ResourceLoader.load(full_path)
		backdrops[item.id] = item


func populate_backdrops():
	for backdrop in backdrops.values():
		var button = TextureButton.new()
		button.texture_normal = backdrop.image
		button.size_flags_horizontal = Control.SIZE_EXPAND
		button.custom_minimum_size = Vector2(100, 100)
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED
		
		button.pressed.connect(_on_backdrop_pressed.bind(backdrop.id))
		
		
		$%Backdrops.add_child(button)


func put_client_into_photo_booth(sprite: AnimatedSprite2D):
	photo_horse = sprite
	photo_horse.position = Vector2(300, 300)
	photo_horse.scale = PHOTO_SCALE
	photo_wall.add_child(photo_horse)


func _on_backdrop_pressed(id: int):
	$%Backdrop.texture = backdrops[id].image
	print("change backdrop to, ", backdrops[id].name)


func _on_change_outfit_pressed():
	put_client_into_dressing_room(photo_horse.duplicate())
	_move_screen(Location.DRESS_UP)
	await get_tree().create_timer(2).timeout
	photo_horse.queue_free()


func _on_take_photo_pressed():
	%ShutterClick.play()
	print("took photo")
	pop_up.show()
	pop_up_animation_player.play("flash")
	var photoed_horse = photo_horse.duplicate()
	var frame = $PhotoWall/SubViewportContainer/PhotoView
	photoed_horse.position = Vector2(frame.size.x / 2.0, frame.size.y / 2.0)
	frame.add_child(photoed_horse)
	await RenderingServer.frame_post_draw
	var image = frame.get_texture().get_image()
	
	var photo = POLAROID.instantiate()
	%TaDa.play()
	photo.image = image
	pop_up_container.add_child(photo)
	photoed_horse.queue_free()
	
	await photo.animation_done
	pop_up.hide()
	photo.queue_free()
	
	# TODO: Add photo somewhere and also save out the screenshot
	client_end_screen()
	

#endregion
