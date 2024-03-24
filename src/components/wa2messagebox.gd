extends Control
class_name Wa2MessageBox
@onready var name_label:Label=$NameLabel
@onready var text_label:Label=$TextLabel
@onready var await_sprite:AnimatedSprite2D=$AwaitSprite
func set_char_name(str:String):
	name_label.text=str
func show_name(str:String):
	name_label.text=str
func hide_name():
	name_label.text=""
func set_text(text:String):
	text=text.replace("\\n","\n")
	var await_position=get_text_position(text) 
	text_label.text=text
	await_sprite.frame=0
	await_sprite.position=text_label.position+await_position*Vector2(28,38)
	await_sprite.hide()
	text_label.visible_ratio=0.0
	text_label.visible_ratio=0
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
	if Globals.click_state==1:
		text_label.visible_ratio+=(float(Globals.text_speed)/len(text_label.text))*delta
		if text_label.visible_ratio>=1.0:
			Globals.click_state=2
	elif Globals.click_state==2:
		text_label.visible_ratio=1.0
		await_sprite.show()
		await_sprite.play()
func clear():
	text_label.text=""
	text_label.visible_ratio=0.0
	await_sprite.hide()
func on(frame:=15):
	clear()
	show()
	var counter=0
	modulate=Color(1,1,1,0)
	while (counter<frame):
		counter+=1
		await get_tree().physics_frame
		var alpha=float(counter)/frame
		modulate=Color(1,1,1,alpha)
		if Globals.skip_flag:
			break
	modulate=Color(1,1,1,1)
func off(frame:=15):
	var counter=frame
	while (counter>0):
		counter-=1
		await get_tree().physics_frame
		if Globals.skip_flag:
			break
		var alpha=float(counter)/frame
		modulate=Color(1,1,1,alpha)
	modulate=Color(1,1,1,0)
	hide()
