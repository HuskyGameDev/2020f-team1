extends Node

#Do we need the beacon to be destroyed? Protected? Collected? This defines how we clear the beacon.
enum BEACON_TYPE {
    TYPE_NULL = -1,
    BEACON_DESTROY, # = 0
    BEACON_SECURE, # = 1
    BEACON_COLLECT # = 2
   }

export var objective_id:String #This is what connects the beacon to the objective.

export var is_timed:bool #If it's timed, simply check this.

export var timer_length:float #The length of the timer, only applied if the beacon is a timed one.

export var objective_radius:float ###The distance away from the beacon needed in order for a timed beacon to start a timer.

export(BEACON_TYPE) var beacon_type = BEACON_TYPE.TYPE_NULL #The type of action required to remove this beacon. Refer to BEACON_TYPE for what each number stands for.

var marked_for_destroy := false


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _OnBeaconDestroy():
    pass #Here we alert the objective system and let it know a beacon was destroyed so it can see if an objective was completed.

func get_class():
    return "objective_beacon"
