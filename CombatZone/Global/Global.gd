extends Node

# Global script will be used to store persistent game info

# Game Settings
var game_over: = false
var game_paused: = false
var current_scene = null
var new_scene = null
var level: = 0
var player

# effects
var blood = preload("res://Environment/Effects/blood_splater.tscn")
# weapon Settings

# projectiles
var b_9mm = preload("res://weapons/bullets/9mm_ammo.tscn")
#export (PackedScene) var b_9mm
var bullet_caliber = {"9mm": b_9mm}


func register_player(game_player):
    player = game_player
    
func shoot_bullet(caliber, pos, rot):
    #var b = bullet_caliber[caliber].instance()
    var b = BulletFactory.get_bullet(caliber)
    b.start_at(pos, rot)
    get_parent().add_child(b)

func spill_blood(pos):
    var bl = blood.instance()
    bl.start_at(pos)
    get_parent().add_child(bl)
