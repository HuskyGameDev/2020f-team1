extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Continue_pressed():
    get_tree().change_scene("res://Assets/TitleScreen.tscn")


func _on_Skip_pressed():
    get_tree().change_scene("res://Assets/TitleScreen.tscn")
