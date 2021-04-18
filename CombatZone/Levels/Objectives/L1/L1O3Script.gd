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
    #Activate timer for the beacon
    var current_scene = get_tree().get_current_scene()
    for node in current_scene.get_children():
        #Need to be sure we have the proper type before we check the IDs
        if (node.get_class() == "objective_beacon"):
            if node.objective_id == id:
                node._ActivateClock()
    pass # Replace with function body
    pass