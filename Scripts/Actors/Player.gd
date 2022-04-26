extends Node2D

class_name Player
onready var body : Sprite
onready var soul : Sprite

var delta : float
var soulModeOn : bool
var currentMode : Sprite
var currentState : State
var lastState : State

var soulResource = load("res://Character/Soul.tscn")
var bodyResource = load("res://Character/Body.tscn")

func _ready():
	print("Dungeon -> Player")
	body = bodyResource.instance()
	add_child(body)
	soul = soulResource.instance()
	add_child(soul)
	currentMode = body
	currentMode.onEnter()

func _process(_delta):
	#delta = _delta
	currentMode.onUpdate()