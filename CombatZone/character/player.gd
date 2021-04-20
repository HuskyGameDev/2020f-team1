extends "res://character/people.gd"
class_name Player

var canShoot = true
var canRoll = true
var input = Vector2()
var moves = false   #Used to keep track if player is moving or not

# check reload
var start_r = 0 # a counter to keep track how much has past since reload is pressed and held

export (PackedScene) var default_weapon
export (PackedScene) var holstered_weap
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var obj_priority_display = Array()

var weap_to_spawn   = null
var weap_in_hand    = null

onready var reach   = $upper_body/reach_for
onready var hand    = $upper_body/hand
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("player")
    $Dodge.hide()
    $Armor_bar.hide()
    var weapon = default_weapon.instance()
    if default_weapon != null:
        hand.add_child(weapon)
        weap_in_hand = weapon.weap_name
    if holstered_weap != null:
        $holsters.add_child(holstered_weap.instance())


func get_input():
    dodge = Vector2.ZERO
    $upper_body.look_at(get_global_mouse_position())
    hand.look_at(get_global_mouse_position()) # weapon points at mouse pos
    if Input.is_action_pressed("player_attack_1"):
        attack1()
    if Input.is_action_pressed("player_attach_2"):
        attack2()
    if Input.is_action_just_pressed("player_switch_weapon"):
        swap_weap()
    if Input.is_action_just_pressed("player_interact"):
        interAct()
    if Input.is_action_pressed("player_dodge"): #LEFT SHIFT TO ROLL
        dodge_roll()
    if Input.is_action_pressed("player_reload"):    # displays round in clip
        start_r = start_r + 1
        #print("check ammo ", start_r)
        print("round in clip: ", hand.get_child(0).bullet_in_mag)
        if start_r > 30:
            var words = " %d rounds left" % hand.get_child(0).bullet_in_mag
            player_speaks(words)
    if Input.is_action_just_released("player_reload"):  # reload weapon on release of buttom under 30 frame (maybe?)
        if(start_r <= 30):
            print("reload")
            reload_weapon()
        start_r = 0
                
    input.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
    input.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
    return input

func attack1() -> void:
    if hand.get_child_count() > 0 and canShoot:
        var shot_fired = hand.get_child(0).shoot()
        if shot_fired == 0:
            canShoot = false
            reload_weapon()
    
func attack2() -> void:
    pass

# call to refill ammo of weapon on hand and holster
func refill_ammo(amount):
    if $upper_body/hand.get_child_count() > 0:
        var in_hand = $upper_body/hand.get_child(0)
        in_hand.add_ammo(in_hand.get_clip_size() * amount)
    if $holsters.get_child_count() > 0:
        var in_holster = $holsters.get_child(0)
        in_holster.add_ammo(in_holster.get_clip_size() * amount)

# pick up items
func interAct() -> void:
    print('player interacting')
    if pickup_item != null:  # pick up items
        # pick up weapon
        if pickup_item.get_groups().has('weapon'):
            switch_weapon()
        else:
            pickup_item.take_effect(self)   # other pickups take effect on player

func embark(vehicle):
    self.vehicle = vehicle
    piloting = true
    # avoid collision with car
    set_collision_layer_bit(1,false)
    $upper_body.hide()
    $foot.hide()
    #$holsters.hide()
    $Dodge.hide()
    $Armor_bar.hide()
    #$health_bars.hide()
    #$ammo_call_out.hide()
    
func disembark():
    vehicle = null
    piloting = false
    set_collision_layer_bit(1,true)
    rotation = 0
    $upper_body.show()
    $foot.show()
    #$holsters.show()
    $Dodge.show()
    if(armor > 0):
        $Armor_bar.show()
    if (health < totalHealth):
        $health_bars.show()
    #$ammo_call_out.show()

# pick up weapon from ground
func switch_weapon() -> void:
    if $holsters.get_child(0) == null:
        $holsters.add_child(BulletFactory.get_weapon(weap_to_spawn))
        pickup_item.queue_free()
        #weap_in_hand = hand.get_child(0).weap_name
        return
    # check different from weap in hand and in holster
    if weap_to_spawn != weap_in_hand && weap_to_spawn != $holsters.get_child(0).weap_name:
        # drop weapon on floor
        if hand.get_child(0) != null:
            # drop weapon to game level
            var temp_weap_Pickup = BulletFactory.get_pickUp(weap_in_hand)
            var angle = hand.global_rotation    # upper body orientation
            get_parent().add_child(temp_weap_Pickup)
            temp_weap_Pickup.global_transform = hand.global_transform
            # apply impulse to throw gun out
            temp_weap_Pickup.apply_central_impulse(Vector2(cos(angle), sin(angle)) * 2000)
            # set temp_weap's drop to true
            hand.get_child(0).queue_free()
            hand.remove_child(hand.get_child(0))
            print('dropped weap, hand has child: ', hand.get_child_count())
        # spawn weapon on hand
        print('picking up weap, hand has children: ', hand.get_child_count())
        hand.add_child(BulletFactory.get_weapon(weap_to_spawn))
        pickup_item.queue_free()
        weap_in_hand = hand.get_child(0).weap_name # new weapon to drop is the current ones in hand
        print('weap to drop is ', weap_in_hand)
        
        # $holsters.remove_child($holsters.get_child(0))
        # $holsters.add_child(temp_weap)
    
func reload_weapon() -> void:
    if hand.get_child(0).clip_full():
        if Global.debug:
            print("player weapon: clip full")
    else:
        var reload_timr = hand.get_child(0).reload_weap()   # call weapon's reload weapon and get reload time
        if reload_timr > 0: # reload occured
            var words = "reloading"
            player_speaks(words)
            $reload_timer.start(reload_timr)
            if Global.debug:
                print("player: reloading ", reload_timr)
        elif reload_timr == -1: # run out of ammo to reload
            if Global.debug:
                print("player: out of ammo")

func old_swap_weap():
    print("switching weapon")
    if $holsters.get_child_count() > 0:
        if Global.debug_on():
            print("I'm switching")
        var temp_weap = $upper_body/hand.get_child(0).duplicate()
        var ammo = $upper_body/hand.get_child(0).ammo
        var bimag = $upper_body/hand.get_child(0).bullet_in_mag
        var swapWeap = $holsters.get_child(0).duplicate()
        var swapAmmo = $holsters.get_child(0).ammo
        var swapBiMag = $holsters.get_child(0).bullet_in_mag
        $upper_body/hand.remove_child($upper_body/hand.get_child(0))
        $upper_body/hand.add_child(swapWeap)
        hand.get_child(0).ammo = swapAmmo
        hand.get_child(0).bullet_in_mag = swapBiMag
        weap_in_hand = hand.get_child(0).weap_name
        $holsters.remove_child($holsters.get_child(0))
        $holsters.add_child(temp_weap)
        $holsters.get_child(0).ammo = ammo
        $holsters.get_child(0).bullet_in_mag = bimag

func swap_weap():
    print('switching weapon')
    if $holsters.get_child_count() > 0: # holster has weapon
        if Global.debug_on():
            print('player swapping weapon')
        
        # get reference to two weapons
        var weap_from_hand: = $upper_body/hand.get_child(0)
        var weap_from_holster: = $holsters.get_child(0)
        
        # swap them
        # delete from parent
        $upper_body/hand.remove_child(weap_from_hand)
        $holsters.remove_child(weap_from_holster)
        # add to new parent
        $upper_body/hand.add_child(weap_from_holster)
        $holsters.add_child(weap_from_hand)
        weap_in_hand = weap_from_holster.weap_name

# return a reference to currently holding weapon
func current_weapon():
    return $upper_body/hand.get_child(0)
    
func _process(delta):
    #if reach.is_colliding():
    #    var reached_item = reach.get_collider()
    #    if Global.debug_on():
    #        print("player ray collided", reached_item)
     #   if reach.get_collider().get_groups().has('weapon'):
     #       print("collider is weapon")     
    $Dodge.scale.x = ($RollTimer.time_left / $RollTimer.wait_time)
    if($Dodge.scale.x == 0):
        $Dodge.hide()
        $Dodge.scale.x = 2
         
    
    #Animation: Checking to see if player is moving
    if Input.is_action_pressed("player_move_down") || Input.is_action_pressed("player_move_up") || Input.is_action_pressed("player_move_left") || Input.is_action_pressed("player_move_right"):
        moves = true
    else:
        moves = false
        
    #If moving, play ShoulderAnimation and LegAnimation
    if moves == true:
        $upper_body/upperbody_sprite/ShoulderAnimation.play("Shoulder Movement")
        #Set up for LegAnimation direction
        var direction = 0   #default direction, assume going up if pass through checks
        if input.x > 0:
            direction = 90  #player going right (replace default)
        if input.x < 0:
            direction = 270 #player going left
        #Check if up or down was pressed
        if input.y != 0:
            if input.x != 0:
                direction = direction + (input.x * input.y * 45)    #Calc direction if right or left was pressed with up or down
            if input.y > 0 && input.x == 0: #If only down was pressed
                direction = 180
        #Legs point with keyboard (fixed degrees)
        $foot/LegAnimation.rotation_degrees = direction
        $foot/LegAnimation.play()
    else:
        $upper_body/upperbody_sprite/ShoulderAnimation.stop(true)
        $foot/LegAnimation.frame = 0    #Reset frame of LegAnimation to 0 (idle)

func dodge_roll():
    if(canShoot == true && canRoll == true):
        canRoll = false
        canShoot = false
        $Dodge.show()
        $Dodgeroll.play()
        print("dodge roll begins")
        $RollTimer.start()
        counter = 100.0 
        dodge = Vector2(input.x, input.y) * 10000
        #while(counter > 0):
        #    $RollTimer2.start()
        #    counter = counter - 1

func _on_RollTimer_timeout():
    canRoll = true
    canShoot = true

# series of methods to check player states
func has_weapon(weapon_name):
    if $upper_body/hand.get_child(0).get_weap_name() == weapon_name:
        return true
    elif $holsters.get_child(0).get_weap_name() == weapon_name:
        return true
    return false

func weapon_full():
    if $upper_body/hand.get_child_count()>0 && $holsters.get_child_count()>0:
        return true
        
func take_damage(pos, damage_amount) -> void:
    $health_bars.show()
    $Armor_bar.show()
    
    if(armor > 0):
        armor -= damage_amount
    else:
        health -= damage_amount
        
    if(health <= 0):
        health = 0
        die()
    $health_bars/HealthG.scale.x = (health / totalHealth)
    $Armor_bar.scale.x = (armor / totalArmor)
    Global.spill_blood(pos)
    #print("Player HP percent: %f" % ((health / 100)))
    #print(" Player Damage, remaining health: %d" % health)

func injured():
    return health < totalHealth
    
func armorDamaged():
    return armor < totalArmor
    
func heal_up(number):
    health += number
    if health>totalHealth:
        health = totalHealth
    $health_bars/HealthG.scale.x = (health / totalHealth)
        
func armor_up(number):
    armor += number
    $Armor_bar.show()
    if(armor > totalArmor):
        armor = totalArmor
    $Armor_bar.scale.x = (armor / totalArmor)
    
func die():
    get_tree().change_scene("res://Assets/Dialogue/Dialogue Levels/GameOver.tscn")
    queue_free()

func player_speaks(text_input) -> void:
    $ammo_call_out.set_text(text_input)
    $ammo_call_out.show()
    $ammo_call_out/text_box_timer.start()
    
#Adds the text given and displays it to the player
#Made for convinience. Easier to let the player deal with its children.
func _update_objectives(new_text:String, offset:int, status:int, priority:int):
    
    #Special case, don't print secret objective if we haven't done it yet.
    if (priority == 2 && status == 0):
        print(offset)
        print("Hidden!")
        return false
            
    var img = Sprite.new()
    
    #Firstly some transformative stuff, making sure it allings properly.
    print(offset)
    print("offset")
    print(((offset*80) -679.99))
    img.position = Vector2(-1239.411, ((offset*80) -679.99)) #Precise numbers needed to display multiple of these and their associated statuses/priorities
    img.scale = Vector2(1, 1)
    
    if (priority == 0):
            #Primary Priority
            match status:
                0:
                    img.texture = load("res://Assets/primaryObjective.png")
                    #Ongoing
                    print("loaded00")
                1:
                    img.texture = load("res://Assets/primaryObjectivePassed.png")
                    #We succeeded!
                    print("loaded01")
                2:
                    img.texture = load("res://Assets/primaryObjectiveFailed.png")
                    print("loaded02")
                    #We failed...
    else:
            #Hidden/Secondary
            #Assuming now it's visible
            match status:
                0:
                    #Ongoing, only used for secondary objectives (hopefully)
                    img.texture = load("res://Assets/secondaryObjective.png")
                    print("loaded10")
                1:
                    #We succeeded!
                    img.texture = load("res://Assets/secondaryObjectivePassed.png")
                    print("loaded11/21")
                2:
                    #We failed...
                    img.texture = load("res://Assets/secondaryObjectiveFailed.png")
                    print("loaded12/22")
    
    obj_priority_display.insert(offset, img)
    self.add_child(img)
    img.set_owner(self)
    $objective_list.append_bbcode(new_text)
    return true
    pass
    
#Makes it easier to clear the objectives if we can find the exact object that needs to be cleared.
func _clear_objectives():
    $objective_list.clear()
    var copy = obj_priority_display
    while(not obj_priority_display.empty()):
        var val = obj_priority_display.pop_front()
        #Remove it from the scene for good if it exists.
        if val != null:
            val.queue_free()
    pass
    
func _OnTimerStart():
    var snd = $TimerTick
    match snd.playing:
        false:
            snd.play()

func _OnTimerEnd():
    var snd = $TimerTick
    match snd.playing:
        true:
            snd.stop()
            
func _ObjectiveSoundQueue(status, priority):
    
    match status:
        1:
            match priority:
                0:
                    $MainComplete.play()
                _:
                    $SideComplete.play()
            return
        _:
            $ObjFail.play()        
            
    
    pass


func _on_reload_timer_timeout() -> void:
    canShoot = true

# text box time out 
func _on_text_box_timer_timeout() -> void:
    $ammo_call_out.hide()

# Detects pick up items in front of the player
# Should check ammo type when encounters weapons
# Should prompt for pick up for health or armors
func _on_pickup_Area2D_body_entered(body: Node) -> void:
    if body.get_groups().has('item_pick_up'):
        print('pick_up detected')
        pickup_item = body
        if body.get_groups().has('weapon'):
            # print('weapon pick_up detected')
            weap_to_spawn = body.weap_name
            print('weapon to spawn is ', weap_to_spawn)


func _on_pickup_Area2D_body_exited(body: Node) -> void:
    if body.get_groups().has('item_pick_up'):
        print('item exited ', body)
        if body == pickup_item:
            pickup_item = null
            weap_to_spawn = null
