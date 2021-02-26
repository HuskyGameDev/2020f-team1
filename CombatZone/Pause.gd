extends Control
onready var scene_tree: = get_tree()
onready var pause_menu: ColorRect = get_node("PauseOverlay")
var already_paused = false setget set_paused

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var player

func _ready():
    player = get_node("/root/Root/Player")

func _input(event):
    if event.is_action_pressed("menu"):
        self.already_paused = not already_paused
            
func set_paused(value: bool) -> void:
    already_paused = value
    scene_tree.paused = value
    pause_menu.visible = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


#Reload current level
func _on_Restart_pressed():
    get_tree().reload_current_scene()
    

#Quit game
func _on_Quit_pressed():
    get_tree().quit()
