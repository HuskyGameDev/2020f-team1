extends Node
# bullet factory should be the script Global.gd calls when spawning bullets
# it should store all scenes of all ammo types

#bullets
var b_9mm = preload("res://weapons/bullets/9mm_ammo.tscn")

onready var caliber_dict = {'9mm': preload("res://weapons/bullets/9mm_ammo.tscn")}


# weapons
var w_9mm_autoloader = preload("res://weapons/hand_gun/9mm_autoloader.tscn")
var w_magnum = preload("res://weapons/hand_gun/magnum.tscn")
var w_sawn_off_b = preload("res://weapons/hand_gun/sawn_off_broomstick.tscn")
var weapon_dict = {'9mmloader': w_9mm_autoloader,
                    'magnum': w_magnum,
                    'sawn_off_boom': w_sawn_off_b
                    }



# call to return instanced ammo objects
func get_bullet(caliber):
    print("returning bullet")
    return caliber_dict[caliber].instance()

func get_weapon(weapon_name):
    return weapon_dict[weapon_name].instance()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
