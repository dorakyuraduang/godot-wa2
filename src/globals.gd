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
var cur_voice=""
var cur_name=""
var text_state:=0
var click_text_state:=0
var text_on_flag:=0
var lookbacks:Array=[]
var message_box=null
var backlog=null
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
