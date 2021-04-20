extends "../fire_arm_basic.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    caliber='tankshell' #TODO: Tank bullets >:3
    pass # Replace with function body.

func shoot() -> int:    # returns int signifying success of firing
    _PreShoot()
    if can_shoot:
        can_shoot = false
        $rate_of_fire.start()
        $fire.play()
        for n in range(shot_Per_shell): # shoot decided amount per shell
            Global.shoot_bullet(caliber, $muzzle.global_position, global_rotation + bullet_spread(spread))
        return bullet_in_mag
    return 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
