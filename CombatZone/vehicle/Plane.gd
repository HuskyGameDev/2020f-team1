extends "res://vehicle/base_vehicle.gd"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func get_input() -> void:
	var turn = 0
	#holds origanal values 
	var defultFri = friction
	var defultDrag = drag
	# Turning
	turn = Input.get_action_strength("vehicle_turn_right") - Input.get_action_strength("vehicle_turn_left")
	steer_angle = turn * deg2rad(steering_angle)
	# Acceleration
	acceleration = transform.x * engine_power * Input.get_action_strength("vehicle_accelerate")
	#gets the volocity of the plane as a float
	var InFlight = velocity.dot(velocity.normalized())
	# Braking
	if Input.is_action_pressed("vehicle_brake"):
		if InFlight < 100: #Plane is on the ground
			acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake") * .66
		if InFlight > 120: #Plane is in the air
			acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake")
	#checks if the plane is in air
	if InFlight >= 100:  
		friction = 0    #no ground friction in air
		drag = -0.0015
		scale.x = 1 + .5
		scale.y = scale.x
		$CollisionShape2D.scale.x = 1+ .5
		$CollisionShape2D.scale.y = 1+ .5
	#on ground
	if InFlight <=100:
		#resets all of the values/ scales
		scale.x = 1
		scale.y = scale.x
		friction = defultFri 
		drag = defultDrag
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 1
		
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
