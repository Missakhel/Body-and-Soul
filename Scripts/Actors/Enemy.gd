extends Actor

class_name Enemy

var kind : int
var isPossessed : bool

enum Kind {ANGRY, SAD, DISGUSTED, SURPRISED, ANGRY, SCARED}

func onPossessionBegin():
    pass

func onPossessionEnd():
    pass