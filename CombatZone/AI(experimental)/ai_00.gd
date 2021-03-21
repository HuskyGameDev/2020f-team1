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

onready var player_detection_zone = $AIDetection


var current_state: int = State.PATROL setget set_state

var player: Player = null
var weapon: Weapon = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    if current_state != null:
        match current_state:
            State.PATROL:
                pass
            State.ENGAGE:
                print('ai engaging...')
                if player != null and weapon != null:
                    aiAttack()
                                       
                else:
                    print('In the engage state but no weapon/player')
            State.SEARCH:
                pass
            var new_emu:
                print("Error: found a state for our enemy that should not exist: ", new_emu)
    
func set_hand(hand):
    if hand.get_child_count()>0:    # hand has weapon, set weapon
        weapon = hand.get_child(0)  # first weapon is weapon
        if Global.debug:
            print('AI weapon set')
    else:
        print("enemy has no weapon in hand")

func aiAttack()-> void:
    if !weapon.shoot():
        weapon.add_ammo(weapon.get_clip_size())
        weapon.reload_weap()
    
func set_state(new_state: int):
    print('setting ai state: ', new_state)
    if new_state == current_state:
        return        
    current_state = new_state
    print('ai now in state: ', current_state)
    emit_signal('state_change', current_state)

func _on_AIDetertion_body_entered(body: Node) -> void:
    if body.is_in_group('player'):
        player = body
        if Global.debug:
            print('AI added player')
        set_state(State.ENGAGE)
