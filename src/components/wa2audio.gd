extends AudioStreamPlayer
class_name Wa2Audio
var duration:int
var counter:int
var loop:=false
var state:=0
var volume:=0.0
func stop_stream(frame:int):
	duration=frame
	counter=0
	if duration>0:
		state=2
	else:
		stop()
func set_volume(_volume,frame):
	duration=frame
	counter=0
	volume=_volume
	if duration>0:
		state=1
	volume_db=linear_to_db(volume)
func play_stream(_stream:AudioStream,_loop:bool,frame:int,_volume:float):
	duration=frame
	seek(0)
	counter=0
	volume=_volume
	loop=_loop
	stream=_stream
	play()
	if duration>0:
		state=1
	else:
		state=0
		volume_db=linear_to_db(volume)
func _physics_process(delta):
	match state:
		1:
			counter+=1
			volume_db=linear_to_db((float(counter)/duration)*volume)
			if counter==duration:
				state=0
		2:
			counter+=1
			volume_db=linear_to_db(((1.0-(float(counter)/duration)))*volume)
			if counter==duration:
				state=0
				stop()
		
