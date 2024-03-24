extends Wa2Audio
class_name  Wa2BgmAudio
var start_stream:AudioStream
var loop_stream:AudioStream
func _ready():
	connect("finished",func ():
		if loop:
			play_stream(loop_stream,true,0,volume)
		else:
			stop()
		)
