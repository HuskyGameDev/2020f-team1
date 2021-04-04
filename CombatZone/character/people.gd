extends KinematicBody2D

export var speed: = 100   # character speed
export var friction: = 0.01
export var acceleration: = 0.1

export var health: = 100.0
export var totalHealth: = 100.0
export var healthPercent: = 100.0

export var armor: = 0.0
export var totalArmor: = 100.0
export var armorPercent: = 0.0

var dodge: = Vector2.ZERO
export var counter: = 100.0
export var countertotal: = 100.0

var velocity: = Vector2.ZERO
var piloting = false
var vehicle = null

var pickup_item = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("flesh_damageable")
    $health_bars.hide()
    $Dodge.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
func get_input():
    return Vector2.ZERO

func dodge_roll():
    pass

func update_health():
    pass
    
func take_damage(pos, damage_amount) -> void:
    #$Health.show()
    #$healthG.show()
    health -= damage_amount
    if(health < 0):
        health = 0

func reload():
    pass
func set_position(pos: Vector2):
    position = pos
    
func _physics_process(delta: float) -> void:
    if not piloting:
        var direction = get_input()
        if direction.length() > 0:
            velocity = lerp(velocity, direction.normalized() * speed, acceleration)
        else:
            velocity = lerp(velocity, Vector2.ZERO, friction)
        # set collision shape rotations
        $CollisionShape2D.rotation = $upper_body.rotation
        #$Pre_pickup_Area2D.rotation = $upper_body.rotation
        velocity =  move_and_slide(velocity + dodge)
    else:
        position = vehicle.global_position
        #rotation = vehicle.global_rotation
