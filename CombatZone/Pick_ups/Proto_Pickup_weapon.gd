extends "res://Pick_ups/Proto_pick_up.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var ammo_type:= '9mm'
export var ammo_count:= 20
var weapon_name # each actual weapon needs to be given names on _ready()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("weapon")
    
func get_input():
    pass
    
func get_amo_count():
    return ammo_count
    
func get_amo_type():
    return ammo_type
    
func get_name():
    return weapon_name

func die():
    queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _weapon_Pre_pickup_Area_2D_body_entered(body: Node) -> void:
    pass # Replace with function body.


func _weapon_Pickup_Area2D_body_entered(body: Node) -> void:
    pass # Replace with function body.


func _weapon_Pickup_Area2D_body_exited(body: Node) -> void:
    pass # Replace with function body.
