extends Node2D

class_name Dungeon

var map : Array = []
var theme : int
var _width = 0
var _height = 0
var _player : Node2D
var roomThemes = ["room", "keep", "hall", "roof"] #This array has all the key words for the location sets
var floorType = ["A","B","C"] #This array contains the keys for floor tiles

export var widthRand : Vector2 = Vector2(0,0)
export var heightRand : Vector2 = Vector2(0,0)

onready var _random = RandomNumberGenerator.new()
onready var _tileMap : TileMap = $TileMap #Tilemap node (Renders tiles on the window)
onready var audio = $AudioStream
onready var _tileSet = _tileMap.tile_set #Tiles chosen to be used in the _tileMap
onready var tileSize = _tileMap.cell_size

enum Theme {ROOM, KEEP, HALL, ROOF}
enum MapCode {ACCESSIBLE, INACCESSIBLE, HOLE, WALL}

func _ready():
	print("Dungeon Ready")
	_player = $Player
	initialize()

func initialize():
	_random.randomize()
	_width = _random.randi_range(widthRand.x, widthRand.y)
	_height = _random.randi_range(heightRand.x, heightRand.y)
	theme = _random.randi_range(0,Theme.size()-1)
	build(theme)
	place(Vector2(1,_width-1), Vector2(1,_height-1), false, roomThemes[theme]+"_hole", MapCode.HOLE)
	place(Vector2(1,_width-1), Vector2(1,_height-1), true, "position", null)

func cellRenderer():
	for y in range(_height):
		for x in range(_width):
			_tileMap.set_cell(x, y, map[y][x].spriteID)

func build(theme):
	for y in range(_height):
		var mapColumn = []
		for x in range(_width):
			var spriteID = 0
			var objectID = 0
			var isWalkable = false
			var isObstacle = false
			#These ifs build the walls around the rooms
			if y == 0:
				if x == 0:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_nw")
				elif x == _width-1:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_ne")
				else:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_n")
			elif y == _height-1:
				if x == 0:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_sw")
				elif x == _width-1:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_se")
				else:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_s")
			else:
				if x == 0:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_w")
				elif x == _width-1:
					spriteID = _tileSet.find_tile_by_name(roomThemes[theme]+"_e")
				else: #If the current cell isn't a wall:
					var probability = _random.randi_range(0,9) #This probability range decides whether the cell will be walkable or not
					if probability > 1:
						probability = _random.randi_range(0,9) #This probability range decides whether the cell is blank or has a spriteID (Both walkable)
						if probability > 4:
							spriteID = _tileSet.find_tile_by_name(roomThemes[theme] + "_" + floorType[_random.randi_range(0,2)])
						else:
							spriteID = _tileSet.find_tile_by_name("floor")
							isWalkable = true
					else:
						spriteID = _tileSet.find_tile_by_name(roomThemes[theme] + "_" + str(_random.randi_range(0,2)))
						isObstacle = true
			if isWalkable: #Enumerator assignation for the objectMap
				objectID = MapCode.ACCESSIBLE
			elif isObstacle:
				objectID = MapCode.INACCESSIBLE
			else:
				objectID = MapCode.WALL
			mapColumn.append(Tile.new(spriteID, objectID))
		map.append(mapColumn)

func place(yRange : Vector2, xRange : Vector2, isPlayer : bool, tileToken : String, objectToken):
	var validPosition = false
	while !validPosition:
		var mapCoordinate = Vector2(_random.randi_range(yRange.x, yRange.y),_random.randi_range(xRange.x, xRange.y))
		if map[mapCoordinate.y][mapCoordinate.x].objectID == MapCode.ACCESSIBLE:
			validPosition = true
			map[mapCoordinate.y][mapCoordinate.x].spriteID = _tileSet.find_tile_by_name(tileToken)
			if isPlayer:
				map[mapCoordinate.y][mapCoordinate.x].updateOccupier(_player.body)
				print(_player.body.gridPosition)
				print(_player.body.worldPosition)
				_player.body.gridPosition = mapCoordinate
				_player.body.worldPosition = tileSize.x * mapCoordinate + _player.body.spriteOffset
				print(_player.body.gridPosition)
				print(_player.body.worldPosition)
				_player.body.stepSize = tileSize.x
				#characterPosition = mapCoordinate
				#worldCoordinate = tileSize.x * mapCoordinate #_tileMap.map_to_world(mapCoordinate)
				#emit_signal("finishedMapGeneration") #This signal is emitted since it means that everything has been placed
			else:
				map[mapCoordinate.y][mapCoordinate.x].objectID = objectToken

func _process(_delta):
	cellRenderer()
