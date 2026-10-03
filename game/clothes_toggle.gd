extends Node2D


@export var title: String
@export var image: Texture2D

@onready var button = $Button
@onready var sprite_2d = $Sprite2D


signal select_item


# Called when the node enters the scene tree for the first time.
func _ready():
	button.text = title
	sprite_2d.texture = image




func _on_button_pressed():
	select_item.emit("tester")
