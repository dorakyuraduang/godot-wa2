extends Control
@onready var animation_player=$AnimationPlayer
func open():
	show()
	animation_player.play("open")


func _on_texture_button_button_down():
	hide()
