extends Node
class_name Wa2Sound
var bgm_audio:Wa2BgmAudio=Wa2BgmAudio.new()
var sys_se_audio:AudioStreamPlayer=AudioStreamPlayer.new()
var voice_audio:Wa2Audio=Wa2Audio.new()
var se_audios:Array[Wa2Audio]=[]
func _ready():
	sys_se_audio.stream=AudioStreamPolyphonic.new()
	add_child(bgm_audio)
	add_child(sys_se_audio)
	add_child(voice_audio)
	sys_se_audio.play()
	for i in Consts.MAX_SE_CHANNELS:
		var audio:Wa2Audio=Wa2Audio.new()
		se_audios.append(audio)
		add_child(audio)
func play_bgm(id:int,loop_flag:bool=true,volume:int=255):
	bgm_audio.play_stream(Wa2Res.get_bgm_stream(id,false),loop_flag,0,volume/255.0)
	bgm_audio.loop_stream=Wa2Res.get_bgm_stream(id,true)
func stop_bgm(frame:int=0):
	bgm_audio.stop_stream(frame)
func play_se(channel:int,id:int,loop_flag:bool,frame:int,volume:int):
	se_audios[channel].play_stream(Wa2Res.get_se_stream(id),loop_flag,frame,volume/255.0)
func stop_se(channel:int,frame:int):
	se_audios[channel].stop_stream(frame)
func play_voice(file_name:String):
	voice_audio.play_stream(Wa2Res.get_voice_stream(file_name),false,0,1)
	#linear_to_db()
	#for i in frame:
func stop_voice():
	voice_audio.stop()
func stop_all_se():
	for audio in se_audios:
		audio.stop()
func play_sys_se(stream:AudioStream):
	var play_back:AudioStreamPlaybackPolyphonic=sys_se_audio.get_stream_playback()
	if stream:
		print(stream)
		play_back.play_stream(stream)
