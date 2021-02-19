extends Node


#OBJECTIVES: Will show each and every objective on the current level.
export (Array, PackedScene) var objectives = Array() #This stores the levels objectives by their pack scene files.
export var completing_beats_level:bool = false
var obj_listing:String

# Called when the node enters the scene tree for the first time.
func _ready():
    #if ply == null:
    #    return
    var current_scene = get_tree().get_current_scene()
    
    for node in current_scene.get_children():
        if node.get_class() == "level_objective":
            if (objectives.count(node) == 0):
                objectives.append(node)
    
    pass # Replace with function body.

#This assumes that the variable actually listing the objectives is empty to begin with
func _initial_display():
    var ply = Global.get_player()
    display(ply)
    
#Adds the text for each objective yet to be completed on the player's screen
func display(ply):
    for node in objectives:
        var obj_string = node._get_objective_string()
        obj_listing = obj_listing + obj_string + "\n"
        pass
    #Added a function call to player so they're the class resposible for managing their children.
    ply._update_objectives(obj_listing)

func _remove_task(task:Node, complete:bool):
    objectives.erase(task)
    #TODO: Calculate new score based on whether we passed or failed the mission.
    _redisplay_objectives()    
    if ((objectives.size() <= 0) && completing_beats_level):
        Global.scene_change_path("res://assets/TitleScreen.tscn") #For now using this function until I understand the use behind scene_change function.

#This is the time where it redisplays the objectives after one is completed or removed.
#It clears the text from the player's screen and displays a new set which more correctly shows the objectives.
func _redisplay_objectives():
    var ply = Global.get_player()
    ply._clear_objectives()
    obj_listing = ""
    display(ply)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

