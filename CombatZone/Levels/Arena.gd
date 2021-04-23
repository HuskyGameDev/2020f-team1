extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var curRound = 1 # The round the player is on, this determines how many npcs are to spawn
var npcCount = 4 # The current number of npcs set to spawn
var npcMax = 4 # The max number of npcs to spawn
var absoluteMax = 25 # This is a set number determining how many NPCs can be on screen at a time.
var respawnDelay = 0 #A simple integrated timer that will allow npcs breathing room when spawning in new waves. 4 at a time unfortunatley, but at least they're all moving towards the player.


var EnemyList

var Objective

# Called when the node enters the scene tree for the first time.
func _ready():
    Global.register_player($player)
    Global.register_objectives()
    Global.register_nav2D($Navigation2D)
    Global.game_state = Global.GAME_STATE.ENDLESS
    EnemyList = $AIGroup
    Objective = $AR1
    
    curRound = 1
    npcCount = 4
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _RegisterEnemy( enemy ):
    if (not is_instance_valid(EnemyList)):
        EnemyList = $AIGroup
    
    if (EnemyList.get_child_count() >= absoluteMax):
        enemy.queue_free()
        return
    
    if (EnemyList.get_child_count() >= npcCount):
        enemy.queue_free()
        return
    
    enemy.connect("on_death", self, "_on_Enemy_on_Death")
    EnemyList.add_child(enemy)
    pass

func _on_Enemy_on_Death():
    print("Oh I died")
    pass
