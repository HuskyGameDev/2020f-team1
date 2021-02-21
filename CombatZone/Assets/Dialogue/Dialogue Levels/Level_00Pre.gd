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

func _ready():
    load_dialogue()

func _process(delta):
    $Sprite.visible = finished
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
    else:
        queue_free()
    index += 1


