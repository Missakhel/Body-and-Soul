extends Emotion

class_name Sad

var outburst : Node2D

func _init():
	id = Emotion.Type.SAD

func onUse():
	outburst = get_parent()
	outburst.stateParent.modulate = Color(0,125,255,1)
	outburst.stateParent.defensePoints = 1 + (outburst.stateParent.sanityLevel * (1 - outburst.stateParent.sanityLevel / 100 ))
	print("Player is sad")