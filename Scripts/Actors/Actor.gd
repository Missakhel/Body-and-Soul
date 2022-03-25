extends Sprite

class_name Actor
var gridPosition : Vector2
var worldPosition : Vector2
var healthPoints : int
var attackPoints : int
var stepSize : int  #Tile size for world positioning
var lastState : State
var currentState : State

func _init():
	pass

#func move(direction : Vector2, tileSize : int):
#	gridPosition += direction
#	worldPosition += direction * tileSize

func damaged(damage : int):
	healthPoints -= damage

func attack(victim : Actor):
	victim.damaged(attackPoints)

#func onEnter():
#	pass

#func onUpdate():
#	pass
#
#func onExit():
#	pass
