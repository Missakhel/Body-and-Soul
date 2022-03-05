extends Node2D
class_name GameWorld

onready var _tileMap : TileMap = $TileMap
onready var _random = RandomNumberGenerator.new()
onready var _tileSet = _tileMap.tile_set
onready var tileSize = _tileMap.cell_size
onready var character = $Character

var objectMap = []
var textureMap = []
var roomSets = ["room", "keep", "hall", "roof"]
var floorSets = ["A","B","C"]
var worldCoordinate : Vector2 = Vector2.ZERO
var characterPosition : Vector2 = Vector2.ZERO

enum MapCode{ACCESSIBLE, INACCESSIBLE, HOLE, WALL}

export var widthRand : Vector2 = Vector2(0,0)
export var heightRand : Vector2 = Vector2(0,0)
var _width = 0
var _height = 0

signal finishedMapGeneration

func mapGenerator(roomKey : int):
	for y in range(_height):
		var objectColumn = []
		var tileColumn = []
		for x in range(_width):
			var tile = 0
			var isWalkable = false
			var isObstacle = false
			if y == 0:
				if x == 0:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_nw")
				elif x == _width-1:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_ne")
				else:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_n")
			elif y == _height-1:
				if x == 0:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_sw")
				elif x == _width-1:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_se")
				else:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_s")
			else:
				if x == 0:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_w")
				elif x == _width-1:
					tile = _tileSet.find_tile_by_name(roomSets[roomKey]+"_e")
				else:
					var probability = _random.randi_range(0,9)
					if probability > 1:
						probability = _random.randi_range(0,9)
						if probability > 4:
							tile = _tileSet.find_tile_by_name(roomSets[roomKey] + "_" + floorSets[_random.randi_range(0,2)])
						else:
							tile = _tileSet.find_tile_by_name("floor")
						isWalkable = true
					else:
						tile = _tileSet.find_tile_by_name(roomSets[roomKey] + "_" + str(_random.randi_range(0,2)))
						isObstacle = true
			if isWalkable:
				objectColumn.append(MapCode.ACCESSIBLE)
			elif isObstacle:
				objectColumn.append(MapCode.INACCESSIBLE)
			else:
				objectColumn.append(MapCode.WALL)
			tileColumn.append(tile)
		textureMap.append(tileColumn)
		objectMap.append(objectColumn)

func cellSetter():
	for y in range(_height):
		for x in range(_width):
			_tileMap.set_cell(x, y, textureMap[y][x])

func setPosition(yRange : Vector2, xRange : Vector2, unitConversion : bool, tileToken : String, objectToken):
	var validPosition = false
	while !validPosition:
		var mapCoordinate = Vector2(_random.randi_range(yRange.x, yRange.y),_random.randi_range(xRange.x, xRange.y))
		if objectMap[mapCoordinate.y][mapCoordinate.x] == MapCode.ACCESSIBLE:
			validPosition = true
			textureMap[mapCoordinate.y][mapCoordinate.x] = _tileSet.find_tile_by_name(tileToken)
			if unitConversion:
				characterPosition = mapCoordinate
				worldCoordinate = tileSize.x * mapCoordinate #_tileMap.map_to_world(mapCoordinate)
				emit_signal("finishedMapGeneration")
			else:
				objectMap[mapCoordinate.y][mapCoordinate.x] = objectToken

func initialize():
	_random.randomize()
	_width = _random.randi_range(widthRand.x, widthRand.y)
	_height = _random.randi_range(heightRand.x, heightRand.y)
	var roomKey : int = _random.randi_range(0,3)
	mapGenerator(roomKey)
	setPosition(Vector2(1,_width-1), Vector2(1,_height-1), false, roomSets[roomKey]+"_hole", MapCode.HOLE)
	setPosition(Vector2(1,_width-1), Vector2(1,_height-1), true, "position", null)
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()

func _process(_delta):
	cellSetter()

func _on_Sprite_moved():
	if character.soulModeON:
		#worldCoordinate = _tileMap.map_to_world(character.soulPosition - character.characterPosition)
		worldCoordinate = tileSize.x * character.soulPosition - tileSize.x * character.characterPosition
	else:
		#worldCoordinate = _tileMap.map_to_world(character.characterPosition)
		worldCoordinate = tileSize.x * character.characterPosition

func _on_Character_enteredHole():
	objectMap.clear()
	textureMap.clear()
	_tileMap.clear()
	worldCoordinate = Vector2.ZERO
	characterPosition = Vector2.ZERO
	initialize()
