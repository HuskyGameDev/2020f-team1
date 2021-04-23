extends "../base_custom_objective.gd"

export(PackedScene) var PreActivateTilemap

#Preload enemies in order to spawn them in.
var PreEnemy = preload("res://character/Proto_enemy.tscn")
var PreBeacon = preload("../base_custom_beacon.tscn")

func _OnReady():
    PreActivateTilemap = get_child(0)
    pass

func _OnPreCompletionProcess():
#    if (gotPlayer == true):
#        var interval = 1
#        gotPlayer = false
#        while (interval < get_child_count()):
#            get_child(interval).get_child(0).ai.accqu_player(Global.get_player())
#            get_child(interval).get_child(0).ai.accqu_player(Global.get_player())
#            get_child(interval).get_child(0).ai.last_known_location = Global.get_player().global_position
#            interval = interval + 1
#            pass
#        pass
    pass
    
func _OnPostCompletionProcess():
    pass

func _PreFail():
    pass
    
func _PreCompletion():
    return true
    pass

func _OnRevealed():
    #Show/create the associated enemies + beacons
    if PreActivateTilemap != null:
        PreActivateTilemap.clear()
    
    #Start at child 1 since child 0 is reserved for the tilemap we clear upon reveeling the objective
    var interval = 1
    while (interval < get_child_count()):
        
        #Instance a new enemy ai
        var newEnemy = PreEnemy.instance()
        
        newEnemy._ready()
        #Add it as a child of spawnpoint so it may appear 
        get_child(interval).add_child(newEnemy)
        
        #We need to be sure we have the proper weapon, default will not cut it.
        #We need to grab the node, unparent it and remove it before we add any new child.
        var ch = newEnemy.grip.get_child(0)
        newEnemy.grip.remove_child(ch)
        ch.queue_free()
        
        #Now we can add a weapon to the enemy's grip without worries that the slot is taken
        newEnemy.grip.add_child(BulletFactory.get_weapon(get_child(interval).spawn_weapon))
        #This SHOULD be correct now due to the child removal from before.
        newEnemy.ai.weapon = newEnemy.grip.get_child(0)
        
        #We apparently need to use global position because position will offset it by thousands. How? IDK?
        newEnemy.global_position = get_child(interval).global_position
        
        #IDK if this is redundant but apparently having this here let's them spawn so... whatever.
        newEnemy.ai.origin_location = newEnemy.global_position
        
        #Now please acquire the player.
        newEnemy.ai.accqu_player(Global.get_player())
        newEnemy.ai.last_known_location = Global.get_player().global_position
        newEnemy.show()
        
        #We need to also assing a beacon to them, 
        var newBeacon = PreBeacon.instance()
        
        #The parameters need to be set, ids must be the same in order to count.
        newBeacon.objective_id = id
        newBeacon.beacon_type = 0
        newBeacon.beacon_priority = 2
        
        #New enemy no longer is relevant, we just need to parent it with the enemy to make the beacon despawn on death.
        get_child(interval).get_child(0).add_child(newBeacon)
        
        beacons.push_back(newBeacon.name)
        interval = interval + 1
        pass
        
    var current_scene = get_tree().get_current_scene()
    for node in current_scene.get_children():
        #Need to be sure we have the proper type before we check the IDs
        if (node.get_class() == "objective_beacon"):
            if node.objective_id == id:
                node.get_parent().ai.accqu_player(Global.get_player())
                node.get_parent().ai.last_known_location = Global.get_player().global_position
                node.get_parent().speed = 500
                
    
    pass
