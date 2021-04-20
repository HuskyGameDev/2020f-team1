extends "../base_custom_objective.gd"

func _OnReady():
    pass

func _OnPreCompletionProcess():
    pass
    
func _OnPostCompletionProcess():
    pass

func _PreFail():
    pass
    
func _PreCompletion():
    pass

func _OnRevealed():
    var count = 0
    while (count < self.get_child_count()):
        get_child(count).ai.accqu_player(Global.get_player())
        get_child(count).ai.last_known_location = Global.get_player().global_position
        get_child(count).speed = 600
        count = count + 1
    pass
