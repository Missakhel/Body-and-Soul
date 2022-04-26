extends State

class_name Use

func onEnter():
	stateParent = get_parent()
	stateParent.inventory.inventoryParent = get_parent()

func usageValidation(itemType : int, itemRef : Item):
	if stateParent.inventory.items[itemType] > 0:
		if stateParent.outburst.emotion != Emotion.Type.SCARED or stateParent.outburst.emotion == Emotion.Type.SCARED and stateParent.random.randi_range(1,100) > stateParent.missProbability:
			#if itemType != Item.Type.TONIC or itemType == Item.Type.TONIC and stateParent.effectTurns == -1:
			if itemRef.onUse():
				print("Player used ", itemRef.name)
				stateParent.inventory.items[itemType] -= 1
				print(stateParent.inventory.items)
		else:
			if stateParent.random.randi_range(1,100) < stateParent.misbehaviorScale:
				print("Player refused to use ", itemRef.name)
			else:
				stateParent.inventory.items[itemType] -= 1
				print("Player wasted a ", itemRef.name)
	else:
		print("Player doesn't have even a single ",itemRef.name)
	onExit()

func onUpdate():
	if Input.is_action_just_released("ui_up"):
		usageValidation(Item.Type.POTION, stateParent.inventory.potion)
	if Input.is_action_just_released("ui_down"):
		onExit()
	if Input.is_action_just_released("ui_left"):
		usageValidation(Item.Type.TONIC, stateParent.inventory.tonic)
	if Input.is_action_just_released("ui_right"):
		usageValidation(Item.Type.ELIXIR, stateParent.inventory.elixir)
	
func onExit():
	stateParent.currentState = stateParent.idle
	stateParent.currentState.onEnter()
