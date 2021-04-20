extends "res://weapons/bullets/tankshell.gd"


#On ready, modify the explosion damage to be weaker than the tank's
func _ready() -> void:
    rng.randomize()
    add_to_group("projectiles")
    explosionDamage = 500

#On base damage, if the player is piloting a vehicle, do more damage.
func do_base_dmg(body):
    if (body.get_groups().has("player") and body.piloting == true):
        body.take_damage(global_position, damage*3)
    else:
        body.take_damage(global_position, damage)
    pass
