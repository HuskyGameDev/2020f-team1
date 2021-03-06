extends "res://character/people.gd"

var path := PoolVector2Array()
#int represents state, 0 = idle, 1 = go after player
var state = 1
var player_pos
export (PackedScene) var default_weapon
var shoot_count = 0
var can_shoot = true
var player 
var player_found = false

var toRandom = false #Whether to spawn random enemies (toggle in level)
var random = RandomNumberGenerator.new() #For producing random number for enemy variety
var theLegs = "walkLight" #Specifies which legs to use in randomizer, walkLight is Default for light enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:          # enemy don't  need holster for storing weapons at this stage of development
    var weapon = default_weapon.instance()
    $foot/LegAnimation.frame = 0 #Default set for leg animation frame (idle)
    # Varied enemies spawn (Randomizer pick):
    if toRandom == true:
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
    
    #print($upper_body/hand.get_child_count())
    player = Global.get_player()
    if default_weapon != null:
        $upper_body/hand.add_child(weapon)
        #print($upper_body/hand.get_child_count())
        
        
func _process(delta):
    if(health <= 1):
        queue_free()
    go_after_player()
    if(player_found && player != null):
        if(position.distance_to(player.position) < 1000):
            shoot_player()

func shoot_player() -> void:
    if $upper_body/hand.get_child_count() > 0 && can_shoot:
        if shoot_count > 100:
            shoot_count = 0
            $action_timer.start()
            can_shoot = false
        else:
            shoot_count += 1
            $upper_body/hand.get_child(0).shoot()
           
func go_after_player() -> void:
    if(player_found):
        player = Global.get_player()
        if(path.size() < 1 && player != null):
            player_pos = player.position
            path= get_parent().get_node("Navigation2D").get_simple_path(position, player_pos)
            #print("path assigned")
            
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
#    print("HP percent: %f" % ((health / 100)))
#    print("Damage, remaining health: %d" % health)

func get_input():
    dodge = Vector2.ZERO
    if(player != null && path.size() > 0):
        $upper_body.look_at(player.position)
        $upper_body/hand.look_at(player.position)
        
        #Points legs towards player with shoulders
        $foot/LegAnimation.look_at(player.position)
        #The 'front' of the legs are to the side, so offset by 90 degrees
        $foot/LegAnimation.rotation_degrees = $foot/LegAnimation.rotation_degrees + 90
        
        var direction = position.direction_to(path[0])
        if(position.distance_to(player.position) < 250):
            var rand = randi()%100+1
            if(rand == 1): 
                dodge = Vector2(-direction.y, direction.x) * 400
                return Vector2(-direction.y, direction.x)
            elif(rand == 2): 
                dodge = Vector2(direction.y, -direction.x) * 400
                return Vector2(direction.y, -direction.x)
            else: 
                return Vector2(-direction.x, -direction.y)
        if(position.distance_to(path[0]) > position.distance_to(player.position)):
            path.empty()
            path[0] = player.position
        direction = position.direction_to(path[0])
        if(position.distance_to(path[0]) < 2.5):
             path.remove(0)
        return direction 
    else:
          return Vector2(0, 0)  

func _on_range_body_entered(body):
    print(body.position)
    if(body.get_groups().has("player")):
        player_found = true

func _on_action_timer_timeout():
    can_shoot = true
