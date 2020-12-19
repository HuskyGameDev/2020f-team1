extends Area2D

signal shoot

export var spread: = 0.05
export var clip_size = 10
export var ammo = 50    # default ammo count
export var fire_rate = 1.0
export var weap_name = 'no_name'
export (PackedScene) var bullet

#onready var b_container = get_node("bullet_container")
var rng:= RandomNumberGenerator.new()   # RNG for bullet 
var can_shoot: = true
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var caliber = 'default'

var remain_in_mag = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rng.randomize()

func shoot() -> void:
    #print("Called")
    if can_shoot and remain_in_mag:
        can_shoot = false
        $rate_of_fire.start()
        Global.shoot_bullet(caliber, $muzzle.global_position, global_rotation + bullet_spread(spread))
        Global.eject_shell($ejection_port.global_position,global_rotation)
        print("shooting ", caliber)
    
func reload() -> int:   # reload would probably return the number of bullets in the clip
    return -1
    
func get_weap_name():
    return weap_name

func bullet_spread(spread) -> float:
    var float_spread = rng.randf_range(-spread,spread)
    return float_spread

func on_weapon_shoot():
    shoot()

func _on_rate_of_fire_timeout() -> void:
    can_shoot = true
