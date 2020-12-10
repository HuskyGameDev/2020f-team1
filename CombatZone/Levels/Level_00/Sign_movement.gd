extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $RichTextLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Area2D_body_entered(body: Node) -> void:
    $RichTextLabel.show()


func _on_Area2D_body_exited(body: Node) -> void:
    $RichTextLabel.hide()
