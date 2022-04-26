extends Tile

class_name Hole

var isUnlocked : bool

func _init(eSpriteID : int, eObjectID : int):
    isUnlocked = false
    spriteID = eSpriteID
    objectID = eObjectID