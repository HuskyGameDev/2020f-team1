extends Area2D

export var speed = 100
export var damage = 50
export var lifetime = 2.0

var velocity:= Vector2()
#var speed: = 0
var rng: = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	set_physics_process(true)

func start_at(pos, dir) -> void:
	rotation = dir.angle()
	position = pos
	$life_time.wait_time = lifetime
	#velocity = Vector2(speed,0).rotated(dir - PI / 2)
	velocity = dir * speed
	
func random_float(spread) -> float:
	var my_random_num = rng.randf_range(-spread, spread)
	return my_random_num
	
func _physics_process(delta: float) -> void:
	#position += transform.x * speed * delta
	position = get_global_position() + velocity * delta
	#position += velocity * delta


func _on_projectiles_body_entered(body: Node) -> void:
	if body.get_groups().has("flesh_damageable"):
		queue_free()
		print(body.get_name())


func _on_life_time_timeout() -> void:
	print("bullet dies")
	queue_free()    # removes object after timeout
