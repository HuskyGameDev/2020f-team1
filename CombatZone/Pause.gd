extends PopupMenu
var already_paused
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var player

func _ready():
	player = get_node("/root/Root/Player")
func _input(event):
	if not visible:
		if Input.is_action_just_pressed("menu"):
			# Pause game
			already_paused = get_tree().paused
			get_tree().paused = true
			# Reset the popup
			popup()
	else:
		if Input.is_action_just_pressed("menu"):
			get_tree().paused = false
			hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
