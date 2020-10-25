extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    $tank_turret.look_at(get_global_mouse_position())
    get_input()
    
func get_input():
    if Input.is_action_pressed("player_attack_1"):
        attack1()
    
func attack1() -> void:
    $tank_turret.shoot()
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
