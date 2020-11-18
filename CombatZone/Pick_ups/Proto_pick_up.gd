extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var picker = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("item_pick_up")

# Called to take desired effect
func take_effect():
    pass

# each pick up type should have different pick up inputs to check different things
func get_input():
    pass
    
func _physics_process(delta: float) -> void:
    get_input()

func _on_Pre_pickup_Area_2D_body_entered(body: Node) -> void:
    print('body enter pre_Pickup area')


func _on_Pickup_Area2D_body_entered(body: Node) -> void:
    print("body entered pickup: ",body)
    if(body.get_groups().has("player")):
        picker = body
    

func _on_Pickup_Area2D_body_exited(body: Node) -> void:
    print("body left pickup",body)
    if(body.get_groups().has("player")):
        picker = null
