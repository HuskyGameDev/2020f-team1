extends Control


var dialogue = [
    "General:\n\n  Hey not bad hon, seems you have what it takes.\n\n  Looks like you have handled a gun before. . .\n\n  Perhaps then that means you are ready for your first misson.\n\n  [Press enter to continue dialogue]",
    "General:\n\n  I will be sending you over to that city off in the distance, they are having a bit of a. . .pest problem if you will.\n\n  He he he. . .",
    "General:\n\n  Take this transciever, I will be sending over orders through that as I am too busy training these other newbies at the moment.\n\n  (Too bad, would've been fun to crack open some heads myself)",
    "General:\n\n  Perhaps if you are good enough handling it on your own you could be the next platoon hero hmm?",
    "General:\n\n  Well go on, get going.\n\n  I do not have all day.\n\n  Just be careful, you only get one shot, alright hon?",
    "General:\n\n  . . .!",
    "General:\n\n  Oh yeah, almost forgot.\n\n  Heard a bomb might be coming in soon as well.\n\n  Do not worry about it, I will send you a signal if the rumor is true, alright?",
    "General:\n\n  Anyways, good luck.\n\n  Bust some heads and take some names for me soldier."
]

var index = 0
var finished = false
var time = 0    #Timing for when to switch animations

func _ready():
    load_dialogue()

func _process(delta):
    #FOENIX: animation USE TWEEN INSTEAD?
    $ContinueArrow/Shift.play("Waiting")
    if time < 350:
        $General/Talking.animation = "Talking"
        $Player/Talking.animation = "Waiting"
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
