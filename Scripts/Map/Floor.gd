extends Tile

class_name Floor

var item : Sprite
var occupier : Sprite
var willBeOccupied : bool

func _init(eSpriteID : int, eObjectID : int):
    willBeOccupied = false
    occupier = null
    item = null
    spriteID = eSpriteID
    objectID = eObjectID