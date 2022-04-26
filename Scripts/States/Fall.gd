extends State

class_name Fall

var initialScale : Vector2
var changedRoom : bool
var reductionIndex : float

func _init():
	name = "Fall"

func onEnter():
	print("Body -> Fall")
	stateParent = get_parent()
	changedRoom = false
	reductionIndex = .0125
	initialScale = Vector2(5,5)

func onUpdate():
	stateParent.scale.x -= reductionIndex
	stateParent.scale.y -= reductionIndex

	if stateParent.scale < Vector2.ZERO and !changedRoom:
		stateParent.dungeonReference.reset()
		print("Player advanced to level ", stateParent.dungeonReference.level)
		changedRoom = true
	elif changedRoom and stateParent.scale < Vector2.ZERO:
		stateParent.scale = initialScale
		reductionIndex = .065
	elif stateParent.scale < Vector2(1,1) and changedRoom:
		stateParent.scale = Vector2(1,1)
		onExit()

func onExit():
	stateParent.currentState = stateParent.idle
	stateParent.onEnter()
