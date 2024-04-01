extends Control
class_name Wa2Main
var game_state=0
var game_await:=false
var lscr=null
var label:=0
var ws:Wa2Script=Wa2Script.new()
#@onready var chars:Wa2Chars=$Wa2Chars
#@onready var bg:Sprite2D=$Wa2Bg
@onready var viewport=$Wa2Viewport
@onready var message_box:Wa2MessageBox=$Wa2MessageBox
var func_lut={
	0xd2:move_command,
	0x92:bg_command,
	0x93:bg2_command,
	0xaa:bg_type_command,
	0x9f:stop_bgm_command,
	0xa6:stop_se_command,
	0xc2:wait_command,
	0xec:wait_command,
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
	0xe7:shake_command,
	0xab:amp_setting_command,
	0xac:amp_command
}
func amp_setting_command(strength:int,mode:int):
	viewport.set_amp_strength(strength/255.0);
	viewport.set_amp_mode(mode)
func amp_command(path,v1:int):
	if path=="sepia.AMP":
		viewport.set_amp(load("res://src/amp/sepia.tres"))
	elif path=="":
		viewport.set_amp(null)
		#print("设置true")
		#bg.material.set_shader_parameter("activation",true)
	#else:
		#print("设置false")
		#bg.material.set_shader_parameter("activation",false)
func _ready():
	Globals.message_box=message_box
	Globals.backlog=$Pages/BackLog
	Globals.save_page=$Pages/SavePage
	load_script(6004)
	while (true):
		await get_tree().process_frame
		await  parse_command()
func _physics_process(delta):
	if Input.is_action_pressed("skip"):
		Globals.ctrl_pressed=true
	else:
		Globals.ctrl_pressed=false
	if Input.is_action_pressed("f12"):
		screenshot()
func screenshot():
	pass
	#var image=Image.create(1280,720,false,Image.FORMAT_RGBA8)
	#var bg_image:Image=viewport.bg_texture.get_image()
	#var char_image=viewport.cur_image
	#bg_image.convert(Image.FORMAT_RGBA8)
	#image.blend_rect(bg_image,Rect2i(Vector2i.ZERO,bg_image.get_size()),Vector2i.ZERO)
	#image.blend_rect(char_image,Rect2i(Vector2i.ZERO,char_image.get_size()),Vector2i.ZERO)
	#image.save_png("res://test.png")
	#set_bg_type(0)
	#change_bg(1005,1,60)
	#await get_tree().create_timer(2.0).timeout
	#change_bg(1005,2,60)
func load_script(id:int):
	ws.load(id)
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
					0x10:
						var a=args.pop_back()
						args[args.size()-1]+=a
					0x17:
						args[args.size()-1]*=-1
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
		print(cb)
		print(args)
		await  cb.callv(args)
func cl_command(char:int,ef:int,frame:int):
	await viewport.cl(char,ef,frame)
func bgm_command(id:int,v1:int,loop:int,volume:int):
	Sound.play_bgm(id,bool(loop),volume)
func wait_command(frame:int,v1:int=0,v2:int=0,v3:int=0):
	Events.add_timer(frame)
	await Events.timeout
func stop_bgm_command(frame:int):
	Sound.stop_bgm(frame)
func set_label(a:int,id:int):
	Globals.label=id
func set_bg_type(type:int):
	Globals.bg_type=type
func bg_command(ef_id:int,id:int,no:int,frame:int,u1,u2,u3,u4,v5):
	Globals.cur_bg=Wa2Res.get_bg_path(id,Globals.bg_type,no)
	await change_bg(frame)
	viewport.clear()
func bg2_command(ef_id:int,id:int,no:int,frame:int,v1,v2,v3,v4,v5,v6):
	viewport.duration=15
	viewport.draw_image()
	viewport.set_chars_priority(true)
	if id<100000:
		Globals.cur_bg=Wa2Res.get_bg_path(id,Globals.bg_type,no)
		await change_bg(frame)
	viewport.set_chars_priority(false)
func bg3_command(ef_id:int,id:int,no:int,frame:int,v1:int,offset_x:int,offset_y:int,scale_x,scale_y,v6,v7):
	Globals.cur_bg=Wa2Res.get_bg_path(id,Globals.bg_type,no)
	await change_bg(frame,Vector2(offset_x-v1,offset_y),Vector2(scale_x,scale_y))
	viewport.clear()
func bg4_command(ef_id:int,id:int,no:int,frame:int,v1:int,v2:int,v3:int,v4:int,v5):
	Globals.cur_bg=Wa2Res.get_cg_path(id,no)
	await change_bg(frame)
	viewport.clear()
func bg_type_command(type:int):
	set_bg_type(type)
	return
func se_command(channel:int,id:int,frame:int,loop:int,volume:int,v4:int):
	Sound.play_se(channel,id,bool(loop),frame,volume)
func change_bg(frame:int,offset:Vector2=Vector2.ZERO,_scale:Vector2=Vector2.ONE):
	var image=load(Globals.cur_bg)
	Globals.move_flag=false
	viewport.set_bg2_image(image)
	viewport.set_bg2_offset(offset)
	viewport.set_bg2_scale(_scale)
	for i in frame:
		await get_tree().physics_frame
		viewport.set_bg2_alpha(i/float(frame))
		if Globals.is_skip():
			break
	viewport.set_bg2_alpha(0.0)
	viewport.set_bg1_image(image)
	viewport.set_bg1_scale(_scale)
	viewport.set_bg1_offset(offset)
	#print("缩放",viewport.get_bg_scale())
	#bg.scale=_scale
	#bg.offset.x=offset
	#viewport.texture=image
	return 
func label_command(v1:int,id:int):
	label=id
func voice_command(char:int,v1:int,v2:int,v3:int,id:int):
	Globals.cur_voice="%04d_%04d_%02d.OGG"%[label,id,char]
func stop_se_command(channel:int,frame:int):
	Sound.stop_se(channel,frame)
func _gui_input(event):
	if is_click(event):
		if Globals.text_state==1:
			Globals.click_text_state=1
		elif Globals.text_state==2:
			if !Globals.text_on_flag:
				message_box.on(1)
			else:
				Globals.click_text_state=2
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
	Globals.cur_text=text.replace("\\n","\n")
	Globals.add_back_info()
	message_box.update_text()
	if !Globals.text_on_flag:
		await message_box.on()
	if Globals.cur_voice:
		Sound.play_voice(Globals.cur_voice)
	await message_box.wait_click
func name_command(str):
	if int(str)==-1:
		Globals.cur_name=""
	else:
		Globals.cur_name=str
func click_command(v1:int):
	Events.add_event(Consts.EventMode.WAIT_CLICK)
	await Events.click_text
	Globals.cur_text=""
	Globals.cur_name=""
	Globals.cur_voice=""
#func parser_func():
	#pass
#func _physics_process(delta):
	#if state==1:
		#while (!game_await):
			#parser_func()
func textoff_command(v1:int,efc:int):
	await message_box.off()
func char_command(char:int,id:int,pos:int,v1:int,v2:int,frame:int,v3:int,v4:int):
	Globals.add_char(char,id,pos)
	viewport.duration=frame
	await viewport.draw_image()
func char2_command(char:int,id:int,pos:int,v1:int,v2:int,v3:int,v4:int):
	Globals.add_char(char,id,pos)
func move_command(offset_x:int,offset_y:int,frame:int,v2:int,v3:int):
	bg_move(Vector2(offset_x,offset_y),frame)
func bg_move(offset:Vector2,frame):
	var counter=0
	Globals.move_flag=true
	var start_offset=viewport.get_bg1_offset()
	var distance=start_offset-offset
	print(start_offset)
	print(offset)
	print("距离",distance)
	while (counter<frame):
		await get_tree().physics_frame
		counter+=1
		viewport.set_bg1_offset(start_offset-distance*(float(counter)/frame))
		if !Globals.move_flag:
			break
func go_command(id:String,v1:int):
	load_script(int(id))
func sewait_command(c:int):
	Events.wait_se_channel=c
	Events.add_event(Consts.EventMode.WAIT_SE)
	await Events.se_finished
#char2 35 4 2000 1 0 0 15 256 128
#35 3 2000 1 0 256 128 0
func shake_command():
	pass
