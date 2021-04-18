extends Area2D

export var speed = 100
export var damage = 50
export var lifetime = 2.0

var velocity:= Vector2()
#var speed: = 0
var rng: = RandomNumberGenerator.new()  # for bullet spread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rng.randomize()
    add_to_group("projectiles")

func start_at(pos, dir) -> void:
    # rotation = dir.angle()
    # print("bullet starts")
    # print(pos)
    rotation = dir
    position = pos
    $life_time.wait_time = lifetime
    velocity = Vector2(speed,0).rotated(dir)
    #velocity = dir * speed
    #$bullet_firing.play()
    $shell_droping.play()
    
# for possible adding bullet spread
func random_float(spread) -> float:
    var my_random_num = rng.randf_range(-spread, spread)
    return my_random_num
    
func _physics_process(delta: float) -> void:
    #position += transform.x * speed * delta
    #position = get_global_position() + velocity * delta
    position += velocity * delta


func _on_projectiles_body_entered(body: Node) -> void:
    print("bullet hit")
    if body.get_groups().has("flesh_damageable"):
        #Sound stop is jarring, but resource management is more tedious.
        #self.hide()
        queue_free()
        print(body.get_name())
        body.take_damage(global_position, damage)
        return
    #Now allow for collision with tilemaps	
    if body.get_class() == "TileMap":
        #Again, the Sound stop is jarring, but resource management is more tedious.
        #self.hide()
        #get_node("CollisionShape2D").disabled= true
        queue_free()

func _on_life_time_timeout() -> void:
    print("bullet dies")
    queue_free()    # removes object after timeout
