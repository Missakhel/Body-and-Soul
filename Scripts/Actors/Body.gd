extends Actor

class_name Body
var inventory : Inventory
var spriteOffset : Vector2
var spriteScale : Vector2
var currentMood : Emotion
var camera : Camera2D
var idle : State
var move : State

func _init():
	print("Player -> Body")
	gridPosition = Vector2.ZERO
	worldPosition = Vector2.ZERO
	healthPoints = 10
	attackPoints = 1
	camera = Camera2D.new()
	idle = Idle.new()
	move = Move.new()
	add_child(camera)
	add_child(idle)
	add_child(move)

func onEnter():
	print("onEnter -> body")
	currentState = idle
	currentState.onEnter()
	camera.current = true
	global_position = worldPosition

func onUpdate():
	print("Body on enter values:")
	print(gridPosition)
	print(worldPosition)
	print(global_transform.origin)
	currentState.onUpdate()

func onExit():
	pass
