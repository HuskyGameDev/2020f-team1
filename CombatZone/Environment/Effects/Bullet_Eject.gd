extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready() -> void:
    $Timer.wait_time = $".".lifetime + 1
    $Timer.start()
    print($Timer.wait_time)

func start_at(pos):
    position = pos
    emitting = true


func _on_Timer_timeout() -> void:
    print("moping shells")
    queue_free()
