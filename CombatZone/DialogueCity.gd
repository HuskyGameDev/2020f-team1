extends Control


var dialogue = [
    "General:\n\nWelcome soldier, you could not have come at a better time!\n\nNormally I would train you, but desperate situations call for desparate measures.\n\n\n\n[Press enter to continue dialogue]",
    "General:\n\nBesides, there is nothing better than learning on the field, with the adrenaline running through your viens.\n\nSurvival is the key in battle young soldier, mercy never shows herself on the battlefield.",
    "General:\n\nYou only get one life in this world, make it count!",
    "General:\n\nI will be sending you over to that city over there in the distance.\n\nThere are enemies lurking around every corner, so be on guard.\n\nIf you are smart, you will be successful.",
    "General:\n\nTake this transceiver, I will be giving you commands from there.\n\nI would love to bash in some heads myself, but I must keep a look-out here.",
    "General:\n\nBy the way, you will be operating alone.\n\nOur platoon is stretched quite thin.\n\n. . . . . .",
    "General:\n\nHeh, you seem unfazed by that sort of news. . .\n\nHa ha, good!\n\nYou show high promise.",
    "General:\n\nAlright, I think you are ready, good luck soldier.\n\nBust some heads and take some names!\n\nYou are our last hope!"
]

var index = 0
var finished = false
var time = 0    #Timing for when to switch animations

func _ready():
    load_dialogue()

func _process(delta):
    #FOENIX: animation for sprites
    $ContinueArrow/Shift.play("Waiting")
    if time < 180:
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
    index += 1
