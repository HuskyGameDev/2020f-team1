extends KinematicBody2D

var speed = 400
var rotation_speed = 1.5

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var rotation_dir = 0

var manned = false
var can_embark = false
var passenger_tobe: KinematicBody2D
var passenger = null

func get_input():
    rotation_dir = 0
    velocity = Vector2.ZERO
    if manned:
        if Input.is_action_pressed("vehicle_turn_right"):
            rotation_dir += 1
        if Input.is_action_pressed("vehicle_turn_left"):
            rotation_dir -= 1
        if Input.is_action_pressed("vehicle_brake"):
            velocity -= transform.x * speed
        if Input.is_action_pressed("vehicle_accelerate"):
            velocity += transform.x * speed
    if not manned:
        if can_embark && Input.is_action_just_released("player_interact"):
            Global.embark(passenger_tobe,self)
            print('to embark')
        # Disembark
    elif Input.is_action_just_released("player_interact"):   # only when it is manned
            Global.disembark(passenger, self)
            print('to disembark')

func _physics_process(delta):
    get_input()
    rotation += rotation_dir * rotation_speed * delta
    velocity = move_and_slide(velocity)
    
func _on_embark_Area2D_body_entered(body: Node) -> void:
    print('Object entered', body)
    if(body.get_groups().has('player')):
        print('player entered')
        can_embark = true
        passenger_tobe = body


func _on_embark_Area2D_body_exited(body: Node) -> void:
    if body.get_groups().has('player'):
        print('player existed embark area')
        can_embark = false
        passenger_tobe = null
    
