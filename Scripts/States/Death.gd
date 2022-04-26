extends State

class_name Death

func onEnter():
	stateParent = get_parent()

func onUpdate():
	if stateParent.id == Actor.Identity.ENEMY:
		stateParent.currentTile.item = stateParent.item
		stateParent.currentTile.item.global_position = stateParent.global_position
		stateParent.currentTile.item.visible = true
		stateParent.currentTile.occupier = null
		print("Player obtained ", stateParent.expAward, " experience points")
		get_node("/root/Scene/Player/Body").experience += stateParent.expAward
		print("XP: ", get_node("/root/Scene/Player/Body").experience)
		onExit()
	elif stateParent.id == Actor.Identity.BODY:
		print(stateParent.name," is dead")
		get_tree().reload_current_scene()

func onExit():
	if stateParent.id == Actor.Identity.ENEMY:
		stateParent.queue_free()

