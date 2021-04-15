extends "../base_custom_objective.gd"

export(PackedScene) var PreActivateTilemap

func _OnReady():
    PreActivateTilemap = get_child(0)
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
    #Show/create the associated enemies + beacons
    if PreActivateTilemap != null:
        PreActivateTilemap.clear()
    pass
