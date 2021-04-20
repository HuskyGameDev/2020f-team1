extends "../base_custom_beacon.gd"

#We set coordinates here for the player to teleport through.
export(Vector2) var TeleportCoordinates

#If this is true, this means the teleporter can only be used once. Once it's been used, it's gone forever.
export(bool) var OneTime

func _OnReady():
    pass

func _PreProcess():
    pass

func _PostProcess():
    pass

#Actually the cool secret thing.
func _RadiusEnteredPre():
    var ply = Global.get_player()
    
    #If the player is in a vehicle, disembark them first. This can cause the teleporter to act weird.
    if (ply.piloting == true):
        ply.disembark()
        
    #Simply set the position, the coordinates provided should suffice.
    ply.set_position(TeleportCoordinates)
    
    #If we're only allowed to use this once, remove this from the scene.
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
