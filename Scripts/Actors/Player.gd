extends Node2D

class_name Player
onready var bodyResource = preload("res://Scripts/Actors/Body.gd")
onready var soulResource = preload("res://Scripts/Actors/Soul.gd")
onready var inventoryResource = preload("res://Scripts/Inventory.gd")

onready var inventory : Inventory
onready var body : Actor
onready var soul : Actor

var soulModeOn : bool
var currentMode : Actor
var currentState : State
var lastState : State

func _ready():
    inventory = inventoryResource.Inventory.new()
    body = bodyResource.Body.new()
    soul = bodyResource.Soul.new()

func _process(delta):
    currentState.onUpdate()

func changeMode():
    if soulModeOn:
        soulModeOn = false
    else:
        soulModeOn = true