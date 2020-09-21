extends Area2D

export var spread: = 1.0
export var clip_size: = 10

export (PackedScene) var bullet


onready var rate_of_fire = get_node("rate_of_fire")
onready var b_container = get_node("bullet_container")

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func shoot() -> void:
    rate_of_fire.start()
    var b = bullet.instance()
    b_container.add_child(b)
    b.start_at(get_rotation(), get_node("muzzle").get_global_position())
    
func reload() -> int:   # reload would probably return the number of bullets in the clip
    return -1
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
