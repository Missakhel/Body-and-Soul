extends State

class_name Move

func onEnter():
    print("Body -> Move")
    parent = get_parent()

func movementUpdate(movementVector : Vector2):
    parent.gridPosition += movementVector
    parent.worldPosition = parent.gridPosition * parent.stepSize
    parent.global_position = parent.worldPosition

    #print(parent.gridPosition)
    #print(parent.worldPosition)
    #print(parent.global_transform.origin)
    onExit()

func onUpdate():
    if Input.is_action_just_released("ui_up"):
        movementUpdate(Vector2(0,-1))
    if Input.is_action_just_released("ui_down"):
        movementUpdate(Vector2(0,1))
    if Input.is_action_just_released("ui_left"):
        movementUpdate(Vector2(-1,0))
    if Input.is_action_just_released("ui_right"):
        movementUpdate(Vector2(1,0))
        
func onExit():
    print("idling again")
    parent.currentState = parent.idle
    parent.currentState.onEnter()