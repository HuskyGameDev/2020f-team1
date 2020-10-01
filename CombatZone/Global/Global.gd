extends Node

# Global script will be used to store persistent game info

# Game Settings
var game_over: = false
var game_paused: = false
var current_scene = null
var new_scene = null
var level: = 0
var player

# weapon Settings

# projectiles
var b_9mm = preload("res://weapons/bullets/9mm_ammo.tscn")
#export (PackedScene) var b_9mm
var bullet_caliber = {"9mm": b_9mm}


func register_player(game_player):
    player = game_player
    
func shoot_bullet(caliber, pos, rot):
    var b = bullet_caliber[caliber].instance()
    b.start_at(pos, rot)
    #$bullet_container.add_child(b)
