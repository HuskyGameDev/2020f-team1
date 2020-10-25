extends Node2D

export (PackedScene) var bullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func shoot():
    var b = bullet.instance()
    b.start_at($Position2D.global_position, rotation)
    $Bullet_container.add_child(b)

func _physics_process(delta: float) -> void:
    look_at(get_global_mouse_position())
    if Input.is_action_pressed("player_move_up"):
        position += Vector2(0,1)
    if Input.is_action_just_pressed("player_attack_1"):
        $"9mm_autoloader".shoot()
