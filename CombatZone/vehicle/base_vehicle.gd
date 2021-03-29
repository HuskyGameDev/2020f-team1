extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var engine_power: = 800  # Forward acceleration force
export var wheel_base: = 70 # Distance from front to rear wheel
export var steering_angle: = 15 # Amount that front wheel turns, in degrees
export var braking: = -450
export var max_speed_reverse: = 250
export var slip_speed = 400 # Speed where traction is reduced
export var traction_fast = 0.1  # High-speed traction
export var traction_slow = 0.7  # Low_speed traction
export var friction: = -0.9 # applied on ground, higher on sand, lower on ice
export var drag: = -0.0015  # wind resistance

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_angle = 0.0
var can_embark = false
var manned = false
var passenger_tobe: KinematicBody2D
var passenger = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func get_input() -> void:
    pass
    
func calculate_steering(delta) -> void:
    pass

func apply_friction() -> void:
    if velocity.length() < 5:
        velocity = Vector2.ZERO
    var friction_force = velocity * friction
    var drag_force = velocity * velocity.length() * drag
    if velocity.length() < 100:
        friction_force *= 3
    acceleration += drag_force + friction_force
    
func _physics_process(delta: float) -> void:
    acceleration = Vector2.ZERO
    get_input()
    apply_friction()
    calculate_steering(delta)
    velocity += acceleration * delta
    velocity = move_and_slide(velocity)


func _on_embark_Area2D_body_entered(body: Node) -> void:
    print('Object entered', body)
    if(body.get_groups().has('player') && !(passenger == body)):
        print('player entered')
        can_embark = true
        passenger_tobe = body


func _on_embark_Area2D_body_exited(body: Node) -> void:
    if body.get_groups().has('player'):
        print('player exited embark area')
        can_embark = false
        passenger_tobe = null
        
