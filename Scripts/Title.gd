extends Sprite

onready var audio = $AudioStream

signal closed

# Called when the node enters the scene tree for the first time.
func _ready():
	audio.play()
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		audio.stop()
		hide()
		emit_signal("closed")
