extends State

class_name Buy

func onEnter():
	stateParent = get_parent()
	stateParent.inventory.inventoryParent = get_parent()

func saleValidation(itemType : int, itemRef : Item):
	if stateParent.canBuy or stateParent.outburst.emotion == Emotion.Type.SCARED:
		if stateParent.inventory.items[Item.Type.COIN] >= itemRef.price:
			if stateParent.outburst.emotion != Emotion.Type.SCARED or stateParent.outburst.emotion == Emotion.Type.SCARED and stateParent.random.randi_range(1,100) > stateParent.missProbability:
				stateParent.inventory.items[Item.Type.COIN] -= itemRef.price
				stateParent.inventory.items[itemType] += 1
				print("Player bought a ", itemRef.name)
				print(stateParent.inventory.items)
				print("Coins: ", stateParent.inventory.items[Item.Type.COIN])
				stateParent.canBuy = false
			else:
				if stateParent.random.randi_range(1,100) < stateParent.misbehaviorScale:
					print("Player refused to buy a ", itemRef.name)
				else:
					stateParent.inventory.items[Item.Type.COIN] *= stateParent.random.randf_range(.75,.95)
					print("Player lost a percentage of coins!")
					print("Coins: ", stateParent.inventory.items[Item.Type.COIN])
		else:
			print("Player doesn't have enough money to buy a ", itemRef.name)
	else:
		print("You can only buy once per level!")
	onExit()

func onUpdate():
	if Input.is_action_just_released("ui_up"):
		saleValidation(Item.Type.POTION, stateParent.inventory.potion)
	if Input.is_action_just_released("ui_down"):
		onExit()
	if Input.is_action_just_released("ui_left"):
		saleValidation(Item.Type.TONIC, stateParent.inventory.tonic)
	if Input.is_action_just_released("ui_right"):
		saleValidation(Item.Type.ELIXIR, stateParent.inventory.elixir)
	
func onExit():
	stateParent.currentState = stateParent.idle
	stateParent.currentState.onEnter()
