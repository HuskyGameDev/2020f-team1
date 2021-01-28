extends Node2D

export var armor_amount = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#

func _on_Pickup_Area2D_body_entered(body: Node) -> void:
    if body.get_groups().has('player'):
        if body.armorDamaged():
            print("Gettting Armor!!!")
            body.armor_up(armor_amount)
            queue_free()
