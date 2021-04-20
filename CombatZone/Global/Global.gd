extends Node

# Global script will be used to store persistent game info

# Game Settings
export var debug = true
var game_over: = false
var game_paused: = false
var current_scene = null
var new_scene = null
var level: = 0
var player

# Navigation
var nav2D :Navigation2D = null

#Objectives
var objectives = preload("res://Levels/Objectives/Objectives.tscn")
var current_objectives

# effects
var blood = preload("res://Environment/Effects/blood_splater.tscn")
var shell = preload("res://Environment/Effects/Bullet_Eject.tscn")
var explosion = preload("res://Environment/Effects/Explosion.tscn")

# weapon Settings

# projectiles

func _ready() -> void:
    if player == null:
        if debug:
            print('Global: player not set...')
# UI
func switch_camera2D(old_node,new_node):
    old_node.get_node('Camera2D').current = false
    new_node.get_node('Camera2D').current = true
    
# register player as player variable for later referencing by script
func register_player(game_player):
    player = game_player
    print("Global: player set")

func register_nav2D(nav):
    nav2D = nav
    print("Global: nav2D set")
    
# Provides the current level's objectives to global class to allow for completion.
func register_objectives():
    current_objectives = objectives.instance()
    current_objectives._initial_display()
    print("Global: Objectives set!")
    
#Originally I used this thinking the scene scripts were bugged
#Turns out I had the wrong script connected o_o
#Oh well, keeping it for convinience.
#This also makes sure that after objectives are defined, that they are displayed as well.
func register_all(game_player):
    # changed to reduce redendancy
    register_player(game_player)
    register_objectives()

#It's a simple function that returns the current objectives the player has at the moment, so long as they exist.
func get_objectives():
    if current_objectives != null:
        return current_objectives
    elif debug:
        print("Global: Found no objectives")
    
func get_player():
    if player != null:
        return player
    elif debug:
        print("Global: player not set, can't return")
        
func get_nav2D():
    if nav2D != null:
        return nav2D
    elif debug:
        print("global: nav2D not set, can't return")

# weapon
func shoot_bullet(caliber, pos, rot):
    #var b = bullet_caliber[caliber].instance()
    var b = BulletFactory.get_bullet(caliber)
    b.start_at(pos, rot)
    get_parent().add_child(b)
    #eject_shell(pos)
    
func eject_shell(pos,rot):
    var sh = shell.instance()
    sh.start_at(pos,rot)
    get_parent().add_child(sh)
    
# effects
func spill_blood(pos):
    var bl = blood.instance()
    bl.start_at(pos)
    get_parent().add_child(bl)

func create_explosion(pos):
    var xpl = explosion.instance()
    xpl.start_at(pos)
    get_parent().add_child(xpl)

# vehicle
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
        if (people.get_groups().has('player')):
            people.remove_from_group('player')
            vehicle.add_to_group('player')
            register_player(vehicle)
        people.hide()

func disembark(people: Node2D,vehicle: Node):
    #if vehicle.is_a_parent_of(people):
        #print('is parent')
    #vehicle.remove_child(people)
    switch_camera2D(vehicle,people)
    if (vehicle.get_groups().has('player')):
            vehicle.remove_from_group('player')
            people.add_to_group('player')
            register_player(people)
    vehicle.remove_from_group('player')
    people.show()
    people.set_process(true)
    people.piloting = false
    vehicle.passenger = null
    print(people.position)
    people.set("position", vehicle.get_node('disembark_Position2D').get_global_position())
    vehicle.manned = false
       
    
# puck-ups
func pickup(player,type,number):
    if debug:
        print("player ",player, "pick up ", type, "quantity of ",number)

func scene_change(path_name):
    get_tree().change_scene_to(path_name)
    
#Not sure what scene_change is ever used for, please let me know and I can try to work with it.
#Until then, this is what is used by objectives
#It is used when going back to the title screen after all objectives are completed, if it's allowed.
func scene_change_path(path_name:String):
    get_tree().change_scene(path_name)

func debug_on() -> bool:
    return debug
