extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.register_player($player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
#func _unhandled_input(event):
#    if event is InputEventMouseButton:
#            if event.button_index == BUTTON_LEFT and event.pressed:
#                var path = $Navigation2D.get_simple_path($DamageableDummy.position, $player.position)
#                $DamageableDummy.path = path
#                $Line2D.points = PoolVector2Array(path)
#                $Line2D.show()
