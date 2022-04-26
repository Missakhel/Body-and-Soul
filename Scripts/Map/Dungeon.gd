extends Node2D

class_name Dungeon

var map : Array = []
var theme : int
var _width = 0
var _height = 0
var isKeyAssigned : bool
var _player : Node2D
var level : int
var roomThemes = ["room", "keep", "hall", "roof"] #This array has all the key words for the location sets
var floorType = ["A","B","C"] #This array contains the keys for floor tiles
var enemyResource = preload("res://Character/Enemy.tscn")
var coinResource = preload("res://Objects/Coin.tscn")
var potionResource = preload("res://Objects/Potion.tscn")
var tonicResource = preload("res://Objects/Tonic.tscn")
var elixirResource = preload("res://Objects/Elixir.tscn")
var keyResource = preload("res://Objects/Key.tscn")

export var widthRand : Vector2 = Vector2(0,0)
export var heightRand : Vector2 = Vector2(0,0)

onready var _random = RandomNumberGenerator.new()
onready var _tileMap : TileMap = $TileMap #Tilemap node (Renders tiles on the window)
onready var audio = $AudioStream
onready var tileSet = _tileMap.tile_set #Tiles chosen to be used in the _tileMap
onready var tileSize = _tileMap.cell_size

enum Theme {ROOM, KEEP, HALL, ROOF}
enum Entity {NONE, PLAYER, ENEMY}
enum MapCode {ACCESSIBLE, INACCESSIBLE, HOLE, WALL}

func _ready():
	print("Dungeon Ready")
	_player = $Player
	level = 0
	initialize()

func reset():
	for child in get_children():
		if child is Enemy:
			child.queue_free()
	_player.body.canBuy = true
	map.clear()
	_tileMap.clear()
	initialize()

func initialize():
	level += 1 #Current level counter
	isKeyAssigned = false
	_random.randomize()
	_width = _random.randi_range(widthRand.x+level, widthRand.y+level)
	_height = _random.randi_range(heightRand.x+level, heightRand.y+level)
	theme = _random.randi_range(0,Theme.size()-1)
	build(theme)
	place(Vector2(1,_width-1), Vector2(1,_height-1), Entity.NONE, roomThemes[theme]+"_hole", MapCode.HOLE)
	place(Vector2(1,_width-1), Vector2(1,_height-1), Entity.PLAYER, "position", null)
	for _i in range(0,_random.randf_range(_width, _height)):
	#for _i in range(0,_random.randf_range(1, 1)):
		place(Vector2(1,_width-1), Vector2(1,_height-1), Entity.ENEMY, null, null)

func cellRenderer():
	for y in range(_height):
		for x in range(_width):
			if map[y][x] is Hole and !map[y][x].isUnlocked:
				_tileMap.set_cell(x, y, tileSet.find_tile_by_name("locked_tile"))
			else:
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
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_nw")
				elif x == _width-1:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_ne")
				else:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_n")
			elif y == _height-1:
				if x == 0:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_sw")
				elif x == _width-1:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_se")
				else:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_s")
			else:
				if x == 0:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_w")
				elif x == _width-1:
					spriteID = tileSet.find_tile_by_name(roomThemes[theme]+"_e")
				else: #If the current cell isn't a wall:
					var probability = _random.randi_range(0,100) #This probability range decides whether the cell will be walkable or not
					if probability > 15:
						probability = _random.randi_range(0,100) #This probability range decides whether the cell is blank or has a spriteID (Both walkable)
						if probability > 40:
							spriteID = tileSet.find_tile_by_name(roomThemes[theme] + "_" + floorType[_random.randi_range(0,2)])
						else:
							spriteID = tileSet.find_tile_by_name("floor")
						isWalkable = true
					else:
						spriteID = tileSet.find_tile_by_name(roomThemes[theme] + "_" + str(_random.randi_range(0,2)))
						isObstacle = true
			if isWalkable: #Enumerator assignation for the objectMap
				objectID = MapCode.ACCESSIBLE
			elif isObstacle:
				objectID = MapCode.INACCESSIBLE
			else:
				objectID = MapCode.WALL
			mapColumn.append(Floor.new(spriteID, objectID))
		map.append(mapColumn)

func place(yRange : Vector2, xRange : Vector2, entity : int, tileToken, objectToken):
	var validPosition = false
	while !validPosition:
		var mapCoordinate = Vector2(_random.randi_range(yRange.x, yRange.y),_random.randi_range(xRange.x, xRange.y))
		if map[mapCoordinate.y][mapCoordinate.x].objectID == MapCode.ACCESSIBLE and map[mapCoordinate.y][mapCoordinate.x].occupier == null:
			validPosition = true
			if entity == Entity.PLAYER:
				map[mapCoordinate.y][mapCoordinate.x].spriteID = tileSet.find_tile_by_name(tileToken)
				_player.body.gridPosition = mapCoordinate
				_player.body.worldPosition = tileSize.x * mapCoordinate + _player.body.spriteOffset
				_player.body.stepSize = tileSize.x
				map[mapCoordinate.y][mapCoordinate.x].occupier = _player.body
				#characterPosition = mapCoordinate
				#worldCoordinate = tileSize.x * mapCoordinate #_tileMap.map_to_world(mapCoordinate)
			elif entity == Entity.ENEMY:
				var enemy = enemyResource.instance()
				var enemySelection = _random.randi_range(0,100)
				if enemySelection > 0 and enemySelection <= 70 - level * 2:
					enemy.kind = Enemy.Kind.A1
				elif enemySelection > 70 - level * 2 and enemySelection <= 90 - level / 2:
					enemy.kind = Enemy.Kind.A2
				elif enemySelection > 90 - level / 2 and enemySelection <= 100:
					enemy.kind = Enemy.Kind.A4
				add_child(enemy)
				enemy.gridPosition = mapCoordinate
				enemy.worldPosition = tileSize.x * mapCoordinate + enemy.spriteOffset
				enemy.currentTile = map[mapCoordinate.y][mapCoordinate.x]
				
				if !isKeyAssigned:
					enemy.item = keyResource.instance()
					#enemy.item.id = Item.Type.KEY
					isKeyAssigned = true
				else:
					var probability = _random.randi_range(0,9)
					if probability < 2:
						enemy.item = potionResource.instance()
						#enemy.item.id = Item.Type.TONIC
					elif probability >= 2 and probability < 3:
						enemy.item = tonicResource.instance()
						#enemy.item.id = Item.Type.POTION
					elif probability >= 3 and probability < 4:
						enemy.item = elixirResource.instance()
						#enemy.item.id = Item.Type.POTION
					else:
						enemy.item = coinResource.instance()
						enemy.item.value = enemy.coinAward
						#enemy.item.id = Item.Type.COIN
				add_child(enemy.item)
				enemy.item.visible = false
				
				map[mapCoordinate.y][mapCoordinate.x].occupier = enemy
			else:
				map[mapCoordinate.y][mapCoordinate.x] = Hole.new(tileSet.find_tile_by_name(tileToken), objectToken)

func _process(_delta):
	cellRenderer()
