extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.register_player($player)
    Global.register_objectives()


func _on_FutureEnemies_ready():
    if (!$FutureEnemies.visible):
        for node in $FutureEnemies.get_children():
            node.queue_free()
    pass # Replace with function body.


func _on_TempEnemies_ready():
    if (!$TempEnemies.visible):
        for node in $TempEnemies.get_children():
            node.queue_free()
    pass # Replace with function body.
