extends Node

#Do we need the beacon to be destroyed? Protected? Collected? This defines how we clear the beacon.
enum BEACON_TYPE {
    TYPE_NULL = -1,
    BEACON_DESTROY, # = 0
    BEACON_SECURE, # = 1
    BEACON_APPROACH # = 2 Renamed to 'Approach' since destroy can be used for collecting items
                    #Also: We need objectives that disappear once the player enters the radius.
   }

export var objective_id:String #This is what connects the beacon to the objective.

export var is_timed:bool #If it's timed, simply check this.

export var timer_length:float #The length of the timer, only applied if the beacon is a timed one.

export var timer_start_on_spawn:bool #Simply put, do we want the timer to start when the map starts? Or do we want the player to be within a radius
                                  #If this is false, we depend on the objective radius to collide with the player to start the timer.

export var objective_radius:float ###The distance away from the beacon needed in order for a timed beacon to start a timer.

export(BEACON_TYPE) var beacon_type = BEACON_TYPE.TYPE_NULL #The type of action required to remove this beacon. Refer to BEACON_TYPE for what each number stands for.

var timer_active := false #Self explanatory, there is only need for one timer and it really shouldn't be an object.
                          #A simple check for activity should suffice better than a timer object.

#var marked_for_destroy := false #Useless because this would not work with how we destroy a beacon, just comment it out.

var timer = 0 #Declaring it here, but we may or may not use it depending on whether it's a time objective or not.

# Called when the node enters the scene tree for the first time.
func _ready():
    #
    if is_timed == true && timer_start_on_spawn == true:
        timer_active = true
    else:
        timer_active = false
    #Thanks to the post on the godot forums, I was able to allow dynamic scaling of the shape at runtime
    ### https://godotengine.org/qa/16283/how-to-resize-a-collisionshape2d-in-game
    #At least, if it worked.
    #TODO: FIND A WAY TO ALLOW FOR DYNAMIC SCALING AT RUNTIME!
    #var shape = $obj_radius.Get_shape()
    #var oldScale = shape.getExtents()
    #shape.setExtents(Vector2((objective_radius*oldScale.x), (objective_radius*oldScale.y)))
    pass # Replace with function body.

func _process(delta):
    #Obviously we tick up the timer here, incrementing by in game time at its given speed.
    if timer_active == true:
        timer += delta
        if (timer > timer_length):
            _OnTimerExpire()
    pass

func _OnTimerExpire():
    #Only two outcomes if a timer expires, we pass or we fail. 
    if beacon_type == BEACON_TYPE.BEACON_SECURE:
        _OnBeaconDestroy(false) #If this was a secure job, we did our job and can complete the mission!
    else:
        _OnBeaconDestroy(true)
    pass

#Called whenever we want to manually destroy the beacon without removing the base entity
#Typically used when a timer reaches completion, but in such case it must be noted the objective had failed
#So a bool was placed, because while most of the time a timer reaching zero is bad news, often it's good in the case of defense missions.
func _OnBeaconDestroy(fail:bool):
    var objective = Global.get_objectives()._get_objective(objective_id)
    if objective == null:
            return            
    #Here we alert the objective system and let it know a beacon was destroyed so it can see if an objective was completed.
    if fail == false:
        objective._MarkBeaconComplete(self.get_name())
        pass
    else:
        objective._OnFail()   #TODO: Find a way to remove all associated beacons, probably best for the level_objective class
    #Either way, if we fail or not, this beacon must be freed from the scene.
    queue_free()
    pass

func get_class():
    return "objective_beacon"

#If the player enters the radius, this is where we commence the timer if the timer_start_on_spawn is disable and objective radius is greater than 0
#However, I doubt we need to check for a radius, since if it's less than or equal to 0, it should never call this, right?
func _on_obj_radius_body_entered(body):
    
    ##Possibility that an approach beacon is timed, so we need to see if it's started already, or if it cannot start at all.
    #If neither we move on to the next if statement.
    if is_timed == false || timer_start_on_spawn == true:
        if beacon_type == BEACON_TYPE.BEACON_APPROACH:
            #Our goal was to approach actually, so we just destroy the beacon and call it complete.
            _OnBeaconDestroy(false)
        return
    
    if timer_active == false && timer_start_on_spawn == false:
        timer_active = true
        timer = 0
        #Start printing more stuff
        #And continue on process    
        return
    
    pass # Replace with function body.
