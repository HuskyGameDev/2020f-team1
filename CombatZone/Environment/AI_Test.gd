extends Node2D

func _ready() -> void:
    Global.register_player($player)
    Global.register_nav2D($Navigation2D)

func _unhandled_input(event):
    if event is InputEventMouseButton:
            if event.button_index == BUTTON_LEFT and event.pressed:
                pass
                #var path = $Navigation2D.get_simple_path($DamageableDummy.global_position, get_global_mouse_position())
                #$DamageableDummy.path = path
                #$Line2D.points = PoolVector2Array(path)
                #$Line2D.show()

func pathVisualize(path:PoolVector2Array):
    $Line2D.points = path
    $Line2D.show()
