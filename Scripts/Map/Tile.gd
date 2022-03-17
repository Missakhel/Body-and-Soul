extends Node2D

class_name Tile

var isWalkable : bool
var sprite : int
var occupier : Actor
var style : int

enum Style {ACCESSIBLE, INACCESSIBLE, HOLE, WALL}

func updateOccupier(occupier : Actor):
    pass