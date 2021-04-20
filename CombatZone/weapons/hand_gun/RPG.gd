extends "../fire_arm_basic.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
    caliber='rocket'
    pass # Replace with function body.

func shoot() -> int:    # returns int signifying success of firing
    _PreShoot()
    if can_shoot:
        if bullet_in_mag > 0:
            can_shoot = false
            $rate_of_fire.start()
            $fire.play()
            for n in range(shot_Per_shell): # shoot decided amount per shell
                print(caliber)
                Global.shoot_bullet(caliber, $muzzle.global_position, global_rotation + bullet_spread(spread))
            #Global.eject_shell($ejection_port.global_position,global_rotation) # eject shells
            bullet_in_mag = bullet_in_mag - 1
            print("bullet in mag ", bullet_in_mag)
            return bullet_in_mag
        else:   # clip empty
            return 0
    return 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

