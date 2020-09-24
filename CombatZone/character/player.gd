extends "res://character/people.gd"


export (PackedScene) var default_weapon
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var weapon = default_weapon.instance()
    print($holsters.get_child_count())
    if default_weapon != null:
        $holsters.add_child(weapon)
        print($holsters.get_child_count())

func get_input():
    look_at(get_global_mouse_position())
    if Input.is_action_pressed("player_attack_1"):
        attack1()
        
    if Input.is_action_pressed("player_attach_2"):
        attack2()
    var input = Vector2()
    input.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
    input.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
    return input

func attack1() -> void:
    pass
    
func attack2() -> void:
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
