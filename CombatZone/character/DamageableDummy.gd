extends "res://character/people.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func take_damage(damage_amount) -> void:
    health -= damage_amount
    print("Damage, remaining health: %d" % health)
    
func get_hit(pos, damag_amount):
    $hit_spot.position = pos
    print($hit_spot.position)
    $hit_spot.emitting = true
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
