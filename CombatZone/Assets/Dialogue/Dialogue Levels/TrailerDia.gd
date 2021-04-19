extends Control


var dialogue = [
    "General:\n\nSoldier, I need your help!\n\nYou are our last and only hope!",
    "General:\n\nThe city has been overrun, and you are the only one I can count on to take it back!",
    "General:\n\nBut be careful, enemies lurk around every corner, and war only gives us one shot at this.",
    "General:\n\nYou will have to go in alone, so utilize what you can find to survive.",
    "General:\n\nNow bust some heads and take some names for me!  I am counting on you!"
]

var index = 0
var finished = false
var time = 0    #Timing for when to switch animations

func _ready():
    $Player.visible = false
    load_dialogue()

func _process(delta):
    #FOENIX: animation for sprites
    $ContinueArrow/Shift.play("Waiting")
    if time < 90:
        $General/Talking.animation = "Talking"
        $Player/Talking.animation = "Waiting"
        #Delays talking sounds, stops with animation
        if time%6 == 1:
            $AudioStreamPlayer.play()
        if time%6 == 3:
            $AudioStreamPlayer2.play()
        if time%6 == 7:
            $AudioStreamPlayer3.play()
    else:
        $General/Talking.animation = "Waiting"
        $Player/Talking.animation = "Talking"
    time += 1
    $General/Talking.play()
    $Player/Talking.play()
    
    if Input.is_action_just_pressed("ui_accept"):
        load_dialogue()

func load_dialogue():
    if index < dialogue.size():
        finished = false
        $DialogueText.bbcode_text = dialogue[index]
        $DialogueText.percent_visible = 0
        $Tween.interpolate_property(
            $DialogueText, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
           )
        $Tween.start()
        time = 0
    else:
        queue_free()
        
    if index == 1:
        $General/Trailer.play("SlideOver")
        $Player.visible = true
    if index == 4:
        $General.visible = false
        $Player/Trailer.play("Slide Center")
    index += 1
