extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Weapon_body_entered(body):
	print("detected")
	print(body.get_name())
	body.take_damage(5)
