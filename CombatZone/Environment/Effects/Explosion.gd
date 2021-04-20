extends Node2D

var damage = 1500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var doDamage = true


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func start_at(pos):
    position = pos
    $Particles.emitting = true
    $ExplosionSound.play()

func _on_LifeTimer_timeout():
    queue_free()
    pass # Replace with function body.


func _on_InnerRadius_body_entered(body):
    if (body.get_groups().has("flesh_damageable") and doDamage):
        body.take_damage(global_position, damage/4)
    pass # Replace with function body.


func _on_MidCollide_body_entered(body):
    if (body.get_groups().has("flesh_damageable") and doDamage):
        body.take_damage(global_position, (damage/8))
    pass # Replace with function body.


func _on_OuterCollide_body_entered(body):
    if (body.get_groups().has("flesh_damageable") and doDamage):
        body.take_damage(global_position, (damage/16))
    pass # Replace with function body.


func _on_ExplosionDamageTimer_timeout():
    doDamage = false
    pass # Replace with function body.
