extends Emotion

class_name Angry

var outburst : Node2D

func _init():
	id = Emotion.Type.ANGRY

func onUse():
	outburst = get_parent()
	outburst.stateParent.modulate = Color(255,0,125,1)
	outburst.stateParent.attackPoints = 2 + (outburst.stateParent.sanityLevel * (2 - outburst.stateParent.sanityLevel / 100 ))
	print("Player is angry")