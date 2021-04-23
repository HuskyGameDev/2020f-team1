extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Continue_pressed():
    if (Global.game_state == Global.GAME_STATE.ENDLESS):
        get_tree().change_scene("res://Levels/Arena.tscn")
        return
    get_tree().change_scene("res://Levels/Test_Cityscape.tscn")
    pass


func _on_Skip_pressed():
    Global.game_state = Global.GAME_STATE.MENU
    get_tree().change_scene("res://Assets/TitleScreen.tscn")
    pass


func _on_Reset_Timer_timeout():
    get_tree().change_scene("res://Assets/TitleScreen.tscn")
    pass # Replace with function body.
