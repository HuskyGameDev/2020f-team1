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
var beaconName

var delay = 1 #A one second delay between updating a display.
var internalTimer = 0

var ongoing
var premature

# Called when the node enters the scene tree for the first time.
func _ready():
    premature = false
    pass # Replace with function body.

func _Initialize(time, id, beacon):
    
    #For a timer, we want to display it like a traditional clock. Minutes before seconds.
    #To get minutes, divide the time by 60, to get the seconds, divide the time but get the remainder.
    totalMinutes = floor(time / 60) #Be sure to floor here, we don't want this to round up in any case.
    totalSeconds = int(time) % 60
    
    print("Total Minutes:")
    print(totalMinutes)
    
    objID = id
    beaconName = beacon
    
    $MissionDisplay.text = objID
    _updateDisplay()
    
    ongoing = true
    
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    #Break the loop, end this timer
    if (ongoing == false):
        Global.get_objectives()._removeClock(objID)
        pass
    
    internalTimer += delta
    if (internalTimer > delay):
            internalTimer = 0
            
            match totalSeconds:
                0:
                    if (totalMinutes == 0):
                            ongoing = false
                            return
                    else:    
                        totalMinutes = totalMinutes - 1
                        totalSeconds = 59
                        _updateDisplay()
                        return        
                _:
                    totalSeconds = totalSeconds - 1
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
