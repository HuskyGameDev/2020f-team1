extends Node


# OBJECTIVES: A way for us to display the current map's tasks (often required) to complete them

enum OBJECTIVE_PRIORITY {
        TYPE_NULL = -1,
        PRIORITY_PRIMARY,
        PRIORITY_SECONDARY,
        PRIORITY_HIDDEN 
   }

export var id:String #Put simply, we need to be sure we can identify the objective to make most of the magic work.
                     #I chose string because I plan to identify objectives by the level in question and objective number
                     # I.E: L1O1 for the first objective of the first level.
export var descriptor:String #This is what will display on the hud, a sort of indicator of what to do.
export(OBJECTIVE_PRIORITY) var priority = OBJECTIVE_PRIORITY.TYPE_NULL #Identifies the importance or secrecy of the given objective.

var complete:bool = false #Determines if the objective in question has been completed, it's false by default and self explanatory.


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _OnCompleted():
    var objectives = Global.get_objectives()
    complete = true #For later use, not needed to remove, but to add to the player's percentage score.
    objectives._remove_task(self, true)
    #Possibly make this a lambda function in the future?

#This maybe should run every time a beacon is destroyed. This function will check for any beacons that correspond to itself.
#If none exist, the objective should be completed
func _CheckCompletionStatus():
    var current_scene = get_tree().get_current_scene()
    for node in current_scene.get_children():
        #Need to be sure we have the proper type before we check the IDs
        for child in node.get_children():
            if child.get_class() == "objective_beacon":
               #if the id is the same, we should exit the function, no need to mark as complete so long as a beacon exists
                if child.objective_id == id:
                    return
    _OnCompleted()
    
func _process(delta):
    _CheckCompletionStatus()

#Easier way to get a printed version of the objective based on description
func _get_objective_string() -> String:
    var description:String
    
    if priority == 0:
        description = "P " + descriptor
    elif priority == 1:
        description = "s " + descriptor
    elif Global.debug:
        description = "h " + descriptor
    else:
        pass #Don't show anything if it's a secret.
    return description

func get_class():
    return "level_objective"
