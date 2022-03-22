extends Node2D

class_name Tile

var objectID : int
var spriteID : int
var occupier : Actor

func updateOccupier(occupier : Actor):
    self.occupier = occupier

func _init(spriteID : int, objectID : int):
    self.spriteID = spriteID
    self.objectID = objectID