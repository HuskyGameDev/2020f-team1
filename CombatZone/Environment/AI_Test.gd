extends Node2D


func _unhandled_input(event):
<<<<<<< HEAD
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				var path = $Navigation2D.get_simple_path($DamageableDummy.position, get_global_mouse_position())
				$DamageableDummy.path = path
				$Line2D.points = PoolVector2Array(path)
				$Line2D.show()
=======
    if event is InputEventMouseButton:
            if event.button_index == BUTTON_LEFT and event.pressed:
                var path = $Navigation2D.get_simple_path($DamageableDummy.global_position, get_global_mouse_position())
                $Line2D.points = PoolVector2Array(path)
                $Line2D.show()
>>>>>>> c41364b93b82f4546dce866a94cdc9f2d57f3ab1
