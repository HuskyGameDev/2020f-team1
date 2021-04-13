extends Control


var dialogue = [
    'Welcome new recruit to your final days at boot camp. We will be running you through a combat simulation to make sure your ready for deployment [Press Enter to continue.]',
    '<Determine Objective :: Placeholder Line>',
    'If you can prove yourself, we will be sending you with the next platoon to <REGION :: Level Design Needed.>',
    'We will be refreshing your memory just to make sure you remember your training as the simulation progresses.',
    'Good luck soldier, and try not to bleed too much from the rubber bullets, the training robots AI will show no mercy against you.'
]


var index = 0
var finished = false

#FOENIX: animation
var time = 0

func _ready():
    load_dialogue()
    
    #FOENIX: animation
    $General/Talking.animation = "Waiting"
    $Player/Talking.animation = "Waiting"
    #FOENIX: animation

func _process(delta):
    $Sprite.visible = finished
    
    #FOENIX: animation USE TWEEN INSTEAD?
    if time < 250:
        $General/Talking.animation = "Talking"
        $Player/Talking.animation = "Waiting"
    else:
        $General/Talking.animation = "Waiting"
        $Player/Talking.animation = "Talking"
    time += 1
    $General/Talking.play()
    $Player/Talking.play()
    #FOENIX: animation
    
    if Input.is_action_just_pressed("ui_accept"):
        load_dialogue()

func load_dialogue():
    if index < dialogue.size():
        finished = false
        $RichTextLabel.bbcode_text = dialogue[index]
        $RichTextLabel.percent_visible = 0
        $Tween.interpolate_property(
            $RichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
           )
        $Tween.start()
        
        #FOENIX: animation
        time = 0
        #FOENIX: animation
        
    else:
        queue_free()
    index += 1


