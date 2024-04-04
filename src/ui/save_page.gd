extends Control
@onready var tip=$Tip
@onready var animation_player:AnimationPlayer=$AnimationPlayer
@onready var data_page=$DataPage
func _ready():
	for i in data_page.slot_list.get_child_count():
		data_page.slot_list.get_child(i).connect("button_down",func ():
			Globals.save_file(i+data_page.page*10)
			tip.show()
			await get_tree().create_timer(1.5).timeout
			tip.hide()
			close()
		)
func open():
	Globals.game_state=0
	animation_player.play("open")
	data_page.set_page(0)
func close():
	animation_player.play("close")
	await  animation_player.animation_finished
	Globals.game_state=1
func _on_texture_button_button_down():
	close()
