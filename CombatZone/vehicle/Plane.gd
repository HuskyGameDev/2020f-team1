extends "res://vehicle/base_vehicle.gd"
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
func get_input() -> void:
    if manned:
        var turn = 0
        var deftBr = braking
        #holds origanal values 
        # Turning
        turn = Input.get_action_strength("vehicle_turn_right") - Input.get_action_strength("vehicle_turn_left")
        steer_angle = turn * deg2rad(steering_angle)
        # Acceleration
        var InFlight = velocity.dot(velocity.normalized())
        acceleration = transform.x * engine_power * Input.get_action_strength("vehicle_accelerate")
        
        TakeOff(InFlight)
        #gets the volocity of the plane as a float
        # Braking
        if Input.is_action_pressed("vehicle_brake"):
            if InFlight < 100: #Plane is on the ground
                acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake") * .66
                braking = deftBr
            if InFlight > 100: #Plane is in the air
                acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake")
                braking = -100
        #checks if the plane is in air
        
        # Embark
    if not manned:
        if can_embark && Input.is_action_just_released("player_interact"):
            Global.embark(passenger_tobe,self)
        # Disembark
    elif Input.is_action_just_released("player_interact"):   # only when it is manned
            Global.disembark(passenger, self)
        
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

func TakeOff(inFlight) -> void:
    var defultFri = friction
    scale.x = 1 + inFlight *.0009
    scale.y = scale.x
    $CollisionShape2D.scale.x = 1 + inFlight *.0009     # all your collision shape changes are incorrect
    $CollisionShape2D.scale.y = 1 + inFlight *.0009     # see it change in 'vehicle test level' scene -- Zong
    $HeadHitBox.scale.x = 1 + inFlight * .0009
    $HeadHitBox.scale.y = 1 + inFlight * .0009
    $TailHitBox.scale.x = 1 + inFlight * .0009
    $TailHitBox.scale.y = 1 + inFlight * .0009
    if inFlight > 200:
        friction = 0
    if inFlight < 200:  # what about using 'else' instead? -- ZOng
        friction = defultFri 
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
