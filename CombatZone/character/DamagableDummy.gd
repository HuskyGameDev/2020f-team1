extends "res://character/people.gd"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func take_damage(damage_amount):
	health -= damage_amount
	print("Damage -5")


