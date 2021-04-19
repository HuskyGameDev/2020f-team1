extends Control


var dialogue = [
    "General:\n\nWell look at that, you did it soldier!",
    "General:\n\nNot only did you bust some heads, but you survived to tell the tale, ha ha!\n\nYou make a general like me proud.",
    "General:\n\nAlthough despite your hard work, the city was still destoryed. . .\n\nNothing on your end you could have done about it though.",
    "General:\n\nThe rest of that is my problem, for now let us get you properly situated.\n\nNothing like treating yourself after a good old scrape against death.",
    "General:\n\nNow. . .\n\nWelcome to your new home soldier.\n\nI expect great things from you in the future.",
    ". . .",
    "Thank you for playing our game!\n\nWe hope you enjoyed playing through it as much as we enjoyed putting it together!"
]

var index = 0
var finished = false
var time = 0    #Timing for when to switch animations

func _ready():
    load_dialogue()

func _process(delta):
    #FOENIX: animation for sprites
    $ContinueArrow/Shift.play("Waiting")
    if time < 90:
        $General/Talking.animation = "Talking"
        $Player/Talking.animation = "Waiting"
        #Delays talking sounds, stops with animation
        if time%6 == 1 && index < 6:
            $AudioStreamPlayer.play()
        if time%6 == 3 && index < 6:
            $AudioStreamPlayer2.play()
        if time%6 == 7 && index < 6:
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
        
    if index == 4:
        $General.visible = false
        $Player/Shift.play("Shift")
    index += 1
