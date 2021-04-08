extends "res://character/people.gd"

# largely a copy of damageabledummy script
# tweaked for AI use

onready var ai = $AI
onready var grip = $upper_body/hand/grip    # grip grips the gun

var path := PoolVector2Array()
var direction := Vector2.ZERO
#int represents state, 0 = idle, 1 = go after player
var state = 1
var player_pos
export (PackedScene) var default_weapon
var shoot_count = 0
var can_shoot = true
var player 
var player_found = false

export var toRandom = false #Whether to spawn random enemies (toggle in level)
var random = RandomNumberGenerator.new() #For producing random number for enemy variety
var theLegs = "walkLight" #Specifies which legs to use in randomizer, walkLight is Default for light enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # enemy don't  need holster for storing weapons at this stage of development
    var weapon = default_weapon.instance()  
    
    $foot/LegAnimation.frame = 0 #Default set for leg animation frame (idle)
    # Varied enemies spawn (Randomizer pick):
    if toRandom == true:                        # how about change in health points after enemy class determination
        random.randomize()
        var rNum = random.randi_range(1, 3)
        if rNum == 1:
            $upper_body/upperbody_sprite.texture = load("res://Assets/Character(s)/Enemies/BasicEnemyLight_Idle.png")
            theLegs = "walkLight"
        if rNum == 2:
            $upper_body/upperbody_sprite.texture = load("res://Assets/Character(s)/Enemies/BasicEnemyMedium_Idle.png")
            theLegs = "walkMedium"
        if rNum == 3:
            $upper_body/upperbody_sprite.texture = load("res://Assets/Character(s)/Enemies/BasicEnemyHeavy_Idle.png")
            theLegs = "walkHeavy"
    
    print($upper_body/hand/grip.get_child_count())
    player = Global.get_player()    # get player instance
    if default_weapon != null:  # accquires weapon
        $upper_body/hand/grip.add_child(weapon)
        print($upper_body/hand/grip.get_child_count())
    ai.initialize(self, grip)
        
func _process(delta):
    # dies when not health left
    if(health <= 1):
        queue_free()

# called when no weapon in hand
func reset_weapon():
    pass
           
func go_after_player() -> void:
    if(player_found):
        player = Global.get_player()
        if(path.size() < 1 && player != null):
            player_pos = player.position
            path= get_parent().get_node("Navigation2D").get_simple_path(position, player_pos)
            print("path assigned")
            
            #Once enemy goes after player, play animation (doesn't stop);
            $upper_body/upperbody_sprite/ShoulderAnimation.play("Shoulder Movement")
            #Leg animation, doesn't stop once start following
            $foot/LegAnimation.play(theLegs)
            
        #get_parent().get_node("Line2D").points = PoolVector2Array(path)

func take_damage(pos, damage_amount) -> void:
    $health_bars.show()
    health -= damage_amount
    player_found = true
    if(health < 0):
        health = 0
    $health_bars/HealthG.scale.x = (health / totalHealth)
    Global.spill_blood(pos)
    print("HP percent: %f" % ((health / 100)))
    print("Damage, remaining health: %d" % health)

func get_input():
    dodge = Vector2.ZERO
    if(player != null && path.size() > 0):
        #Points legs towards player with shoulders
        $foot/LegAnimation.look_at(player.position)
        #The 'front' of the legs are to the side, so offset by 90 degrees
        $foot/LegAnimation.rotation_degrees = $foot/LegAnimation.rotation_degrees + 90
        
        direction = position.direction_to(path[0])
        if(position.distance_to(path[0]) > position.distance_to(player.position)):
            path.empty()
            path[0] = player.position
        direction = position.direction_to(path[0])
        if(position.distance_to(path[0]) < 2.5):
             path.remove(0)
        return direction 
    else:
          return direction

# set can_shoot false, used for reload
func i_cant_shoot() -> void:
    can_shoot = false

# check if I can shoot
func can_I_shoot() -> bool:
    return can_shoot

func _on_action_timer_timeout():
    can_shoot = true
