extends "res://vehicle/base_vehicle.gd"

var speed = 400
var rotation_speed = 1.5



var rotation_dir = 0


func get_input():
    rotation_dir = 0
    velocity = Vector2.ZERO
    if manned:
        if Input.is_action_pressed("vehicle_turn_right"):
            rotation += .01
        if Input.is_action_pressed("vehicle_turn_left"):
            rotation -= .01
        if Input.is_action_pressed("vehicle_brake"):
            velocity -= transform.x * speed
        if Input.is_action_pressed("vehicle_accelerate"):
            velocity += transform.x * speed


    
