extends Actor

class_name Body

var random = RandomNumberGenerator.new()
var healthCap : int
var canBuy : bool
var isMisbehaved : bool
#EXP
var experience : int
var experienceCap : int
var sanityLevel : int
#OUTBURST
var outburstLimit : Vector2
var outburstTurns : int
var outburstTracker : int
#EFFECTS
var poweredUp : bool
var effectTurns : int
#MISBEHAVIOR
var missProbability : int
var misbehaviorScale : int
var inventory : Inventory
var currentMood : Emotion
var attackTile : Tile
#STATES
var idle : State
var move : State
var fall : State
var use : State
var buy : State
var attack : State
var outburst : State
var levelUp : State
var death : State
#NODES
var sfx : AudioStreamPlayer
onready var polygon = $Polygon2D
var sfxResource = load("res://Nodes/Slay.tscn")

onready var camera = $Camera

func _init():
	print("Player -> Body")
	random.randomize()
	modulate = Color(255,255,255,1)
	id = Identity.BODY
	gridPosition = Vector2.ZERO
	worldPosition = Vector2.ZERO
	poweredUp = false
	sanityLevel = 1
	effectTurns = -1
	missProbability = 45
	misbehaviorScale = 75
	experienceCap = 10
	healthCap = 10
	healthPoints = 10
	attackPoints = 2
	defensePoints = 1
	outburstLimit = Vector2(15,20)
	outburstTurns = 0
	outburstTracker = random.randi_range(outburstLimit.x, outburstLimit.y)
	canBuy = true
	isMisbehaved = true
	idle = Idle.new()
	move = Move.new()
	fall = Fall.new()
	use = Use.new()
	buy = Buy.new()
	outburst = Outburst.new()
	attack = Attack.new()
	levelUp = LevelUp.new()
	death = Death.new()
	inventory = Inventory.new()
	sfx = sfxResource.instance()
	add_child(idle)
	add_child(move)
	add_child(fall)
	add_child(use)
	add_child(buy)
	add_child(outburst)
	add_child(levelUp)
	add_child(death)
	add_child(inventory)
	add_child(attack)
	add_child(sfx)

func _ready():
	print("Body Ready")
	backColor = $Polygon2D
	spriteOffset = Vector2(32,32)
	actorParent = get_parent()
	dungeonReference = actorParent.get_parent()

func onEnter():
	print("onEnter -> body")
	camera.current = true
	currentState = idle
	currentState.onEnter()

func onUpdate():
	#print("Body on enter values:")
	currentState.onUpdate()
	global_position = worldPosition

func onExit():
	pass