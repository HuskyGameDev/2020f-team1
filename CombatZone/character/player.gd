extends "res://character/people.gd"

var canShoot = true
var canRoll = true
var input = Vector2()

export (PackedScene) var default_weapon
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("player")
    $Dodge.hide()
    var weapon = default_weapon.instance()
    print($holsters.get_child_count())
    if default_weapon != null:
        $holsters.add_child(weapon)
        print($holsters.get_child_count())
        

func get_input():
    dodge = Vector2.ZERO
    look_at(get_global_mouse_position())
    if Input.is_action_pressed("player_attack_1"):
        attack1()
    if Input.is_action_pressed("player_attach_2"):
        attack2()
    if Input.is_action_pressed("player_dodge"): #LEFT SHIFT TO ROLL
        dodge_roll()
    input.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
    input.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
    return input

func attack1() -> void:
    if $holsters.get_child_count()>0:
        $holsters.get_child(0).shoot()
    
func attack2() -> void:
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass

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
