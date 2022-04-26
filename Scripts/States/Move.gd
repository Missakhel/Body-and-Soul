extends State

class_name Move

var directionArray = [Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1,0), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1), Vector2(1,1)]
enum Direction {B_UP, B_DOWN, B_LEFT, B_RIGHT,S_UP, S_DOWN, S_LEFT, S_RIGHT}

func _init():
	name = "Move"

func onEnter():
	stateParent = get_parent()
	#print(stateParent.name," -> Move")

#This function updates the effects of the player each turn.
func turnUpdate():
	if stateParent.outburst.emotion == Emotion.Type.NEUTER:
		stateParent.outburstTracker -= 1
	else:
		stateParent.outburstTurns -= 1

	if stateParent.effectTurns > 0:
		stateParent.effectTurns -= 1

#This function makes the player move to a random position within the the direction array
func randomMovement():
	while true:
		var direction : int = stateParent.random.randi_range(0, Direction.size() - 1)
		if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x].objectID == 0:
			if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x].occupier == null:
				stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[direction].y][stateParent.gridPosition.x + directionArray[direction].x]
				return direction

func movementExecution(index : int):
	stateParent.gridPosition += directionArray[index]
	stateParent.worldPosition = stateParent.gridPosition * stateParent.stepSize + stateParent.spriteOffset
	stateParent.global_position = stateParent.worldPosition
	if stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x].objectID != 2:
		stateParent.currentTile.occupier = null
		stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x]
	else:
		stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x]

func TurnCompletion():
	stateParent.currentState = stateParent.idle
	#print(stateParent.name," -> Idle")
	onExit()

#Each time this function is invoked, a turn passes.
func movementVerification(index : int):
	if stateParent.id == Actor.Identity.BODY:
		#If next the next tile is walkable
		if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].objectID == 0:
			#This condition must be passed to move into a new tile
			if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].occupier == null:
				if stateParent.outburst.emotion != Emotion.Type.SAD or stateParent.outburst.emotion == Emotion.Type.SAD and stateParent.random.randi_range(1,100) > stateParent.missProbability:
					movementExecution(index)
				else:
					if stateParent.random.randi_range(1,100) < stateParent.misbehaviorScale:
						print("Player refused to move!")
					else:
						print("Player moved to another tile!")
						movementExecution(randomMovement())
				TurnCompletion()
			#Else there's an enemy and it should move to the attack state
			elif stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].occupier.id == Actor.Identity.ENEMY:
				if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].occupier.move.hasMoved:
					stateParent.attackTile = stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x]
					stateParent.currentState = stateParent.attack
					print(stateParent.name," -> attacked ", stateParent.attackTile.occupier.name)
					onExit()
				else: #If there's an enemy but it will move, then move to the enemy's tile.
					movementExecution(index)
					TurnCompletion()
		#If next tile is the level exit, then move to that tile if it is unlocked.
		elif stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].objectID == 2:
			if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].isUnlocked:
				movementExecution(index)
				stateParent.currentState = stateParent.fall
				print(stateParent.name," -> Fall")
				onExit()
			else: 
				if stateParent.inventory.items[Item.Type.KEY]>0:
					print("Next level unlocked!")
					stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].isUnlocked = true
					stateParent.inventory.items[Item.Type.KEY] -= 1
					TurnCompletion()
		else: #Else, do nothing and return to the idle state. Turn wasted.
			TurnCompletion()
		turnUpdate()
	else:
		#This part is only executed when playing as the soul
		if stateParent.dungeonReference.map[stateParent.gridPosition.y + directionArray[index].y][stateParent.gridPosition.x + directionArray[index].x].objectID != 3:
			movementExecution(directionArray[index])
			stateParent.canMerge = true
			TurnCompletion()

func onUpdate():
	if Input.is_action_just_released("ui_up"):
		if stateParent.id == Actor.Identity.BODY:
			movementVerification(Direction.B_UP)
		elif stateParent.id == Actor.Identity.SOUL:
			movementVerification(Direction.S_UP)
	if Input.is_action_just_released("ui_down"):
		if stateParent.id == Actor.Identity.BODY:
			movementVerification(Direction.B_DOWN)
		elif stateParent.id == Actor.Identity.SOUL:
			movementVerification(Direction.S_UP)
	if Input.is_action_just_released("ui_left"):
		if stateParent.id == Actor.Identity.BODY:
			movementVerification(Direction.B_LEFT)
		elif stateParent.id == Actor.Identity.SOUL:
			movementVerification(Direction.S_UP)
	if Input.is_action_just_released("ui_right"):
		if stateParent.id == Actor.Identity.BODY:
			movementVerification(Direction.B_RIGHT)
		elif stateParent.id == Actor.Identity.SOUL:
			movementVerification(Direction.S_UP)

	stateParent.currentTile = stateParent.dungeonReference.map[stateParent.gridPosition.y][stateParent.gridPosition.x]
	if (stateParent.currentTile.objectID != 2): #If the current tile isn't the hole (The hole can't have an occupier)
		stateParent.currentTile.occupier = stateParent #Set current tile occupier to the player

	#If current tile has an object, pick it
	if stateParent.currentTile.objectID != 2 and stateParent.currentTile.item != null:
		if stateParent.currentTile.item.id != Item.Type.COIN:
			stateParent.inventory.items[stateParent.currentTile.item.id] += 1
		else:
			print("Kefuri obtained ", stateParent.currentTile.item.value, " coin(s)")
			stateParent.inventory.items[stateParent.currentTile.item.id] += stateParent.currentTile.item.value
		stateParent.currentTile.item.queue_free()
		stateParent.currentTile.item = null
		print(stateParent.inventory.items)
		
func onExit():
	stateParent.currentState.onEnter()
