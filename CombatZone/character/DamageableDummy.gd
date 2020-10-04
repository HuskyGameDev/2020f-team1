extends "res://character/people.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Health.hide()
    $HealthG.hide()

func take_damage(damage_amount) -> void:
    $Health.show()
    $HealthG.show()
    health -= damage_amount
    $HealthG.scale.x = (health / totalHealth)
    print("HP percent: %f" % ((health / 100)))
    print("Damage, remaining health: %d" % health)

func get_hit(pos, damage_amount):
    $Health.show()
    $HealthG.show()
    Global.spill_blood(pos)
    #$hit_spot.global_position = pos
    #print($hit_spot.position)

    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
