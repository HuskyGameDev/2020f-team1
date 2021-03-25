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

export var agility = 0.1
export var engage_timeout = 2   # a timer that breaks engagement when I can't see target
                                # with ray cast

onready var player_detection_zone = $AIDetection

var current_state: int = State.PATROL setget set_state

var actor = null
var player: Player = null
var weapon: Weapon = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

# get reference of actor and weapon
func initialize(mySelf, grip):
    actor = mySelf
    
    # a way to get items from actors
    # print('upper_body has children: ', actor.get_node('upper_body').get_child_count())
    if grip.get_child_count()>0:    # hand has weapon, set weapon
        weapon = grip.get_child(0)  # first weapon is weapon
        if Global.debug:
            print('AI weapon set')
    else:
        print("enemy has no weapon in hand")

func _process(delta: float) -> void:
    if current_state != null:
        match current_state:
            State.PATROL:
                pass
            State.ENGAGE:
                var upperBody = actor.get_node('upper_body')
                var hand = upperBody.get_node('hand')
                var aim = hand.get_node('RayCast2D')
                #print('collide with: ',aim.get_collider())

                if player != null and weapon != null:
                    # body face target
                    upperBody.rotation = lerp(upperBody.rotation, upperBody.global_position.direction_to(player.global_position).angle(), agility)
                    hand.global_rotation = lerp(hand.global_rotation, hand.global_position.direction_to(player.global_position).angle(), agility/2)
                    if aim.get_collider() == player:
                        if actor.can_shoot:
                            aiAttack()
                    else:
                        # start timing when lose sight of target
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

func _on_AIDetertion_body_entered(body: Node) -> void:
    if body.is_in_group('player'):  # Checks whether body is player group
        player = body               # could change to other groups if player has allies
        if Global.debug:
            print('AI added player')
        set_state(State.ENGAGE)

# set to search when engage timed out
func _on_Engage_timer_timeout() -> void:
    set_state(State.SEARCH)
