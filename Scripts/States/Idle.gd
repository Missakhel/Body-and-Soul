extends State

class_name Idle

func _init():
	name = "Idle"

func onEnter():
	stateParent = get_parent()
	#print(stateParent.name, " -> Idle")

func movement():
	stateParent.currentState = stateParent.move
	onExit()

func switchMode():
	print("Switched mode")
	if stateParent.actorParent.currentMode == stateParent.actorParent.body:
		stateParent.actorParent.currentMode = stateParent.actorParent.soul
		for child in stateParent.actorParent.get_children():
			child.rotation_degrees = 45
		stateParent.actorParent.currentMode.onEnter()
	elif stateParent.actorParent.body.gridPosition == stateParent.gridPosition and stateParent.canMerge:
		#stateParent.actorParent.currentMode.onExit()
		stateParent.actorParent.currentMode = stateParent.actorParent.body
		stateParent.actorParent.currentMode.rotation_degrees = 0
		#for child in stateParent.actorParent.get_children():
		#	child.rotation_degrees = -45
		stateParent.actorParent.currentMode.onEnter()

func onUpdate():
	if stateParent.healthPoints <= 0:
		stateParent.currentState = stateParent.death
		onExit()

	if stateParent.id == Actor.Identity.BODY:
		if stateParent.outburstTracker == 0 or stateParent.outburstTurns == 0 and stateParent.outburst.emotion != Emotion.Type.NEUTER:
			stateParent.currentState = stateParent.outburst
			onExit()

		if stateParent.poweredUp and stateParent.effectTurns == -1 or stateParent.experience > stateParent.experienceCap or stateParent.effectTurns == 0:
			stateParent.currentState = stateParent.levelUp
			onExit()

	if Input.is_action_just_pressed("ui_up"):
		movement()
	if Input.is_action_just_pressed("ui_down"):
		movement()
	if Input.is_action_just_pressed("ui_left"):
		movement()
	if Input.is_action_just_pressed("ui_right"):
		movement()
	if stateParent.id == Actor.Identity.BODY:
		if Input.is_action_just_pressed("use"):
			stateParent.currentState = stateParent.use
			onExit()
		if Input.is_action_just_pressed("buy"):
			stateParent.currentState = stateParent.buy
			onExit()
	if stateParent.id == Actor.Identity.BODY or stateParent.id == Actor.Identity.SOUL: 
		if Input.is_action_just_pressed("soul_mode"):
				switchMode()
		if Input.is_action_just_released("reset"):
			stateParent.dungeonReference.level -= 1
			stateParent.dungeonReference.reset()
			print("Reseted dungeon")
			#pass

func onExit():
	stateParent.currentState.onEnter()
