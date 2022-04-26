extends Actor

class_name Enemy

var idle : State
var move : State
var attack : State
var death : State
var nextTile : Tile
var attackTile : Tile
var aimingDirection : int
var kind : int
var expAward : int
var coinAward : int
var isPossessed : bool
var item : Sprite
var directionArrow : Sprite
var target : Sprite
var sfx : AudioStreamPlayer
var arrowResource = load("res://Nodes/Arrow.tscn")
var targetResource = load("res://Nodes/Target.tscn")
var sfxResource = load("res://Nodes/Damage.tscn")
var colorArray = [Color(0,0,255,1),Color(0,255,0,1),Color(255,0,0,1)]
var aimingArray = []

enum Kind {A1, A2, A4}

func _init():
	print("Enemy initialized")
	id = Identity.ENEMY
	gridPosition = Vector2.ZERO
	worldPosition = Vector2.ZERO
	idle = Idle.new()
	move = MoveAI.new()
	attack = Attack.new()
	death = Death.new()
	aimingDirection = 0
	directionArrow = arrowResource.instance()
	target = targetResource.instance()
	sfx = sfxResource.instance()
	add_child(idle)
	add_child(move)
	add_child(attack)
	add_child(death)
	add_child(target)
	add_child(directionArrow)
	add_child(sfx)

func _ready():
	dungeonReference = get_parent()
	if kind == Kind.A1:
		print("A1 Enemy Ready")
		frame = 319
		healthPoints = 4 + dungeonReference.level
		attackPoints = 2 + dungeonReference.level
		expAward = 3 + dungeonReference.level
		coinAward = 1
	elif kind == Kind.A2:
		print("A2 Enemy Ready")
		frame = 170
		healthPoints = 6 + dungeonReference.level
		attackPoints = 3 + dungeonReference.level
		expAward = 6 + dungeonReference.level
		coinAward = 2
	else:
		print("A4 Enemy Ready")
		frame = 171
		healthPoints = 10 + dungeonReference.level
		attackPoints = 4 + dungeonReference.level
		expAward = 9 + dungeonReference.level
		coinAward = 3
	defensePoints = 0
	modulate = colorArray[kind]
	#directionArrow.modulate = colorArray[kind]
	directionArrow.visible = false
	target.visible = false
	backColor = $Polygon2D
	spriteOffset = Vector2(32,32)
	dungeonReference = get_parent()
	stepSize = dungeonReference.tileSize.x
	onEnter()

func onEnter():
	print("onEnter -> Enemy")
	currentState = idle
	currentState.onEnter()

func onUpdate():
	currentState.onUpdate()
	if aimingArray.size() == 1 and !move.hasMoved:
		target.global_position = aimingArray[aimingDirection] * stepSize + spriteOffset
		if target.visible:
			target.visible = false
		else:
			target.visible = true
	if aimingArray.size() > 1:
		target.global_position = aimingArray[aimingDirection] * stepSize + spriteOffset
		if aimingDirection >= aimingArray.size()-1:
			aimingDirection = 0
		else:
			aimingDirection += 1
			#print(target.global_position)
	global_position = worldPosition

func onExit():
	pass

func _process(_delta):
	onUpdate()
