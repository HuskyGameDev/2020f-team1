extends Node2D


func _unhandled_input(event):
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				var path = $Navigation2D.get_simple_path($DamageableDummy.position, get_global_mouse_position())
				$DamageableDummy.path = path
				$Line2D.points = PoolVector2Array(path)
				$Line2D.show()
