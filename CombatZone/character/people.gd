extends KinematicBody2D

export var speed: = 100   # character speed
export var friction: = 0.01
export var acceleration: = 0.1

export var health: = 100.0
export var totalHealth = 100.0
export var healthPercent = 100.0

var velocity: = Vector2.ZERO

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("flesh_damageable")
    $Health.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
func get_input():
    return Vector2.ZERO

func update_health():
    pass
    
func take_damage(damage_amount) -> void:
    #$Health.show()
    #$healthG.show()
    health -= damage_amount
    update_health()

func _physics_process(delta: float) -> void:
    var direction = get_input()
    if direction.length() > 0:
        velocity = lerp(velocity, direction.normalized() * speed, acceleration)
    else:
        velocity = lerp(velocity, Vector2.ZERO, friction)
    velocity =  move_and_slide(velocity)
