extends Node2D

class_name Tile

var objectID : int
var spriteID : int
var occupier : Sprite

func updateOccupier(eOccupier : Sprite):
    occupier = eOccupier

func _init(eSpriteID : int, eObjectID : int):
    spriteID = eSpriteID
    objectID = eObjectID