extends Node2D
class_name GameWorld

#Child node instancing
onready var _tileMap : TileMap = $TileMap #Tilemap node (Renders tiles on the window)
onready var _random = RandomNumberGenerator.new()
onready var _tileSet = _tileMap.tile_set #Tiles chosen to be used in the _tileMap
onready var tileSize = _tileMap.cell_size
onready var character = $Character

#Arrays and Keywords:
#Room sprite placement is made through string concateneation
var objectMap = [] #This array contains collision and other object information
var textureMap = [] #This array contains the tiles that will be rendered by the engine
var roomSets = ["room", "keep", "hall", "roof"] #This array has all the key words for the location sets
var floorSets = ["A","B","C"] #This array contains the keys for floor tiles
var worldCoordinate : Vector2 = Vector2.ZERO #Character position relative to the world (screen)
var characterPosition : Vector2 = Vector2.ZERO #Character position relative to the grid

enum MapCode{ACCESSIBLE, INACCESSIBLE, HOLE, WALL} #Enumerating the key values for the objectMap

#Room generation is made by randomly choosing two values within the x and y values each vector
export var widthRand : Vector2 = Vector2(0,0)
export var heightRand : Vector2 = Vector2(0,0)
#These variables show the size of the current room
var _width = 0
var _height = 0

signal finishedMapGeneration

#This function defines the collisions and tiles of the map
#[roomKey] indicates the theme of the room
func mapGenerator(roomKey : int):
	for y in range(_height):
		var objectColumn = []
		var tileColumn = []
		for x in range(_width):
			var tile = 0
			var isWalkable = false
			var isObstacle = false
			#These ifs build the walls around the rooms
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
				else: #If the current cell isn't a wall:
					var probability = _random.randi_range(0,9) #This probability range decides whether the cell will be walkable or not
					if probability > 1:
						probability = _random.randi_range(0,9) #This probability range decides whether the cell is blank or has a tile (Both walkable)
						if probability > 4:
							tile = _tileSet.find_tile_by_name(roomSets[roomKey] + "_" + floorSets[_random.randi_range(0,2)])
						else:
							tile = _tileSet.find_tile_by_name("floor")
						isWalkable = true
					else:
						tile = _tileSet.find_tile_by_name(roomSets[roomKey] + "_" + str(_random.randi_range(0,2)))
						isObstacle = true
			if isWalkable: #Enumerator assignation for the objectMap
				objectColumn.append(MapCode.ACCESSIBLE)
			elif isObstacle:
				objectColumn.append(MapCode.INACCESSIBLE)
			else:
				objectColumn.append(MapCode.WALL)
			tileColumn.append(tile)
		textureMap.append(tileColumn)
		objectMap.append(objectColumn)

#This function renders each cell in the grid
func cellSetter():
	for y in range(_height):
		for x in range(_width):
			_tileMap.set_cell(x, y, textureMap[y][x])

#This function selects a random cell within the grid, if it is walkable, sets the [token] in that position
#[xRange] and [yRange] set the boundaries of the random tile selection
#[unitConversion] updates the character position within the grid and the world. It is only used for character placement when a new room is generated
#[tileToken] is the tile name to be placed in the selected position
#[objectToken] is the tile collision value according to the MapCode enumerator
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
				emit_signal("finishedMapGeneration") #This signal is emitted since it means that everything has been placed
			else:
				objectMap[mapCoordinate.y][mapCoordinate.x] = objectToken

#This function rebuilds a new room once the player enters a "hole"
func initialize():
	_random.randomize()
	_width = _random.randi_range(widthRand.x, widthRand.y)
	_height = _random.randi_range(heightRand.x, heightRand.y)
	var roomKey : int = _random.randi_range(0,3)
	mapGenerator(roomKey)
	setPosition(Vector2(1,_width-1), Vector2(1,_height-1), false, roomSets[roomKey]+"_hole", MapCode.HOLE)
	setPosition(Vector2(1,_width-1), Vector2(1,_height-1), true, "position", null)

func _ready():
	initialize()

#The tileMap gets refreshed each frame
func _process(_delta):
	cellSetter()

#From EMPEROR.GD
#This signal function updates the character position relative to the world
func _on_Sprite_moved():
	if character.soulModeON:
		#worldCoordinate = _tileMap.map_to_world(character.soulPosition - character.characterPosition)
		worldCoordinate = tileSize.x * character.soulPosition - tileSize.x * character.characterPosition
	else:
		#worldCoordinate = _tileMap.map_to_world(character.characterPosition)
		worldCoordinate = tileSize.x * character.characterPosition

#From EMPEROR.GD
#This signal function is accessed when the player position is the same as the hole position
#The character and matrix values for tiles and collisions are cleared here to be reinitialized again
func _on_Character_enteredHole():
	objectMap.clear()
	textureMap.clear()
	_tileMap.clear()
	worldCoordinate = Vector2.ZERO
	characterPosition = Vector2.ZERO
	initialize()