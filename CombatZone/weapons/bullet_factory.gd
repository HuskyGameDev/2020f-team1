extends Node
# bullet factory should be the script Global.gd calls when spawning bullets
# it should store all scenes of all ammo types

#bullets
var b_9mm = preload("res://weapons/bullets/9mm_ammo.tscn")

onready var caliber_dict = {'9mm': preload("res://weapons/bullets/9mm_ammo.tscn")}


# weapons
var w_9mm_autoloader = preload("res://weapons/hand_gun/9mm_autoloader.tscn")
var w_magnum = preload("res://weapons/hand_gun/magnum.tscn")
var w_sawn_off_b = preload("res://weapons/hand_gun/sawn_off_boomstick.tscn")

# pickups
var p_9mm_autoloader = preload("res://Pick_ups/Weapons/hand_guns/pickUp_9mm_autoloader.tscn")
var p_mac10 = preload("res://Pick_ups/Weapons/hand_guns/pickUp_weapon_mac10.tscn")

var weapon_dict = {'9mmloader': w_9mm_autoloader,
                    'magnum': w_magnum,
                    'sawn_off_boom': w_sawn_off_b
                    }

var weap_pickup_dict = {'9mmloader': p_9mm_autoloader,
                        'mac10': p_mac10}

# call to return instanced ammo objects
func get_bullet(caliber):
    print("returning bullet")
    return caliber_dict[caliber].instance()

func get_weapon(weapon_name):
    return weapon_dict[weapon_name].instance()
    
func get_pickUp(weapon_name):
    return weap_pickup_dict[weapon_name].instance()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
