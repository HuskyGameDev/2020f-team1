extends Node


# OBJECTIVES: A way for us to display the current map's tasks (often required) to complete them

enum OBJECTIVE_PRIORITY {
        TYPE_NULL = -1,
        PRIORITY_PRIMARY,
        PRIORITY_SECONDARY,
        PRIORITY_HIDDEN 
   }

enum OBJECTIVE_TYPE {
    TYPE_NULL = -1,
    TYPE_DESTROY, # = 0
    TYPE_SECURE, # = 1
    TYPE_COLLECT # = 2
   }

enum OBJECTIVE_STATUS {
    TYPE_NULL = -1,
    STATUS_ONGOING,
    STATUS_SUCCESS,
    STATUS_FAIL
   }

export var id:String #Put simply, we need to be sure we can identify the objective to make most of the magic work.
                     #I chose string because I plan to identify objectives by the level in question and objective number
                     # I.E: L1O1 for the first objective of the first level.
export var descriptor:String #This is what will display on the hud, a sort of indicator of what to do.
export(OBJECTIVE_PRIORITY) var priority = OBJECTIVE_PRIORITY.TYPE_NULL #Identifies the importance or secrecy of the given objective.

export var completing_beats_level:bool = false

export(OBJECTIVE_TYPE) var obj_type = OBJECTIVE_TYPE.TYPE_NULL

var status = OBJECTIVE_STATUS.STATUS_ONGOING #Determines if the objective in question has been completed, it's pretty straight forward and goes off of objective_status enum.

var beacons = Array() #A new thing I'm trying to allow this to work both with or without being a secure objective type.

# Called when the node enters the scene tree for the first time.
func _ready():
    var current_scene = get_tree().get_current_scene()
    for node in current_scene.get_children():
        #Need to be sure we have the proper type before we check the IDs
        for child in node.get_children():
            if child.get_class() == "objective_beacon":
               #if the id is the same, we should exit the function, no need to mark as complete so long as a beacon exists
                if child.objective_id == id:
                    beacons.push_back(child.get_name())
    pass # Replace with function body.

func _OnCompleted():
    var objectives = Global.get_objectives()
    status = OBJECTIVE_STATUS.STATUS_SUCCESS #For later use, not needed to remove, but to add to the player's percentage score.
    objectives._remove_task(self, true)
    #Possibly make this a lambda function in the future?

#Uh oh, we failed one. We gotta set the status to fail and make sure it continued to display after this.
func _OnFail():
    var objectives = Global.get_objectives()
    #This will be used for every time it is printed out from here on out
    status = OBJECTIVE_STATUS.STATUS_FAIL
    #We don't technically actually remove it, but we have to notify the objectives class that this objective failed.
    objectives._remove_task(self, false)
    pass
    
func _MarkBeaconComplete(name:String):
    beacons.erase(name)
    pass
    
#This maybe should run every time a beacon is destroyed. This function will check for any beacons that correspond to itself.
#If none exist, the objective should be completed
func _CheckCompletionStatus():
    if status == OBJECTIVE_STATUS.STATUS_FAIL:
        #We have already stated that this objective has failed, there is no need to check for its beacons.
        return
    var current_scene = get_tree().get_current_scene()
    for node in current_scene.get_children():
        #Need to be sure we have the proper type before we check the IDs
        for child in node.get_children():
            if child.get_class() == "objective_beacon":
               #if the id is the same, we should exit the function, no need to mark as complete so long as a beacon exists
                if child.objective_id == id:
                    return
    #Now that we see there is nothing left, we see now if our objective type changes if we complete this or not
    #Only fail on destroy if the objective was simply to protect another thing.
    if obj_type == OBJECTIVE_TYPE.TYPE_SECURE && beacons.size() > 0:
        _OnFail()
        return
        
    _OnCompleted()
    
func _process(delta):
    _CheckCompletionStatus()

#Easier way to get a printed version of the objective based on description
func _get_objective_string() -> String:
    var description:String
    
    #Based on priority, we put a p for primary, s for secondary
    #and h for hidden but ONLY in debug mode
    #hidden objectives should be hidden in game
    if priority == 0:
        description = "P " + descriptor
    elif priority == 1:
        description = "s " + descriptor
    elif Global.debug:
        description = "h " + descriptor
    else:
        pass #Don't show anything if it's a secret.
    
    #TODO: Find a cleaner way to signify this
    #This should display even if hidden objectives fail
    if status == OBJECTIVE_STATUS.STATUS_FAIL:
        description = description + " FAILED!"
    
    return description

func get_class():
    return "level_objective"
