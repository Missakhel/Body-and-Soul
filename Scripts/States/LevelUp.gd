extends State

class_name LevelUp

var upgradeLevel : int
var isLeveledUp : bool

func _init():
	upgradeLevel = 0

func levelUp(leveledUp : bool):
	stateParent.healthCap = 10 + stateParent.sanityLevel
	if leveledUp:
		stateParent.experience -= stateParent.experienceCap
		stateParent.experienceCap += stateParent.experienceCap * .15
		stateParent.sanityLevel += 1
	else:
		if stateParent.healthPoints > stateParent.healthCap:
			stateParent.healthPoints = stateParent.healthCap
	stateParent.attackPoints = 2 + stateParent.sanityLevel
	stateParent.defensePoints = 1 + (stateParent.sanityLevel/2)
	stateParent.missProbability = 35 - (stateParent.sanityLevel*2)
	stateParent.misbehaviorScale = 75 + (stateParent.sanityLevel/2)
	print("Player is now level ", stateParent.sanityLevel)

func upgrade():
	stateParent.polygon.color = Color(255,0,0,1)
	stateParent.healthCap = 10 + stateParent.sanityLevel
	stateParent.attackPoints = 2 + upgradeLevel
	stateParent.defensePoints = 1 + (upgradeLevel/2)
	stateParent.missProbability = 35 - (upgradeLevel*2)
	stateParent.misbehaviorScale = 75 + (upgradeLevel/2)
	print("Player momentarily upgraded to level ", upgradeLevel)

func onEnter():
	#Setting variables according to normal level up or tonic power up
	stateParent = get_parent()

func onUpdate():
	if upgradeLevel == 0:
		isLeveledUp = true
		if !stateParent.poweredUp and stateParent.experience > stateParent.experienceCap:
			levelUp(isLeveledUp)
		elif stateParent.poweredUp and stateParent.experience > stateParent.experienceCap:
			levelUp(isLeveledUp)
			upgrade()
		elif stateParent.poweredUp and stateParent.experience < stateParent.experienceCap:
			if stateParent.outburst.emotion == Emotion.Type.SCARED:
				upgradeLevel = stateParent.sanityLevel + 8
				stateParent.effectTurns = 15
			else:
				upgradeLevel = stateParent.sanityLevel + 5
				stateParent.effectTurns = 10
			upgrade()
		#stateParent.poweredUp = false
	else:
		isLeveledUp = false
		levelUp(isLeveledUp)
		upgradeLevel = 0
		stateParent.effectTurns = -1
		stateParent.poweredUp = false
		stateParent.polygon.color = Color(0,0,0,1)
		print("Player returned to level ", stateParent.sanityLevel)
	onExit()

func onExit():
	stateParent.currentState = stateParent.idle
	stateParent.currentState.onEnter()
