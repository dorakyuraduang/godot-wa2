extends Control
@onready var titile_menu=$TitleMenu
@onready var inital_start=$InitalStart
@onready var animation_player:AnimationPlayer=$AnimationPlayer
func open():
	show()
	animation_player.play("logo")
	await animation_player.animation_finished
	animation_player.play("open")
	await animation_player.animation_finished
func _gui_input(event):
	if Globals.is_click(event):
		if animation_player.current_animation=="logo":
			animation_player.advance(3)
		elif animation_player.current_animation=="open":
			animation_player.advance(2.5)


func _on_start_button_down():
	print(6)
	titile_menu.hide()
	inital_start.show()
	


func _on_start_1_button_down():
	animation_player.play("close")
	await animation_player.animation_finished
	hide()
	Ws.load(6001)
	Globals.game_state=1
func _on_start_2_button_down():
	animation_player.play("close")
	await animation_player.animation_finished
	hide()
	Ws.load(6101)
	Globals.game_state=1
