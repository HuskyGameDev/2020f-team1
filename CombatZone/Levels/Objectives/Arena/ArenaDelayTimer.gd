extends "../base_custom_beacon.gd"

func _OnReady():
    pass

func _PreProcess():
    pass

func _PostProcess():
    pass

#Actually the cool secret thing.
func _RadiusEnteredPre():
    pass

#This is only called if the beacon is NOT an approach beacon.
func _RadiusEnteredPost():
    pass
    
#On destroy, we should notify our objective to decrement the counter.
func _PreDestroy():
    pass
    
func _PostDestroy():
    pass

func _PreTimerExpire():
    pass
    
func _PostTimerExpire():
    pass
