extends Actor

class_name Soul
var integrity : float
var possessedBody : Sprite
var camera : Camera2D

func _init():
	print("Init soul from Player")
	camera = Camera2D.new()
	add_child(camera)
	transform.origin = worldPosition
	print(gridPosition)
	print(transform.origin)

func onEnter():
	camera.current = true

func onUpdate():
	pass

func onExit():
	pass