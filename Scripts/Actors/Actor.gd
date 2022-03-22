extends Sprite

class_name Actor
var gridPosition : Vector2
var worldPosition : Vector2
var healthPoints : int
var attackPoints : int

func _init():
	gridPosition = Vector2.ZERO
	worldPosition = Vector2.ZERO
	healthPoints = 0
	attackPoints = 0

func move(direction : Vector2, tileSize : int):
	gridPosition += direction
	worldPosition += direction * tileSize

func damaged(damage : int):
	healthPoints -= damage

func attack(victim : Actor):
	victim.damaged(attackPoints)

func onEnter():
	pass

func onUpdate():
	pass

func onExit():
	pass