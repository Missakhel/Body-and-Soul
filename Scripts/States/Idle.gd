extends State

class_name Idle

func onEnter():
	print("Body -> Idle")
	parent = get_parent()

func movement():
	parent.currentState = parent.move
	parent.currentState.onEnter()
	onExit()

func onUpdate():
	if Input.is_action_just_pressed("ui_up"):
		movement()
	if Input.is_action_just_pressed("ui_down"):
		movement()
	if Input.is_action_just_pressed("ui_left"):
		movement()
	if Input.is_action_just_pressed("ui_right"):
		movement()

func onExit():
	pass
