extends Control


var dialogue = [
    'This is a test. [Press Enter to continue.]',
    'Showing multiple lines',
    'YEET!'
   ]


var index = 0
var finished = false

func _ready():
    load_dialogue()

func _process(delta):
    $DialogueAdv.visible = finished
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


func _on_Tween_tween_completed(object, key):
    finished = true
