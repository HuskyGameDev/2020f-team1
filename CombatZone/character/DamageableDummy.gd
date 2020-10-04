extends "res://character/people.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Health.hide()
    $HealthG.hide()

func take_damage(pos, damage_amount) -> void:
    $Health.show()
    $HealthG.show()
    health -= damage_amount
    $HealthG.scale.x = (health / totalHealth)
    Global.spill_blood(pos)
    print("HP percent: %f" % ((health / 100)))
    print("Damage, remaining health: %d" % health)

    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
