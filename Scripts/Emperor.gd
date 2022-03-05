extends Sprite

onready var gameWorld = get_node("/root/Scene")
onready var camera = $Camera
onready var audio = $AudioStream
onready var soul = $Soul
onready var soulCamera = $Soul/Camera

var characterPosition : Vector2 = Vector2(0,0)
var soulPosition : Vector2 = Vector2(0,0)
var spriteOffset : Vector2 = Vector2(32, 32)
var soulModeON : bool = false
var soulMergeable : bool = false
var targetCell : int = 0

signal moved
signal enteredHole

func _ready():
	pass

func _on_Scene_finishedMapGeneration():
	transform.origin = gameWorld.worldCoordinate + spriteOffset
	characterPosition = gameWorld.characterPosition
	soul.transform.origin = gameWorld.worldCoordinate
	scale = Vector2(5,5)
	rotation = 0
	soul.visible = false

func soulModeActivation(activated : bool):
	if activated:
		soulModeON = true
		soul.visible = true
		soulCamera.current = true
		soulPosition = characterPosition
		emit_signal("moved")
		soul.transform.origin = gameWorld.worldCoordinate + gameWorld.worldCoordinate*.09
	else:
		soulModeON = false
		soul.visible = false
		camera.current = true

func movement(movementVector: Vector2): 
	if soulModeON:
		soulPosition += movementVector
		targetCell = gameWorld.objectMap[soulPosition.y][soulPosition.x]
		if targetCell == gameWorld.MapCode.WALL:
			soulPosition -= movementVector
		else:
			if soulPosition == characterPosition and soulMergeable:
				soulModeActivation(false)
			soulMergeable = true
			emit_signal("moved")
			#Taking reference the main character as origin of the soul plus an offset of 10% percentage to match the tiles
			soul.transform.origin = gameWorld.worldCoordinate
	else:
		characterPosition += movementVector
		targetCell = gameWorld.objectMap[characterPosition.y][characterPosition.x]
		if targetCell == gameWorld.MapCode.INACCESSIBLE or targetCell == gameWorld.MapCode.WALL:
			characterPosition -= movementVector
		else:
			emit_signal("moved")
			transform.origin = gameWorld.worldCoordinate + spriteOffset

func _process(_delta):
	if gameWorld.objectMap[characterPosition.y][characterPosition.x] == gameWorld.MapCode.HOLE and !soulModeON:
		scale.x -= _delta
		scale.y -= _delta
		if scale <= Vector2.ZERO:
			emit_signal("enteredHole")
			scale = Vector2(5,5)
	elif scale >Vector2(1,1):
		scale.x -= _delta * 5
		scale.y -= _delta * 5
	elif scale <= Vector2(1,1):
		scale = Vector2(1,1)
		if Input.is_action_just_pressed("ui_up"):
			movement(Vector2(0,-1))
		if Input.is_action_just_pressed("ui_down"):
			movement(Vector2(0,1))
		if Input.is_action_just_pressed("ui_left"):
			movement(Vector2(-1,0))
		if Input.is_action_just_pressed("ui_right"):
			movement(Vector2(1,0))
		if Input.is_action_just_pressed("soul_mode") and !soulModeON:
			soulModeActivation(true)
	
func _on_Title_closed():
	camera.current = true
	audio.play()