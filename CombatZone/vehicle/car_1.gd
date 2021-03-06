extends "res://vehicle/base_vehicle.gd"



# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func get_input() -> void:
    var turn = 0
    #$tank_turret.look_at(get_global_mouse_position())
    if manned:  # will change motion only when it is occupied
        # Turning
        turn = Input.get_action_strength("vehicle_turn_right") - Input.get_action_strength("vehicle_turn_left")
        steer_angle = turn * deg2rad(steering_angle)
        # Acceleration
        acceleration = transform.x * engine_power * Input.get_action_strength("vehicle_accelerate")
        # Braking
        if Input.is_action_pressed("vehicle_brake"):
            acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake")
    
func calculate_steering(delta):
    var rear_wheel = position - transform.x * wheel_base / 2.0
    var front_wheel = position + transform.x * wheel_base / 2.0
    rear_wheel += velocity * delta
    front_wheel += velocity.rotated(steer_angle) * delta
    
    var new_heading = (front_wheel - rear_wheel).normalized()
    
    var traction = traction_slow
    if velocity.length() > slip_speed:
        traction = traction_fast
        
    var dot = new_heading.dot(velocity.normalized())
    if dot > 0:
        velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
    if dot < 0:
        velocity = -new_heading * min(velocity.length(), max_speed_reverse)
        
    rotation = new_heading.angle()
