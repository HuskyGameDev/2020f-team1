extends Node


#OBJECTIVES: Will show each and every objective on the current level.
export (Array, PackedScene) var objectives = Array() #This stores the levels objectives by their pack scene files.
export var completing_beats_level:bool = false
var obj_listing:String
var obj_complete_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    #if ply == null:
    #    return
    var current_scene = get_tree().get_current_scene()
    
    for node in current_scene.get_children():
        if node.get_class() == "level_objective":
            if (objectives.count(node) == 0 && node.disabled == false):
                objectives.append(node)
    
    pass # Replace with function body.

#This assumes that the variable actually listing the objectives is empty to begin with
func _initial_display():
    var ply = Global.get_player()
    display(ply)
    
#Adds the text for each objective yet to be completed on the player's screen
func display(ply):
    var oInterval = 0
    var fNode = objectives[oInterval]
    var offset = 0
    
    match fNode.priority:
        0:
            #If Primary, display first
            ply._update_objectives(fNode._get_objective_string() + "\n", offset, fNode.status, 0)
            offset = offset + 1
            continue
        _:
            #Else, display later
            oInterval = oInterval + 1
    
    var node = objectives[oInterval]
    var priority = 0
    while (priority < 3):
        
        #FIRSTLY: Check to see if the id of the current is equal to the first node
        #Important because if we don't check this, it's an infinite circle.
        if (node.id == fNode.id):
            priority = priority + 1
            oInterval = (oInterval + 1) if oInterval < objectives.size() - 1 else 0
            node = objectives[oInterval]
            continue
        pass
        
        #We should check the priority second  to see if they're the right priority
        #Remember it goes Primary, secondary, then hidden.
        if (priority != node.priority):
            oInterval = (oInterval + 1) if oInterval < objectives.size() - 1 else 0
            node = objectives[oInterval]
            continue
        pass
        
        #Should be assumed by now priority is the same, and the node is unique, so we should print.
        ply._update_objectives(node._get_objective_string() + "\n", offset, node.status, priority)
        offset = offset + 1
        oInterval = (oInterval + 1) if oInterval < objectives.size() - 1 else 0
        node = objectives[oInterval]
        
    pass
pass
    #Added a function call to player so they're the class resposible for managing their children.
    

func _remove_task(task:Node, destroy:bool):
    if destroy:
        objectives.erase(task)
        obj_complete_counter = obj_complete_counter - 1
        #TODO: Calculate new score based on whether we passed or failed the mission.
    obj_complete_counter = obj_complete_counter + 1
    _show_hidden_on_requirement(task.name)
    _redisplay_objectives()    
    if ((obj_complete_counter >= objectives.size()) && completing_beats_level):
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

func _get_objective(name:String):
    for node in objectives:
        if (name == node.id):
            return node
        pass
    return null
pass

func _show_hidden_on_requirement(name:String):
    for node in objectives:
        if (node.objective_requirement == name):
            node.priority = node.realPriority
        pass
    return
pass

#Custom functions: To be used in classes that inherit this one.
