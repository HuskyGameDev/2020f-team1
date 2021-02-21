extends "res://Pick_ups/pickUp_proto.gd"

export var armor_amount = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func take_effect(player) -> void:
    if player.get_groups().has('player'):
        if player.armorDamaged():
            player.armor_up(armor_amount)
            queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
