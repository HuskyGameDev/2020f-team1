extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    
     #For every loop, we want to be sure the AI knows the player exists, so to do that, we make sure the ai has the player set
    for n in get_children():
        if is_instance_valid(n):
            n.ai.last_known_location = Global.get_player().global_position
            n.ai.accqu_player(Global.get_player())
            
            #You might wonder why this is here
            #Well whenever we try to remove weapons as it spawns in, somehow the weapon sneaks back in
            #This code is meant to remove the second gun, even though it's unused, it would still appear visible, so we might as well remove it.
            #This realitstically should only occur once.
            if (n.grip.get_child_count() > 1):
                #Get the last child as that's certain to be the pistol.
                var oldWeapon = n.grip.get_child(n.grip.get_child_count() - 1)
                oldWeapon.queue_free()
                if (is_instance_valid(oldWeapon)):
                    n.grip.remove_child(oldWeapon)
        else:
            get_parent().npcCount -= 1
    pass
