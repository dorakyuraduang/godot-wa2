extends Control
@onready var animation_player=$AnimationPlayer
func open():
	show()
	animation_player.play("open")
