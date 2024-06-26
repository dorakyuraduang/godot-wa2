extends Control
class_name Wa2MessageBox
signal wait_click
@onready var name_label:Wa2Text=$NameText
@onready var text_label:Wa2Text=$Wa2Text
@onready var wait_sprite:AnimatedSprite2D=$AwaitSprite
@onready var label_sprite=$TextureRect3
@onready var auto_sprite=$TextureRect4
@onready var skip_sprite=$TextureRect5
@onready var button_list=$HBoxContainer
func update_text():
	var wait_position=get_text_position(Globals.cur_text) 
	wait_sprite.frame=0
	text_label.text=Globals.cur_text
	name_label.text=Globals.cur_name
	wait_sprite.position=text_label.position+wait_position*Vector2(32,32)
	Globals.text_state=1
	text_label.visible_ratio=0.0
func get_text_position(text:String):
	var y:=0
	var x:=0
	for i in len(text):
		if text[i]=="\n":
			x=0
			y+=1
		else:
			x+=1
	return Vector2(x,y)
func _physics_process(delta):
	if Globals.text_on_flag:
		if Globals.text_state==1:
			wait_sprite.hide()
			text_label.visible_ratio+=(float(Globals.text_speed)/len(text_label.text))*delta
			if text_label.visible_ratio>=1.0 or Globals.is_skip() or Globals.click_text_state==1:
				Globals.text_state=2
				text_label.visible_ratio=1.0
				emit_signal("wait_click")
				if Globals.auto_flag:
					Events.add_event(Consts.EventMode.WAIT_VOICE)
		elif Globals.text_state==2:
			if !Globals.auto_flag and !Globals.is_skip():
				wait_sprite.show()
			else:
				wait_sprite.hide()
		else:
			wait_sprite.hide()
		for btn:Wa2Button in button_list.get_children():
			if Globals.text_state==2 or Globals.skip_flag:
				btn.mouse_filter=Control.MOUSE_FILTER_STOP
			else:
				btn.mouse_filter=Control.MOUSE_FILTER_IGNORE
func on(frame:=15):
	show()
	wait_sprite.frame=0
	wait_sprite.play()
	var counter=0
	modulate=Color(1,1,1,0)
	while (counter<frame):
		counter+=1
		await get_tree().physics_frame
		var alpha=float(counter)/frame
		modulate=Color(1,1,1,alpha)
		if Globals.is_skip():
			break
	modulate=Color(1,1,1,1)
	Globals.text_on_flag=true
	if Globals.auto_flag:
		if !Events.has_event(Consts.EventMode.WAIT_VOICE):
			Events.add_timer(Globals.auto_wait_frame)
func off(frame:=15):
	Globals.text_on_flag=false
	var counter=frame
	while (counter>0):
		counter-=1
		await get_tree().physics_frame
		if Globals.is_skip():
			break
		var alpha=float(counter)/frame
		modulate=Color(1,1,1,alpha)
	modulate=Color(1,1,1,0)
	hide()


func _on_off_button_down():
	if Globals.text_state==2:
		off()
		Events.remove_timer()


func _on_skip_button_down():
	Globals.skip_flag=!Globals.skip_flag
	if Globals.skip_flag:
		skip_sprite.show()
	else:
		skip_sprite.hide()

func _on_auto_button_down():
	if Globals.text_state==2:
		Globals.auto_flag=!Globals.auto_flag
		if Globals.auto_flag:
			auto_sprite.show()
			Events.add_event(Consts.EventMode.WAIT_VOICE)
		else:
			auto_sprite.hide()


func _on_back_button_down():
	if Globals.text_state==2:
		Globals.backlog.open()
		off(0)


func _on_save_button_down():
	if Globals.text_state==2:
		Globals.save_page.open()


func _on_load_button_down():
	if Globals.text_state==2:
		Globals.load_page.open()
