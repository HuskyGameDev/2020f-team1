extends Area2D

signal shoot

export var spread: = 0.05
export var shot_Per_shell = 1
export var clip_size = 10
export var ammo = 50    # default ammo count
export var fire_rate = 1.0
export var weap_name = 'no_name'
export var reload_time = 2 # in second
export (PackedScene) var bullet

#onready var b_container = get_node("bullet_container")
var rng:= RandomNumberGenerator.new()   # RNG for bullet 
var can_shoot: = true
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var caliber = 'default'

var bullet_in_mag = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rng.randomize()

func shoot() -> int:    # returns int signifying success of firing
    if can_shoot:
        if bullet_in_mag > 0:
            can_shoot = false
            $rate_of_fire.start()
            for n in range(shot_Per_shell): # shoot decided amount per shell
                Global.shoot_bullet(caliber, $muzzle.global_position, global_rotation + bullet_spread(spread))
            Global.eject_shell($ejection_port.global_position,global_rotation) # eject shells
            bullet_in_mag = bullet_in_mag - 1
            print("bullet in mag ", bullet_in_mag)
            return bullet_in_mag
        else:   # clip empty
            return 0
    return 1
    
func reload_weap() -> int:   # reload would probably return the number of bullets in the clip
    if Global.debug_on():
        print("weapon: reloading")
        ammo -= clip_size
        if ammo == 0 - clip_size:   # no ammo to reload
            if Global.debug:
                print("ammo used up")
            return -1
        bullet_in_mag = clip_size   # reloaded
        if Global.debug:
            print("ammo left ", ammo)
        if ammo < 0:
            bullet_in_mag += ammo   # if not enough ammo count to fill up clip
            ammo = 0
    return reload_time

func clip_full() -> bool:
    return bullet_in_mag == clip_size
    
func get_weap_name():
    return weap_name

func bullet_spread(spread) -> float:
    var float_spread = rng.randf_range(-spread,spread)
    return float_spread

func on_weapon_shoot():
    shoot()

func _on_rate_of_fire_timeout() -> void:
    can_shoot = true
