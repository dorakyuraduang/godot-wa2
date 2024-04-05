extends Control
@onready var tip=$Tip
@onready var animation_player:AnimationPlayer=$AnimationPlayer
@onready var data_page=$DataPage
signal  load_file(no:int)
func _ready():
	for i in data_page.slot_list.get_child_count():
		var slot:DataSlot=data_page.slot_list.get_child(i)
		var no=data_page.page*10+i
		slot.connect("button_down",func ():
			if slot.state==0:
				return
			Sound.stop_bgm(0)
			if Globals.cur_page==0:
				Globals.load_file(no)
				Globals.game_state=1
			tip.show()
			await get_tree().create_timer(1.5).timeout
			await  close()
			if Globals.cur_page==1:
				emit_signal("load_file",no)
				
			
		)
func open():
	show()
	tip.hide()
	animation_player.play("open")
	data_page.set_page(0)
	Globals.game_state=0
func close():
	animation_player.play("close")
	await animation_player.animation_finished
	Globals.game_state=1
	hide()
func _on_texture_button_button_down():
	close()
	
