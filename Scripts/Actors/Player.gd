extends Node2D

class_name Player
onready var body : Sprite
onready var soul : Sprite

var dungeon : Node2D
var soulModeOn : bool
var currentMode : Sprite
var currentState : State
var lastState : State

var soulResource = load("res://Character/Soul.tscn")
var bodyResource = load("res://Character/Body.tscn")

func _ready():
	print("Dungeon -> Player")
	dungeon = get_parent()
	soul = soulResource.instance()
	add_child(body)
	body = bodyResource.instance()
	add_child(soul)
	currentMode = body
	currentMode.onEnter()

func _process(_delta):
	currentMode.onUpdate()

func changeMode():
	currentMode.onExit()
	if soulModeOn:
		soulModeOn = false
		currentMode = body
	else:
		soulModeOn = true
		currentMode = soul
	currentMode.onEnter()
