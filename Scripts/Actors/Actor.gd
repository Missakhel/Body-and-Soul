extends Sprite

class_name Actor
var gridPosition : Vector2
var worldPosition : Vector2
var healthPoints : int
var attackPoints : int
var spriteIndex : int

func move(direction : Vector2, tileSize : int):
	gridPosition += direction
	worldPosition += direction * tileSize

func damaged(damage : int):
	healthPoints -= damage

func attack(victim : Actor):
	victim.damaged(attackPoints)