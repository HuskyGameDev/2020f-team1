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

export var agility = 0.1        # affects how fast ai can turn and look around
export var engage_timeout = 2   # a timer that breaks engagement when I can't see target
                                # with ray cast
export var search_timeout = 7   # a timer that return ai to patrol when search took too long

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# get reference of actor and weapon
# from parent(actor) to AI
func initialize(mySelf, grip):
    # Set position
    origin_location = self.global_position
    
    # set actor
    actor = mySelf
    upperBody = actor.get_node('upper_body')
    hand = upperBody.get_node('hand')
    aim = upperBody.get_node('head')
    sight = aim.get_node('RayCast2D')
    
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
                pass
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

func _physics_process(delta: float) -> void:
    # get space state for RayCast collision quary
    #var space_state = get_world_2d().direct_space_state
    #var result = space_state.interesect_ray()
    pass

func aiAttack()-> void:
    if !weapon.shoot(): # if gun shooting returns false, clip empty
        print('ai reloading')
        weapon.add_ammo(weapon.get_clip_size())
        var time_returned = weapon.reload_weap()
        print('after reload magazine clip fullis : ', weapon.clip_full())
        actor.i_cant_shoot()
        print('reload takes: ', time_returned)
        actor.get_node('action_timer').start(time_returned)
    
func set_state(new_state: int):
    print('setting ai state: ', new_state)
    if new_state == current_state:
        return        
    current_state = new_state
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
    if body.is_in_group('player'):  # Checks whether body is player group
        if checkout_target(body):   # could change to other groups if player has allies
            player = body
            if Global.debug:
                print('AI added player')
            set_state(State.ENGAGE)
        
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
    # accquire next point
    # go to next point
    # reset timer
    # reset patrol status
    patrol_location_reached = false
    pass # Replace with function body.

# when time out, go back to patrol
func _on_Search_timeOut_timeout() -> void:
    set_state(State.PATROL)
