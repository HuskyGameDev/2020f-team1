extends "res://character/people.gd"

var player
var path := PoolVector2Array()
#int represents state, 0 = idle, 1 = go after player
var state = 1
var player_pos
export (PackedScene) var default_weapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Health.hide()
    $HealthG.hide()
    var weapon = default_weapon.instance()
    print($holsters.get_child_count())
    if default_weapon != null:
        $holsters.add_child(weapon)
        print($holsters.get_child_count())
        
        
func _process(delta):
    if(health <= 1):
        queue_free()
    go_after_player()
    if(player!= null):
        if(position.distance_to(player.position) < 500):
            shoot_player()

func shoot_player() -> void:
    if $holsters.get_child_count()>0:
        $holsters.get_child(0).shoot()
    
#func state_change() -> void:
#    if(player != null):
#        print("distance ", position.distance_to(player.position))
#        if(position.distance_to(player.position) > 100):
#            print("change state ", state)
#            state = 1
#            go_after_player(state)
#        else:
#            print("change state ", state)
#            path.empty()
#            state = 0

func go_after_player() -> void:
    if(player != null):
        if(path.size() < 1):
            player_pos = player.position
            path = get_parent().get_node("Navigation2D").get_simple_path(position, player_pos)
            print("path assigned")
        get_parent().get_node("Line2D").points = PoolVector2Array(path)
        get_parent().get_node("Line2D").show()

func take_damage(pos, damage_amount) -> void:
    $Health.show()
    $HealthG.show()
    health -= damage_amount
    if(health < 0):
        health = 0
    $HealthG.scale.x = (health / totalHealth)
    Global.spill_blood(pos)
    print("HP percent: %f" % ((health / 100)))
    print("Damage, remaining health: %d" % health)

func get_input():
    dodge = Vector2.ZERO
    if(player != null && path.size() > 0):
        look_at(player.position)
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
        player = body
