extends Node
var os_name=OS.get_name()
var text_speed=40
var script_offset=0
var game_state:=0
var message_box_state:=0
var skip_flag:=false
var move_flag:=false
var ctrl_pressed:=false
var auto_flag:=false
var event_mode:=0
var cur_command=null
var auto_wait_frame:=120
var label:=0
var bg_type:=0
var cur_text=""
var save_page=null
var cur_voice=""
var cur_name=""
var text_state:=0
var cur_bg=""
var char_info={}
var click_text_state:=0
var text_on_flag:=0
var lookbacks:Array=[]
var message_box=null
var backlog=null
var bg_draw_frame:=0
var viewport=null
var main:Wa2Main
var load_page=null
var title_menu_page=null
var cur_bgm:int=0
var bgm_volume:int=0
var bgm_loop:int=0
var cur_page:=0
var func_lut={
	0xc5:remenu_command,
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
func add_back_info():
	if lookbacks.size()>=Consts.MAX_BACK_INFO_COUNT:
		lookbacks.pop_front()
	lookbacks.append({
		"text":Globals.cur_text,
		"name":Globals.cur_name,
		"voice":Globals.cur_voice
	})
	
func is_skip():
	return ctrl_pressed or skip_flag
func add_char(char,id,pos):
	if !char_info.has(char):
		char_info[char]={}
	char_info[char].id=id
	char_info[char].pos=pos
func save_file(no:int):
	var file_name="%02d.sav"%no
	var file = FileAccess.open("user://"+file_name,FileAccess.WRITE)
	var image=viewport.get_image()
	image.resize(320,180)
	var save_data={
		"cur_text":cur_text,
		"cur_name":cur_name,
		"cur_voice":cur_voice,
		"cur_bg":cur_bg,
		"char_info":char_info,
		"date":Time.get_datetime_dict_from_system(),
		"label":label,
		"bg_type":bg_type,
		"amp_flag":viewport.get_shader_var("amp_flag"),
		"amp_mode":viewport.get_shader_var("amp_mode"),
		"bg_offset":viewport.get_shader_var("bg1_offset"),
		"bg_scale":viewport.get_shader_var("bg1_scale"),
		"amp_strength":viewport.get_shader_var("amp_strength"),
		"image":image.data,
		"offset":Ws.offset,
		"cur_bgm":cur_bgm,
		"bgm_loop":bgm_loop,
		"bgm_volume":bgm_volume
	}
	file.store_var(save_data)
	file.close()
func get_file_info(page:int):
	var file_info={}
	for i in 10:
		if FileAccess.file_exists("user://%02d.sav"%(page*10+i)):
			var file = FileAccess.open("user://%02d.sav"%(page*10+i),FileAccess.READ)
			var data=file.get_var()
			file_info[i]=data
			file.close()
	return file_info
func load_file(no:int):
	game_state=0
	var file = FileAccess.open("user://%02d.sav"%no,FileAccess.READ)
	var data=file.get_var()
	file.close()
	Events.emit_signal("next")
	#await  get_tree().physics_frame
	cur_text=data.cur_text
	cur_name=data.cur_name
	cur_voice=data.cur_voice
	cur_bg=data.cur_bg
	char_info=data.char_info
	label=data.label
	bg_type=data.bg_type
	cur_bg=data.cur_bg
	bgm_loop=data.bgm_loop
	cur_bgm=data.cur_bgm
	bgm_volume=data.bgm_volume
	viewport.set_shader_var("amp_mode",data.amp_mode)
	viewport.set_shader_var("bg1_offset",data.bg_offset)
	viewport.set_shader_var("bg1_scale",data.bg_scale)
	viewport.set_shader_var("amp_strength",data.amp_strength)
	viewport.set_shader_var("amp_flag",data.amp_flag)
	viewport.bg_draw_frame=0
	viewport.duration=0
	viewport.change_bg()
	viewport.draw_image()
	Sound.stop_voice()
	Sound.stop_bgm(1)
	Ws.load(data.label,data.offset)
	cur_command=click_command.bindv([0])
	Sound.play_bgm(cur_bgm,bool(bgm_loop),bgm_volume)
	message_box.on(0)
	message_box.update_text()
	game_state=1
func amp_setting_command(strength:int,mode:int):
	viewport.set_shader_var("amp_strength",strength/255.0)
	viewport.set_shader_var("amp_mode",mode)
func amp_command(path,v1:int):
	if path=="sepia.AMP":
		viewport.set_shader_var("amp_flag",true)
		viewport.set_amp(load("res://src/amp/sepia.tres"))
	elif path=="":
		viewport.set_shader_var("amp_flag",false)
		viewport.set_amp(null)
func cl_command(char:int,ef:int,frame:int):
	await viewport.cl(char,ef,frame)
func bgm_command(id:int,v1:int,loop:int,volume:int):
	Globals.cur_bgm=id
	Globals.bgm_volume=volume
	Globals.bgm_loop=loop
	Sound.play_bgm(id,bool(loop),volume)
func wait_command(frame:int,v1:int=0,v2:int=0,v3:int=0,v4:int=0):
	Events.add_timer(frame)
	await Events.timeout
func stop_bgm_command(frame:int):
	Sound.stop_bgm(frame)
func set_label(a:int,id:int):
	Globals.label=id
func set_bg_type(type:int):
	Globals.bg_type=type
func bg_command(ef_id:int,id:int,no:int,frame:int,v1:=0,v2:=0,v3:=0,v4:=0,v5:=0):
	viewport.bg_draw_frame=frame
	if id<100000:
		Globals.cur_bg=Wa2Res.get_bg_path(id,Globals.bg_type,no)
		await viewport.change_bg()
	viewport.clear()
func bg2_command(ef_id:int,id:int,no:int,frame:int,v1,v2,v3,v4,v5,v6):
	viewport.bg_draw_frame=frame
	viewport.duration=frame
	viewport.set_chars_priority(true)
	viewport.draw_image()
	if id<100000:
		Globals.cur_bg=Wa2Res.get_bg_path(id,Globals.bg_type,no)
		await viewport.change_bg()
	viewport.set_chars_priority(false)
	
func bg3_command(ef_id:int,id:int,no:int,frame:int,v1:int,offset_x:int,offset_y:int,scale_x,scale_y,v6,v7):
	Globals.cur_bg=Wa2Res.get_bg_path(id,Globals.bg_type,no)
	viewport.bg_draw_frame=frame
	await viewport.change_bg(Vector2(offset_x-v1,offset_y),Vector2(scale_x,scale_y))
	viewport.clear()
func bg4_command(ef_id:int,id:int,no:int,frame:int,v1:int,v2:int,v3:int,v4:int,v5):
	Globals.cur_bg=Wa2Res.get_cg_path(id,no)
	viewport.bg_draw_frame=frame
	await viewport.change_bg()
	viewport.clear()
func bg_type_command(type:int):
	set_bg_type(type)
	return
func se_command(channel:int,id:int,frame:int,loop:int,volume:int,v4:int):
	Sound.play_se(channel,id,bool(loop),frame,volume)
	#print("缩放",viewport.get_bg_scale())
	#bg.scale=_scale
	#bg.offset.x=offset
	#viewport.texture=image
	return 
func label_command(v1:int,id:int):
	Globals.label=id
func voice_command(char:int,v1:int,v2:int,v3:int,id:int):
	Globals.cur_voice="%04d_%04d_%02d.OGG"%[Globals.label,id,char]
func stop_se_command(channel:int,frame:int):
	Sound.stop_se(channel,frame)
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
	await Events.next
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
	print(Globals.char_info)
	Globals.add_char(char,id,pos)
	viewport.duration=frame
	await viewport.draw_image()
func char2_command(char:int,id:int,pos:int,v1:int,v2:int,v3:int,v4:int):
	Globals.add_char(char,id,pos)
	viewport.duration=v3
	viewport.bg_draw_frame=v3
func move_command(offset_x:int,offset_y:int,frame:int,v2:int,v3:int):
	bg_move(Vector2(offset_x,offset_y),frame)
func bg_move(offset:Vector2,frame):
	await viewport.bg_move(offset,frame)
func go_command(id:String,v1:int):
	Ws.load(int(id))
func sewait_command(c:int,v1:int=0):
	Events.wait_se_channel=c
	Events.add_event(Consts.EventMode.WAIT_SE)
	await Events.se_finished
#char2 35 4 2000 1 0 0 15 256 128
#35 3 2000 1 0 256 128 0
func shake_command(v1:int=0,v2:int=0,v3:int=0,v4:int=0,v5:int=0,v6:int=0):
	pass
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
func remenu_command():
	game_state=0
	Sound.stop_all_se()
	Sound.stop_bgm()
	title_menu_page.open()
