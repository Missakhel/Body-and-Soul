extends Sprite

class_name Actor

enum Identity {BODY, SOUL, ENEMY}

var gridPosition : Vector2
var worldPosition : Vector2
var spriteOffset : Vector2
var healthPoints : int
var attackPoints : int
var defensePoints : int
var stepSize : int  #Tile size for world positioning
var lastState : State
var currentState : State
var currentTile : Node2D
var dungeonReference : Node2D
var actorParent : Node2D
var backColor : Polygon2D
var id : int

func _init():
	pass

#func move(direction : Vector2, tileSize : int):
#	gridPosition += direction
#	worldPosition += direction * tileSize

func damaged(damage : int):
	healthPoints -= damage

#func onEnter():
#	pass

#func onUpdate():
#	pass
#
#func onExit():
#	pass
