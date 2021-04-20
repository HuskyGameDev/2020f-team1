extends "res://weapons/fire_arm_basic.gd"

export var maxSpread = 0.5
export var minSpread = 0.08
export var spreadInterval = 0.01
var timerOngoing
var spreadTimer:Timer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    spreadTimer = $SpreadTimer
    timerOngoing = false
    caliber='9mm'


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
    
#    pass

func _PreShoot():
    if (spreadTimer.time_left > 0):                   # what is this magic number? 0.09?
        spreadTimer.set_wait_time(spreadTimer.get_wait_time() + 0.09)
        
        if (spread < maxSpread):
            spread += spreadInterval
        
    else:
        spreadTimer.start(0.09)
        timerOngoing = true
        
    print('spread is: ', spread)      
    pass


func _on_SpreadTimer_timeout():
    spread = minSpread    
    pass # Replace with function body.
