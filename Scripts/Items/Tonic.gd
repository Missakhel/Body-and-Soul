extends Item

class_name Tonic

var inventory : Node2D
var price : int

func _init():
	id = Item.Type.TONIC
	price = 10
	name = "Tonic"

func onUse():
	inventory = get_parent()
	if !inventory.inventoryParent.poweredUp and inventory.inventoryParent.effectTurns == -1:
		inventory.inventoryParent.poweredUp = true
		print("Player powered up!")
		return true
	else:
		print("Player is unable to use tonic right now.")
		return false