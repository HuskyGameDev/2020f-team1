extends "res://Pick_ups/Proto_pick_up.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var ammo_type:= '9mm'
export var ammo_count:= 20
var weapon_name # each actual weapon needs to be given names on _ready()

var get_ammo = false
var swap_weapon = false # determine whether to simply pick up weapon or swap weapon on hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("weapon")
    
func get_input():
    if picker != null && Input.is_action_just_released("player_interact"):
        if swap_weapon:
            picker.get
    
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
    pass
        


func _weapon_Pickup_Area2D_body_entered(body: Node) -> void:
    if body.get_groups().has('player'): # only players can pick up
        picker = body
        if body.has_weapon(weapon_name):    #will only pick up ammo
            get_ammo = true
        else:
            if body.weapon_full():  # will swap weapon with holster
                swap_weapon = true


func _weapon_Pickup_Area2D_body_exited(body: Node) -> void:
    if body.get_groups().has('player'): # only players can pick up
        picker = null
        get_ammo = false
        swap_weapon = false
