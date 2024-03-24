extends Control
class_name Wa2Main
var game_state=0
var game_await:=false
var lscr=null
var bg_type:=0
var label:=0
var ws:Wa2Script=Wa2Script.new()
@onready var chars:Wa2Chars=$Wa2Chars
@onready var sound:Wa2Sound=$Wa2Sound
@onready var bg:Wa2Bg=$Wa2Bg
@onready var message_box:Wa2MessageBox=$Wa2MessageBox
@onready var effect:Wa2Effect=$Wa2Effect
var func_lut={
	0xd2:move_command,
	0x92:bg_command,
	0x93:bg2_command,
	0xaa:bg_type_command,
	0x9f:stop_bgm_command,
	0xa6:stop_se_command,
	0xc2:await_command,
	0xec:await_command,
	0xa5:se_command,
	0x9e:bgm_command,
	0x8a:voice_command,
	0x89:label_command,
	0x83:text_command,
	0x8f:textoff_command,
	0x90:name_command,
	0x84:click_command,
	0x9b:char2_command,
	0x9a:char_command,
	0xe1:bg3_command,
	0x0:go_command,
	0x9c:cl_command,
	0x94:bg4_command,
	0xa8:sewait_command,
	0xe7:shake_command
}
func _ready():
	load_script(6001)
func _physics_process(delta):
	if Input.is_action_pressed("skip"):
		Globals.skip_flag=true
		clicked()
	else:
		Globals.skip_flag=false
	if game_state==1 and !game_await:
		parse_command()
	#set_bg_type(0)
	#change_bg(1005,1,60)
	#await get_tree().create_timer(2.0).timeout
	#change_bg(1005,2,60)
func load_script(id:int):
	ws.load(id)
	game_state=1
func parse_command():
	var parse_end:=false
	var args:Array
	var cb:Callable
	while (!parse_end):
		match ws.read_int():
			6:
				match ws.read_int():
					0x1e:
						args=[]
			3:
				args.append(ws.str_args[ws.read_int()])
			5:
				match ws.read_int():
					3:
						args.append(ws.read_int())
					4:
						args.append(ws.read_float())
			4:
				var func_idx=ws.read_int()
				if func_lut.has(func_idx):
					cb=func_lut[func_idx]
				parse_end=true
	if cb:
		cb.callv(args)
func cl_command(char:int,ef:int,frame:int):
	game_await=true
	await chars.cl(char,ef,frame)
	game_await=false
func bgm_command(id:int,v1:int,loop:int,volume:int):
	sound.play_bgm(id,bool(loop),volume)
func await_command(frame:int,v1:int=0,v2:int=0,v3:int=0):
	game_await=true
	for i in frame:
		await  get_tree().physics_frame
		if Globals.skip_flag:
			break
	game_await=false
func stop_bgm_command(frame:int):
	sound.stop_bgm(frame)
func set_label(a:int,id:int):
	label=id
func set_bg_type(type:int):
	bg_type=type
	await get_tree().physics_frame
func bg_command(ef_id:int,id:int,no:int,frame:int,u1,u2,u3,u4,u5):
	game_await=true
	var image=Wa2Res.get_bg_image(id,bg_type,no)
	await change_bg(image,frame)
	chars.clear()
	game_await=false
func bg2_command(ef_id:int,id:int,no:int,frame:int,v1,v2,v3,v4,v5,v6):
	game_await=true
	chars.duration=frame
	chars.draw_image()
	chars.z_index=1
	var image=null
	if id>=100000:
		image=bg.texture
	else:
		image=Wa2Res.get_bg_image(id,bg_type,no)
		
	await change_bg(image,frame)
	chars.z_index=0
	game_await=false
func bg3_command(ef_id:int,id:int,no:int,frame:int,v1,offset,v2,scale_x,scale_y,v6,v7):
	game_await=true
	var image=Wa2Res.get_bg_image(id,bg_type,no)
	await change_bg(image,frame,offset,Vector2(scale_x,scale_y))
	chars.clear()
	game_await=false
func bg4_command(ef_id:int,id:int,no:int,frame:int,v1:int,v2:int,v3:int,v4:int,v5:int):
	game_await=true
	var image=Wa2Res.get_cg_image(id,no)
	await change_bg(image,frame)
	chars.clear()
	game_await=false
func bg_type_command(type:int):
	set_bg_type(type)
	return
func se_command(channel:int,id:int,frame:int,loop:int,volume:int,v4:int):
	sound.play_se(channel,id,bool(loop),frame,volume)
func change_bg(image:Texture2D,frame:int,offset:int=0,_scale:Vector2=Vector2.ONE):
	Globals.move_flag=false
	effect.image=image
	effect.show()
	effect.duration=frame
	effect.counter=0
	effect.scale=_scale
	effect.offset.x=offset
	game_await=true
	while (await effect.do_effect()):
		if Globals.skip_flag:
			break
	bg.scale=_scale
	bg.offset.x=offset
	bg.texture=image
	effect.hide()
	return 
func label_command(v1:int,id:int):
	label=id
func voice_command(char:int,v1:int,v2:int,v3:int,id:int):
	sound.play_voice(label,char,id)
func stop_se_command(channel:int,frame:int):
	sound.stop_se(channel,frame)
func _gui_input(event):
	if is_click(event):
		clicked()
func clicked():
	if Globals.click_state==Consts.ClickState.NEW_PAGE:
		Globals.click_state=Consts.ClickState.CLICK_EOL
	elif Globals.click_state==Consts.ClickState.CLICK_EOL:
		Globals.click_state=Consts.ClickState.NONE
		message_box.await_sprite.hide()
		Events.emit_signal("clicked")
func is_click(event):
	if Globals.os_name=="Android":
		if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
			return true
		else:
			return false
	elif  event is InputEventMouseButton and event.is_pressed() and event.button_index==MOUSE_BUTTON_LEFT:
		return true
	else:
		return false
func text_command(text:String,idx:int,click_flag:int):
	game_await=true
	if !message_box.visible:
		await message_box.on()
	Globals.click_state=Consts.ClickState.NEW_PAGE
	message_box.set_text(text)
	game_await=false
func name_command(str):
	if int(str)==1:
		message_box.set_char_name("")
	else:
		message_box.set_char_name(str)
func click_command(v1:int):
	game_await=true
	await Events.clicked
	game_await=false
#func parser_func():
	#pass
#func _physics_process(delta):
	#if state==1:
		#while (!game_await):
			#parser_func()
func textoff_command(v1:int,efc:int):
	game_await=true
	await message_box.off()
	game_await=false
func char_command(char:int,id:int,no:int,pos:int,v1:int,v2:int,frame:int,v3:int,v4:int):
	game_await=true
	var image=Wa2Res.get_char_image(char,id,no)
	chars.set_char(char,pos,image)
	chars.duration=frame
	await chars.draw_image()
	game_await=false
func char2_command(char:int,id:int,no:int,pos:int,v1:int,v2:int,v3:int,v4:int):
	var image=Wa2Res.get_char_image(char,id,no)
	chars.set_char(char,pos,image)
func move_command(offset:int,v1:int,frame:int,v2:int,v3:int):
	var counter=0
	Globals.move_flag=true
	var start_offset=bg.offset.x
	var distance=offset
	while (counter<frame):
		await get_tree().physics_frame
		counter+=1
		bg.offset.x=start_offset+distance*(float(counter)/frame)
		if !Globals.move_flag:
			break
func go_command(id:String,v1:int):
	load_script(int(id))
func sewait_command(c:int):
	game_await=true
	await sound.se_audios[c].finished
	game_await=false
#char2 35 4 2000 1 0 0 15 256 128
#35 3 2000 1 0 256 128 0
func shake_command():
	pass
