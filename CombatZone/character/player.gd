extends "res://character/people.gd"

var canShoot = true
var canRoll = true
var input = Vector2()

export (PackedScene) var default_weapon
export (PackedScene) var holstered_weap
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("player")
    $Dodge.hide()
    var weapon = default_weapon.instance()
    if default_weapon != null:
        $hand.add_child(weapon)
    if holstered_weap != null:
        $holsters.add_child(holstered_weap.instance())


func get_input():
    dodge = Vector2.ZERO
    look_at(get_global_mouse_position())
    if Input.is_action_pressed("player_attack_1"):
        attack1()
    if Input.is_action_pressed("player_attach_2"):
        attack2()
    if Input.is_action_just_pressed("player_switch_weapon"):
        swap_weap()
    if Input.is_action_pressed("player_dodge"): #LEFT SHIFT TO ROLL
        dodge_roll()
    input.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
    input.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
    return input

func attack1() -> void:
    if $hand.get_child_count()>0:
        $hand.get_child(0).shoot()
    
func attack2() -> void:
    pass

func swap_weap():
    print("switching weapon")
    if $holsters.get_child_count() > 0:
        print("I'm switching")
        var temp_weap = $hand.get_child(0).duplicate()
        $hand.remove_child($hand.get_child(0))
        $hand.add_child($holsters.get_child(0).duplicate())
        $holsters.remove_child($holsters.get_child(0))
        $holsters.add_child(temp_weap)


func _process(delta):
    $Dodge.scale.x = ($RollTimer.time_left / $RollTimer.wait_time)
    if($Dodge.scale.x == 0):
        $Dodge.hide()
        $Dodge.scale.x = 2

func dodge_roll():
    if(canShoot == true && canRoll == true):
        canRoll = false
        canShoot = false
        $Dodge.show()
        print("dodge roll begins")
        $RollTimer.start()
        counter = 100.0 
        dodge = Vector2(input.x, input.y) * 5000
        #while(counter > 0):
        #    $RollTimer2.start()
        #    counter = counter - 1

func _on_RollTimer_timeout():
    canRoll = true
    canShoot = true

# series of methods to check player states
func has_weapon(weapon_name):
    if $hand.get_child(0).get_weap_name == weapon_name:
        return true
    elif $holsters.get_child(0).get_weap_name == weapon_name:
        return true
    return false

func weapon_full():
    if $hand.get_child_count()>0 && $holsters.get_child_count()>0:
        return true
        
func take_damage(pos, damage_amount) -> void:
    $Health.show()
    $HealthG.show()
    health -= damage_amount
    if(health <= 0):
        health = 0
        die()
    $HealthG.scale.x = (health / totalHealth)
    Global.spill_blood(pos)
    print("Player HP percent: %f" % ((health / 100)))
    print(" Player Damage, remaining health: %d" % health)


func die():
    get_tree().change_scene("res://assets/TitleScreen.tscn")
    queue_free()
