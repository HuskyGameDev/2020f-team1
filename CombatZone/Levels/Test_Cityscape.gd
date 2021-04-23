extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    #Register the player, objective systen, and navigation pathing.
    Global.register_player($player)
    Global.register_objectives()
    Global.register_nav2D($Navigation2D)
    Global.game_state = Global.GAME_STATE.STORY


func pathVisualize(path:PoolVector2Array):
    $Line2D.points = path
    #$Line2D.show()
