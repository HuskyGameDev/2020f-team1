extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("item_pick_up")

# Called to take desired effect
func take_effect():
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Pre_pickup_Area_2D_body_entered(body: Node) -> void:
    pass # Replace with function body.


func _on_Pickup_Area2D_body_entered(body: Node) -> void:
    print("pickup detected body: ",body)
