extends "res://Pick_ups/pickUp_proto.gd"


export var ammo_type:= '9mm'
export var ammo_count:= 20
export var weap_name:= 'no_name' # each actual weapon needs to match weapon name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("weapon")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
