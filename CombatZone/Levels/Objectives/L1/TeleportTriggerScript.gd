extends "../base_custom_beacon.gd"

export(Vector2) var TeleportCoordinates
export(bool) var OneTime

var wasUsed = false

func _OnReady():
    pass

func _PreProcess():
    pass

func _PostProcess():
    pass

#Actually the cool secret thing.
func _RadiusEnteredPre():
    var ply = Global.get_player()
    if (ply.piloting == true):
        ply.disembark()
        
    ply.set_position(TeleportCoordinates)
    if OneTime:
        queue_free()
    pass

#This is only called if the beacon is NOT an approach beacon.
func _RadiusEnteredPost():
    pass
    
func _PreDestroy():
    pass
    
func _PostDestroy():
    pass

func _PreTimerExpire():
    pass
    
func _PostTimerExpire():
    pass
