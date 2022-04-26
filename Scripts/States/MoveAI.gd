extends State

class_name MoveAI

var hasMoved = true
var direction : int
var random = RandomNumberGenerator.new()
var directionArray = [Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0)]
var rotationArray = [0, 180, 270, 90]
enum Direction {UP, DOWN, LEFT, RIGHT}

func _init():
	name = "Move"
	random.randomize()

func onEnter():
	stateParent = get_parent()
	#print(stateParent.name," -> MoveAI")

func TurnCompletion():
	stateParent.currentState = stateParent.idle
	#print(stateParent.name," -> Idle")
	onExit()

func aimingConfirmation(aimingDirection : Vector2):
	if stateParent.dungeonReference.map[stateParent.gridPosition.y + aimingDirection.y][stateParent.gridPosition.x + aimingDirection.x].objectID == 0:
		#if stateParent.dungeonReference.map[stateParent.gridPosition.y + aimingDirection.y][stateParent.gridPosition.x + aimingDirection.x].occupier != null:
			#if stateParent.dungeonReference.map[stateParent.gridPosition.y + aimingDirection.y][stateParent.gridPosition.x + aimingDirection.x].occupier.id != Actor.Identity.ENEMY:
		if stateParent.dungeonReference.map[stateParent.gridPosition.y + aimingDirection.y][stateParent.gridPosition.x + aimingDirection.x].willBeOccupied == false:
			stateParent.aimingArray.append(stateParent.gridPosition + aimingDirection)

func aiming(aimingVector : Vector2):
	stateParent.aimingDirection = 0
	stateParent.aimingArray.clear()
	if stateParent.kind == 0:
		stateParent.aimingArray.append(stateParent.gridPosition + aimingVector)
	elif stateParent.kind == 1:
		stateParent.aimingArray.append(stateParent.gridPosition + aimingVector)
		aimingConfirmation(aimingVector * -1)
	else:
		stateParent.aimingArray.append(stateParent.gridPosition + aimingVector)
		for aimingDirection in directionArray:
			aimingConfirmation(aimingDirection)
	#print(stateParent.aimingArray)

func movementExecution(movementVector : Vector2):
	var attacked : bool = false
	stateParent.directionArrow.visible = false
	stateParent.target.visible = false

	if stateParent.aimingArray.size()>0:
		for aimingDirection in stateParent.aimingArray:
			#print(aimingDirection)
			if stateParent.dungeonReference.map[aimingDirection.y][aimingDirection.x].occupier != null:
				if stateParent.dungeonReference.map[aimingDirection.y][aimingDirection.x].occupier.id == Actor.Identity.BODY:
					stateParent.attackTile = stateParent.dungeonReference.map[aimingDirection.y][aimingDirection.x]
					stateParent.nextTile.willBeOccupied = false
					stateParent.currentState = stateParent.attack
					attacked = true
					onExit()
		#print(stateParent.name," -> Attack player")
	if !attacked:
		stateParent.currentTile.occupier = null
		stateParent.gridPosition += movementVector
		stateParent.worldPosition = stateParent.gridPosition * stateParent.stepSize + stateParent.spriteOffset
		stateParent.global_position = stateParent.worldPosition
		stateParent.currentTile = stateParent.nextTile
		#stateParent.currentTile.occupier = stateParent
		stateParent.currentTile.willBeOccupied = false
		stateParent.currentState = stateParent.idle
		TurnCompletion()
		#print(stateParent.name," -> Idle")
	
	#stateParent.nextTile = null

#FIRST STEP
#Verify next move
#Assign next tile to random result
#Assign enemy reference to next tile
#Set "will be occupied to true"
#NEXT STEP
#Move sprite
#Remove occupier reference from current tile
#Assign next tile to current tile
#Delete next tile reference

func movementVerification():
	stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x]
	while true:
		direction = random.randi_range(0, Direction.size() - 1)
		if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x].objectID == 0:
			if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x].occupier == null:
				if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x].willBeOccupied == false:
					stateParent.directionArrow.visible = true
					stateParent.target.visible = true
					stateParent.directionArrow.global_position = (stateParent.gridPosition + directionArray[direction]) * stateParent.stepSize + stateParent.spriteOffset
					stateParent.directionArrow.rotation_degrees = rotationArray[direction]
					#stateParent.target.global_position = (stateParent.gridPosition + directionArray[direction]) * stateParent.stepSize + stateParent.spriteOffset
					stateParent.nextTile = stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x]
					stateParent.nextTile.willBeOccupied = true
					#stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x]
					aiming(directionArray[direction])
					return false
		else:
			return true

func onUpdate():
	if Input.is_action_just_released("ui_up"):
		if !hasMoved:
			hasMoved = true
			movementExecution(directionArray[direction])
		else:
			hasMoved = movementVerification()
			TurnCompletion()
	if Input.is_action_just_released("ui_down"):
		if !hasMoved:
			hasMoved = true
			movementExecution(directionArray[direction])
		else:
			hasMoved = movementVerification()
			TurnCompletion()
	if Input.is_action_just_released("ui_left"):
		if !hasMoved:
			hasMoved = true
			movementExecution(directionArray[direction])
		else:
			hasMoved = movementVerification()
			TurnCompletion()
	if Input.is_action_just_released("ui_right"):
		if !hasMoved:
			hasMoved = true
			movementExecution(directionArray[direction])
		else:
			hasMoved = movementVerification()
			TurnCompletion()
	
	stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x]
	stateParent.currentTile.occupier = stateParent
		
func onExit():
	stateParent.currentState.onEnter()
