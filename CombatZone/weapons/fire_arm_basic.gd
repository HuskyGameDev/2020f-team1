extends Area2D

signal shoot

export var spread: = 1.0
export var clip_size = 10
export var fire_rate = 1.0

export (PackedScene) var bullet

#onready var b_container = get_node("bullet_container")

var can_shoot: = true
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var caliber = 'default'
var remain_in_mag = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func shoot() -> void:
	#print("Called")
	if can_shoot and remain_in_mag:
		can_shoot = false
		$rate_of_fire.start()
		var dir = Vector2(1,0).rotated(global_rotation)
		Global.shoot_bullet(caliber, $muzzle.global_position, global_rotation)
		print("shooting ", caliber)
		# emit_signal('shoot', bullet, caliber, $muzzle.global_position, dir)
	
func reload() -> int:   # reload would probably return the number of bullets in the clip
	return -1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
func on_weapon_shoot():
	shoot()

func _on_rate_of_fire_timeout() -> void:
	can_shoot = true
