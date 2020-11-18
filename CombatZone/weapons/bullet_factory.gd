extends Node
# bullet factory should be the script Global.gd calls when spawning bullets
# it should store all scenes of all ammo types

#bullets
var b_9mm = preload("res://weapons/bullets/9mm_ammo.tscn")

var caliber_dict = {'9mm': b_9mm}

# weapons
var w_9mm_autoloader = preload("res://weapons/hand_gun/9mm_autoloader.tscn")
var weapon_dict = {'9mm_autoloader': w_9mm_autoloader}




# call to return instanced ammo objects
func get_bullet(caliber):
    print("returning bullet")
    return caliber_dict[caliber].instance()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
