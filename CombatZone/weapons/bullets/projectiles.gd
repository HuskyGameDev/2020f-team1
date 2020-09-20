extends Area2D

export var speed = 100
export var damage = 50

var velocity:= Vector2.ZERO
#var speed: = 0
var rng: = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rng.randomize()

func start_at(dir, pos) -> void:
    rotation = dir
    position = pos
    
    velocity = Vector2(speed,0).rotated(dir - PI / 2)
    
func random_float(spread) -> float:
    var my_random_num = rng.randf_range(-spread, spread)
    return my_random_num
    
func _physics_process(delta: float) -> void:
    position += transform.x * speed * delta



func _on_projectiles_body_entered(body: Node) -> void:
    if body.get_groups().has("flesh_damageable"):
        queue_free()
        print(body.get_name())
