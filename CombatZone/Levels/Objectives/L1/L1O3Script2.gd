extends "../base_custom_beacon.gd"

func _OnReady():
    pass

func _PreProcess():
    pass

func _PostProcess():
    pass

func _RadiusEnteredPre():
    get_tree().change_scene("res://Assets/Dialogue/Dialogue Levels/CityScape_End.tscn")
    pass

func _RadiusEnteredPost():
    pass
    
func _PreDestroy():
    pass
    
func _PostDestroy():
    pass

func _PreTimerExpire():
    pass
    
#Should we even explain? If the timer expires, the missiles go off, and you die!
func _PostTimerExpire():
    #TODO: Fancier shit
    Global.get_player().die()
    pass
