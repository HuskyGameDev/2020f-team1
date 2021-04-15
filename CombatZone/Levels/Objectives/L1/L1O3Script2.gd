extends "../base_custom_beacon.gd"

func _OnReady():
    pass

func _PreProcess():
    pass

func _PostProcess():
    pass

func _RadiusEnteredPre():
    pass

func _RadiusEnteredPost():
    pass
    
func _PreDestroy():
    pass
    
func _PostDestroy():
    pass

func _PreTimerExpire():
    pass
    
func _PostTimerExpire():
    #TODO: Fancier shit
    Global.get_player().die()
    pass
