extends State

class_name Outburst

var emotion : int
var sad : Emotion
var angry : Emotion
var scared : Emotion

func _init():
	name = "Outburst"
	emotion = Emotion.Type.NEUTER
	sad = Sad.new()
	angry = Angry.new()
	scared = Scared.new()
	add_child(sad)
	add_child(angry)
	add_child(scared)

func onEnter():
	stateParent = get_parent()
	if stateParent.outburstTracker == 0:
		stateParent.outburstLimit = Vector2(15+stateParent.sanityLevel, 20+stateParent.sanityLevel) 
		stateParent.outburstTracker = stateParent.random.randi_range(stateParent.outburstLimit.x, stateParent.outburstLimit.y)
		stateParent.outburstTurns += 6 + stateParent.sanityLevel
		if stateParent.isMisbehaved:
			stateParent.missProbability = 45 - (stateParent.sanityLevel*2)
			stateParent.misbehaviorScale = 75 + (stateParent.sanityLevel/2)
		else:
			stateParent.missProbability = 0
			stateParent.isMisbehaved = true
		emotion = stateParent.random.randi_range(1, Emotion.Type.size()-1)
	elif stateParent.outburstTurns == 0:
		emotion = Emotion.Type.NEUTER

func onUpdate():
	if emotion == Emotion.Type.NEUTER:
		stateParent.modulate = Color(255,255,255,1)
		stateParent.attackPoints = 2 + stateParent.sanityLevel
		print("Player returned to normal")
		onExit()
	elif emotion == Emotion.Type.SAD:
		sad.onUse()
		onExit()
	elif emotion == Emotion.Type.ANGRY:
		angry.onUse()
		onExit()
	elif emotion == Emotion.Type.SCARED:
		scared.onUse()
		onExit()
	
func onExit():
	stateParent.currentState = stateParent.idle
	stateParent.currentState.onEnter()
