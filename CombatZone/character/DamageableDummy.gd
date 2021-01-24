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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:          # enemy don't  need holster for storing weapons at this stage of development
    var weapon = default_weapon.instance()
    print($upper_body/hand.get_child_count())
    player = Global.get_player()
    if default_weapon != null:
        $upper_body/hand.add_child(weapon)
        print($upper_body/hand.get_child_count())
        
        
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
            path = get_parent().get_node("Navigation2D").get_simple_path(position, player_pos)
            print("path assigned")
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
        $upper_body.look_at(player.position)
        $upper_body/hand.look_at(player.position)
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
