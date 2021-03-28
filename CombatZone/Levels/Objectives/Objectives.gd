extends Node2D


#OBJECTIVES: Will show each and every objective on the current level.
export (Array, PackedScene) var objectives = Array() #This stores the levels objectives by their pack scene files.
var activeClocks = Array() #Stores the active clocks so that we may go and remove them at a notice.
export var completing_beats_level:bool = false
var obj_listing:String
var obj_complete_counter = 0

var clock = preload("res://character/Clock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    #if ply == null:
    #    return
    var current_scene = get_tree().get_current_scene()
    
    for node in current_scene.get_children():
        if node.get_class() == "level_objective":
            if (objectives.count(node) == 0 && node.disabled == false):
                objectives.append(node)
        if node.get_child_count() > 0:
            RootObjectives(node)
    
    pass # Replace with function body.

func RootObjectives(node):
    for child in node.get_children():
        if (child.get_class() == "level_objective"):
            if (objectives.count(child) == 0 && child.disabled == false):
                objectives.append(child)
        if child.get_child_count() > 0:
            RootObjectives(child)
    pass

#This assumes that the variable actually listing the objectives is empty to begin with
func _initial_display():
    var ply = Global.get_player()
    display(ply)
    
#Adds the text for each objective yet to be completed on the player's screen
func display(ply):
    var oInterval = 0
    if (objectives.empty()):
        return
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
    
    if oInterval >= objectives.size():
        return
    
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
        if (ply._update_objectives(node._get_objective_string() + "\n", offset, node.status, priority) == true):    
            offset = offset + 1
            pass
        
        oInterval = (oInterval + 1) if oInterval < objectives.size() - 1 else 0
        node = objectives[oInterval]
        
    pass
pass
    #Added a function call to player so they're the class resposible for managing their children.
    

func _remove_task(task:Node, destroy:bool):
    _forceStopClock(task.id)
    obj_complete_counter = obj_complete_counter + 1
    _show_hidden_on_requirement(task.name)
    if destroy:
        objectives.erase(task)
        obj_complete_counter = obj_complete_counter - 1
        #TODO: Calculate new score based on whether we passed or failed the mission.
    if ((obj_complete_counter >= objectives.size()) && completing_beats_level):
        Global.scene_change_path("res://Assets/TitleScreen.tscn") #For now using this function until I understand the use behind scene_change function.
        return
    _redisplay_objectives()    

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

func _createClock(beacon):

    var cl = clock.instance()
    var pl = Global.get_player()
    var offset = ((-1)*activeClocks.size())
    cl._Initialize(beacon.timer_length, beacon.objective_id, beacon.name)
    cl.position = Vector2(1000, ((-500)+(-180*offset)))
    cl.scale = Vector2(5, 5)
    pl.add_child(cl)
    pl._OnTimerStart()
    activeClocks.push_front(cl)
    
    pass

func _forceStopClock(id):

    if activeClocks.empty():
        return

    for node in activeClocks:
        if (id == node.objID):
            node._EndClockPremature()
            return
        pass
        
    pass
    
func _removeClock(id):
    
    if activeClocks.empty():
        return
        
    var obj = _get_objective(id)
    
    for node in activeClocks:
        
        if (id == node.objID):
            Global.get_player().remove_child(node)
            if (obj != null):
                if (node.premature):
                    match obj.obj_type:
                        1:
                            obj._OnFail()
                        _:
                            obj._MarkBeaconComplete(node.beaconName)
                else:
                    match obj.obj_type:
                        1:
                            obj._MarkBeaconComplete(node.beaconName)
                        _:
                            obj._OnFail()
            
            activeClocks.remove(activeClocks.find(node))
            var pl = Global.get_player()
            if activeClocks.empty():
                pl._OnTimerEnd()    
            node.queue_free()
            #Either here or somewhere else we inform the objective
            return
    
    pass

func _show_hidden_on_requirement(name:String):
    for node in objectives:
        if (node.objective_requirement == name):
            node.priority = node.realPriority
        pass
    return
pass

func _SoundQueue(status, priority):
    
    match status:
        1:
            match priority:
                0:
                    $MainComplete.play()
                _:
                    $SideComplete.play()
            return
        _:
            $ObjFail.play()        
            
    
    pass

func get_class():
    return "Objectives"

#Custom functions: To be used in classes that inherit this one.
