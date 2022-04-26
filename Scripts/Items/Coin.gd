extends Item

class_name Coin

var value : int

func _init():
	name = "Coin"
	id = Item.Type.COIN

func _ready():
	if value > 1:
		frame = 233
	else:
		frame = 185