extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var weapons = ['9mmloader', 'magnum', 'mac10', 'sawn_off_boom', 'rpg']

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
    timer = get_child(0)
    pass # Replace with function body.

func _RandomWeapon():
    #Just gives us a random weapon from the array
    #I'm too fucking stressed to deal with getting a random value from a dictionary, sorry not sorry Zong
    return weapons[randi() % (weapons.size())]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_AvailabilityTimer_timeout():
    get_parent()._RespawnEnemies()
    pass # Replace with function body.
