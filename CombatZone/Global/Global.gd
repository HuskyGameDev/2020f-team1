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
var shell = preload("res://Environment/Effects/Bullet_Eject.tscn")
#var Tshell = preload("")
# weapon Settings

# projectiles
var b_9mm = preload("res://weapons/bullets/9mm_ammo.tscn")
#export (PackedScene) var b_9mm
var bullet_caliber = {"9mm": b_9mm}

func _ready() -> void:
    if player == null:
        print('player not set...')
func register_player(game_player):
    player = game_player
    
func shoot_bullet(caliber, pos, rot):
    #var b = bullet_caliber[caliber].instance()
    var b = BulletFactory.get_bullet(caliber)
    b.start_at(pos, rot)
    get_parent().add_child(b)
    eject_shell(pos)

func spill_blood(pos):
    var bl = blood.instance()
    bl.start_at(pos)
    get_parent().add_child(bl)
    
func eject_shell(pos):
    var sh = shell.instance()
    sh.start_at(pos)
    get_parent().add_child(sh)

func embark(people: Node2D, vehicle):
    if vehicle.manned:  #if vehicle is occupied, can't get in
        pass
    else:
        switch_camera2D(people,vehicle)
        vehicle.manned = true
        vehicle.passenger = people
        vehicle.can_embark = false
        people.piloting = true
        people.position = Vector2(-1000,-1000)
        people.hide()

func disembark(people: Node2D,vehicle: Node):
    #if vehicle.is_a_parent_of(people):
        #print('is parent')
    #vehicle.remove_child(people)
    switch_camera2D(vehicle,people)
    people.show()
    people.set_process(true)
    people.piloting = false
    print(people.position)
    people.set("position", vehicle.get_node('disembark_Position2D').get_global_position())
    vehicle.manned = false

func switch_camera2D(old_node,new_node):
    old_node.get_node('Camera2D').current = false
    new_node.get_node('Camera2D').current = true
