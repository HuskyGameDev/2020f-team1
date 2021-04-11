extends Node2D

# author: ZD

# a script to attach to AI node for enemy use
class_name AI # what is this

signal state_change(new_state)  # signal for state changing

# State enumerator for AI
enum State {
    PATROL,
    ENGAGE,
    SEARCH
   }

export var agility = 0.1            # affects how fast ai can turn and look around
export var patrol_stand_timeout = 3 # a timer determining how long actor stays at one patrol point
export var patrol_range = 20        # how far from origin point does actor patrol to
export var engage_timeout = 2       # a timer that breaks engagement when I can't see target
                                    # with ray cast
export var search_timeout = 7       # a timer that return ai to patrol when search took too long

onready var player_detection_zone = $AIDetection

# States
var current_state: int = State.PATROL setget set_state
var origin_location := Vector2.ZERO 
# Patrol
var patrol_location := Vector2.ZERO
var patrol_location_reached := false
var patrol_waitTime := 3    # how long of a wait time before patroling to the next waypoint

# targetting
var player: Player = null   # reference to target
var last_known_location: = Vector2.ZERO  # last known location of target  

# references to the actor
var actor: KinematicBody2D = null
var upperBody = null
var hand = null
var aim = null
var sight = null
var weapon: Weapon = null

var navi2D : Navigation2D = null
var path := PoolVector2Array()  # path from navi2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

func accquire_Nav2D():
    navi2D = Global.get_nav2D()

# get reference of actor and weapon
# from parent(actor) to AI
func initialize(mySelf, grip):    
    # set actor
    actor = mySelf
    upperBody = actor.get_node('upper_body')
    hand = upperBody.get_node('hand')
    aim = upperBody.get_node('head')
    sight = aim.get_node('RayCast2D')
    
    # Set position
    origin_location = actor.global_position
    
    # accquire navigation2D of level from Global
    accquire_Nav2D()
    
    # a way to get items from actors
    # print('upper_body has children: ', actor.get_node('upper_body').get_child_count())
    if grip.get_child_count()>0:    # hand has weapon, set weapon
        weapon = grip.get_child(0)  # first weapon is weapon
        if Global.debug:
            print('AI weapon set')
    else:
        print("enemy has no weapon in hand")

func _process(delta: float) -> void:
    # align detection triangle with body
    $AIDetection.rotation = upperBody.rotation
    
    # state behaviour switch
    if current_state != null:
        match current_state:
            State.PATROL:
                if not patrol_location_reached: # actor not reach patrol point yet
                    if not path.empty():    #  as long as there are waypoints, move to next point
                        actor.direction = actor.global_position.direction_to(path[0])   # get direction to first way point in the array
                        upperBody.rotation = lerp(upperBody.rotation, upperBody.global_position.direction_to(path[0]).angle(), agility)
                        if actor.global_position.distance_to(path[0]) < 5:
                            path.remove(0)
                    elif $Patrol_timer.is_stopped():
                        $Patrol_timer.start(patrol_stand_timeout)   # actor wait at patrol point till timeout
                        
                    patrol_location_reached = actor.global_position.distance_to(patrol_location) < 5
                elif $Patrol_timer.is_stopped():
                    $Patrol_timer.start(patrol_stand_timeout)   # actor wait at patrol point till timeout
                    print('patrol time start: ', patrol_stand_timeout)
            State.ENGAGE:
                if player != null and weapon != null:
                    # body face target
                    upperBody.rotation = lerp(upperBody.rotation, upperBody.global_position.direction_to(player.global_position).angle(), agility)
                    hand.global_rotation = lerp(hand.global_rotation, hand.global_position.direction_to(player.global_position).angle(), agility/2)
                    if sight.get_collider() == player:
                        $Engage_timer.stop()
                        if actor.can_shoot:
                            aiAttack()
                    else:
                        # start timing when lose sight of target
                        if $Engage_timer.is_stopped():
                            last_known_location = player.global_position    # record location for search state
                            $Engage_timer.start(engage_timeout)
                        
                else:
                    print('In the engage state but no weapon/player')
            State.SEARCH:
                pass
            var new_emu:
                print("Error: found a state for our enemy that should not exist: ", new_emu)
    else:
        current_state = State.PATROL

func _physics_process(delta: float) -> void:
    # get space state for RayCast collision quary
    #var space_state = get_world_2d().direct_space_state
    #var result = space_state.interesect_ray()
    pass

func next_patrol_point():
    randomize()
    var randx = rand_range(-patrol_range, +patrol_range)
    var randy = rand_range(-patrol_range, +patrol_range)
    patrol_location = Vector2(randx ,randy) + origin_location
    print('patrol location is x: ', randx)
    print('y: ', randy)

func aiAttack()-> void:
    if !weapon.shoot(): # if gun shooting returns false, clip empty
        print('ai reloading')
        weapon.add_ammo(weapon.get_clip_size())
        var time_returned = weapon.reload_weap()
        print('after reload magazine clip fullis : ', weapon.clip_full())
        actor.i_cant_shoot()
        print('reload takes: ', time_returned)
        actor.get_node('action_timer').start(time_returned)
    
# Stops all state timers
# incase timers from other states switches state
func stop_timers():
    $Engage_timer.stop()
    $Patrol_timer.stop()
    $Search_timeOut.stop()

func set_state(new_state: int):
    print('setting ai state: ', new_state)
    if new_state == current_state:
        return        
    current_state = new_state
    stop_timers()
    print('ai now in state: ', current_state)
    emit_signal('state_change', current_state)

# called when detected beody entering, check if target behind wall
# return bool
func checkout_target(target) -> bool:
    var old_rotation = aim.rotation # old rotation for reset after target check
    var see_target = false  # return value
    # scan toward target direction
    aim.rotation = aim.global_position.direction_to(target.global_position).angle()
    
    # force raycast update to avoid
    # waiting for _physics_proccess'es update
    sight.force_raycast_update()
    if sight.get_collider() == target:  # target not behind wall
        see_target = true
    # aim.rotation = old_rotation
    aim.rotation = old_rotation
    return see_target

# When target enter detection zone,
# if raycast reaches target, switch to engage
func _on_AIDetertion_body_entered(body: Node) -> void:
    print('ai red detected: ', body)
    if body.is_in_group('player'):  # Checks whether body is player group 
                                    # could change to other groups if player has allies
        if checkout_target(body):
            player = body
            if Global.debug:
                print('AI added player')
            set_state(State.ENGAGE)
    else:
        print('this is not player: ', body)
    
        
# get player, change state to engage
func get_player(player_in):
    if player != player_in: # get reference
        player = player_in
    set_state(State.ENGAGE)

# set to search when engage timed out
func _on_Engage_timer_timeout() -> void:
    if player != null:
        set_state(State.SEARCH)
    

# upon time out move to next patrol waypoint
func _on_Patrol_timer_timeout() -> void:
    print('patrol timer timedout')
    # accquire next point
    next_patrol_point()
    if navi2D != null:  # check navi2D availabilities
        path = navi2D.get_simple_path(global_position, patrol_location) # accquire path
    else:
        accquire_Nav2D() # reaccquire navigation
    if get_parent().get_parent().has_node('Line2D'):
        get_parent().get_parent().pathVisualize(path) # path visualize
    # reset patrol status
    patrol_location_reached = false

# when time out, go back to patrol
func _on_Search_timeOut_timeout() -> void:
    set_state(State.PATROL)
