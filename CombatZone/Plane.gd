extends "res://vehicle/base_vehicle.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func get_input() -> void:
	var turn = 0
	var defultFri = friction
	var defultDrag = drag

	# Turning
	turn = Input.get_action_strength("vehicle_turn_right") - Input.get_action_strength("vehicle_turn_left")
	steer_angle = turn * deg2rad(steering_angle)
	# Acceleration
	acceleration = transform.x * engine_power * Input.get_action_strength("vehicle_accelerate")
	var result = velocity.dot(velocity.normalized())
	#resets values
	friction = defultFri
	drag = defultDrag
	print(result)
	# Braking
	if Input.is_action_pressed("vehicle_brake"):
		if result < 100:
			velocity.x = 0
			velocity.y = 0
			acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake") *.5
		if result > 200:
			acceleration = transform.x * braking * Input.get_action_strength("vehicle_brake")
	#checks if floating 
	if result >= 100:
		friction = 0 #no ground friction in air
		drag = -0.0015
		scale.x = 1 + .5
		scale.y = scale.x
	if result <=100:
		scale.x = 1
		scale.y = scale.x
	
		
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
