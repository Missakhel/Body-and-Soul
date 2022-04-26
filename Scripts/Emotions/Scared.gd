extends Emotion

class_name Scared

var outburst : Node2D

func _init():
	id = Emotion.Type.SCARED

func onUse():
	outburst = get_parent()
	outburst.stateParent.modulate = Color(125,255,0,1)
	print("Player is scared")
