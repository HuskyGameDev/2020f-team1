extends "res://weapons/fire_arm_basic.gd"

var maxSpread = 0.5
var minSpread = 0.08
var spreadInterval = 0.01
var timerOngoing
var spreadTimer


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
    if (spreadTimer.time_left > 0):
        spreadTimer.set_wait_time(spreadTimer.get_wait_time() + 0.09)
        
        if (spread < maxSpread):
            spread += spreadInterval
        
    else:
        spreadTimer.start(0.09)
        timerOngoing = true        
    pass


func _on_SpreadTimer_timeout():
    spread = minSpread    
    pass # Replace with function body.
