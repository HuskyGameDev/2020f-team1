extends "../base_custom_objective.gd"

export(PackedScene) var PreActivateTilemap

#Preload enemies in order to spawn them in.
var PreEnemy = preload("res://character/Proto_enemy.tscn")
var PreBeacon = preload("../base_custom_beacon.tscn")
var gotPlayer = false

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
    pass

func _OnRevealed():
    #Show/create the associated enemies + beacons
    if PreActivateTilemap != null:
        PreActivateTilemap.clear()
    
    var interval = 1
    while (interval < get_child_count()):
        var newEnemy = PreEnemy.instance()
        
        
        newEnemy._ready()
        get_child(interval).add_child(newEnemy)
        newEnemy.grip.get_child(0).queue_free()
        newEnemy.grip.add_child(BulletFactory.get_weapon(get_child(interval).spawn_weapon))
        newEnemy.global_position = get_child(interval).global_position
        newEnemy.ai.origin_location = newEnemy.global_position
        newEnemy.speed = 500
        newEnemy.show()
        
        var newBeacon = PreBeacon.instance()
        newBeacon.objective_id = id
        newBeacon.beacon_type = 0
        newBeacon.beacon_priority = 2
        newEnemy.add_child(newBeacon)
        
        beacons.push_back(newBeacon.get_name())
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
                
    
    gotPlayer = true
    pass
