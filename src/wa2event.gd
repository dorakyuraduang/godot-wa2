extends Node
var wait_frame:=0
var remaining_frame:=0
var wait_se_channel
signal  timeout
signal  click_text
signal  voice_finished
signal se_finished
func clear_event():
	Globals.event_mode=0
func add_event(event:int):
	Globals.event_mode|=event
func has_event(event:int):
	return Globals.event_mode&event==event
func remove_event(event:int):
	Globals.event_mode&=~event
func add_timer(frame:int):
	wait_frame=frame
	remaining_frame=frame
	add_event(Consts.EventMode.WAIT_TIME)
func remove_timer():
	wait_frame=0
	remaining_frame=0
	remove_event(Consts.EventMode.WAIT_TIME)
func _physics_process(delta):
	if has_event(Consts.EventMode.WAIT_TIME):
		remaining_frame-=1
		if remaining_frame<=0 or Globals.is_skip():
			remove_timer()
			emit_signal("timeout")
	if has_event(Consts.EventMode.WAIT_VOICE):
		if !Sound.voice_audio.playing or Globals.is_skip():
			print("移除")
			remove_event(Consts.EventMode.WAIT_VOICE)
			emit_signal("voice_finished")
			if Globals.auto_flag and Globals.text_on_flag:
				add_timer(Globals.auto_wait_frame)
	if has_event(Consts.EventMode.WAIT_CLICK):
		if Globals.text_on_flag:
			if Globals.click_text_state==2 or Globals.is_skip() or\
			(Globals.auto_flag and \
			!has_event(Consts.EventMode.WAIT_VOICE) and !has_event(Consts.EventMode.WAIT_TIME)):
				Globals.click_text_state=0
				Globals.text_state=0
				emit_signal("click_text")
				clear_event()
	if has_event(Consts.EventMode.WAIT_SE):
		if !Sound.se_audios[wait_se_channel].playing or Globals.is_skip():
			remove_event(Consts.EventMode.WAIT_SE)
			emit_signal("se_finished")
