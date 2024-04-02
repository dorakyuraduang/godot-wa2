extends Node
var os_name=OS.get_name()
var text_speed=40
var message_box_state:=0
var skip_flag:=false
var move_flag:=false
var ctrl_pressed:=false
var auto_flag:=false
var event_mode:=0
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
		"cur_text":Globals.cur_text,
		"cur_name":Globals.cur_name,
		"cur_voice":Globals.cur_voice,
		"cur_bg":Globals.cur_bg,
		"char_info":Globals.char_info,
		"date":Time.get_datetime_dict_from_system(),
		"label":label,
		"bg_type":bg_type,
		"amp_mode":viewport.get_shader_var("amp_mode"),
		"bg_offset":viewport.get_shader_var("bg1_offset"),
		"bg_scale":viewport.get_shader_var("bg1_scale"),
		"amp_strength":viewport.get_shader_var("amp_strength"),
		"image":image.data
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
		else:
			file_info[i]=null
	return file_info
