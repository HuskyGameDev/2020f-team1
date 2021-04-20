extends "res://weapons/bullets/tankshell.gd"

func do_base_dmg(body):
    if (body.get_groups().has("player") and body.piloting == true):
        body.take_damage(global_position, damage*3)
    else:
        body.take_damage(global_position, damage)
    pass
