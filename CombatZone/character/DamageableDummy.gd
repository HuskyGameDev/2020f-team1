extends "res://character/people.gd"


var path := PoolVector2Array()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Health.hide()
    $HealthG.hide()

func take_damage(pos, damage_amount) -> void:
    $Health.show()
    $HealthG.show()
    health -= damage_amount
    if(health < 0):
        health = 0
    $HealthG.scale.x = (health / totalHealth)
    Global.spill_blood(pos)
    print("HP percent: %f" % ((health / 100)))
    print("Damage, remaining health: %d" % health)

func get_input():
    if(path.size() > 0):
        print("Inside if")
        var direction = position.direction_to(path[0])
        print("size: ", path.size())
        if(position.distance_to(path[0]) < 2.5):
            path.remove(0)
        return direction
    else: 

        return Vector2(0, 0)    

