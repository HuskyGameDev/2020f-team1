extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func _on_weapon_shoot(bullet, pos, dir):
    var b = bullet.instance()
    add_child(b)
    b.start(pos,dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
func _unhandled_input(event):
    if event is InputEventMouseButton:
            if event.button_index == BUTTON_LEFT and event.pressed:
                var path = $Navigation2D.get_simple_path($DamageableDummy.position, get_global_mouse_position())
                $Line2D.points = PoolVector2Array(path)
                $Line2D.show()
