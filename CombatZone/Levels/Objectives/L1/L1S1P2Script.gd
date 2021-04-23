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
    return true
    pass

func _OnRevealed():
    
    var count = 0
    #Every child here is an enemy to chase the player, we must loop through each of these
    #In order to set the targeted player, the last known location, and increase the speed for the fun effect.
    while (count < self.get_child_count()):
        get_child(count).ai.accqu_player(Global.get_player())
        get_child(count).ai.last_known_location = Global.get_player().global_position
        #It's fun guys i swear!
        get_child(count).speed = 600
        #Be sure to increment... why did I use a while loop?
        count = count + 1
    pass
