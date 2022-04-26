extends State

class_name Attack

func onEnter():
	stateParent = get_parent()

func onUpdate():
	if stateParent.id == Actor.Identity.ENEMY:
		stateParent.sfx.play()
		if stateParent.kind == 1:
			stateParent.attackTile.occupier.outburstTracker = 0
			print("The enemy caused Kefuri an emotional outburst!")
		elif stateParent.kind == 2:
			stateParent.attackTile.occupier.outburstTurns += stateParent.dungeonReference.level + stateParent.dungeonReference.level * .25
			stateParent.attackTile.occupier.missProbability = 35 + (stateParent.attackTile.occupier.sanityLevel*2)
			stateParent.attackTile.occupier.misbehaviorScale = 75 - (stateParent.attackTile.occupier.sanityLevel/2)
			stateParent.attackTile.occupier.effectTurns = 10
			print("The enemy will cause Kefuri's emotional outbursts to last longer and misbehave frequently!")
		stateParent.attackTile.occupier.healthPoints -= (stateParent.attackPoints - stateParent.attackTile.occupier.defensePoints)
		print("Player damage received :", stateParent.attackPoints)
		print("Player HP: ",stateParent.attackTile.occupier.healthPoints)
	elif stateParent.id == Actor.Identity.BODY:
		if stateParent.outburst.emotion != Emotion.Type.ANGRY or stateParent.outburst.emotion == Emotion.Type.ANGRY and stateParent.random.randi_range(1,100) > stateParent.missProbability:
			stateParent.sfx.play()
			stateParent.attackTile.occupier.healthPoints -= (stateParent.attackPoints)
			print(stateParent.attackTile.occupier.name," HP: ",stateParent.attackTile.occupier.healthPoints)
		else:
			if stateParent.random.randi_range(1,100) < stateParent.misbehaviorScale:
				print("Player failed its attack!")
			else:
				stateParent.healthPoints -= stateParent.attackPoints / 2
				print("Player attacked himself!")
				print("Player HP: ",stateParent.healthPoints)
	onExit()

func onExit():
	stateParent.currentState = stateParent.idle
	stateParent.currentState.onEnter()
