extends "res://Pick_ups/pickUp_proto.gd"


# refill this number * clip_size
export var refill_clips := 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func take_effect(player):
    if player.get_groups().has('player'):
        player.refill_ammo(refill_clips)
        queue_free()
