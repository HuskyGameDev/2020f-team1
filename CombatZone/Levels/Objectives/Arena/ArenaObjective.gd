extends "../base_custom_objective.gd"

#Preload enemies in order to spawn them in.
var PreEnemy = preload("res://character/Proto_enemy.tscn")
var PreBeacon = preload("ArenaBeacon.tscn")

var curCount = 0

var npcInterval = 0

func _OnReady():
    _RespawnEnemies()
    pass

func _OnPreCompletionProcess():
    #Check curcount here
    pass
    
func _OnPostCompletionProcess():
    
    pass

func _PreFail():
    pass
    
func _PreCompletion():
    get_parent().curRound += 1
    #get_parent().npcMax = get_parent().curRound * 3
    if (get_parent().npcMax > get_parent().absoluteMax):
        get_parent().npcCount = get_parent().absoluteMax
    else:
        get_parent().npcCount = get_parent().npcMax
    npcInterval = 0
    
    _RespawnEnemies()
    return false
    pass

func _RespawnEnemies():
    #Start at child 0, we have only spawnpoints here.
    var interval = 0
    while (interval < get_child_count()):
        
        #Start the timer
        
        #Instance a new enemy ai
        var newEnemy = PreEnemy.instance()
        
        newEnemy._ready()
        #Add it as a child of spawnpoint so it may appear 
        
        #We need to be sure we have the proper weapon, default will not cut it.
        #We need to grab the node, unparent it and remove it before we add any new child.
        #This apparently is the way to do it, idk why, idk how, it just is
        print(newEnemy.grip.get_child_count())
        var node = newEnemy.grip.get_child(0)
            #newEnemy.grip.remove_child(n)
        node.queue_free()
        
        print(newEnemy.grip.get_child_count())
        if is_instance_valid(node):
            newEnemy.grip.remove_child(node)
            
        print(newEnemy.grip.get_child_count())
        
        #TODO: Weapon randomization
        #Now we can add a weapon to the enemy's grip without worries that the slot is taken
        var weapon = BulletFactory.get_weapon(get_child(interval)._RandomWeapon())
        #ch = newEnemy.grip.get_child(0)
        #This SHOULD be correct now due to the child removal from before.
        newEnemy.ai.weapon = weapon
        newEnemy.grip.add_child(weapon)
        print(newEnemy.grip.get_child_count())
        var test = newEnemy.grip.get_child_count()
        
        #We need to also assing a beacon to them, 
        var newBeacon = PreBeacon.instance()
        
        #The parameters need to be set, ids must be the same in order to count.
        newBeacon.objective_id = id
        newBeacon.beacon_type = 0
        newBeacon.beacon_priority = 2
        newBeacon.name = "AR1B" + str(curCount)
        
        #New enemy no longer is relevant, we just need to parent it with the enemy to make the beacon despawn on death.
        newEnemy.add_child(newBeacon)
        
        beacons.push_back(newBeacon.name)
        
        #We apparently need to use global position because position will offset it by thousands. How? IDK?
        newEnemy.global_position = get_child(interval).global_position
        
        #IDK if this is redundant but apparently having this here let's them spawn so... whatever.
        newEnemy.ai.origin_location = newEnemy.global_position
        
        #Now please acquire the player.
        newEnemy.ai.accqu_player(Global.get_player())
        newEnemy.show()
        
        get_parent()._RegisterEnemy(newEnemy)
        
        npcInterval += 1
        curCount += 1
        interval = interval + 1
        
        pass

func _OnRevealed():
    
    pass


func _on_AvailabilityTimer_timeout():
    
    pass # Replace with function body.
