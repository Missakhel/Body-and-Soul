extends Actor

class_name Body
var inventory : Inventory
var spriteOffset : Vector2
var spriteScale : Vector2
var currentMood : Emotion
var camera : Camera2D

func _init():
	camera = Camera2D.new()
	add_child(camera)
	healthPoints = 10
	attackPoints = 1

func onEnter():
	camera.current = true

func onUpdate():
	transform.origin = worldPosition
	print(transform.origin)