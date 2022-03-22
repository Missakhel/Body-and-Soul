extends Node2D

class_name Player
onready var body : Actor
onready var soul : Actor

var soulModeOn : bool
var currentMode : Actor
var currentState : State
var lastState : State

func _init():
	body = Body.new()
	soul = Soul.new()
	add_child(body)
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
