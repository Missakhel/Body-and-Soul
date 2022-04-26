extends Item

class_name Potion

var inventory : Node2D
var price : int

func _init():
	name = "Potion"
	price = 5
	id = Item.Type.POTION

func cure(healthCured : int):
	if inventory.inventoryParent.healthPoints + healthCured <= inventory.inventoryParent.healthCap:
		inventory.inventoryParent.healthPoints += healthCured
	else:
		inventory.inventoryParent.healthPoints = inventory.inventoryParent.healthCap		
	print("Player HP: ", inventory.inventoryParent.healthPoints)

func onUse():
	inventory = get_parent()
	if inventory.inventoryParent.outburst.emotion == Emotion.Type.SCARED:
		cure(5)
	else:
		cure(3)
	return true