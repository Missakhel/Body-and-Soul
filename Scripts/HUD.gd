extends CanvasLayer


onready var startButton = $Button
onready var integrityMeter = $"Integrity Meter"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Character_updateIntegrity(integrity):
	integrityMeter.value = integrity