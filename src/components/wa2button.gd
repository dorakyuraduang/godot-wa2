extends TextureButton
class_name Wa2Button
@export var hover_se:AudioStream
@export var click_se:AudioStream
func _ready():
	connect("mouse_entered",func ():
		if !disabled:
			Sound.play_sys_se(hover_se)
		)
	connect("button_down",func ():
		Sound.play_sys_se(click_se)
		)
#InputEvent
#func _gui_input(event):
	##print(6)
	#if disabled:
		#Globals.main.propagate_call("_gui_input",[event])
