extends Actor

class_name Soul
var integrity : float
var possessedBody : Sprite
var idle : State
var move : State
var meter : CanvasLayer
var canMerge : bool

onready var camera = $Camera
#var meterResource = load("res://Nodes/HUD.tscn")

func _init():
	print("Player -> Soul")
	id = Identity.SOUL
	gridPosition = Vector2.ZERO
	worldPosition = Vector2.ZERO
	idle = Idle.new()
	move = Move.new()
	add_child(idle)
	add_child(move)
	#meter = meterResource.instance()

func _ready():
	print("Soul Ready")
	backColor = $Polygon2D
	spriteOffset = Vector2(32,32)
	actorParent = get_parent()
	dungeonReference = actorParent.get_parent()
	camera.add_child(meter)
	visible = false

func onEnter():
	print("onEnter -> Soul")
	visible = true
	stepSize = dungeonReference.tileSize.x
	gridPosition = actorParent.body.gridPosition 
	worldPosition = actorParent.body.worldPosition
	camera.current = true
	canMerge = false
	currentState = idle
	currentState.onEnter()

func onUpdate():
	currentState.onUpdate()
	global_position = worldPosition

func onExit():
	visible = false
	pass
