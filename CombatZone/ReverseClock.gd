#Clock!
#This is simply a timer that is meant to display on the player's hud in the case an objective is timed
#The clock is activated by the objective/beacon and given a time to process
#Once the time is over, it will call to the objective/beacon informing it that it is done while also removing it.
#Timers may be pre-destroyed as well upon the objective being completed before the timer runs out.


extends Node2D

#Two key members, time in seconds and time in minutes
#We should NEVER need time in hours, so I'm not going to add it.
var totalMinutes = 0
var totalSeconds = 0

var objID #Stores the objective id for when we need to tell the objective that the timer has stopped.
export var objText = ''
var beaconName

var delay = 1 #A one second delay between updating a display.
var internalTimer = 0

var ongoing
var premature

var beacon_obj = null

# Called when the node enters the scene tree for the first time.
func _ready():
    premature = false
    _Initialize()
    pass # Replace with function body.

func _Initialize():
#    print("Total Minutes:")
#    print(totalMinutes)
    
    #TODO: Conditional: Either text or id depending on DEBUG MODE ENABLED
    $MissionDisplay.text = objText
    _updateDisplay()
    
    position = Vector2(1000, ((-500)+(-180*0)))
    scale = Vector2(5, 5)
    
    ongoing = true
    
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    internalTimer += delta
    if (internalTimer > delay):
            internalTimer = 0
            
            if (totalSeconds == 60):
                totalMinutes = totalMinutes + 1
                totalSeconds = 0
            else:
                totalSeconds = totalSeconds + 1
            _updateDisplay()
        
    pass
    
func _updateDisplay():
    
    var secs = "0"+String(totalSeconds) if totalSeconds < 10 else String(totalSeconds)
    
    var timDisp = String(totalMinutes) + ":" + secs
    
    $TimerDisplay.text = timDisp
    
    pass


func _EndClockPremature():
    
    ongoing = false
    premature = true
    
    pass
