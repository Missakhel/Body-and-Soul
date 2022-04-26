extends Node2D

class_name Inventory

var potion : Item
var tonic : Item
var elixir : Item
var inventoryParent : Actor

func _init():
	potion = Potion.new()
	tonic = Tonic.new()
	elixir = Elixir.new()
	add_child(potion)
	add_child(tonic)
	add_child(elixir)

var items = {Item.Type.KEY:1, Item.Type.COIN:0, Item.Type.POTION:2, Item.Type.TONIC:2, Item.Type.ELIXIR:2}
