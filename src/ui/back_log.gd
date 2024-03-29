extends Control
var scroll_pos:=0
var max_scroll_pos:=0
@onready var scroll_bar:=$MarginContainer/HBoxContainer/Scroll/TextureRect/Control/SrollBar
@onready var message_list=$MarginContainer/HBoxContainer/VBoxContainer
func open():
	show()
	max_scroll_pos=max(0,Globals.lookbacks.size()-4)
	scroll_pos=max_scroll_pos
	update()
func update():
	for msg in message_list.get_children():
		msg.clear()
	var msg_count=4
	if Globals.lookbacks.size()<4:
		msg_count=Globals.lookbacks.size()
	for i in msg_count:
		var msg_info=Globals.lookbacks[scroll_pos+i]
		message_list.get_child(i).update(msg_info)
	scroll_bar.position.y=scroll_pos/float(max_scroll_pos)*(532-88)
	#if scroll_pos==0 and max_pos<4:
		#message_count=
	#for i in message_list.get_child_count():
		#for i in 
func _on_texture_button_button_down():
	hide()
	Globals.message_box.on(0)


func _on_up_button_button_down():
	scroll_pos=clamp(scroll_pos-4,0,max_scroll_pos)
	update()

func _on_down_button_button_down():
	scroll_pos=clamp(scroll_pos+4,0,max_scroll_pos)
	update()
