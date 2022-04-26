extends Item

class_name Elixir

var inventory : Node2D
var price : int

func _init():
	id = Item.Type.ELIXIR
	price = 7
	name = "Elixir"

func onUse():
	inventory = get_parent()
	if inventory.inventoryParent.isMisbehaved:
		inventory.inventoryParent.isMisbehaved = false
		print("Player won't misbehave on his next emotional outburst.")
		return true
	else:
		print("Player is already controlled emotionally.")
		return false