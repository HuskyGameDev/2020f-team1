extends Node2D

var damage = 500

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

#Simply start the particle system, make them appear and play.
func start_at(pos, dmg):
    damage = dmg
    position = pos
    $Particles.emitting = true
    $ExplosionSound.play()

#There is a timer given for the explosion, this one is a bit longer than the damage timer
#Simply because we want to have the particles appear properly and for a bit.
func _on_LifeTimer_timeout():
    queue_free()
    pass # Replace with function body.


func _on_InnerRadius_body_entered(body):
    #if (body.get_groups().has("flesh_damageable") and doDamage):
    #    body.take_damage(global_position, damage/4)
    pass # Replace with function body.


func _on_MidCollide_body_entered(body):
    #if (body.get_groups().has("flesh_damageable") and doDamage):
    #    body.take_damage(global_position, (damage/8))
    pass # Replace with function body.


func _on_OuterCollide_body_entered(body):
    if (body.get_groups().has("flesh_damageable") and doDamage):
        #We want to determine damage by the distance,
        #By using a vector distance equation:
        # d = sqrt((x1-x2)^2+(y1-y2)^2
        # WE can get the distance the entity should be from the explosion
        # And considering that we have negative coordinates here
        # We want to apply absolute values to the subtractions we perform
        # So if x1-x2 is negative, we must perform abs to ensure we have a valid distance still
        var distance = sqrt((pow(abs($OuterCollide.global_position.x-body.global_position.x), 2)+(pow(abs($OuterCollide.global_position.y-body.global_position.y), 2))))

        #Now be sure to take away damage based on how far away from the center of the explosion the entity is.       
        body.take_damage(body.global_position, (damage-distance))
    pass # Replace with function body.

#
func _on_ExplosionDamageTimer_timeout():
    doDamage = false
    pass # Replace with function body.
